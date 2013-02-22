Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab3BVJyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:54:24 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:47777 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3BVJyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:54:20 -0500
Date: Fri, 22 Feb 2013 10:54:16 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
Message-ID: <20130222095416.GA4450@gmail.com>
References: <51079178.3070002@linux.vnet.ibm.com>
 <20130220104958.GA9152@gmail.com>
 <5125A7C8.8020308@linux.vnet.ibm.com>
 <1361442055.26780.3.camel@laptop>
 <5126D9E0.7040108@linux.vnet.ibm.com>
 <1361522197.26780.39.camel@laptop>
 <1361526022.5817.115.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361526022.5817.115.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Fri, 2013-02-22 at 09:36 +0100, Peter Zijlstra wrote: 
> > On Fri, 2013-02-22 at 10:37 +0800, Michael Wang wrote:
> > > But that's really some benefit hardly to be estimate, especially when
> > > the workload is heavy, the cost of wake_affine() is very high to
> > > calculated se one by one, is that worth for some benefit we could not
> > > promise?
> > 
> > Look at something like pipe-test.. wake_affine() used to 
> > ensure both client/server ran on the same cpu, but then I 
> > think we added select_idle_sibling() and wrecked it again :/
> 
> Yeah, that's the absolute worst case for 
> select_idle_sibling(), 100% synchronous, absolutely nothing to 
> be gained by cross cpu scheduling. Fortunately, most tasks do 
> more than that, but nonetheless, select_idle_sibling() 
> definitely is a two faced little b*tch.  I'd like to see the 
> evil b*tch die, but something needs to replace it's pretty 
> face.  One thing that you can do is simply don't call it when 
> the context switch rate is incredible.. its job is to recover 
> overlap, if you're scheduling near your max, there's no win 
> worth the cost.

Couldn't we make the cutoff dependent on sched_migration_cost? 
If the wakeup comes in faster than that then don't spread.

Thanks,

	Ingo
