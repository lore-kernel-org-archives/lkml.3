Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3LKQMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:12:25 -0500
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:41063 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab3LKQMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:12:22 -0500
X-Greylist: delayed 685 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 11:12:22 EST
Date: Wed, 11 Dec 2013 16:00:56 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 7/7] mm/migrate: remove result argument on page
 allocation function for migration
In-Reply-To: <20131211084719.GA2043@lge.com>
Message-ID: <00000142e263bbcd-65959fd3-eadc-4580-b55b-065c734a229e-000000@email.amazonses.com>
References: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com> <1386580248-22431-8-git-send-email-iamjoonsoo.kim@lge.com> <00000142d83adfc7-81b70cc9-c87b-4e7e-bd98-0a97ee21db31-000000@email.amazonses.com> <20131211084719.GA2043@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.11-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Joonsoo Kim wrote:

> In do_move_pages(), if error occurs, 'goto out_pm' is executed and the
> page status doesn't back to userspace. So we don't need to store err number.

If a page cannot be moved then the error code is containing the number of
pages that could not be migrated. The check there is for err < 0.
So a positive number is not an error.

migrate_pages only returns an error code if we are running out of memory.
