Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3BULh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 06:37:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58868 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3BULhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 06:37:55 -0500
Message-ID: <1361446661.26780.15.camel@laptop>
Subject: Re: [RFC PATCH v3 1/3] sched: schedule balance map foundation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 21 Feb 2013 12:37:41 +0100
In-Reply-To: <5125A966.6040601@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <510791B2.6090506@linux.vnet.ibm.com> <1361366720.10155.25.camel@laptop>
	 <5125A966.6040601@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 12:58 +0800, Michael Wang wrote:
> 
> You are right, it cost space in order to accelerate the system, I've
> calculated the cost once before (I'm really not good at this, please
> let
> me know if I make any silly calculation...), 

The exact size isn't that important, but its trivial to see its quadric.
You have a NR_CPUS array per-cpu, thus O(n^2).

( side note; invest in getting good at complexity analysis -- or at
least competent, its the single most important aspect of programming. )

...

> And the final cost is 3000 int and 1030000 pointer, and some padding,
> but won't bigger than 10M, not a big deal for a system with 1000 cpu
> too.

Maybe, but quadric stuff should be frowned upon at all times, these
things tend to explode when you least expect it.

For instance, IIRC the biggest single image system SGI booted had 16k
cpus in there, that ends up at something like 14+14+3=31 aka as 2G of
storage just for your lookup -- that seems somewhat preposterous.

The domain levels are roughly O(log n) related to the total cpus, so
what you're doing is replacing an O(log n) lookup with an O(1) lookup,
but at the cost of O(n^2) storage. 



