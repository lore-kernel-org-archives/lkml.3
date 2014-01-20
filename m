Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaATKjz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:39:55 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:6535 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaATKjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:39:51 -0500
Message-ID: <52DCFC33.80008@huawei.com>
Date: Mon, 20 Jan 2014 18:36:35 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [question] how to figure out OOM reason? should dump slab/vmalloc
 info when OOM?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.155]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When OOM happen, will dump buddy free areas info, hugetlb pages info,
memory state of all eligible tasks, per-cpu memory info.
But do not dump slab/vmalloc info, sometime, it's not enough to figure out the
reason OOM happened.

So, my questions are:
1. Should dump slab/vmalloc info when OOM happen? Though we can get these from proc file,
but usually we do not monitor the logs and check proc file immediately when OOM happened.

2. /proc/$pid/smaps and pagecache info also helpful when OOM, should also be dumped?

3. Without these info, usually how to figure out OOM reason?

