Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701AbaJUR4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:56:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:53116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430AbaJUR4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:56:11 -0400
Date: Tue, 21 Oct 2014 19:56:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        akpm@linux-foundation.org, riel@redhat.com, mgorman@suse.de,
        oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 0/6] Another go at speculative page faults
Message-ID: <20141021175603.GI3219@twins.programming.kicks-ass.net>
References: <20141020215633.717315139@infradead.org>
 <20141021162340.GA5508@gmail.com>
 <20141021170948.GA25964@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021170948.GA25964@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 08:09:48PM +0300, Kirill A. Shutemov wrote:
> It would be interesting to see if the patchset affects non-condended case.
> Like a one-threaded workload.

It does, and not in a good way, I'll have to look at that... :/

 Performance counter stats for './multi-fault 1' (5 runs):

        73,860,251      page-faults                                                   ( +-  0.28% )
            40,914      cache-misses                                                  ( +- 41.26% )

      60.001484913 seconds time elapsed                                          ( +-  0.00% )


 Performance counter stats for './multi-fault 1' (5 runs):

        70,700,838      page-faults                                                   ( +-  0.03% )
            31,466      cache-misses                                                  ( +-  8.62% )

      60.001753906 seconds time elapsed                                          ( +-  0.00% )
