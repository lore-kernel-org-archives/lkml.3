Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaDPTgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:36:39 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:61867 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaDPTgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:36:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140416.152632.1543291596640945219.davem@davemloft.net>
References: <20140416175434.GA13158@www.outflux.net>
	<20140416.152632.1543291596640945219.davem@davemloft.net>
Date: Wed, 16 Apr 2014 12:36:37 -0700
X-Google-Sender-Auth: Zepy_m0AEs1PlkcCkD7_Yc3PXyw
Message-ID: <CAGXu5j+ebLk-oke8KyZO=XsxN8_e02py+EXsyvaoK6KgCrBArA@mail.gmail.com>
Subject: Re: [PATCH v2] seccomp: fix memory leak on filter attach
From: Kees Cook <keescook@chromium.org>
To: David Miller <davem@davemloft.net>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Josh Triplett <josh@joshtriplett.org>, Eric Paris <eparis@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Masami Ichikawa <masami256@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 12:26 PM, David Miller <davem@davemloft.net> wrote:
> From: Kees Cook <keescook@chromium.org>
> Date: Wed, 16 Apr 2014 10:54:34 -0700
>
>> This sets the correct error code when final filter memory is unavailable,
>> and frees the raw filter no matter what.
>>
>> unreferenced object 0xffff8800d6ea4000 (size 512):
>>   comm "sshd", pid 278, jiffies 4294898315 (age 46.653s)
>>   hex dump (first 32 bytes):
>>     21 00 00 00 04 00 00 00 15 00 01 00 3e 00 00 c0  !...........>...
>>     06 00 00 00 00 00 00 00 21 00 00 00 00 00 00 00  ........!.......
>>   backtrace:
>>     [<ffffffff8151414e>] kmemleak_alloc+0x4e/0xb0
>>     [<ffffffff811a3a40>] __kmalloc+0x280/0x320
>>     [<ffffffff8110842e>] prctl_set_seccomp+0x11e/0x3b0
>>     [<ffffffff8107bb6b>] SyS_prctl+0x3bb/0x4a0
>>     [<ffffffff8152ef2d>] system_call_fastpath+0x1a/0x1f
>>     [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> Reported-by: Masami Ichikawa <masami256@gmail.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Tested-by: Masami Ichikawa <masami256@gmail.com>
>> Acked-by: Daniel Borkmann <dborkman@redhat.com>
>> ---
>> David, since you just pushed the a0-a5 fix, can you push this fix as well?
>
> Applied, but please in the future CC: netdev on patches you want me to
> apply so that they get properly a) reviewed and b) queued up in patchwork.

Ah! Yes, sorry for the oversight on that. Thanks for taking it!

-Kees

-- 
Kees Cook
Chrome OS Security
