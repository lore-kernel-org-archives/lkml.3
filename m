Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaIXLou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:44:50 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:17518 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaIXLos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:44:48 -0400
To: lizefan@huawei.com, peterz@infradead.org, mingo@kernel.org
Cc: tj@kernel.org, miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, keescook@chromium.org
Subject: Re: [PATCH v2 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should be atomic flags
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <54210D3F.2090409@huawei.com>
	<54210DA5.4040606@huawei.com>
	<201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
	<542233F0.1080402@huawei.com>
In-Reply-To: <542233F0.1080402@huawei.com>
Message-Id: <201409242044.GFJ81269.FJFVQOLSHtFMOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 24 Sep 2014 20:44:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zefan Li wrote:
> Those macros make the code easier to read, and emacs and cscope can also
> understand them.

I'm using legacy LXR which cannot understand them. But

> I'd vote for this:
> 
> TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
> TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
> 
> TASK_PFA_TEST(SPREAD_PAGE, spread_page)
> TASK_PFA_SET(SPREAD_PAGE, spread_page)
> TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
> 
> TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
> TASK_PFA_SET(SPREAD_SLAB, spread_slab)
> TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
> 
> over this:

you can go ahead. This difference is not a stopper.

Tejun Heo wrote:
> All the patches look good to me.  I can't say I'm a big fan of
> function defining macros but I don't have prettier alternatives
> either.  Once Peter/Ingo acks the patches, I'll route them through
> cgroup/for-3.17-fixes.

Peter and Ingo, are these patches OK for you?
