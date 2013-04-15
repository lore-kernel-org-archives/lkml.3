Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab3DOXTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:19:37 -0400
Received: from www.sr71.net ([198.145.64.142]:54956 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab3DOXTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:19:35 -0400
Message-ID: <516C8B03.7040203@sr71.net>
Date: Mon, 15 Apr 2013 16:19:31 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] IOZone with transparent huge page cache
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com> <20130415181718.4A1A1E0085@blue.fi.intel.com>
In-Reply-To: <20130415181718.4A1A1E0085@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2013 11:17 AM, Kirill A. Shutemov wrote:
> I run iozone using mmap files (-B) with different number of threads.
> The test machine is 4s Westmere - 4x10 cores + HT.

How did you run this, exactly?  Which iozone arguments?  It was run on
ramfs, since that's the only thing that transparent huge page cache
supports right now?

> ** Initial writers **
> threads:	        1        2        4        8       16       32       64      128      256
> baseline:	  1103360   912585   500065   260503   128918    62039    34799    18718     9376
> patched:	  2127476  2155029  2345079  1942158  1127109   571899   127090    52939    25950
> speed-up(times):     1.93     2.36     4.69     7.46     8.74     9.22     3.65     2.83     2.77

I'm a _bit_ surprised that iozone scales _that_ badly especially while
threads<nr_cpus.  Is this normal for iozone?  What are the units and
metric there, btw?

> Minimal speed up is in 1-thread reverse readers - 23%.
> Maximal is 9.2 times in 32-thread initial writers. It's probably due
> batched radix tree insert - we insert 512 pages a time. It reduces
> mapping->tree_lock contention.

It might actually be interesting to see this at 10, 20, 40, 80, etc...
since that'll actually match iozone threads to CPU cores on your
particular system.
