Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966503AbaFRMZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:25:22 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:44141 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966264AbaFRMZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:25:19 -0400
Date: Wed, 18 Jun 2014 15:24:42 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 1/2] mm, thp: move invariant bug check out of loop in
 __split_huge_page_map
Message-ID: <20140618122442.GB5957@node.dhcp.inet.fi>
References: <1403044679-9993-1-git-send-email-Waiman.Long@hp.com>
 <1403044679-9993-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403044679-9993-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 06:37:58PM -0400, Waiman Long wrote:
> In the __split_huge_page_map() function, the check for
> page_mapcount(page) is invariant within the for loop. Because of the
> fact that the macro is implemented using atomic_read(), the redundant
> check cannot be optimized away by the compiler leading to unnecessary
> read to the page structure.
> 
> This patch moves the invariant bug check out of the loop so that it
> will be done only once. On a 3.16-rc1 based kernel, the execution
> time of a microbenchmark that broke up 1000 transparent huge pages
> using munmap() had an execution time of 38,245us and 38,548us with
> and without the patch respectively. The performance gain is about 1%.

For this low difference it would be nice to average over few runs +
stddev. It can easily can be a noise.

> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

But okay:

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
