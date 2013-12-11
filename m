Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3LKPWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:22:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab3LKPWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:22:03 -0500
Date: Wed, 11 Dec 2013 10:21:26 -0500
From: Rik van Riel <riel@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: numa: Guarantee that tlb_flush_pending updates are
 visible before page table updates
Message-ID: <20131211102126.532c763d@annuminas.surriel.com>
In-Reply-To: <20131211132109.GB24125@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
	<20131211132109.GB24125@suse.de>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 13:21:09 +0000
Mel Gorman <mgorman@suse.de> wrote:

> According to documentation on barriers, stores issued before a LOCK can
> complete after the lock implying that it's possible tlb_flush_pending can
> be visible after a page table update. As per revised documentation, this patch
> adds a smp_mb__before_spinlock to guarantee the correct ordering.

And now you have 18 patches :)
 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>
 
-- 
All rights reversed.
