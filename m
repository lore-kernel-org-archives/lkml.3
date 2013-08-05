Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3HEPF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:05:57 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52267 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752514Ab3HEPFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:05:55 -0400
Date: Mon, 5 Aug 2013 10:05:51 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCHv2] Add per-process flag to control thp
Message-ID: <20130805150551.GA2703@sgi.com>
References: <20130802205735.GS26476@sgi.com>
 <20130803170102.GD32568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130803170102.GD32568@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 think the changelog should explain why madvise() is bad.

No problem.  I wanted to keep it simple for the original submission, but
that's probably something that should be included.

> But I simply can't understand why this flag is per-thread. It should
> be
> mm flag, no?

This is something that we (Robin and I) had discussed a while back, and,
upon review, I'm beginning to agree that this might be the more sensible
route to take.

I'm going to try and gather a bit more data to see if we can get some
more exact answers as to why THP is performing so poorly under certain
conditions before trying to push this particular patch any further.

Thanks for the input!

- Alex
