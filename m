Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbaITOaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:30:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:46234 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbaITOaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:30:23 -0400
Date: Sat, 20 Sep 2014 16:30:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, mingo@redhat.com,
        tj@kernel.org, akpm@linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fernando_b1@lab.ntt.co.jp,
        keescook@chromium.org
Subject: Re: Racy manipulation of task_struct->flags in cgroups code causes
 hard to reproduce kernel panics
Message-ID: <20140920143012.GL2832@worktop.localdomain>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
 <541D16EA.70407@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541D16EA.70407@huawei.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 01:55:54PM +0800, Zefan Li wrote:
> We should make the updating of this flag atomic.

>  /* Per-process atomic flags. */
>  #define PFA_NO_NEW_PRIVS 0x00000001	/* May not gain new privileges. */
> +#define PFA_SPREAD_PAGE  0x00000002	/* Spread page cache over cpuset */
> +#define PFA_SPREAD_SLAB  0x00000004	/* Spread some slab caches over cpuset */

Ooh, I was not ware we had those.. /me checks where that came from. Hmm
weird, while I did get that patch it had a seccomp prefix when landing
in my inbox so I ignored it. However the commit has a sched prefix
(which I would not have ignored). Dubious things happened here.


