Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab3FQXUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:20:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:59611 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab3FQXUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="331162690"
Message-ID: <51BF99B0.4040509@intel.com>
Date: Tue, 18 Jun 2013 07:20:16 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <1371165333.27102.568.camel@schen9-DESK>  <1371167015.1754.14.camel@buesod1.americas.hpqcorp.net>  <51BD8A77.2080201@intel.com> <1371486122.1778.14.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1371486122.1778.14.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 12:22 AM, Davidlohr Bueso wrote:
> After a lot of benchmarking, I finally got the ideal results for aim7,
> so far: this patch + optimistic spinning with preemption disabled. Just
> like optimistic spinning, this patch by itself makes little to no
> difference, yet combined is where we actually outperform 3.10-rc5. In
> addition, I noticed extra throughput when disabling preemption in
> try_optimistic_spin().
> 
> With i_mmap as a rwsem and these changes I could see performance
> benefits for alltests (+14.5%), custom (+17%), disk (+11%), high_systime
> (+5%), shared (+15%) and short (+4%), most of them after around 500
> users, for fewer users, it made little to no difference.

A pretty good number. what's the cpu number in your machine? :)

-- 
Thanks
    Alex
