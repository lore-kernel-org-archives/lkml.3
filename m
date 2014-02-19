Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaBSQlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:41:36 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11921 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754091AbaBSQle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:41:34 -0500
Date: Wed, 19 Feb 2014 16:41:25 +0000
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
Message-ID: <20140219164125.GD22252@arm.com>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org>
 <1391767892-5395-2-git-send-email-takahiro.akashi@linaro.org>
 <20140218153856.GB904@localhost>
 <530497DD.2020806@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530497DD.2020806@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:39:09AM +0000, AKASHI Takahiro wrote:
> On 02/19/2014 12:38 AM, Catalin Marinas wrote:
> > On Fri, Feb 07, 2014 at 10:11:31AM +0000, AKASHI Takahiro wrote:
> >> --- a/arch/arm64/kernel/ptrace.c
> >> +++ b/arch/arm64/kernel/ptrace.c
> >> @@ -26,6 +26,7 @@
> >>   #include <linux/smp.h>
> >>   #include <linux/ptrace.h>
> >>   #include <linux/user.h>
> >> +#include <linux/seccomp.h>
> >>   #include <linux/security.h>
> >>   #include <linux/init.h>
> >>   #include <linux/signal.h>
> >> @@ -1064,6 +1065,10 @@ asmlinkage int syscall_trace(int dir, struct pt_regs *regs)
> >>   {
> >>   	unsigned long saved_reg;
> >>
> >> +	if (!dir && secure_computing((int)regs->syscallno))
> >> +		/* seccomp failures shouldn't expose any additional code. */
> >> +		return -1;
> >
> > That's only restricted to the arm64 code but could we use a more
> > meaningful error number?
> 
> Other architectures, including arm, also return just -1 in syscall_trace_enter(),
> but of course, we can use another value, say, -EPERM or -ENOSYS?

Actually we have another case of setting regs->syscallno = ~0UL in the
same function, so we could do the same (also in line with entry.S).

-- 
Catalin
