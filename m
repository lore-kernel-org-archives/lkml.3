Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3H1Jcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 05:32:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58084 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3H1Jcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 05:32:45 -0400
Date: Wed, 28 Aug 2013 11:32:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alex Thorlton <athorlton@sgi.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <robinmholt@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/8] THP: Use real address for NUMA policy
Message-ID: <20130828093219.GL10002@twins.programming.kicks-ass.net>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
 <1376663644-153546-2-git-send-email-athorlton@sgi.com>
 <520E672C.3080102@intel.com>
 <20130816181728.GQ26093@sgi.com>
 <20130816185212.GA3568@shutemov.name>
 <20130827165039.GC2886@sgi.com>
 <20130828091814.GA13681@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828091814.GA13681@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:18:14AM +0200, Ingo Molnar wrote:
> But ideally THP should detect cases where a hugepage is heavily used from 
> multiple nodes and un-HP the page in question. Or not turn it into a 
> hugepage in the first place. (We actually have a memory access pattern 
> sampling facility in place upstream, the new CONFIG_NUMA_BALANCING=y code, 
> which could in theory be utilized.)

Mel and I spoke about doing just that a few weeks ago. Breaking up THP
pages when we get shared faults from different nodes and avoiding
coalescing when the pages are from different nodes.

Rik seemed a little skeptical about the entire thing saying that the
huge tlb gain is about the same order as the locality thing -- while
this is more or less true for the 'tiny' machines most of us have, this
is clearly not the case for these big machines.
