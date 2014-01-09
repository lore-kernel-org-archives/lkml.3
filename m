Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbaAIOFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:05:30 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:35993 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaAIOFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:05:06 -0500
MIME-Version: 1.0
In-Reply-To: <xa1tha9dbk2t.fsf@mina86.com>
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
	<xa1tha9dbk2t.fsf@mina86.com>
Date: Thu, 9 Jan 2014 23:05:04 +0900
Message-ID: <CAAmzW4PyCp1Hw1ThHGZV5i1wb9494vgpDhZ4h+Gr3Q=pLOojJA@mail.gmail.com>
Subject: Re: [PATCH 0/7] improve robustness on handling migratetype
From: Joonsoo Kim <js1304@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mel Gorman <mgorman@suse.de>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/9 Michal Nazarewicz <mina86@mina86.com>:
> On Thu, Jan 09 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
>> Third, there is the problem on buddy allocator. It doesn't consider
>> migratetype when merging buddy, so pages from cma or isolate region can
>> be moved to other migratetype freelist. It makes CMA failed over and over.
>> To prevent it, the buddy allocator should consider migratetype if
>> CMA/ISOLATE is enabled.
>
> There should never be situation where a CMA page shares a pageblock (or
> a max-order page) with a non-CMA page though, so this should never be an
> issue.

Right... It never happens.
When I ported CMA region reservation code to my own code for testing,
I made a mistake. Sorry for noise.

Thanks.
