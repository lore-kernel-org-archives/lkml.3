Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbaFJAHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:07:09 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34004 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311AbaFJAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:07:06 -0400
Date: Mon, 9 Jun 2014 17:07:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 05/10] mm, compaction: remember position within pageblock
 in free pages scanner
In-Reply-To: <1402305982-6928-5-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1406091706500.17705@chino.kir.corp.google.com>
References: <1402305982-6928-1-git-send-email-vbabka@suse.cz> <1402305982-6928-5-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Vlastimil Babka wrote:

> Unlike the migration scanner, the free scanner remembers the beginning of the
> last scanned pageblock in cc->free_pfn. It might be therefore rescanning pages
> uselessly when called several times during single compaction. This might have
> been useful when pages were returned to the buddy allocator after a failed
> migration, but this is no longer the case.
> 
> This patch changes the meaning of cc->free_pfn so that if it points to a
> middle of a pageblock, that pageblock is scanned only from cc->free_pfn to the
> end. isolate_freepages_block() will record the pfn of the last page it looked
> at, which is then used to update cc->free_pfn.
> 
> In the mmtests stress-highalloc benchmark, this has resulted in lowering the
> ratio between pages scanned by both scanners, from 2.5 free pages per migrate
> page, to 2.25 free pages per migrate page, without affecting success rates.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: David Rientjes <rientjes@google.com>
