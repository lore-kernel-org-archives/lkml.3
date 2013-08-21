Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3HURxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:53:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56870 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752980Ab3HURxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:53:03 -0400
Date: Wed, 21 Aug 2013 18:52:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3 4/6] ARM64: arch_timer: configure and enable event
 stream
Message-ID: <20130821175227.GH1653@mudshark.cambridge.arm.com>
References: <1376414984-14182-5-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1377018526-9832-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377018526-9832-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sudeep,

On Tue, Aug 20, 2013 at 06:08:46PM +0100, Sudeep KarkadaNagesha wrote:
> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> 
> This patch configures the event stream frequency and enables it.
> It also adds the hwcaps as well as compat-specific definitions to
> the user to detect this event stream feature.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> [sudeep: moving ARM/ARM64 changes into separate patches]
> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
> ---
>  arch/arm64/include/asm/arch_timer.h | 15 +++++++++++++--
>  arch/arm64/include/asm/hwcap.h      |  7 ++++++-
>  arch/arm64/include/uapi/asm/hwcap.h |  1 +
>  arch/arm64/kernel/setup.c           |  6 ++++++
>  4 files changed, 26 insertions(+), 3 deletions(-)
> 
> Hi Will,
> 
> This is modified version enabling timer event stream hwcap compat dynamically.
> Let me know if this looks fine.

Looks pretty good to me, one minor comment:

> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index add6ea6..91af65a 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -60,6 +60,11 @@ EXPORT_SYMBOL(processor_id);
>  unsigned int elf_hwcap __read_mostly;
>  EXPORT_SYMBOL_GPL(elf_hwcap);
>  
> +#ifdef CONFIG_COMPAT
> +unsigned int compat_dyn_elf_hwcap __read_mostly = 0;
> +EXPORT_SYMBOL_GPL(compat_dyn_elf_hwcap);
> +#endif

Given that the arch timer is the only user of this at the moment, and cannot
be built as a module, I don't think we should bother exporting the symbol
until it's actually required.

Will
