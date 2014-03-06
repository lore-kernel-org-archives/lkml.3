Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaCFVyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:54:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaCFVsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:48:50 -0500
Date: Thu, 6 Mar 2014 13:48:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20140306134848.7aabdc426fbad30f6e818631@linux-foundation.org>
In-Reply-To: <20140306192234.62ad3ac104a2adc16752b033@canb.auug.org.au>
References: <20140306192234.62ad3ac104a2adc16752b033@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 19:22:34 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> arch/sparc/kernel/time_64.c: In function 'timer_interrupt':
> arch/sparc/kernel/time_64.c:735:28: error: lvalue required as increment operand
> arch/sparc/kernel/traps_64.c: In function '__cheetah_flush_icache':
> arch/sparc/kernel/traps_64.c:963:2: error: 'pscr_ret__.icache_size' is used uninitialized in this function [-Werror=uninitialized]
> arch/sparc/kernel/traps_64.c: In function 'cheetah_flush_dcache':
> arch/sparc/kernel/traps_64.c:1002:2: error: 'pscr_ret__.dcache_size' is used uninitialized in this function [-Werror=uninitialized]
> arch/sparc/kernel/traps_64.c: In function 'cheetah_plus_parity_error':
> arch/sparc/kernel/traps_64.c:1023:2: error: 'pscr_ret__.dcache_size' may be used uninitialized in this function [-Werror=uninitialized]
> arch/sparc/kernel/traps_64.c:1020:16: note: 'pscr_ret__.dcache_size' was declared here
> arch/sparc/kernel/traps_64.c:1033:33: error: 'pscr_ret__.dcache_line_size' may be used uninitialized in this function [-Werror=uninitialized]
> arch/sparc/kernel/traps_64.c:1021:21: note: 'pscr_ret__.dcache_line_size' was declared here
> cc1: all warnings being treated as errors
> kernel/softirq.c: In function '__do_softirq':
> kernel/softirq.c:252:1: error: lvalue required as left operand of assignment
> kernel/softirq.c: In function '__raise_softirq_irqoff':
> kernel/softirq.c:427:1: error: lvalue required as left operand of assignment
> arch/sparc/kernel/ptrace_64.c: In function 'flush_ptrace_access':
> arch/sparc/kernel/ptrace_64.c:91:20: error: 'pscr_ret__.dcache_line_size' may be used uninitialized in this function [-Werror=uninitialized]
> arch/sparc/kernel/ptrace_64.c:113:20: error: 'pscr_ret__.icache_line_size' may be used uninitialized in this function [-Werror=uninitialized]
> 
> Caused by commit 5aa661aa13d4 ("sparc: replace __get_cpu_var uses").
> 
> I have reverted that commit for today.
> 
> I suspect that this whole series may need more review and work.

Yes, I've disabled the whole series for now.  Some of these errors
appear to be caused by compiler mishandling, so it's going to be
difficult :(

