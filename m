Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab3HBJjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:39:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:48043 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab3HBJjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:39:08 -0400
Message-ID: <51FB7DF5.8030600@huawei.com>
Date: Fri, 2 Aug 2013 17:37:57 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: <gaoyang.zyh@taobao.com>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: stable: a59f4e079d19464eebb9b06513a1d4f55fdae5ba needs backport ?
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a59f4e079d19464eebb9b06513a1d4f55fdae5ba
Author: Zhu Yanhai <gaoyang.zyh@taobao.com>
Date:   Tue Jan 8 12:56:52 2013 +0800

    sched: Fix the broken sched_rr_get_interval()

Without this patch, syscall sched_rr_get_interval() can return wrong
value, and the bug was introduced in 2.6.24, so this looks like a
candidate for stable kernel.

The concern for backporting is that this might break some userspace
programs? As the changelog says:

    [ Since this is an ABI and an old bug, we'll test this via a
      slow upstream route, to hopefully discover any app breakage. ]
