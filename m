Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaJHObQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:31:16 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43962 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833AbaJHObP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:31:15 -0400
Date: Wed, 8 Oct 2014 15:30:59 +0100
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 5/6] arm64: add SIGSYS siginfo for compat task
Message-ID: <20141008143059.GS26140@arm.com>
References: <1412243176-16192-1-git-send-email-takahiro.akashi@linaro.org>
 <1412243176-16192-6-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412243176-16192-6-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 10:46:15AM +0100, AKASHI Takahiro wrote:
> SIGSYS is primarily used in secure computing to notify tracer.
> This patch allows signal handler on compat task to get correct information
> with SA_SIGINFO specified when this signal is delivered.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  arch/arm64/include/asm/compat.h |    7 +++++++
>  arch/arm64/kernel/signal32.c    |    6 ++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
> index 253e33b..c877915 100644
> --- a/arch/arm64/include/asm/compat.h
> +++ b/arch/arm64/include/asm/compat.h
> @@ -205,6 +205,13 @@ typedef struct compat_siginfo {
>  			compat_long_t _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
>  			int _fd;
>  		} _sigpoll;
> +
> +		/* SIGSYS */
> +		struct {
> +			compat_uptr_t _call_addr; /* calling user insn */
> +			int _syscall;	/* triggering system call number */
> +			unsigned int _arch;	/* AUDIT_ARCH_* of syscall */

nit, but compat_uint_t looks better here (I have no idea why I didn't do
this for the signed int types, but hey).

Will
