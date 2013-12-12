Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3LLAER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:04:17 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51525 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab3LLAEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:04:16 -0500
X-AuditID: 9c930179-b7ce4ae000000e86-0b-52a8fd7e3c3e
Date: Thu, 12 Dec 2013 09:07:14 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 7/7] mm/migrate: remove result argument on page
 allocation function for migration
Message-ID: <20131212000714.GA3634@lge.com>
References: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1386580248-22431-8-git-send-email-iamjoonsoo.kim@lge.com>
 <00000142d83adfc7-81b70cc9-c87b-4e7e-bd98-0a97ee21db31-000000@email.amazonses.com>
 <20131211084719.GA2043@lge.com>
 <00000142e263bbcd-65959fd3-eadc-4580-b55b-065c734a229e-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142e263bbcd-65959fd3-eadc-4580-b55b-065c734a229e-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 04:00:56PM +0000, Christoph Lameter wrote:
> On Wed, 11 Dec 2013, Joonsoo Kim wrote:
> 
> > In do_move_pages(), if error occurs, 'goto out_pm' is executed and the
> > page status doesn't back to userspace. So we don't need to store err number.
> 
> If a page cannot be moved then the error code is containing the number of
> pages that could not be migrated. The check there is for err < 0.
> So a positive number is not an error.
> 
> migrate_pages only returns an error code if we are running out of memory.

Ah... I missed it. I will drop this patch and send v3 for whole patchset.

Thanks.
