Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbaISPTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:19:15 -0400
Received: from gw1.transmode.se ([195.58.98.146]:60477 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbaISPTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:19:13 -0400
In-Reply-To: <20140919135756.A060D1AB26D@localhost.localdomain>
References: <20140919135756.A060D1AB26D@localhost.localdomain>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] powerpc32: add support for csum_add()
X-KeepSent: 690C56D2:618CBADE-C1257D58:00535C2F;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF690C56D2.618CBADE-ONC1257D58.00535C2F-C1257D58.005426A0@transmode.se>
Date: Fri, 19 Sep 2014 17:19:08 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 19/09/2014 17:19:08,
	Serialize complete at 19/09/2014 17:19:08
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2014/09/19 15:57:56:
> Subject: [PATCH 2/2] powerpc32: add support for csum_add()
> 
> The C version of csum_add() as defined in include/net/checksum.h gives 
the
> following assembly:
>        0:       7c 04 1a 14     add     r0,r4,r3
>        4:       7c 64 00 10     subfc   r3,r4,r0
>        8:       7c 63 19 10     subfe   r3,r3,r3
>        c:       7c 63 00 50     subf    r3,r3,r0
> 
> include/net/checksum.h also offers the possibility to define an arch 
specific
> function.
> This patch provides a ppc32 specific csum_add() inline function.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> ---

Ouch, this is still so. Back in 2010 I reported this to gcc:
  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=43892

Anyway, 
        Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
