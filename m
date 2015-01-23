Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbbAWBWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:22:48 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54134 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbbAWBWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:22:45 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 23 Jan 2015 10:23:34 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Zhang Yanfei <zhangyanfei.yes@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Hui Zhu <teawater@gmail.com>, akpm@linux-foundation.org,
        mgorman@suse.de, hannes@cmpxchg.org, riel@redhat.com, vbabka@suse.cz,
        isimatu.yasuaki@jp.fujitsu.com, wangnan0@huawei.com, davidlohr@hp.com,
        rientjes@google.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hui Zhu <zhuhui@xiaomi.com>, Weixing Liu <liuweixing@xiaomi.com>
Subject: Re: [PATCH] CMA: treat free cma pages as non-free if not ALLOC_CMA
 on watermark checking
Message-ID: <20150123012334.GA32632@js1304-P5Q-DELUXE>
References: <1421569979-2596-1-git-send-email-teawater@gmail.com>
 <20150119065544.GA18473@blaptop>
 <54BE7547.6010701@gmail.com>
 <20150122015718.GE21444@js1304-P5Q-DELUXE>
 <alpine.DEB.2.11.1501221012000.3937@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501221012000.3937@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 10:12:43AM -0600, Christoph Lameter wrote:
> On Thu, 22 Jan 2015, Joonsoo Kim wrote:
> 
> > > Just out of curiosity, "new zone"? Something like movable zone?
> >
> > Yes, I named it as ZONE_CMA. Maybe I can send prototype of
> > implementation within 1 or 2 weeks.
> 
> Ugghh. I'd rather reduce the zone types. Do we need slab allocator etc
> allocations in that zone? This will multiply the management structures in
> various subsystems.

Hello,

Pages in CMA area should be movable so slab allocator which uses
unmovable/reclaimable allocation wouldn't need to consider that zone.

Thanks.
