Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaKCR6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:58:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:32380 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752144AbaKCR6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:58:46 -0500
Date: Mon, 3 Nov 2014 12:58:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Nathan Lynch <Nathan_Lynch@mentor.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, Rabin Vincent <rabin@rab.in>,
        Ingo Molnar <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] tracing/syscalls: ignore numbers outside NR_syscalls'
 range
Message-ID: <20141103125835.0be67cc1@gandalf.local.home>
In-Reply-To: <5457B673.1000409@mentor.com>
References: <1414620418-29472-1-git-send-email-rabin@rab.in>
	<20141030082606.GA7945@infradead.org>
	<20141030101808.GO27405@n2100.arm.linux.org.uk>
	<20141030071039.37633bf5@gandalf.local.home>
	<20141030111441.GP27405@n2100.arm.linux.org.uk>
	<20141030073028.284c468c@gandalf.local.home>
	<20141030113523.GQ27405@n2100.arm.linux.org.uk>
	<5457B673.1000409@mentor.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014 11:08:03 -0600
Nathan Lynch <Nathan_Lynch@mentor.com> wrote:


> > Or do we just ignore the high "special" ARM syscalls and treat them (from
> > the tracing point of view) as non-syscalls, avoiding the allocation of
> > something around 1.2MB for the syscall bitmap.  I really don't know, I
> > don't use any of this tracing stuff, so it isn't something I care about.
> > 
> > Maybe those who do use the facility should have an input here?
> 
> I checked strace and it knows about ARM's high syscalls.  I wouldn't
> want to go from casually using strace to digging deeper with ftrace only
> to get the impression that syscalls are disappearing.

I agree, but currently the syscall tracing does not support different
mappings, and if there's a group of calls outside of NR_syscalls range,
they will currently be ignored.

The fix may be to restructure how syscall tracing works. But for now,
the only answer we have is to just ignore them. x86 has the same issue
with compat calls (i386 syscalls on x86_64 kernels).

-- Steve
