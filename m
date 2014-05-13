Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbaEMUHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:07:48 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54657 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaEMUHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1405131255380.3392@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405131255380.3392@chino.kir.corp.google.com>
Date: Tue, 13 May 2014 13:07:41 -0700
Message-ID: <CAMEtUuwOY=k8hcpn4CsiNLTHgnxwidZgwXD=UsU-65+LcrmOGQ@mail.gmail.com>
Subject: Re: [patch] net, filter: make new test_bpf depend on networking
From: Alexei Starovoitov <ast@plumgrid.com>
To: David Rientjes <rientjes@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:57 PM, David Rientjes <rientjes@google.com> wrote:
> CONFIG_TEST_BPF depends on CONFIG_NET, otherwise the build fails:
>
> ERROR: "sk_unattached_filter_destroy" [lib/test_bpf.ko] undefined!
> ERROR: "kfree_skb" [lib/test_bpf.ko] undefined!
> ERROR: "sk_unattached_filter_create" [lib/test_bpf.ko] undefined!
> ERROR: "sk_run_filter_int_skb" [lib/test_bpf.ko] undefined!
> ERROR: "__alloc_skb" [lib/test_bpf.ko] undefined!
>
> Add the dependency.
>
> Cc: Alexei Starovoitov <ast@plumgrid.com>
> Signed-off-by: David Rientjes <rientjes@google.com>

commit 98920ba6911c7 ("net: fix test_bpf build to depend on NET")
is already in net-next.
Sorry about the breakage.

> ---
>  lib/Kconfig.debug | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1639,6 +1639,7 @@ config TEST_USER_COPY
>  config TEST_BPF
>         tristate "Test BPF filter functionality"
>         default n
> +       depends on NET
>         depends on m
>         help
>           This builds the "test_bpf" module that runs various test vectors
