Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3EIOpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:45:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab3EIOpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:45:17 -0400
Message-ID: <518BB5FA.5080301@redhat.com>
Date: Thu, 09 May 2013 10:43:06 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, davidlohr.bueso@hp.com,
        viro@zeniv.linux.org.uk, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: SHM oops in newseg()
References: <20130509043532.GA28235@redhat.com> <518B4B5F.9040900@huawei.com>
In-Reply-To: <518B4B5F.9040900@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 03:08 AM, Li Zefan wrote:
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>
> On 2013/5/9 12:35, Dave Jones wrote:
>> Just saw this on v3.9-11789-ge0fd9af while fuzz-testing.
>>
>> [  163.917836] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>> [  163.918984] IP: [<ffffffff812c48ed>] newseg+0x10d/0x390
>
> The patch below should fix it.
>
> ===========================
>
> [PATCH] shm: fix null pointer deref when userspace specifies invalid hugepage size
>
> Dave reported an oops triggered by trinity:
>
> [  163.917836] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [  163.918984] IP: [<ffffffff812c48ed>] newseg+0x10d/0x390
> [  163.919705] PGD cf8c1067 PUD cf8c2067 PMD 0
> [  163.920326] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  163.929949] CPU: 2 PID: 7636 Comm: trinity-child2 Not tainted 3.9.0+#67
> ...
> [  163.953629] Call Trace:
> [  163.957706]  [<ffffffff812be322>] ipcget+0x182/0x380
> [  163.962123]  [<ffffffff810b99a5>] ?trace_hardirqs_on_caller+0x115/0x1e0
> [  163.966752]  [<ffffffff812c559a>] SyS_shmget+0x5a/0x60
> [  163.971163]  [<ffffffff812c47e0>] ? shm_close+0x140/0x140
> [  163.975590]  [<ffffffff812c3e60>] ? shm_release+0x50/0x50
> [  163.979991]  [<ffffffff812c3df0>] ? shm_get_unmapped_area+0x20/0x20
> [  163.984499]  [<ffffffff816caa14>] tracesys+0xdd/0xe2
>
> This bug was introduced by commit af73e4d9506d3b797509f3c030e7dcd554f7d9c4
> ("hugetlbfs: fix mmap failure in unaligned size request").
>
> Reported-by: Dave Jones <davej@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Li Zefan <lizfan@huawei.com>

Acked-by: Rik van Riel <riel@redhat.com>

