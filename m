Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaFSMw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:52:29 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:30796 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751570AbaFSMw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:52:27 -0400
Date: Thu, 19 Jun 2014 13:52:23 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/24] ARM64:ILP32: COMPAT_USE_64BIT_TIME is true for
 ILP32 tasks.
Message-ID: <20140619125223.GC8476@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-15-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-15-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:02:09AM -0700, Andrew Pinski wrote:
> Since __kernel_long_t (time_t) is long long, we need to tell the rest
> of kernel that we use 64bit time_t for compat when the task is not an
> AARCH32 task.  The reason why we check AARCH32 rather than ILP32 here
> is because if we don't have AARCH32 compiled in (which is going to be
> the common case due to AARCH32 requiring 4k pages).
> 
> Thanks,
> Andrew Pinski
> 
> Signed-off-by: Andrew Pinski <apinski@cavium.com>
> ---
>  arch/arm64/include/asm/compat.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
> index 85f945c..c77fc0f 100644
> --- a/arch/arm64/include/asm/compat.h
> +++ b/arch/arm64/include/asm/compat.h
> @@ -76,6 +76,9 @@ struct compat_timeval {
>  	s32		tv_usec;
>  };
>  
> +/* ILP32 uses 64bit time_t and not the above compat structures */
> +#define COMPAT_USE_64BIT_TIME !is_a32_compat_task()

Brackets.

BTW, you could write is_ilp32_compat_task().

-- 
Catalin
