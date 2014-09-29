Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaI2HZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 03:25:57 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:36449 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaI2HZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 03:25:56 -0400
Message-ID: <54290962.8010603@huawei.com>
Date: Mon, 29 Sep 2014 15:25:22 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        "Pekka Enberg" <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        "Joonsoo Kim" <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] Simplify cpuset API and fix cpuset check in SL[AU]B
References: <cover.1411741632.git.vdavydov@parallels.com>
In-Reply-To: <cover.1411741632.git.vdavydov@parallels.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.5429096C.00E6,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 425d2b5e3b93231f88502f4bfc2eb38f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/26 22:50, Vladimir Davydov wrote:
> Hi,
> 
> SLAB and SLUB use hardwall cpuset check on fallback alloc, while the
> page allocator uses softwall check for all kernel allocations. This may
> result in falling into the page allocator even if there are free objects
> on other nodes. SLAB algorithm is especially affected: the number of
> objects allocated in vain is unlimited, so that they theoretically can
> eat up a whole NUMA node. For more details see comments to patches 3, 4.
> 
> When I last sent a fix (https://lkml.org/lkml/2014/8/10/100), David
> found the whole cpuset API being cumbersome and proposed to simplify it
> before getting to fixing its users. So this patch set addresses both
> David's complain (patches 1, 2) and the SL[AU]B issues (patches 3, 4).
> 
> Reviews are appreciated.
> 
> Thanks,
> 
> Vladimir Davydov (4):
>   cpuset: convert callback_mutex to a spinlock
>   cpuset: simplify cpuset_node_allowed API
>   slab: fix cpuset check in fallback_alloc
>   slub: fix cpuset check in get_any_partial
> 

Acked-by: Zefan Li <lizefan@huawei.com>

