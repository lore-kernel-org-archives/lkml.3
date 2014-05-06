Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaEFRZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:25:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaEFRZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:25:22 -0400
Message-ID: <53691AF9.7080608@redhat.com>
Date: Tue, 06 May 2014 13:25:13 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/17] mm: page_alloc: Take the ALLOC_NO_WATERMARK check
 out of the fast path
References: <1398933888-4940-1-git-send-email-mgorman@suse.de> <1398933888-4940-8-git-send-email-mgorman@suse.de>
In-Reply-To: <1398933888-4940-8-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 04:44 AM, Mel Gorman wrote:
> ALLOC_NO_WATERMARK is set in a few cases. Always by kswapd, always for
> __GFP_MEMALLOC, sometimes for swap-over-nfs, tasks etc. Each of these cases
> are relatively rare events but the ALLOC_NO_WATERMARK check is an unlikely
> branch in the fast path.  This patch moves the check out of the fast path
> and after it has been determined that the watermarks have not been met. This
> helps the common fast path at the cost of making the slow path slower and
> hitting kswapd with a performance cost. It's a reasonable tradeoff.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
