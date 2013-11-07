Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3KGRRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 12:17:05 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50265 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab3KGRRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 12:17:04 -0500
MIME-Version: 1.0
In-Reply-To: <1383798912-10832-1-git-send-email-avagin@openvz.org>
References: <1383798912-10832-1-git-send-email-avagin@openvz.org>
Date: Thu, 7 Nov 2013 09:17:02 -0800
Message-ID: <CAMEtUuyKJgbOtC68yCqLYE0Zq1TSM4zLByH8P+DdCUdHb=GRoA@mail.gmail.com>
Subject: Re: [PATCH] net: x86: bpf: don't forget to free sk_filter (v2)
From: Alexei Starovoitov <ast@plumgrid.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 8:35 PM, Andrey Vagin <avagin@openvz.org> wrote:
> sk_filter isn't freed if bpf_func is equal to sk_run_filter.
>
> This memory leak was introduced by v3.12-rc3-224-gd45ed4a4
> "net: fix unsafe set_memory_rw from softirq".
>
> Before this patch sk_filter was freed in sk_filter_release_rcu,
> now it should be freed in bpf_jit_free.
>
> Here is output of kmemleak:
> unreferenced object 0xffff8800b774eab0 (size 128):
>   comm "systemd", pid 1, jiffies 4294669014 (age 124.062s)
>   hex dump (first 32 bytes):
>     00 00 00 00 0b 00 00 00 20 63 7f b7 00 88 ff ff  ........ c......
>     60 d4 55 81 ff ff ff ff 30 d9 55 81 ff ff ff ff  `.U.....0.U.....
>   backtrace:
>     [<ffffffff816444be>] kmemleak_alloc+0x4e/0xb0
>     [<ffffffff811845af>] __kmalloc+0xef/0x260
>     [<ffffffff81534028>] sock_kmalloc+0x38/0x60
>     [<ffffffff8155d4dd>] sk_attach_filter+0x5d/0x190
>     [<ffffffff815378a1>] sock_setsockopt+0x991/0x9e0
>     [<ffffffff81531bd6>] SyS_setsockopt+0xb6/0xd0
>     [<ffffffff8165f3e9>] system_call_fastpath+0x16/0x1b
>     [<ffffffffffffffff>] 0xffffffffffffffff
>
> v2: add extra { } after else
>
> Fixes: d45ed4a4e33a ("net: fix unsafe set_memory_rw from softirq")
> Acked-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Alexei Starovoitov <ast@plumgrid.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---

Acked-by: Alexei Starovoitov <ast@plumgrid.com>

Thanks!
