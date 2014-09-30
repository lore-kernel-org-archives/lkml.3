Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaI3E7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:59:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38907 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaI3E7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:59:53 -0400
Date: Tue, 30 Sep 2014 00:59:25 -0400 (EDT)
Message-Id: <20140930.005925.995989898229686123.davem@davemloft.net>
To: samuel.thibault@ens-lyon.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] Fix getsockopt(SO_PEERNAME) buffer size against
 potential future buffer overflow
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140928135545.GA23220@type.youpi.perso.aquilenet.fr>
References: <20140928135545.GA23220@type.youpi.perso.aquilenet.fr>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Sep 2014 21:59:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date: Sun, 28 Sep 2014 15:55:45 +0200

> In net/core/sock.c's sock_getsockopt, the address buffer size is
> hardcoded to 128. It happens that sizeof(struct sockaddr_storage) is
> indeed 128, but that is just luck and would probably not get updated
> whenever sockaddr_storage would grow. This patch makes it simply use
> sockaddr_storage instead.
> 
> Signed-off-by:  Samuel Thibault <samuel.thibault@ens-lyon.org>

sockaddr_storage's size is a user exported API and therefore can
never, ever, change.

If you want to change 128 to _K_SS_MAXSIZE or similar, fine.
