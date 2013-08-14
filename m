Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759713Ab3HNJPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:15:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:63325 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3HNJPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:15:48 -0400
Message-ID: <520B4A76.8050903@huawei.com>
Date: Wed, 14 Aug 2013 17:14:30 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, <aquini@redhat.com>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: skip the page buddy block instead of one page
References: <520B0B75.4030708@huawei.com> <20130814085711.GK2296@suse.de>
In-Reply-To: <20130814085711.GK2296@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/14 16:57, Mel Gorman wrote:

> On Wed, Aug 14, 2013 at 12:45:41PM +0800, Xishi Qiu wrote:
>> A large free page buddy block will continue many times, so if the page 
>> is free, skip the whole page buddy block instead of one page.
>>
>> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> 
> page_order cannot be used unless zone->lock is held which is not held in
> this path. Acquiring the lock would prevent parallel allocations from the
> buddy allocator (per-cpu allocator would be ok except for refills).  I expect
> it would not be a good tradeoff to acquire the lock just to use page_order.
> 
> Nak.
> 

Oh, you are right, we must hold zone->lock first.

Thanks,
Xishi Qiu
