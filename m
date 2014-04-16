Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaDPA1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:27:40 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60007 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDPA1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:27:39 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 16 Apr 2014 09:28:04 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Richard Yao <ryao@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel@gentoo.org,
        Matthew Thode <mthode@mthode.org>
Subject: Re: [PATCH] mm/vmalloc: Introduce DEBUG_VMALLOCINFO to reduce
 spinlock contention
Message-ID: <20140416002804.GB17350@js1304-P5Q-DELUXE>
References: <1397148058-8737-1-git-send-email-ryao@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397148058-8737-1-git-send-email-ryao@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 12:40:58PM -0400, Richard Yao wrote:
> Performance analysis of software compilation by Gentoo portage on an
> Intel E5-2620 with 64GB of RAM revealed that a sizeable amount of time,
> anywhere from 5% to 15%, was spent in get_vmalloc_info(), with at least
> 40% of that time spent in the _raw_spin_lock() invoked by it.
> 
> The spinlock call is done on vmap_area_lock to protect vmap_area_list,
> but changes to vmap_area_list are made under RCU. The only consumer that
> requires a spinlock on an RCU-ified list is /proc/vmallocinfo. That is

Why only '/proc/vmallocinfo' needs the spinlock?
List iterators which access va->vm such as vread() and vwrite() needs
the spinlock too.
But, I think that get_vmalloc_info() doesn't need it, so you can use
rcu list iteration on that function and it would fix your problem.

Thanks.

