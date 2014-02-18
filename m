Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaBRPjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:39:06 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:23272 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932120AbaBRPjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:39:02 -0500
Date: Tue, 18 Feb 2014 15:38:56 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "wad@chromium.org" <wad@chromium.org>, Will Deacon <Will.Deacon@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH 1/2] arm64: Add seccomp support
Message-ID: <20140218153856.GB904@localhost>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org>
 <1391767892-5395-2-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391767892-5395-2-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:11:31AM +0000, AKASHI Takahiro wrote:
> --- a/arch/arm64/kernel/ptrace.c
> +++ b/arch/arm64/kernel/ptrace.c
> @@ -26,6 +26,7 @@
>  #include <linux/smp.h>
>  #include <linux/ptrace.h>
>  #include <linux/user.h>
> +#include <linux/seccomp.h>
>  #include <linux/security.h>
>  #include <linux/init.h>
>  #include <linux/signal.h>
> @@ -1064,6 +1065,10 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>  {
>  	unsigned long saved_reg;
>  
> +	if (!dir && secure_computing((int)regs->syscallno))
> +		/* seccomp failures shouldn't expose any additional code. */
> +		return -1;

That's only restricted to the arm64 code but could we use a more
meaningful error number?

-- 
Catalin
