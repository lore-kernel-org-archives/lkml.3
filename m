Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbaJ3LKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:10:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:10847 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759108AbaJ3LKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:10:52 -0400
Date: Thu, 30 Oct 2014 07:10:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Rabin Vincent <rabin@rab.in>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/syscalls: ignore numbers outside NR_syscalls'
 range
Message-ID: <20141030071039.37633bf5@gandalf.local.home>
In-Reply-To: <20141030101808.GO27405@n2100.arm.linux.org.uk>
References: <1414620418-29472-1-git-send-email-rabin@rab.in>
	<20141030082606.GA7945@infradead.org>
	<20141030101808.GO27405@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014 10:18:08 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Oct 30, 2014 at 01:26:06AM -0700, Christoph Hellwig wrote:
> > On Wed, Oct 29, 2014 at 11:06:58PM +0100, Rabin Vincent wrote:
> > > ARM has some private syscalls (for example, set_tls(2)) which lie
> > > outside the range of NR_syscalls.  If any of these are called while
> > > syscall tracing is being performed, out-of-bounds array access will
> > > occur in the ftrace and perf sys_{enter,exit} handlers.
> > 
> > While this patch looks like good caution, having syscalls outside of
> > NR_syscalls seems like a receipe for a disaster.  Can you try to fix
> > that issue as ell, please?
> 
> No.  We've had them since the inception of Linux on ARM.  They predate
> this tracing crap by more than a decade.  We're not changing them
> because that would be a massive user API breakage.
> 

Since syscall tracing is only broken on ARM, then the fix needs to be
ARM specific, and not remove the check for all other architectures that
have a sane NR_syscalls variable.

-- Steve
