Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaJ0P72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:59:28 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:49142 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaJ0P7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:59:24 -0400
Date: Mon, 27 Oct 2014 15:59:11 +0000
From: Will Deacon <will.deacon@arm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <htejun@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [percpu] Convert remaining __get_cpu_var uses in 3.18-rcX
Message-ID: <20141027155910.GX8768@arm.com>
References: <alpine.DEB.2.11.1410271047400.17089@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1410271047400.17089@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 03:49:45PM +0000, Christoph Lameter wrote:
> During the 3.18 merge period additional __get_cpu_var uses were
> added. The patch converts these to this_cpu_ptr().
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/arch/arm64/kernel/psci.c
> ===================================================================
> --- linux.orig/arch/arm64/kernel/psci.c
> +++ linux/arch/arm64/kernel/psci.c
> @@ -511,7 +511,7 @@ static int cpu_psci_cpu_kill(unsigned in
> 
>  static int psci_suspend_finisher(unsigned long index)
>  {
> -	struct psci_power_state *state = __get_cpu_var(psci_power_state);
> +	struct psci_power_state *state = __this_cpu_read(psci_power_state);
> 
>  	return psci_ops.cpu_suspend(state[index - 1],
>  				    virt_to_phys(cpu_resume));
> @@ -520,7 +520,7 @@ static int psci_suspend_finisher(unsigne
>  static int __maybe_unused cpu_psci_cpu_suspend(unsigned long index)
>  {
>  	int ret;
> -	struct psci_power_state *state = __get_cpu_var(psci_power_state);
> +	struct psci_power_state *state = __this_cpu_read(psci_power_state);
>  	/*
>  	 * idle state index 0 corresponds to wfi, should never be called
>  	 * from the cpu_suspend operations

Apologies for not spotting this one during review:

  Acked-by: Will Deacon <will.deacon@arm.com>

Feel free to take this via some other route (than the arm64 tree).

Will
