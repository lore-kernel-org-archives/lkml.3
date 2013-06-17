Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab3FQXTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:19:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:16437 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3FQXTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:19:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="331161972"
Message-ID: <51BF9960.904@intel.com>
Date: Tue, 18 Jun 2013 07:18:56 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Performance regression from switching lock to rw-sem for anon-vma
 tree
References: <1371165333.27102.568.camel@schen9-DESK>  <1371167015.1754.14.camel@buesod1.americas.hpqcorp.net>  <51BD8A77.2080201@intel.com>  <1371486122.1778.14.camel@buesod1.americas.hpqcorp.net> <1371494746.27102.633.camel@schen9-DESK>
In-Reply-To: <1371494746.27102.633.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 02:45 AM, Tim Chen wrote:
>>> +			if (unlikely(sem->count < RWSEM_WAITING_BIAS)) {
>>> > > +				cpu_relax();
>>> > > +				continue;
>>> > > +			}
> The above two if statements could be cleaned up as a single check:
> 		
> 			if (unlikely(sem->count < RWSEM_WAITING_BIAS))
> 				return sem;
> 	 
> This one statement is sufficient to check that we don't have a writer
> stolen the lock before we attempt to acquire the read lock by modifying
> sem->count.  
> 
> 

Thanks. I will send out the patchset base your suggestion.


-- 
Thanks
    Alex
