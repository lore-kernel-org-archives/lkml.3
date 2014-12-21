Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaLUSCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 13:02:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:63354 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbaLUSCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 13:02:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="502305545"
Message-ID: <54970B49.3070104@linux.intel.com>
Date: Sun, 21 Dec 2014 10:02:49 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, oleg@redhat.com,
        rientjes@google.com, linux-mm@kvack.org
Subject: Re: [PATCH] proc: task_mmu: show page size in /proc/<pid>/numa_maps
References: <c97f30472ec5fe79cb8fa8be66cc3d8509777990.1419079617.git.aquini@redhat.com> <20141220183613.GA19229@phnom.home.cmpxchg.org> <20141220194457.GA3166@x61.redhat.com>
In-Reply-To: <20141220194457.GA3166@x61.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2014 11:44 AM, Rafael Aquini wrote:
>> > 
>> > It would be simpler to include this unconditionally.  Otherwise you
>> > are forcing everybody parsing the file and trying to run calculations
>> > of it to check for its presence, and then have them fall back and get
>> > the value from somewhere else if not.
> I'm fine either way, it makes the change even simpler. Also, if we
> decide to get rid of page_size != PAGE_SIZE condition I believe we can 
> also get rid of that "huge" hint being conditionally printed out too.

That would break existing users of the "huge" flag.  That makes it out
of the question, right?

