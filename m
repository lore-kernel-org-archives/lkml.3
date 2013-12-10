Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab3LJIfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:35:38 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56738 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab3LJIfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:35:33 -0500
X-AuditID: 9c930197-b7bdbae000000e78-4b-52a6d253e62b
Date: Tue, 10 Dec 2013 17:38:25 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 2/7] mm/migrate: correct failure handling if
 !hugepage_migration_support()
Message-ID: <20131210083825.GB24992@lge.com>
References: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1386580248-22431-3-git-send-email-iamjoonsoo.kim@lge.com>
 <00000142d8263858-5c29199b-77e5-47a5-9db6-2ea6ea7c7fc8-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142d8263858-5c29199b-77e5-47a5-9db6-2ea6ea7c7fc8-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 04:17:32PM +0000, Christoph Lameter wrote:
> On Mon, 9 Dec 2013, Joonsoo Kim wrote:
> 
> > We should remove the page from the list if we fail without ENOSYS,
> > since migrate_pages() consider error cases except -ENOMEM and -EAGAIN
> > as permanent failure and it assumes that the page would be removed from
> > the list. Without this patch, we could overcount number of failure.
> 
> Ok what does the patch do about this? I dont see any modifications. Remove
> this part of the description?

Description is slightly wrong.
Following is correct one.

"We should remove the page from the list if we fail *with* ENOSYS,"

And this patch do this by adding putback_active_hugepage(hpage)
on ENOSYS case.

> 
> > In addition, we should put back the new hugepage if
> > !hugepage_migration_support(). If not, we would leak hugepage memory.
> 
> Ok looks like that is fixed by this patch.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Thanks.
