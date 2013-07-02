Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3GBXXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:23:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35901 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab3GBXXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:23:00 -0400
Date: Tue, 2 Jul 2013 16:22:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Joseph Lo <josephl@nvidia.com>, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: move body of head-common.S back to text section
Message-ID: <20130702232259.GH11625@codeaurora.org>
References: <1372805629-18382-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372805629-18382-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Commit 281ecb7 "arm: delete __cpuinit/__CPUINIT usage from all ARM
> users" removed a __CPUINIT from head-common.S. However, the code
> immediately before the removed tag was marked __INIT, and was missing
> a match __FINIT. This caused code after the removed __CPUINIT to end
> up in the init section rather than the main text section as desired.
> This caused issues such as secondary CPU boot failures or crashes.
> Add the missing __FINIT to solve this.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/arm/kernel/head-common.S | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/kernel/head-common.S b/arch/arm/kernel/head-common.S
> index 529ce99..a9dc804 100644
> --- a/arch/arm/kernel/head-common.S
> +++ b/arch/arm/kernel/head-common.S
> @@ -122,6 +122,8 @@ __mmap_switched_data:
>  	.long	init_thread_union + THREAD_START_SP @ sp
>  	.size	__mmap_switched_data, . - __mmap_switched_data
>  
> +	__FINIT
> +
>  /*
>   * This provides a C-API version of __lookup_processor_type
>   */

Shouldn't this come after lookup_processor_type()? Otherwise you
just removed that function from the init section?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
