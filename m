Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaAGSbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:31:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:22757 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752618AbaAGSbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:31:14 -0500
Date: Tue, 7 Jan 2014 13:31:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        sahara <keun-o.park@windriver.com>, Keun-O Park <kpark3469@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available
 for ARM_UNWIND
Message-ID: <20140107133111.0fe49c21@gandalf.local.home>
In-Reply-To: <20140107163629.GC3350@e103592.cambridge.arm.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
	<201401071533.35309.arnd@arndb.de>
	<20140107144130.GJ27432@n2100.arm.linux.org.uk>
	<4325142.7drL5ndxN9@wuerfel>
	<20140107163629.GC3350@e103592.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jan 2014 16:36:29 +0000
Dave Martin <Dave.Martin@arm.com> wrote:

> My other concern was that we might end up in a recursive trace due to
> the use of non-notrace core functions in the unwinder.  But I seem to
> remember Steve Rostedt saying the the tracer guards against recursive
> invocation nowadays -- if so, that shouldn't be a problem.

I guess it matters what type of tracing you are talking about. The
function tracer protects against all recursive contexts (normal,
softirq, irq and NMI) and so does the ring buffer (same levels).

Those may be the only ones that matter, as things like events shouldn't
recurse, unless you have an event in the unwinder itself. But that's
where you take the doctor's advice of "don't do that".

-- Steve
