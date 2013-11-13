Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab3KMLtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:49:23 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:49960 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab3KMLtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:49:20 -0500
Date: Wed, 13 Nov 2013 12:49:13 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/2] sched/mm: add finish_switch_mm function
Message-ID: <20131113124913.005fcfe5@mschwide>
In-Reply-To: <20131113114143.GJ21461@twins.programming.kicks-ass.net>
References: <1384330574-18418-1-git-send-email-schwidefsky@de.ibm.com>
	<1384330574-18418-2-git-send-email-schwidefsky@de.ibm.com>
	<20131113114143.GJ21461@twins.programming.kicks-ass.net>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111311-0342-0000-0000-000006D8852C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 12:41:43 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Nov 13, 2013 at 09:16:13AM +0100, Martin Schwidefsky wrote:
> > The switch_mm function is called with the task_lock and/or with
> > request queue lock. Add finish_switch_mm to allow an architecture
> > to execute some code after the mm has been switched but without
> > any locks held. One use case is the s390 architecture which will
> > use this to wait for the completion of TLB flush operations.
> 
> This so reminds me of what finish_arch_post_lock_switch() was supposed
> to do. See commit: 01f23e1630d9 ("sched/arch: Introduce the
> finish_arch_post_lock_switch() scheduler callback").
> 
> Now you hook into more places; but maybe you can Catalin can come up
> with something you both can use?

finish_task_switch() has the call to finish_arch_post_lock_switch(), but
idle_task_exit() and use_mm() do not have the call. If it is safe to add
finish_arch_post_lock_switch() there as well I could use it for s390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

