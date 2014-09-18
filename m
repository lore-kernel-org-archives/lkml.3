Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaIRQOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:14:40 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:63751 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbaIRQOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:14:38 -0400
MIME-Version: 1.0
In-Reply-To: <541AA5CE.8040006@huawei.com>
References: <541AA5CE.8040006@huawei.com>
Date: Thu, 18 Sep 2014 09:14:37 -0700
Message-ID: <CAM_iQpV0LykCy1GpZUmaAse_niNPnabLKTkW=LdoBjKhqkyx0Q@mail.gmail.com>
Subject: Re: [PATCH] cgroup: fix unbalanced locking
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Zefan Li <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 2:28 AM, Zefan Li <lizefan@huawei.com> wrote:
> cgroup_pidlist_start() holds cgrp->pidlist_mutex and then calls
> pidlist_array_load(), and cgroup_pidlist_stop() releases the mutex.
>
> It is wrong that we release the mutex in the failure path in
> pidlist_array_load(), because cgroup_pidlist_stop() will be called
> no matter if cgroup_pidlist_start() returns errno or not.
>

I found same thing yesterday and tried to analysis if this could
be the cause of the the NULL ptr def bug I saw, it seems not.

Anyway, this fix is definitely correct,

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
