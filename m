Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbaJaKB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:01:59 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39130 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbaJaKB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:01:57 -0400
Date: Fri, 31 Oct 2014 11:01:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Rabin Vincent <rabin@rab.in>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing/syscalls: ignore numbers outside NR_syscalls'
 range
Message-ID: <20141031100153.GA23722@gmail.com>
References: <1414620418-29472-1-git-send-email-rabin@rab.in>
 <20141030082606.GA7945@infradead.org>
 <20141030101808.GO27405@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030101808.GO27405@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Oct 30, 2014 at 01:26:06AM -0700, Christoph Hellwig wrote:
> > On Wed, Oct 29, 2014 at 11:06:58PM +0100, Rabin Vincent wrote:
> > > ARM has some private syscalls (for example, set_tls(2)) which lie
> > > outside the range of NR_syscalls.  If any of these are called while
> > > syscall tracing is being performed, out-of-bounds array access will
> > > occur in the ftrace and perf sys_{enter,exit} handlers.
> > 
> > While this patch looks like good caution, having syscalls 
> > outside of NR_syscalls seems like a receipe for a disaster.  
> > Can you try to fix that issue as ell, please?
> 
> No.  We've had them since the inception of Linux on ARM.  They 
> predate this tracing crap by more than a decade.  We're not 
> changing them because that would be a massive user API 
> breakage.

So if you go around calling other people's code 'crap' so easily: 
if we should call something 'crap' in this area it's the decision 
of ARM to deviate from all other architectures arbitrarily and to 
introduce 'private' syscalls outside NR_syscalls...

There's a reason why we have NR_syscalls with relatively tighly 
packed syscall numbers and there's a reason why we don't do 
'private' syscalls on other architectures.

I'd probably have NAK-ed ARM's 'private syscalls' had I known 
about it when this was introduced for ARM. IMO you should be 
ashamed for it instead of blaming others for the complication ...

But yes, it's probably an ABI, albeit a crappy one, which is now 
hurting the introduction of a generic kernel facility in the ARM 
space.

Thanks,

	Ingo
