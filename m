Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab3DWXxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:53:25 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:28297
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756395Ab3DWXxY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:53:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zzbb2dI98dI9371Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Tue, 23 Apr 2013 18:53:20 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v2 02/15] powerpc/85xx: add sleep and deep sleep support
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <1366368468-29143-2-git-send-email-chenhui.zhao@freescale.com>
	(from chenhui.zhao@freescale.com on Fri Apr 19 05:47:35 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1366761200.5825.18@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 05:47:35 AM, Zhao Chenhui wrote:
>  static int pmc_suspend_enter(suspend_state_t state)
>  {
> -	int ret;
> +	int ret = 0;
> +
> +	switch (state) {
> +#ifdef CONFIG_PPC_85xx
> +	case PM_SUSPEND_MEM:
> +#ifdef CONFIG_SPE
> +		enable_kernel_spe();
> +#endif
> +		enable_kernel_fp();

Why does enable_kernel_spe() need an ifdef but enable_kernel_fp()  
doesn't?

> +	case PM_SUSPEND_STANDBY:
> +#ifdef CONFIG_FSL_SOC_BOOKE
> +		flush_dcache_L1();
> +#endif
> +		setbits32(&pmc_regs->powmgtcsr, POWMGTCSR_SLP);

Only L1, even on e500mc?

-Scott
