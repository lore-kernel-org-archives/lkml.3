Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab3GDJcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:32:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3GDJcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:32:14 -0400
Date: Thu, 4 Jul 2013 10:32:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/13] mm: numa: Scan pages with elevated page_mapcount
Message-ID: <20130704093211.GN1875@suse.de>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-13-git-send-email-mgorman@suse.de>
 <20130703184124.GD18898@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130703184124.GD18898@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 08:41:24PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 03, 2013 at 03:21:39PM +0100, Mel Gorman wrote:
> 
> > Note that the patch still leaves shared, file-backed in VM_EXEC vmas in
> > place guessing that these are shared library pages. Migrating them are
> > likely to be of major benefit as generally the expectation would be that
> > these are read-shared between caches and that iTLB and iCache pressure is
> > generally low.
> 
> I'm failing to grasp.. we don't migrate them because migrating them would
> likely be beneficial?
> 
> Missing a negative somewhere?

Yes.

Note that the patch does not migrate shared, file-backed within vmas marked
VM_EXEC as these are generally shared library pages. Migrating such pages
is not beneficial as there is an expectation they are read-shared between
caches and iTLB and iCache pressure is generally low.

-- 
Mel Gorman
SUSE Labs
