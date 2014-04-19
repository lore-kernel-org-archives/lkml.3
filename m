Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaDSQJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 12:09:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56237 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDSQJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 12:09:49 -0400
Date: Sat, 19 Apr 2014 18:09:47 +0200
From: Pavel Machek <pavel@denx.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH 16/28] nios2: System calls handling
Message-ID: <20140419160947.GA27776@amd.pavel.ucw.cz>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-13-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397824031-4892-13-git-send-email-lftan@altera.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-04-18 20:26:59, Ley Foon Tan wrote:
> This patch adds support for system calls from userspaces. It uses the
> asm-generic/unistd.h definitions with architecture spcific syscall. The sys_call_table
> is just an array defined in a C file and it contains pointers to the syscall functions.
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>


> +/* Additional Nios II specific syscalls. */
> +#define __NR_cacheflush (__NR_arch_specific_syscall)
> +__SYSCALL(__NR_cacheflush, sys_cacheflush)

I guess you should Cc: Michael Kerrisk on this one.

Also... explanation why you need this syscall while other
architectures live happily without it would be nice.

> +/* sys_cacheflush -- flush the processor cache. */
> +asmlinkage int sys_cacheflush(unsigned long addr, unsigned long len,
> +				unsigned int op)
> +{
> +	struct vm_area_struct *vma;
> +
> +	if (len == 0)
> +		return 0;

op is being ignored? You should remove it... or if (op) return -EINVAL
if you want future extensions.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
