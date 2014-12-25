Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaLYKNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 05:13:11 -0500
Received: from mx1.mxmail.xiaomi.com ([58.68.235.87]:19745 "EHLO
	mx1.mxmail.xiaomi.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751996AbaLYKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 05:13:07 -0500
From: Hui Zhu <zhuhui@xiaomi.com>
To: <m.szyprowski@samsung.com>, <mina86@mina86.com>,
        <akpm@linux-foundation.org>, <iamjoonsoo.kim@lge.com>,
        <aneesh.kumar@linux.vnet.ibm.com>, <pintu.k@samsung.com>,
        <weijie.yang@samsung.com>, <mgorman@suse.de>, <hannes@cmpxchg.org>,
        <riel@redhat.com>, <vbabka@suse.cz>,
        <laurent.pinchart+renesas@ideasonboard.com>, <rientjes@google.com>,
        <sasha.levin@oracle.com>, <liuweixing@xiaomi.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <teawater@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>
Subject: [PATCH 0/3] CMA: Handle the issues of aggressively allocate the
Date: Thu, 25 Dec 2014 17:43:25 +0800
Message-ID: <1419500608-11656-1-git-send-email-zhuhui@xiaomi.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.27.14.101]
X-ClientProxiedBy: CNCAS3.mioffice.cn (10.237.8.133) To cnbox4.mioffice.cn
 (10.237.8.144)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried the Joonsoo's CMA patches [1] in my part and found that they works
better than mine [2] about handle LRU and other issues even if they
don't shrink the memory before cma_alloc.  So I began to test it in my
part.
But my colleague Weixing found some issues around it.  So we make 2 patches to
handle the issues.
And I merged cma_alloc_counter from [2] to cma_alloc work better.

This patchset is based on aa39477b5692611b91ac9455ae588738852b3f60 and [1].

[1] https://lkml.org/lkml/2014/5/28/64
[2] https://lkml.org/lkml/2014/10/15/623

Hui Zhu (3):
CMA: Fix the bug that CMA's page number is substructed twice
CMA: Fix the issue that nr_try_movable just count MIGRATE_MOVABLE memory
CMA: Add cma_alloc_counter to make cma_alloc work better if it meet busy range

 include/linux/cma.h    |    2 +
 include/linux/mmzone.h |    3 +
 mm/cma.c               |    6 +++
 mm/page_alloc.c        |   76 ++++++++++++++++++++++++++++++++++---------------
 4 files changed, 65 insertions(+), 22 deletions(-)

