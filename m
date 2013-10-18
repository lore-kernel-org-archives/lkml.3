Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3JROK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:10:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898Ab3JROKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:10:23 -0400
Date: Fri, 18 Oct 2013 17:12:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Build error for nommu if CONFIG_DEBUG_ATOMIC_SLEEP is selected
Message-ID: <20131018141202.GA24660@redhat.com>
References: <1382088475.16935.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382088475.16935.4.camel@phoenix>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 05:27:55PM +0800, Axel Lin wrote:
> Hi Michael,
> 
> I got below build error for nommu if CONFIG_DEBUG_ATOMIC_SLEEP is selected.
> Also got the same build error if CONFIG_PROVE_LOCKING is selected.
> 
> Seems this issue is introduced by commit 662bbcb2747c2
> "mm, sched: Allow uaccess in atomic with pagefault_disable()".
> 
> arch/arm/kernel/built-in.o: In function `arch_ptrace':
> arch/arm/kernel/ptrace.c:852: undefined reference to `might_fault'
> arch/arm/kernel/built-in.o: In function `restore_sigframe':
> arch/arm/kernel/signal.c:173: undefined reference to `might_fault'
> arch/arm/kernel/signal.c:174: undefined reference to `might_fault'
> arch/arm/kernel/signal.c:175: undefined reference to `might_fault'
> arch/arm/kernel/signal.c:176: undefined reference to `might_fault'
> arch/arm/kernel/built-in.o:arch/arm/kernel/signal.c:177: more undefined references to `might_fault' follow
> make: *** [vmlinux] Error 1
> 
> Regards,
> Axel

Can you send/upload your full .config please?
