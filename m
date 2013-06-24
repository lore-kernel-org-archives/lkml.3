Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3FXVak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 17:30:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:35526 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab3FXVag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 17:30:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,931,1363158000"; 
   d="scan'208";a="334861716"
Subject: Re: [PATCH 2/2] rwsem: do optimistic spinning for writer lock
 acquisition
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Alex Shi <alex.shi@intel.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <51C8B0AA.4070204@hurleysoftware.com>
References: <cover.1371855277.git.tim.c.chen@linux.intel.com>
	 <1371858700.22432.5.camel@schen9-DESK>
	 <51C558E2.1040108@hurleysoftware.com>
	 <1372017836.1797.14.camel@buesod1.americas.hpqcorp.net>
	 <1372093876.22432.34.camel@schen9-DESK>
	 <51C894C3.4040407@hurleysoftware.com>
	 <1372105065.22432.65.camel@schen9-DESK>
	 <51C8B0AA.4070204@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jun 2013 14:30:38 -0700
Message-ID: <1372109438.22432.75.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 16:48 -0400, Peter Hurley wrote:

> 
> Also, I haven't given a lot of thought to if preemption must be disabled
> before calling rwsem_can_spin_on_owner(). If so, wouldn't you just drop
> rwsem_can_spin_on_owner() (because the conditions tested in the loop are
> equivalent)?
> 

Not totally equivalent.  If we drop the call to rwsem_can_spin_on_owner,
we will spin when readers are holding the lock (owner is null).  
Right now we only allow writers to spin when other writers are 
holding the lock by adding the rwsem_can_spin_on_owner check.  
Letting spinning on readers held lock is tricky as
we could have a reader that sleeps and if we don't detect the case.  We
could spin for too long.

Thanks.

Tim


