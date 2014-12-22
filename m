Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaLVR7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:59:40 -0500
Received: from mga14.intel.com ([192.55.52.115]:49937 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071AbaLVR7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:59:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,625,1413270000"; 
   d="scan'208";a="658576858"
Message-ID: <54985C08.8080608@linux.intel.com>
Date: Mon, 22 Dec 2014 09:59:36 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, oleg@redhat.com, rientjes@google.com,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] proc: task_mmu: show page size in /proc/<pid>/numa_maps
References: <c97f30472ec5fe79cb8fa8be66cc3d8509777990.1419079617.git.aquini@redhat.com> <20141220183613.GA19229@phnom.home.cmpxchg.org> <20141220194457.GA3166@x61.redhat.com> <54970B49.3070104@linux.intel.com> <20141221222850.GA2038@x61.redhat.com> <5498508A.4080108@linux.intel.com> <20141222172459.GA11396@t510.redhat.com>
In-Reply-To: <20141222172459.GA11396@t510.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 09:25 AM, Rafael Aquini wrote:
> Remaining question here is: should we print out 'pagesize' deliberately 
> or conditionally, only to disambiguate cases where page_size != PAGE_SIZE?

I say print it unconditionally.  Not to completely overdesign this, but
I do think we should try to at least mirror the terminology that smaps uses:

	KernelPageSize:        4 kB
	MMUPageSize:           4 kB

So definitely call this kernelpagesize.

It appears that powerpc is the only architecture where there is a
difference, and I'm not sure that this is very common at all these days.
 Do we need mmupagesize in numa_maps too?

