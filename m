Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3DLJQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:16:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48456 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3DLJQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:16:19 -0400
Message-ID: <1365758166.17140.35.camel@laptop>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Peter Zijlstra <peterz@infradead.org>
To: Olivier Langlois <olivier@trillion01.com>
Cc: mingo@redhat.com, tglx@linutronix.de, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Apr 2013 11:16:06 +0200
In-Reply-To: <1365608911.707.65.camel@Wailaba2>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:48 -0400, Olivier Langlois wrote:
> Please explain how expensive it is. All I am seeing is a couple of
> additions.

Let me start with this, since your earlier argument also refers to
this.

So yes it does look simple and straight fwd, only one addition. However
its an atomic operation across all threads of the same process. Imagine
a single process with 512 threads, all running on a separate cpu.

Do you see the problem? The cacheline contention of that one atomic is
enough to bring a machine that size to its knees. People tried, it
works.

This is a fundamentally unscalable problem that is part of the POSIX
interface.

Also, since its a concurrent problem, the entire question: "what is the
current runtime of the process" is uncertain and fuzzy. I prefer to
look at it as a Heisenberg uncertainty principle of SMP computing; you
cannot know the exact state of your SMP system and have it run (fast).



