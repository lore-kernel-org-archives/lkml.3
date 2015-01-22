Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbbAVQMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:12:49 -0500
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:38763 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbbAVQMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:12:47 -0500
Date: Thu, 22 Jan 2015 10:12:43 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Hui Zhu <teawater@gmail.com>, akpm@linux-foundation.org,
        mgorman@suse.de, hannes@cmpxchg.org, riel@redhat.com, vbabka@suse.cz,
        isimatu.yasuaki@jp.fujitsu.com, wangnan0@huawei.com, davidlohr@hp.com,
        rientjes@google.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hui Zhu <zhuhui@xiaomi.com>, Weixing Liu <liuweixing@xiaomi.com>
Subject: Re: [PATCH] CMA: treat free cma pages as non-free if not ALLOC_CMA
 on watermark checking
In-Reply-To: <20150122015718.GE21444@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.11.1501221012000.3937@gentwo.org>
References: <1421569979-2596-1-git-send-email-teawater@gmail.com> <20150119065544.GA18473@blaptop> <54BE7547.6010701@gmail.com> <20150122015718.GE21444@js1304-P5Q-DELUXE>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Joonsoo Kim wrote:

> > Just out of curiosity, "new zone"? Something like movable zone?
>
> Yes, I named it as ZONE_CMA. Maybe I can send prototype of
> implementation within 1 or 2 weeks.

Ugghh. I'd rather reduce the zone types. Do we need slab allocator etc
allocations in that zone? This will multiply the management structures in
various subsystems.

