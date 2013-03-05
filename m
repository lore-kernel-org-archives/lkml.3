Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab3CEIef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:34:35 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57956 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540Ab3CEIee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:34:34 -0500
Date: Tue, 5 Mar 2013 08:34:21 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: proc: Add Krait proc info
Message-ID: <20130305083421.GA19391@mudshark.cambridge.arm.com>
References: <1362439299-29617-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362439299-29617-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, Stepan,

On Mon, Mar 04, 2013 at 11:21:39PM +0000, Stephen Boyd wrote:
> From: Stepan Moskovchenko <stepanm@codeaurora.org>
> 
> Add processor info for the Qualcomm, Inc. Krait family of
> processors, to use the generic ARMv7 initialisation
> procedure but explicitly enable the IDIV hardware
> capability flag.
> 
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mm/proc-v7.S |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
> index 3a3c015..81adeb3 100644
> --- a/arch/arm/mm/proc-v7.S
> +++ b/arch/arm/mm/proc-v7.S
> @@ -434,6 +434,16 @@ __v7_ca15mp_proc_info:
>  	.size	__v7_ca15mp_proc_info, . - __v7_ca15mp_proc_info
>  
>  	/*
> +	 * Qualcomm Inc. Krait processors.
> +	 */
> +	.type	__krait_proc_info, #object
> +__krait_proc_info:
> +	.long	0x510f0400		@ Required ID value
> +	.long	0xff0ffc00		@ Mask for ID
> +	__v7_proc __v7_setup, hwcaps = HWCAP_IDIV

I was looking at this the other day and wondered whether we could set
HWCAP_IDIV in __v7_setup, depending on ID_ISAR0[27:24]. I can't immediately
think why that would be difficult, but similarly there may well be a reason
why we assign it like this.

Fancy taking a look?

Will
