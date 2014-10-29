Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaJ2Rlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:41:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:60778 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaJ2Rlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:41:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="408001793"
Date: Wed, 29 Oct 2014 10:41:47 -0700 (PDT)
From: Vikas Shivappa <vikas.shivappa@intel.com>
X-X-Sender: vikas@vshiva-Udesk
To: Peter Zijlstra <peterz@infradead.org>
cc: "Auld, Will" <will.auld@intel.com>, Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>, Tejun Heo <tj@kernel.org>,
        "Shivappa, Vikas" <vikas.shivappa@intel.com>
Subject: Re: Cache Allocation Technology Design
In-Reply-To: <20141029172845.GP12706@worktop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
References: <1413485050.28564.14.camel@vshiva-Udesk> <20141020161855.GF12020@console-pimps.org> <20141024105306.GI12706@worktop.programming.kicks-ass.net> <20141028232215.GO12020@console-pimps.org> <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org> <20141029134526.GC3337@twins.programming.kicks-ass.net> <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com> <20141029172845.GP12706@worktop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Oct 2014, Peter Zijlstra wrote:

> On Wed, Oct 29, 2014 at 04:32:04PM +0000, Auld, Will wrote:
>> I maybe repeating what Peter has just said but for elements in the
>> hierarchy where the mask is the same as its parents mask there is no
>> need for a separate CLOS even in the case where there are tasks in the
>> group. So we can inherit the CLOS of the parent until which time both
>> the mask is different than the parent and there are tasks in the
>> group.
>
> I did not state that explicitly, but I did think about that. We could
> still wait to allocate a CLOS until at least one such group acquires a
> task.
>

Was wondering if it is a requirement of the 'full hierarchy' for the 
child to inherit the cbm of parent ? .
Alternately we can allocate the CLOSid when a cgroup 
is created and have an empty cbm - but dont let the tasks to be added 
unless the user assigns a cbm. Cpuset does something similar where 
its necessary to set the cpu mask(empty by default) of a cgroup before adding 
tasks.
