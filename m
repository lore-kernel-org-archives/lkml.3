Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaE0Rtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:49:46 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51554 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaE0Rto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:49:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bSOruyGOjWHnR8XRBWba5
Date: Tue, 27 May 2014 10:49:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the  tree
Message-ID: <20140527174932.GB18063@atomide.com>
References: <20140527104526.5c6f819e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527104526.5c6f819e@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [140526 17:46]:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-omap2/omap-mpuss-lowpower.c between commit 4e4bb5c72f6b
> ("ARM: l2c: omap2: avoid reading directly from the L2 registers in
> platform code") from the arm tree and commit edfaf05c2fcb ("ARM:
> OMAP2+: raw read and write endian fix") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

OK thanks. FYI, looks like for this one the subject is missing which
tree it conflicts with.

Regards,

Tony
 
> --- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
> +++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
> @@@ -187,15 -187,19 +187,15 @@@ static void l2x0_pwrst_prepare(unsigne
>    * in every restore MPUSS OFF path.
>    */
>   #ifdef CONFIG_CACHE_L2X0
>  -static void save_l2x0_context(void)
>  +static void __init save_l2x0_context(void)
>   {
> - 	__raw_writel(l2x0_saved_regs.aux_ctrl,
> - 		     sar_base + L2X0_AUXCTRL_OFFSET);
> - 	__raw_writel(l2x0_saved_regs.prefetch_ctrl,
> - 		     sar_base + L2X0_PREFETCH_CTRL_OFFSET);
>  -	u32 val;
>  -	void __iomem *l2x0_base = omap4_get_l2cache_base();
>  -	if (l2x0_base) {
>  -		val = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
>  -		writel_relaxed(val, sar_base + L2X0_AUXCTRL_OFFSET);
>  -		val = readl_relaxed(l2x0_base + L2X0_PREFETCH_CTRL);
>  -		writel_relaxed(val, sar_base + L2X0_PREFETCH_CTRL_OFFSET);
>  -	}
> ++	writel_relaxed(l2x0_saved_regs.aux_ctrl,
> ++		       sar_base + L2X0_AUXCTRL_OFFSET);
> ++	writel_relaxed(l2x0_saved_regs.prefetch_ctrl,
> ++		       sar_base + L2X0_PREFETCH_CTRL_OFFSET);
>   }
>   #else
>  -static void save_l2x0_context(void)
>  +static void __init save_l2x0_context(void)
>   {}
>   #endif
>   


