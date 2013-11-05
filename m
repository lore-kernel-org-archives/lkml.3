Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab3KEXfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:35:38 -0500
Received: from [204.155.152.216] ([204.155.152.216]:45627 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab3KEXfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:35:37 -0500
Date: Wed, 6 Nov 2013 00:39:06 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Rik van Riel <riel@redhat.com>
Cc: Ron van der Wees <rvdwees@redhat.com>, Erik Mouw <erik.mouw_2@nxp.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, walken@google.com,
        Shaohua Li <shli@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH -mm] provide estimated available memory in
 /proc/meminfo
Message-ID: <20131105223906.GB20167@shutemov.name>
References: <ECFC0369-0745-44AB-9858-E689F41CCB4D@nxp.com>
 <5256D4C7.90301@redhat.com>
 <DB649DE8-5595-4370-912B-BDC6BD5FF8C3@nxp.com>
 <20131025120752.GB2415@rh0004426.ams.redhat.com>
 <20131105173852.709a103b@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105173852.709a103b@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 05:38:52PM -0500, Rik van Riel wrote:
> Many load balancing and workload placing programs check /proc/meminfo
> to estimate how much free memory is available. They generally do this
> by adding up "free" and "cached", which was fine ten years ago, but
> is pretty much guaranteed to be wrong today.
> 
> It is wrong because Cached includes memory that is not freeable as
> page cache, for example shared memory segments, tmpfs, and ramfs,
> and it does not include reclaimable slab memory, which can take up
> a large fraction of system memory on mostly idle systems with lots
> of files.
> 
> Currently, the amount of memory that is available for a new workload,
> without pushing the system into swap, can be estimated from MemFree,
> Active(file), Inactive(file), and SReclaimable, as well as the "low"
> watermarks from /proc/zoneinfo.

ramfs pages first go to (in)active lists, moves to unevictable later, so
it's not really true already. ;)

-- 
 Kirill A. Shutemov
