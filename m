Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3CEQnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:43:14 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42800 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab3CEQnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:43:13 -0500
MIME-Version: 1.0
In-Reply-To: <5135A736.8050104@huawei.com>
References: <5135A736.8050104@huawei.com>
Date: Wed, 6 Mar 2013 00:43:12 +0800
Message-ID: <CACvQF52iWWagM=YVV30pScFqHM+UhiSZv4bSovY3Gcxre1AnDQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] sched: Shrink include/linux/sched.h
From: Lai Jiangshan <eag0628@gmail.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 4:05 PM, Li Zefan <lizefan@huawei.com> wrote:
> While working of a cgroup patch which also touched include/linux/sched.h,
> I found some function/macro/structure declarations can be moved to
> kernel/sched/sched.h, and some can even be total removed, so here's
> the patchset.
>
> The result is a reduction of ~200 LOC from include/linux/sched.h.

It looks good to me.
Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

>
> 0001-sched-Remove-some-dummpy-functions.patch
> 0002-sched-Remove-test_sd_parent.patch
> 0003-sched-Move-SCHED_LOAD_SHIFT-macros-to-kernel-sched-s.patch
> 0004-sched-Move-struct-sched_group-to-kernel-sched-sched..patch
> 0005-sched-Move-wake-flags-to-kernel-sched-sched.h.patch
> 0006-sched-Move-struct-sched_class-to-kernel-sched-sched..patch
> 0007-sched-Make-default_scale_freq_power-static.patch
> 0008-sched-Move-group-scheduling-functions-out-of-include.patch
> 0009-sched-Remove-double-declaration-of-root_task_group.patch
>
> --
>  include/linux/sched.h | 194 +-------------------------------------------------
>  kernel/sched/core.c   |  14 ++--
>  kernel/sched/fair.c   |   6 +-
>  kernel/sched/sched.h  | 159 +++++++++++++++++++++++++++++++++++++++--
>  4 files changed, 168 insertions(+), 205 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
