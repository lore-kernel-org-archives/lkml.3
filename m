Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3I0GCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:02:20 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48664 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3I0GCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:02:18 -0400
Date: Fri, 27 Sep 2013 08:02:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Jason Low <jason.low2@hp.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
Message-ID: <20130927060213.GA6673@gmail.com>
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>
 <1380147049.3467.67.camel@schen9-DESK>
 <CAGQ1y=7Ehkr+ot3tDZtHv6FR6RQ9fXBVY0=LOyWjmGH_UjH7xA@mail.gmail.com>
 <1380226007.2170.2.camel@buesod1.americas.hpqcorp.net>
 <1380226997.2602.11.camel@j-VirtualBox>
 <1380228059.2170.10.camel@buesod1.americas.hpqcorp.net>
 <1380229794.2602.36.camel@j-VirtualBox>
 <1380231702.3467.85.camel@schen9-DESK>
 <1380235333.3229.39.camel@j-VirtualBox>
 <1380236265.3467.103.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380236265.3467.103.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Chen <tim.c.chen@linux.intel.com> wrote:

> > If we prefer to optimize this a bit though, perhaps we can first move 
> > the node->lock = 0 so that it gets executed after the "if (likely(prev 
> > == NULL)) {}" code block and then delete "node->lock = 1" inside the 
> > code block.
> 
> I suppose we can save one single assignment. The gain is probably not 
> noticeable as once we set node->next to NULL, node->locked is likely in 
> local cache line and the assignment operation is cheap.

Would be nice to have this as a separate, add-on patch. Every single 
instruction removal that has no downside is an upside!

You can add a comment that explains it.

Thanks,

	Ingo
