Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbaJ3Lal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:30:41 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:15871 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758559AbaJ3Lak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:30:40 -0400
Date: Thu, 30 Oct 2014 07:30:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Rabin Vincent <rabin@rab.in>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/syscalls: ignore numbers outside NR_syscalls'
 range
Message-ID: <20141030073028.284c468c@gandalf.local.home>
In-Reply-To: <20141030111441.GP27405@n2100.arm.linux.org.uk>
References: <1414620418-29472-1-git-send-email-rabin@rab.in>
	<20141030082606.GA7945@infradead.org>
	<20141030101808.GO27405@n2100.arm.linux.org.uk>
	<20141030071039.37633bf5@gandalf.local.home>
	<20141030111441.GP27405@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014 11:14:41 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:


> We have always had syscall number range of 0x900000 or so.  The tracing
> design does not expect that.  Therefore, the tracing design did not take
> account of ARM when it was created.  Therefore, it's up to the tracing
> people to decide how to properly fit their ill-designed subsystem into
> one of the popular and well-established kernel architectures - or at
> least suggest a way to work around this issue.
> 


Fine, lets define a MAX_SYSCALL_NR that is by default NR_syscalls, but
an architecture can override it.

In trace_syscalls.c, where the checks are done, have this:

#ifndef MAX_SYSCALL_NR
# define MAX_SYSCALL_NR NR_syscalls
#endif

change all the checks to test against MAX_SYSCALL_NR instead of
NR_syscalls.

Then in arch/arm/include/asm/syscall.h have:

#define MAX_SYSCALL_NR 0xa00000

or whatever would be the highest syscall number for ARM.

-- Steve
