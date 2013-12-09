Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142Ab3LIQzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:55:46 -0500
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:45271 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932795Ab3LIQzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:55:44 -0500
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Dec 2013 11:55:43 EST
Date: Mon, 9 Dec 2013 16:40:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Rafael Aquini <aquini@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Joonsoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v2 7/7] mm/migrate: remove result argument on page
 allocation function for migration
In-Reply-To: <1386580248-22431-8-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <00000142d83adfc7-81b70cc9-c87b-4e7e-bd98-0a97ee21db31-000000@email.amazonses.com>
References: <1386580248-22431-1-git-send-email-iamjoonsoo.kim@lge.com> <1386580248-22431-8-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.09-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Joonsoo Kim wrote:

> First, we don't use error number in fail case. Call-path related to
> new_page_node() is shown in the following.
>
> do_move_page_to_node_array() -> migrate_pages() -> unmap_and_move()
> -> new_page_node()
>
> If unmap_and_move() failed, migrate_pages() also returns err, and then
> do_move_page_to_node_array() skips to set page's status to user buffer.
> So we don't need to set error number to each pages on failure case.

I dont get this. new_page_node() sets the error condition in the
page_to_node array before this patch. There is no post processing in
do_move_page_to_node_array(). The function simply returns and relies on
new_page_node() to have set the page status. do_move_pages() then returns
the page status back to userspace. How does the change preserve these
diagnostics?

> Next, we don't need to set node id of the new page in unmap_and_move(),
> since it cannot be different with pm->node. In new_page_node(), we always
> try to allocate the page in exact node by referencing pm->node. So it is
> sufficient to set node id of the new page in new_page_node(), instead of
> unmap_and_move().

Thats a good thought.


