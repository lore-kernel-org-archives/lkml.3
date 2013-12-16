Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3LPUwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:52:45 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:50199 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab3LPUwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:52:43 -0500
Date: Mon, 16 Dec 2013 15:52:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] mm: page_alloc: Only account batch allocations
 requests that are eligible
Message-ID: <20131216205237.GB21724@cmpxchg.org>
References: <1386943807-29601-1-git-send-email-mgorman@suse.de>
 <1386943807-29601-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386943807-29601-7-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 02:10:06PM +0000, Mel Gorman wrote:
> Not signed off. Johannes, was the intent really to decrement the batch
> counts regardless of whether the policy was being enforced or not?

Yes.  Bursts of allocations for which the policy does not get enforced
will still create memory pressure and affect cache aging on a given
node.  So even if we only distribute page cache, we want to distribute
it in a way that all allocations on the eligible zones equal out.
