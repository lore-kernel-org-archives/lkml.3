Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaBQTcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 14:32:41 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38515 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137AbaBQTcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 14:32:39 -0500
Date: Mon, 17 Feb 2014 19:32:10 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "wad@chromium.org" <wad@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH 2/2] arm64: is_compat_task is defined both in
 asm/compat.h and linux/compat.h
Message-ID: <20140217193210.GI26590@mudshark.cambridge.arm.com>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org>
 <1391767892-5395-3-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391767892-5395-3-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:11:32AM +0000, AKASHI Takahiro wrote:
> kernel/seccomp.c includes linux/compat.h and, indicrectly, asm/compat.h
> via asm/syscall.h. Due to the duplicated definition of is_compat_task,
> compiling this file will fail in the case of !CONFIG_COMPAT.
> This patch makes the definition in asm/compat.h valid only if necessary.
> 
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/include/asm/compat.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
> index fda2704..72f3b18 100644
> --- a/arch/arm64/include/asm/compat.h
> +++ b/arch/arm64/include/asm/compat.h
> @@ -305,10 +305,12 @@ static inline int is_compat_thread(struct thread_info *thread)
>  
>  #else /* !CONFIG_COMPAT */
>  
> +#ifndef is_compat_task /* it's there in linux/compat.h */
>  static inline int is_compat_task(void)
>  {
>  	return 0;
>  }
> +#endif

This is horrible! Can we instead include linux/compat.h where we need this
macro and then remove this definition?

Will
