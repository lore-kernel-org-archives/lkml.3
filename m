Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab3LQJPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:15:31 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:28914 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab3LQJPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:15:24 -0500
Message-ID: <52B01594.80001@huawei.com>
Date: Tue, 17 Dec 2013 17:12:52 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Li Wang <liwang@ubuntukylin.com>
CC: Matthew Wilcox <matthew@wil.cx>, Cong Wang <xiyou.wangcong@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Sage Weil <sage@inktank.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH 0/5] VFS: Directory level cache cleaning
References: <cover.1387205337.git.liwang@ubuntukylin.com> <CAM_iQpUSX1yX9SMvUnbwZ7UkaBMUheOEiZNaSb4m8gWBQzzGDQ@mail.gmail.com> <52AFC020.10403@ubuntukylin.com> <20131217035847.GA10392@parisc-linux.org> <52AFFBE3.8020507@ubuntukylin.com>
In-Reply-To: <52AFFBE3.8020507@ubuntukylin.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/17 15:23, Li Wang wrote:
> If we do wanna equip fadvise() with directory level page cache cleaning,
> this could be solved by invoking (inode_permission() || capable(CAP_SYS_ADMIN)) before manipulating the page cache of that inode.
> We think the current extension to 'drop_caches' has a complete back
> compatibility, the old semantics keep unchanged, and with add-on
> features to do finer granularity cache cleaning should be also
> desirable.
> 

I don't think you can extend the drop_caches interface this way. It should
be used for debuging only.

commit 9d0243bca345d5ce25d3f4b74b7facb3a6df1232
Author: Andrew Morton <akpm@osdl.org>
Date:   Sun Jan 8 01:00:39 2006 -0800

    [PATCH] drop-pagecache

    Add /proc/sys/vm/drop_caches.  When written to, this will cause the kernel to
    discard as much pagecache and/or reclaimable slab objects as it can.  THis
    operation requires root permissions.

    ...

    This is a debugging feature: useful for getting consistent results between
    filesystem benchmarks.  We could possibly put it under a config option, but
    it's less than 300 bytes.

Also see http://lkml.org/lkml/2013/7/26/230

