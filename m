Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3KDHFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 02:05:07 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61764 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3KDHFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 02:05:06 -0500
Date: Mon, 4 Nov 2013 08:05:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Davidlohr Bueso <davidlohr@hp.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        aswin@hp.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm: cache largest vma
Message-ID: <20131104070500.GE13030@gmail.com>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
 <20131103101234.GB5330@gmail.com>
 <1383538810.2373.22.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383538810.2373.22.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Davidlohr Bueso <davidlohr@hp.com> wrote:

> Btw, do you suggest using a high level tool such as perf for getting 
> this data or sprinkling get_cycles() in find_vma() -- I'd think that the 
> first isn't fine grained enough, while the later will probably variate a 
> lot from run to run but the ratio should be rather constant.

LOL - I guess I should have read your mail before replying to it ;-)

Yes, I think get_cycles() works better in this case - not due to 
granularity (perf stat will report cycle granular just fine), but due to 
the size of the critical path you'll be measuring. You really want to 
extract the delta, because it's probably so much smaller than the overhead 
of the workload itself.

[ We still don't have good 'measure overhead from instruction X to 
  instruction Y' delta measurement infrastructure in perf yet, although
  Frederic is working on such a trigger/delta facility AFAIK. ]

Thanks,

	Ingo
