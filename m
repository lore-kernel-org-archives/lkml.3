Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3D1KVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 06:21:22 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:35231
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752155Ab3D1KVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 06:21:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
Date: Sun, 28 Apr 2013 18:20:42 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>
Subject: Re: [PATCH v2 02/15] powerpc/85xx: add sleep and deep sleep support
Message-ID: <20130428102042.GB27100@localhost.localdomain>
References: <1366368468-29143-2-git-send-email-chenhui.zhao@freescale.com>
 <1366761200.5825.18@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1366761200.5825.18@snotra>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 06:53:20PM -0500, Scott Wood wrote:
> On 04/19/2013 05:47:35 AM, Zhao Chenhui wrote:
> > static int pmc_suspend_enter(suspend_state_t state)
> > {
> >-	int ret;
> >+	int ret = 0;
> >+
> >+	switch (state) {
> >+#ifdef CONFIG_PPC_85xx
> >+	case PM_SUSPEND_MEM:
> >+#ifdef CONFIG_SPE
> >+		enable_kernel_spe();
> >+#endif
> >+		enable_kernel_fp();
> 
> Why does enable_kernel_spe() need an ifdef but enable_kernel_fp()
> doesn't?
> 

will enclose it with CONFIG_PPC_FPU.

> >+	case PM_SUSPEND_STANDBY:
> >+#ifdef CONFIG_FSL_SOC_BOOKE
> >+		flush_dcache_L1();
> >+#endif
> >+		setbits32(&pmc_regs->powmgtcsr, POWMGTCSR_SLP);
> 
> Only L1, even on e500mc?
> 
> -Scott

This patch is just for chips with pmc unit. They have no e500mc core.

-Chenhui

