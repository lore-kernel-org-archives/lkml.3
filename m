Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763102Ab3IDRPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:15:33 -0400
Received: from relay3.sgi.com ([192.48.152.1]:58215 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752831Ab3IDRPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:15:32 -0400
Date: Wed, 4 Sep 2013 12:15:28 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Robin Holt <robinmholt@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
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
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/8] THP: Use real address for NUMA policy
Message-ID: <20130904171528.GB2975@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
 <1376663644-153546-2-git-send-email-athorlton@sgi.com>
 <520E672C.3080102@intel.com>
 <20130816181728.GQ26093@sgi.com>
 <20130816185212.GA3568@shutemov.name>
 <20130827165039.GC2886@sgi.com>
 <CAPp3RGqifK=tum94nGKcqSmDpzj3ceC_ZDo7KNLOz4KHjqv5mw@mail.gmail.com>
 <20130904154301.GA2975@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904154301.GA2975@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Robin,
> 
> I tweaked one of our other tests to behave pretty much exactly as I
> - malloc a large array
> - Spawn a specified number of threads
> - Have each thread touch small, evenly spaced chunks of the array (e.g.
>   for 128 threads, the array is divided into 128 chunks, and each thread
>   touches 1/128th of each chunk, dividing the array into 16,384 pieces)

Forgot to mention that the threads don't touch their chunks of memory
concurrently, i.e. thread 2 has to wait for thread 1 to finish first.
This is important to note, since the pages won't all get stuck on the
first node without this behavior.
