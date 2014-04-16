Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbaDPT0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:26:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47582 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaDPT0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:26:34 -0400
Date: Wed, 16 Apr 2014 15:26:32 -0400 (EDT)
Message-Id: <20140416.152632.1543291596640945219.davem@davemloft.net>
To: keescook@chromium.org
Cc: dborkman@redhat.com, ast@plumgrid.com, josh@joshtriplett.org,
        eparis@redhat.com, rashika.kheria@gmail.com, masami256@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] seccomp: fix memory leak on filter attach
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140416175434.GA13158@www.outflux.net>
References: <20140416175434.GA13158@www.outflux.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Apr 2014 12:26:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Wed, 16 Apr 2014 10:54:34 -0700

> This sets the correct error code when final filter memory is unavailable,
> and frees the raw filter no matter what.
> 
> unreferenced object 0xffff8800d6ea4000 (size 512):
>   comm "sshd", pid 278, jiffies 4294898315 (age 46.653s)
>   hex dump (first 32 bytes):
>     21 00 00 00 04 00 00 00 15 00 01 00 3e 00 00 c0  !...........>...
>     06 00 00 00 00 00 00 00 21 00 00 00 00 00 00 00  ........!.......
>   backtrace:
>     [<ffffffff8151414e>] kmemleak_alloc+0x4e/0xb0
>     [<ffffffff811a3a40>] __kmalloc+0x280/0x320
>     [<ffffffff8110842e>] prctl_set_seccomp+0x11e/0x3b0
>     [<ffffffff8107bb6b>] SyS_prctl+0x3bb/0x4a0
>     [<ffffffff8152ef2d>] system_call_fastpath+0x1a/0x1f
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Reported-by: Masami Ichikawa <masami256@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Tested-by: Masami Ichikawa <masami256@gmail.com>
> Acked-by: Daniel Borkmann <dborkman@redhat.com>
> ---
> David, since you just pushed the a0-a5 fix, can you push this fix as well?

Applied, but please in the future CC: netdev on patches you want me to
apply so that they get properly a) reviewed and b) queued up in patchwork.

Thanks.
