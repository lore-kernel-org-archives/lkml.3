Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab3HNI5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:57:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56821 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759559Ab3HNI5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:57:16 -0400
Date: Wed, 14 Aug 2013 09:57:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
        Minchan Kim <minchan@kernel.org>, aquini@redhat.com,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: skip the page buddy block instead of one page
Message-ID: <20130814085711.GK2296@suse.de>
References: <520B0B75.4030708@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <520B0B75.4030708@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 12:45:41PM +0800, Xishi Qiu wrote:
> A large free page buddy block will continue many times, so if the page 
> is free, skip the whole page buddy block instead of one page.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>

page_order cannot be used unless zone->lock is held which is not held in
this path. Acquiring the lock would prevent parallel allocations from the
buddy allocator (per-cpu allocator would be ok except for refills).  I expect
it would not be a good tradeoff to acquire the lock just to use page_order.

Nak.

-- 
Mel Gorman
SUSE Labs
