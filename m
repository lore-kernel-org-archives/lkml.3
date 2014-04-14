Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaDNSYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaDNSYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:24:11 -0400
Message-ID: <534C27BE.9020709@redhat.com>
Date: Mon, 14 Apr 2014 20:23:58 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Masami Ichikawa <masami256@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        James Morris <james.l.morris@oracle.com>, davem@davemloft.net,
        eparis@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] seccomp: fix memory leak on filter attach
References: <20140414171114.GA31384@www.outflux.net>
In-Reply-To: <20140414171114.GA31384@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 07:11 PM, Kees Cook wrote:
> This sets the correct error code when final filter memory is unavailable,
> and frees the raw filter no matter what.
>
> unreferenced object 0xffff8800d6ea4000 (size 512):
>    comm "sshd", pid 278, jiffies 4294898315 (age 46.653s)
>    hex dump (first 32 bytes):
>      21 00 00 00 04 00 00 00 15 00 01 00 3e 00 00 c0  !...........>...
>      06 00 00 00 00 00 00 00 21 00 00 00 00 00 00 00  ........!.......
>    backtrace:
>      [<ffffffff8151414e>] kmemleak_alloc+0x4e/0xb0
>      [<ffffffff811a3a40>] __kmalloc+0x280/0x320
>      [<ffffffff8110842e>] prctl_set_seccomp+0x11e/0x3b0
>      [<ffffffff8107bb6b>] SyS_prctl+0x3bb/0x4a0
>      [<ffffffff8152ef2d>] system_call_fastpath+0x1a/0x1f
>      [<ffffffffffffffff>] 0xffffffffffffffff
>
> Reported-by: Masami Ichikawa <masami256@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org

Acked-by: Daniel Borkmann <dborkman@redhat.com>
