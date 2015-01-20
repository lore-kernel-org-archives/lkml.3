Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbbATLoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:44:13 -0500
Received: from smtp-out4.electric.net ([192.162.216.181]:54944 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbbATLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:44:11 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'leroy christophe'" <christophe.leroy@c-s.fr>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "scottwood@freescale.com" <scottwood@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 07/11] powerpc/8xx: macro for handling CPU15 errata
Thread-Topic: [PATCH v2 07/11] powerpc/8xx: macro for handling CPU15 errata
Thread-Index: AQHQNJjRMWEAMW5jYkWhruJEX7vwspzI2I/ggAAH1oCAAAItgA==
Date: Tue, 20 Jan 2015 11:43:16 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CACF0E4@AcuExch.aculab.com>
References: <20150120095735.A55671A5E86@localhost.localdomain>
 <063D6719AE5E284EB5DD2968C1650D6D1CACEFD9@AcuExch.aculab.com>
 <54BE3CD7.4040208@c-s.fr>
In-Reply-To: <54BE3CD7.4040208@c-s.fr>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0KBiIhv011372

From: leroy 
> Le 20/01/2015 12:09, David Laight a Ã©crit :
> >  From Christophe Leroy
> >> Having a macro will help keep clear code.
> > It might remove an #if but it doesn't really help.
> > All it means is that anyone reading the code has to hunt for
> > the definition before proceeding.
> >
> > Some comment about what (and why) the extra code is needed
> > might help.
> The main reason is because of patch 09/11 where we have to duplicate
> this code. I prefer to just duplicate one line rather than duplicate the
> whole code (especially because in v1 of the PATCHset, it was duplicated
> twice):
> 
> -    DO_8xx_CPU15(r11, r10)
> [...]
> #ifdef CONFIG_MODULES
> [...]
> +    DO_8xx_CPU15(r10, r11)
> [...]
> +#else
> +    mfspr    r10, SPRN_SRR0    /* Get effective address of fault */
> +    DO_8xx_CPU15(r11, r10)
> 
> Is this approach wrong ?

I'd call it something that infers 'invalidate adjacent pages'
and then mention that this is needed due to a cpu errata.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
