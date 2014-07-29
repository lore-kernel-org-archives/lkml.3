Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaG2Rsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:48:40 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:59717 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaG2Rsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <53D7697C.6020103@gmail.com>
References: <53D7697C.6020103@gmail.com>
Date: Tue, 29 Jul 2014 10:48:37 -0700
Message-ID: <CAHA+R7MC2gKeSWqR8pDDX26D-Th4BG1AveM+HseMMPjLBJuWDw@mail.gmail.com>
Subject: Re: ipv4: net namespace does not inherit network configurations
From: Cong Wang <cwang@twopensource.com>
To: zhuyj <zyjzyj2000@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Hong Zhiguo <honkiko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "Tao, Yue" <Yue.Tao@windriver.com>,
        Alexandre Dietsch <alexandre.dietsch@windriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 2:29 AM, zhuyj <zyjzyj2000@gmail.com> wrote:
> Hi,all
>
> I did a test on kernel3.16 rc6:
>
> root@qemu1:~# echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
> root@qemu1:~# echo 1 > /proc/sys/net/ipv4/conf/all/forwarding
> root@qemu1:~# ip netns list
> root@qemu1:~# ip netns add fib1
> root@qemu1:~# ip netns exec fib1 bash
> root@qemu1:~# cat /proc/sys/net/ipv6/conf/all/forwarding
> 0
> root@qemu1:~# cat /proc/sys/net/ipv4/conf/all/forwarding
> 1
>
> The behavior of ipv4 and ipv6 is very inconsistent. I checked
> the kernel source code. I found that from this patch
> [ipv6: fix bad free of addrconf_init_net], the above difference
> appeared.
>
> Since a net namespace is independent to another. That is, there
> is no any relationship between the net namespaces. So the behavior
> of ipv4 is not correct.
>

Well, they are already independent, not shared, just that the initial
value is duplicated from init_net for IPv4.

This change might break existing applications which rely on this
behavior, but given IPv6 change is almost the same, I think it's ok.

BTW, you need to submit a patch as normal, instead of as an attachment.
