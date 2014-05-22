Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaEVCvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 22:51:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40844 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbaEVCvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 22:51:13 -0400
Date: Wed, 21 May 2014 19:51:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 2/2] mm/compaction: avoid rescanning pageblocks in
 isolate_freepages
In-Reply-To: <5379D99E.1020302@suse.cz>
Message-ID: <alpine.DEB.2.02.1405211950430.13243@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com> <1399464550-26447-1-git-send-email-vbabka@suse.cz> <1399464550-26447-2-git-send-email-vbabka@suse.cz> <5379D99E.1020302@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1088296400-1400727068=:13243"
Content-ID: <alpine.DEB.2.02.1405211951100.13243@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1088296400-1400727068=:13243
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.02.1405211951101.13243@chino.kir.corp.google.com>

On Mon, 19 May 2014, Vlastimil Babka wrote:

> Fix a (spurious) build warning:
> 
> mm/compaction.c:860:15: warning: ‘next_free_pfn’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> Seems like the compiler cannot prove that exiting the for loop without updating
> next_free_pfn there will mean that the check for crossing the scanners will
> trigger. So let's not confuse people who try to see why this warning occurs.
> 
> Instead of initializing next_free_pfn to zero with an explaining comment, just
> drop the damned variable altogether and work with cc->free_pfn directly as
> Nayoa originally suggested.
> 

s/Nayoa/Naoya/

> Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: David Rientjes <rientjes@google.com>
--531381512-1088296400-1400727068=:13243--
