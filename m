Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3LPNUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:20:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab3LPNUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:20:23 -0500
Message-ID: <52AEFE08.5020501@redhat.com>
Date: Mon, 16 Dec 2013 08:20:08 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] mm: page_alloc: Use zone node IDs to approximate
 locality
References: <1386943807-29601-1-git-send-email-mgorman@suse.de> <1386943807-29601-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1386943807-29601-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 09:10 AM, Mel Gorman wrote:
> zone_local is using node_distance which is a more expensive call than
> necessary. On x86, it's another function call in the allocator fast path
> and increases cache footprint. This patch makes the assumption zones on a
> local node will share the same node ID. The necessary information should
> already be cache hot.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
