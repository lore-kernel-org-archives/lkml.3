Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbaDVUB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:01:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaDVUBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:01:53 -0400
Date: Tue, 22 Apr 2014 13:01:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Bugfix] sched: fix possible invalid memory access caused by
 CPU hot-addition
Message-Id: <20140422130151.83bc4539364ca660c68de859@linux-foundation.org>
In-Reply-To: <20140422081515.GF11182@twins.programming.kicks-ass.net>
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
	<20140422081515.GF11182@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 10:15:15 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Apr 22, 2014 at 01:27:15PM +0800, Jiang Liu wrote:
> > When calling kzalloc_node(size, flags, node), we should first check
> > whether node is onlined, otherwise it may cause invalid memory access
> > as below.
> 
> But this is only for memory less node crap, right? 

um, why are memoryless nodes crap?
