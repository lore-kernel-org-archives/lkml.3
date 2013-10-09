Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3JIH3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:29:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60617 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3JIH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:29:13 -0400
Date: Wed, 9 Oct 2013 09:28:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v8 0/9] rwsem performance optimizations
Message-ID: <20131009072838.GY3081@twins.programming.kicks-ass.net>
References: <cover.1380748401.git.tim.c.chen@linux.intel.com>
 <1380753493.11046.82.camel@schen9-DESK>
 <20131003073212.GC5775@gmail.com>
 <1381186674.11046.105.camel@schen9-DESK>
 <20131009061551.GD7664@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009061551.GD7664@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 08:15:51AM +0200, Ingo Molnar wrote:
> So I'd expect this to be a rather sensitive workload and you'd have to 
> actively engineer it to hit the effect PeterZ mentioned. I could imagine 
> MPI workloads to run into such patterns - but not deterministically.

The workload that I got the report from was a virus scanner, it would
spawn nr_cpus threads and {mmap file, scan content, munmap} through your
filesystem.

Now if I only could remember who reported this.. :/
