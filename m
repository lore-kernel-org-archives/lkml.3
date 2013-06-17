Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3FQW1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:27:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:57231 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3FQW1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:27:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="331138158"
Subject: Re: Performance regression from switching lock to rw-sem for
 anon-vma tree
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Michel Lespinasse <walken@google.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        "Shi, Alex" <alex.shi@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <CANN689GtHw6dDeMd+2fuUz_dv_Z44XndVj2u-TNy70qkZWkpDw@mail.gmail.com>
References: <1371165333.27102.568.camel@schen9-DESK>
	 <1371167015.1754.14.camel@buesod1.americas.hpqcorp.net>
	 <1371226197.27102.594.camel@schen9-DESK>
	 <1371249104.1758.20.camel@buesod1.americas.hpqcorp.net>
	 <CANN689GtHw6dDeMd+2fuUz_dv_Z44XndVj2u-TNy70qkZWkpDw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jun 2013 15:27:46 -0700
Message-ID: <1371508066.27102.639.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 15:47 -0700, Michel Lespinasse wrote:
> On Fri, Jun 14, 2013 at 3:31 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> > A few ideas that come to mind are avoiding taking the ->wait_lock and
> > avoid dealing with waiters when doing the optimistic spinning (just like
> > mutexes do).
> >
> > I agree that we should first deal with the optimistic spinning before
> > adding the MCS complexity.
> 
> Maybe it would be worth disabling the MCS patch in mutex and comparing
> that to the rwsem patches ? Just to make sure the rwsem performance
> delta isn't related to that.
> 

I've tried to back out the MCS patch.  In fact, for exim, it is about 1%
faster without MCS.  So the better performance of mutex I saw was not
due to MCS.  Thanks for the suggestion.

Tim

