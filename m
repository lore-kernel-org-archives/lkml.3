Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaCRR0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:26:46 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:49598
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757151AbaCRR0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:26:42 -0400
Date: Tue, 18 Mar 2014 12:26:40 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Peter Zijlstra <peterz@infradead.org>
cc: Dave Hansen <dave.hansen@intel.com>, lsf@lists.linux-foundation.org,
        Linux-MM <linux-mm@kvack.org>, Wu Fengguang <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Lsf] [LSF/MM TOPIC] Testing Large-Memory Hardware
In-Reply-To: <20140318165059.GI22095@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1403181224000.23935@nuc>
References: <5328753B.2050107@intel.com> <20140318165059.GI22095@laptop.programming.kicks-ass.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Peter Zijlstra wrote:

> > My gut reaction was that we'd probably be better served by putting
> > resources in to systems with higher core counts rather than lots of RAM.
> >  I have encountered the occasional boot bug on my 1TB system, but it's
> > far from a frequent occurrence, and even more infrequent to encounter
> > things at runtime.
> >
> > Would folks agree with that?  What kinds of tests, benchmarks, stress
> > tests, etc... do folks run that are both valuable and can only be run on
> > a system with a large amount of actual RAM?
>
> We had a sched-numa + kvm fail on really large systems the other day,
> but yeah in general such problems tend to be rare. Then again, without
> test coverage they will always be rare, for even if there were problems,
> nobody would notice :-)

SGI had systems out there up to few PB of RAM. There were a couple of
tricks to get this going. Bootup time was pretty long. I/O has to be done
carefully. The MM subsystem used to work with these sizes (I have not had
a chance to verify that recently).

This was Itanium with 64K page size so you had a factor of 16 less page
structs to process. What I saw there is one of the reasons why I would
like to see larger page support in the kernel. Managing massive amounts of
4k pages is creation far too much overhead.

