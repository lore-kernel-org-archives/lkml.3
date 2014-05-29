Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbaE2M4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 08:56:10 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42611 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275AbaE2M4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 08:56:08 -0400
Message-ID: <1401368165.3645.21.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] vmalloc: use rcu list iterator to reduce vmap_area_lock
 contention
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Richard Yao <ryao@gentoo.org>
Date: Thu, 29 May 2014 05:56:05 -0700
In-Reply-To: <1401344554-3596-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1401344554-3596-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-29 at 15:22 +0900, Joonsoo Kim wrote:
> Richard Yao reported a month ago that his system have a trouble
> with vmap_area_lock contention during performance analysis
> by /proc/meminfo. Andrew asked why his analysis checks /proc/meminfo
> stressfully, but he didn't answer it.
> 
> https://lkml.org/lkml/2014/4/10/416
> 
> Although I'm not sure that this is right usage or not, there is a solution
> reducing vmap_area_lock contention with no side-effect. That is just
> to use rcu list iterator in get_vmalloc_info(). This function only needs
> values on vmap_area structure, so we don't need to grab a spinlock.
> 
> Reported-by: Richard Yao <ryao@gentoo.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Nice, I was considering the same

Acked-by: Eric Dumazet <edumazet@google.com>



