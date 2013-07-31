Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288Ab3GaOhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:37:42 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57738 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab3GaOhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:37:40 -0400
Message-ID: <1375281457.10515.98.camel@edumazet-glaptop>
Subject: Re: [PATCH] net: check net.core.somaxconn sysctl values
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: "David S. Miller" <davem@davemloft.net>, raise.sail@gmail.com,
        ebiederm@xmission.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 31 Jul 2013 07:37:37 -0700
In-Reply-To: <51F917CF.7010905@yandex-team.ru>
References: <51F917CF.7010905@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 17:57 +0400, Roman Gushchin wrote:
> It's possible to assign an invalid value to the net.core.somaxconn
> sysctl variable, because there is no checks at all.
> 
> The sk_max_ack_backlog field of the sock structure is defined as
> unsigned short. Therefore, the backlog argument in inet_listen()
> shouldn't exceed USHRT_MAX. The backlog argument in the listen() syscall
> is truncated to the somaxconn value. So, the somaxconn value shouldn't
> exceed 65535 (USHRT_MAX).
> Also, negative values of somaxconn are meaningless.
> 
> before:
> $ sysctl -w net.core.somaxconn=256
> net.core.somaxconn = 256
> $ sysctl -w net.core.somaxconn=65536
> net.core.somaxconn = 65536
> $ sysctl -w net.core.somaxconn=-100
> net.core.somaxconn = -100
> 
> after:
> $ sysctl -w net.core.somaxconn=256
> net.core.somaxconn = 256
> $ sysctl -w net.core.somaxconn=65536
> error: "Invalid argument" setting key "net.core.somaxconn"
> $ sysctl -w net.core.somaxconn=-100
> error: "Invalid argument" setting key "net.core.somaxconn"
> 
> Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
> ---
>   net/core/sysctl_net_core.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)


We had a discussion about this one month ago, as Changli Gao posted a
patch. http://patchwork.ozlabs.org/patch/255460/

So proper credits would be nice ;)

Based on a prior patch from Changli Gao

Reported-by: Changli Gao <xiaosuo@gmail.com>
Suggested-by: Eric Dumazet <edumazet@google.com>

Acked-by: Eric Dumazet <edumazet@google.com>




