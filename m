Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3HBWTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:19:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42476 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3HBWTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:19:16 -0400
Date: Fri, 02 Aug 2013 15:19:15 -0700 (PDT)
Message-Id: <20130802.151915.1964036907997678424.davem@davemloft.net>
To: klamm@yandex-team.ru
Cc: eric.dumazet@gmail.com, raise.sail@gmail.com, ebiederm@xmission.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: check net.core.somaxconn sysctl values
From: David Miller <davem@davemloft.net>
In-Reply-To: <1375454200-21303-1-git-send-email-klamm@yandex-team.ru>
References: <20130801.141836.1104130035137318887.davem@davemloft.net>
	<1375454200-21303-1-git-send-email-klamm@yandex-team.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 02 Aug 2013 15:19:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>
Date: Fri,  2 Aug 2013 18:36:40 +0400

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
> Based on a prior patch from Changli Gao.
> 
> Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
> Reported-by: Changli Gao <xiaosuo@gmail.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied, thanks.
