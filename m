Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab3LIQby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:31:54 -0500
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:43624 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932737Ab3LIQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:31:50 -0500
X-Greylist: delayed 856 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Dec 2013 11:31:50 EST
Date: Mon, 9 Dec 2013 16:17:32 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Joonsoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 2/7] mm/migrate: correct failure handling if
 !hugepage_migration_support()
In-Reply-To: <1386580248-22431-3-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000142d8263858-5c29199b-77e5-47a5-9db6-2ea6ea7c7fc8-000000@email.amazonses.com>
References: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com> <1386580248-22431-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.09-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Joonsoo Kim wrote:

> We should remove the page from the list if we fail without ENOSYS,
> since migrate_pages() consider error cases except -ENOMEM and -EAGAIN
> as permanent failure and it assumes that the page would be removed from
> the list. Without this patch, we could overcount number of failure.

Ok what does the patch do about this? I dont see any modifications. Remove
this part of the description?

> In addition, we should put back the new hugepage if
> !hugepage_migration_support(). If not, we would leak hugepage memory.

Ok looks like that is fixed by this patch.

Acked-by: Christoph Lameter <cl@linux.com>
