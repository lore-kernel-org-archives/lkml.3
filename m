Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935392Ab3BTOFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:05:31 -0500
Received: from mout.gmx.net ([212.227.17.20]:54659 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935312Ab3BTOFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:05:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Yu2I7cp/YH8vJcJMI0jkRRTHfY/T8giOrvXGdfD
	Pz4zBdyJ7LVz+W
Message-ID: <1361369119.5919.86.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>, Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Wed, 20 Feb 2013 15:05:19 +0100
In-Reply-To: <1361367148.10155.30.camel@laptop>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <1361367148.10155.30.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 14:32 +0100, Peter Zijlstra wrote: 
> On Wed, 2013-02-20 at 11:49 +0100, Ingo Molnar wrote:
> 
> > The changes look clean and reasoable, 
> 
> I don't necessarily agree, note that O(n^2) storage requirement that
> Michael failed to highlight ;-)

(yeah, I mentioned that needs to shrink.. a lot)

> > any ideas exactly *why* it speeds up?
> 
> That is indeed the most interesting part.. There's two parts to
> select_task_rq_fair(), the 'regular' affine wakeup path, and the
> fork/exec find_idlest_goo() path. At the very least we need to quantify
> which of these two parts contributes most to the speedup.
> 
> In the power balancing discussion we already noted that the
> find_idlest_goo() is in need of attention.

Yup, even little stuff like break off the search when load is zero..
unless someone is planning on implementing anti-idle 'course ;-)

-Mike


