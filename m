Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbaBWFQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 00:16:20 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:62294 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaBWFQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 00:16:19 -0500
Date: Sun, 23 Feb 2014 00:18:17 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <53084317.4090304@zytor.com>
Message-ID: <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211732290.11615@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402212342090.17416@vincent-weaver-1.um.maine.edu>
 <53084317.4090304@zytor.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, H. Peter Anvin wrote:

> Error 6 reflects a write in userspace to a not-present page.
> 
> Since your previous trace indicates that the value of the register in question
> is a different one, I'm guessing that what we have here is PEBS getting
> activated.  0x120 is 2*0x90, and 0x90 is the size of a 64-bit PEBS record.

I'm having problems generating a replayable syscall trace that exhibits 
the problem.

It turns out that the segfault address listed (the multiple of 0x120) 
happens to be the value in the RBP register at the time of the segfault.

That's odd, as the instruction is
	movdqa %xmm0,(%rdi)
and rdi is the valid mmap address of the perf ring buffer
	rdi            0xf7768000	4151738368

so I'm not sure why RBP is involved at all.

In all of the cases I've investigated the precise_ip value has been set 
for the problem event... but none of the events have been hardware events
(software and breakpoint so far).  So probably not PEBS related?

Vince

