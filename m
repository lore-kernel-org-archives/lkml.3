Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaIWKzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:55:53 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:24402 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbaIWKzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:55:51 -0400
To: lizefan@huawei.com, tj@kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, miaox@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        keescook@chromium.org
Subject: Re: [PATCH v2 3/3] cpuset: PF_SPREAD_PAGE and PF_SPREAD_SLAB should beatomic flags
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <54210D3F.2090409@huawei.com>
	<54210DA5.4040606@huawei.com>
In-Reply-To: <54210DA5.4040606@huawei.com>
Message-Id: <201409231955.FDB73406.FOOJLOVQMHFSFt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 23 Sep 2014 19:55:48 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zefan Li wrote:
> Tetsuo reported a hard-to-reproduce kernel crash on RHEL6, which happend

s/happend/happened/

> @@ -1972,6 +1973,14 @@ static inline void memalloc_noio_restore(unsigned int flags)
>  TASK_PFA_TEST(NO_NEW_PRIVS, no_new_privs)
>  TASK_PFA_SET(NO_NEW_PRIVS, no_new_privs)
>  
> +TASK_PFA_TEST(SPREAD_PAGE, spread_page)
> +TASK_PFA_SET(SPREAD_PAGE, spread_page)
> +TASK_PFA_CLEAR(SPREAD_PAGE, spread_page)
> +
> +TASK_PFA_TEST(SPREAD_SLAB, spread_slab)
> +TASK_PFA_SET(SPREAD_SLAB, spread_slab)
> +TASK_PFA_CLEAR(SPREAD_SLAB, spread_slab)
> +

I wonder how adding 3 macro lines differs from 3 inlined functions.
Personally, from LXR (source code browser) point of view, inlined functions
are more friendly than macros. Also, I wonder about the cost of extracting
macros in a file which is likely included by every file but referenced
by few files. Speak of SPREAD_PAGE and SPREAD_SLAB, they should be defined
as inlined functions in include/linux/cpuset.h rather than as macros in
include/linux/sched.h ?
