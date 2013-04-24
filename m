Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab3DXLPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:15:18 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:1248
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab3DXLPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:15:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Wed, 24 Apr 2013 19:14:32 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>
Subject: Re: [PATCH v2 13/15] powerpc/85xx: add support for e6500 L1 cache
 operation
Message-ID: <20130424111432.GB3172@localhost.localdomain>
References: <1366368468-29143-1-git-send-email-chenhui.zhao@freescale.com>
 <1366368468-29143-13-git-send-email-chenhui.zhao@freescale.com>
 <1366761649.5825.20@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366761649.5825.20@snotra>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 07:00:49PM -0500, Scott Wood wrote:
> On 04/19/2013 05:47:46 AM, Zhao Chenhui wrote:
> >From: Chen-Hui Zhao <chenhui.zhao@freescale.com>
> >
> >The L1 Data Cache of e6500 contains no modified data, no flush
> >is required.
> >
> >Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> >Signed-off-by: Li Yang <leoli@freescale.com>
> >Signed-off-by: Andy Fleming <afleming@freescale.com>
> >---
> > arch/powerpc/kernel/fsl_booke_cache.S |   11 ++++++++++-
> > 1 files changed, 10 insertions(+), 1 deletions(-)
> >
> >diff --git a/arch/powerpc/kernel/fsl_booke_cache.S
> >b/arch/powerpc/kernel/fsl_booke_cache.S
> >index 232c47b..24a52bb 100644
> >--- a/arch/powerpc/kernel/fsl_booke_cache.S
> >+++ b/arch/powerpc/kernel/fsl_booke_cache.S
> >@@ -65,13 +65,22 @@ _GLOBAL(flush_dcache_L1)
> >
> > 	blr
> >
> >+#define PVR_E6500	0x8040
> >+
> > /* Flush L1 d-cache, invalidate and disable d-cache and i-cache */
> > _GLOBAL(__flush_disable_L1)
> >+/* L1 Data Cache of e6500 contains no modified data, no flush is
> >required */
> >+	mfspr	r3, SPRN_PVR
> >+	rlwinm	r4, r3, 16, 0xffff
> >+	lis	r5, 0
> >+	ori	r5, r5, PVR_E6500@l
> >+	cmpw	r4, r5
> >+	beq	2f
> > 	mflr	r10
> > 	bl	flush_dcache_L1	/* Flush L1 d-cache */
> > 	mtlr	r10
> >
> >-	msync
> >+2:	msync
> > 	mfspr	r4, SPRN_L1CSR0	/* Invalidate and disable d-cache */
> > 	li	r5, 2
> > 	rlwimi	r4, r5, 0, 3
> 
> Note that disabling the cache is a core operation, rather than a
> thread operation.  Is this only called when the second thread is
> disabled?
> 
> -Scott

It is called only when a core is down.
I can add a comment in the code.

-Chenhui

