Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3I0OFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:05:10 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:43348 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752238Ab3I0OFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:05:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3
X-HE-Tag: screw10_6609ca4c22439
X-Filterd-Recvd-Size: 3769
Message-ID: <1380290700.17366.95.camel@joe-AO722>
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
From: Joe Perches <joe@perches.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Jason Low <jason.low2@hp.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Date: Fri, 27 Sep 2013 07:05:00 -0700
In-Reply-To: <20130927134802.GA15690@laptop.programming.kicks-ass.net>
References: <1380226007.2170.2.camel@buesod1.americas.hpqcorp.net>
	 <1380226997.2602.11.camel@j-VirtualBox>
	 <1380228059.2170.10.camel@buesod1.americas.hpqcorp.net>
	 <1380229794.2602.36.camel@j-VirtualBox>
	 <1380231702.3467.85.camel@schen9-DESK>
	 <1380235333.3229.39.camel@j-VirtualBox>
	 <1380236265.3467.103.camel@schen9-DESK> <20130927060213.GA6673@gmail.com>
	 <20130927112323.GJ3657@laptop.programming.kicks-ass.net>
	 <1380289495.17366.91.camel@joe-AO722>
	 <20130927134802.GA15690@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 15:48 +0200, Peter Zijlstra wrote:
> On Fri, Sep 27, 2013 at 06:44:55AM -0700, Joe Perches wrote:
> > It's a CHK test, so it's only tested with --strict
> > 
> > $ scripts/checkpatch.pl -f --strict kernel/mutex.c 2>&1 | grep memory
> > CHECK: memory barrier without comment
> > CHECK: memory barrier without comment
> > 
> > It could be changed to WARN so it's always on.
> 
> Yes please, we can't be too careful with memory barriers.

I'll send the patch separately.

It seems a pretty noisy test.
There are 13 hits just in arch/x86/kernel/

$ ./scripts/checkpatch.pl -f arch/x86/kernel/*.c | grep -A3 "memory barrier"
WARNING: memory barrier without comment
#685: FILE: x86/kernel/alternative.c:685:
+	smp_wmb();

--
WARNING: memory barrier without comment
#401: FILE: x86/kernel/kvm.c:401:
+		rmb();

WARNING: memory barrier without comment
#403: FILE: x86/kernel/kvm.c:403:
+		rmb();

--
WARNING: memory barrier without comment
#702: FILE: x86/kernel/kvm.c:702:
+	smp_wmb();

WARNING: memory barrier without comment
#704: FILE: x86/kernel/kvm.c:704:
+	smp_wmb();

--
WARNING: memory barrier without comment
#62: FILE: x86/kernel/ldt.c:62:
+	wmb();

WARNING: memory barrier without comment
#64: FILE: x86/kernel/ldt.c:64:
+	wmb();

--
WARNING: memory barrier without comment
#204: FILE: x86/kernel/smpboot.c:204:
+	wmb();

WARNING: memory barrier without comment
#265: FILE: x86/kernel/smpboot.c:265:
+	wmb();

--
WARNING: memory barrier without comment
#557: FILE: x86/kernel/smpboot.c:557:
+	mb();

--
WARNING: memory barrier without comment
#1065: FILE: x86/kernel/smpboot.c:1065:
+	mb();

--
WARNING: memory barrier without comment
#1321: FILE: x86/kernel/smpboot.c:1321:
+	mb();

WARNING: memory barrier without comment
#1399: FILE: x86/kernel/smpboot.c:1399:
+		mb();



