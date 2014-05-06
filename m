Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbaEFPE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:04:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaEFPE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:04:26 -0400
Message-ID: <5368F9F0.5070702@redhat.com>
Date: Tue, 06 May 2014 11:04:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/17] mm: page_alloc: Do not update zlc unless the zlc
 is active
References: <1398933888-4940-1-git-send-email-mgorman@suse.de> <1398933888-4940-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1398933888-4940-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 04:44 AM, Mel Gorman wrote:
> The zlc is used on NUMA machines to quickly skip over zones that are full.
> However it is always updated, even for the first zone scanned when the
> zlc might not even be active. As it's a write to a bitmap that potentially
> bounces cache line it's deceptively expensive and most machines will not
> care. Only update the zlc if it was active.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
