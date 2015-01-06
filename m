Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbbAFNGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:06:35 -0500
Received: from smtp-out6.electric.net ([192.162.217.186]:58957 "EHLO
	smtp-out6.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbbAFNGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:06:33 -0500
X-Greylist: delayed 3444 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 08:06:33 EST
From: David Laight <David.Laight@ACULAB.COM>
To: "'Joakim Tjernlund'" <Joakim.Tjernlund@transmode.se>,
        "christophe.leroy@c-s.fr" <christophe.leroy@c-s.fr>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "scottwood@freescale.com" <scottwood@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: RE: [PATCH 05/11] powerpc/8xx: Optimise access to swapper_pg_dir
Thread-Topic: [PATCH 05/11] powerpc/8xx: Optimise access to swapper_pg_dir
Thread-Index: AQHQGUF+EnF0bbuoVUWd2Dp/RmzK9Zyx6QEAgAE2+WA=
Date: Tue, 6 Jan 2015 12:08:09 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CAC1765@AcuExch.aculab.com>
References: <20141216150338.D4F0A1A5E0A@localhost.localdomain>
 <1420482826.25047.26.camel@transmode.se>
In-Reply-To: <1420482826.25047.26.camel@transmode.se>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Outbound-IP: 213.249.233.130
X-Env-From: David.Laight@ACULAB.COM
X-PolicySMART: 3396946, 3397078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t06D6e0t012565

> On Tue, 2014-12-16 at 16:03 +0100, Christophe Leroy wrote:
> > All accessed to PGD entries are done via 0(r11).
> > By using lower part of swapper_pg_dir as load index to r11, we can remove the
> > ori instruction.
> >
> > Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> Nice :)
> Acked-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>
> 
> >
> > ---
> >  arch/powerpc/kernel/head_8xx.S | 22 ++++++++++------------
> >  1 file changed, 10 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
> > index ae05f28..aa45225 100644
> > --- a/arch/powerpc/kernel/head_8xx.S
> > +++ b/arch/powerpc/kernel/head_8xx.S
> > @@ -322,13 +322,12 @@ InstructionTLBMiss:
> >         mfspr   r11, SPRN_M_TW/* Get level 1 table base address */
> >  #ifdef CONFIG_MODULES
> >         beq     3f
> > -       lis     r11, (swapper_pg_dir-PAGE_OFFSET)@h
> > -       ori     r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
> > +       lis     r11, (swapper_pg_dir-PAGE_OFFSET)@ha
> >  3:
> >  #endif
> >         /* Insert level 1 index */
> >         rlwimi  r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
> > -       lwz     r11, 0(r11)/* Get the level 1 entry */
> > +       lwz     r11, (swapper_pg_dir-PAGE_OFFSET)@l(r11)/* Get the level 1 entry */
> >

On the face of it that fragment doesn't look right when CONFIG_MODULES is undefined.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
