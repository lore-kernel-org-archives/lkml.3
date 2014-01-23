Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaAWO4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:56:40 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46803 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753869AbaAWO4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:56:39 -0500
Date: Thu, 23 Jan 2014 14:56:05 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>, Will Deacon <Will.Deacon@arm.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v2 6/6] arm64: audit: Add audit hook in
 ptrace/syscall_trace
Message-ID: <20140123145605.GG27520@arm.com>
References: <1389946399-4525-1-git-send-email-takahiro.akashi@linaro.org>
 <1389946399-4525-7-git-send-email-takahiro.akashi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389946399-4525-7-git-send-email-takahiro.akashi@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 08:13:19AM +0000, AKASHI Takahiro wrote:
> @@ -1064,6 +1066,16 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
>  {
>  	unsigned long saved_reg;
>  
> +#ifdef CONFIG_AUDITSYSCALL
> +	if (dir)
> +		audit_syscall_exit(regs);
> +	else
> +		audit_syscall_entry(syscall_get_arch(current, regs),
> +			(int)regs->syscallno,
> +			regs->orig_x0, regs->regs[1],
> +			regs->regs[2], regs->regs[3]);
> +#endif /* CONFIG_AUDITSYSCALL */

It should work without the #ifdef as audit_syscall_exit/entry are dummy
static inline functions when !CONFIG_AUDITSYSCALL.

-- 
Catalin
