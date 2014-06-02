Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaFBOB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:01:59 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:62647 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbaFBOB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:01:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140602121034.GB1039@esperanza>
References: <cover.1401457502.git.vdavydov@parallels.com>
	<23a736c90a81e13a2252d35d9fc3dc04a9ed7d7c.1401457502.git.vdavydov@parallels.com>
	<20140602044154.GB17964@js1304-P5Q-DELUXE>
	<20140602121034.GB1039@esperanza>
Date: Mon, 2 Jun 2014 23:01:55 +0900
Message-ID: <CAAmzW4MiUmmqXFeiwVNPDmtOSf6U+9J_U4_ZAF4Qv9w=T4AMiA@mail.gmail.com>
Subject: Re: [PATCH -mm 8/8] slab: reap dead memcg caches aggressively
From: Joonsoo Kim <js1304@gmail.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-02 21:10 GMT+09:00 Vladimir Davydov <vdavydov@parallels.com>:
> On Mon, Jun 02, 2014 at 01:41:55PM +0900, Joonsoo Kim wrote:
>> According to my code reading, slabs_to_free() doesn't return number of
>> free slabs. This bug is introduced by 0fa8103b. I think that it is
>> better to fix it before applyting this patch. Otherwise, use n->free_objects
>> instead of slabs_tofree() to achieve your purpose correctly.
>
> Hmm, I don't think slab_tofree() computes the number of free slabs
> wrong. If we have N free objects, there may be
> DIV_ROUND_UP(N,objs_per_slab) empty slabs at max, and that's exactly
> what slab_tofree() does, no?

Oops... Sorry for wrong comment.
You are right. Please ignore my comment. :)

BTW, we don't need DIV_ROUND_UP. I think that just N / objs_per_slab is
sufficient to get number of empty slabs at max. Am I missing too?

Thanks.
