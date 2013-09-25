Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3IYIbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:31:11 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:44727 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3IYIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:31:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAL1ERfP70oz=tbVEAfDhgNzgLsvnpbWeOCPOMBpmKTUn0v_Lfg@mail.gmail.com>
References: <CAL1ERfOiT7QV4UUoKi8+gwbHc9an4rUWriufpOJOUdnTYHHEAw@mail.gmail.com>
	<52118042.30101@oracle.com>
	<20130819054742.GA28062@bbox>
	<CAL1ERfN3AUYwWTctGBjVcgb-mwAmc15-FayLz48P1d0GzogncA@mail.gmail.com>
	<20130821074939.GE3022@bbox>
	<CAL1ERfP70oz=tbVEAfDhgNzgLsvnpbWeOCPOMBpmKTUn0v_Lfg@mail.gmail.com>
Date: Wed, 25 Sep 2013 16:31:08 +0800
Message-ID: <CAA_GA1ffZVEkbifGfV6zZTTOcityHwYuQotJHBG4L9CJF7LXcA@mail.gmail.com>
Subject: Re: [BUG REPORT] ZSWAP: theoretical race condition issues
From: Bob Liu <lliubbo@gmail.com>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 4:09 PM, Weijie Yang <weijie.yang.kh@gmail.com> wrote:
> I think I find a new issue, for integrity of this mail thread, I reply
> to this mail.
>
> It is a concurrence issue either, when duplicate store and reclaim
> concurrentlly.
>
> zswap entry x with offset A is already stored in zswap backend.
> Consider the following scenario:
>
> thread 0: reclaim entry x (get refcount, but not call zswap_get_swap_cache_page)
>
> thread 1: store new page with the same offset A, alloc a new zswap entry y.
>   store finished. shrink_page_list() call __remove_mapping(), and now
> it is not in swap_cache
>

But I don't think swap layer will call zswap with the same offset A.

> thread 0: zswap_get_swap_cache_page called. old page data is added to swap_cache
>
> Now, swap cache has old data rather than new data for offset A.
> error will happen If do_swap_page() get page from swap_cache.
>

-- 
Regards,
--Bob
