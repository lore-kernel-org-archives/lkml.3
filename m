Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab3D3EoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 00:44:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39677 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3D3EoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 00:44:10 -0400
Date: Tue, 30 Apr 2013 00:44:08 -0400 (EDT)
Message-Id: <20130430.004408.1248228240476926838.davem@davemloft.net>
To: bpoirier@suse.de
Cc: edumazet@google.com, xemul@parallels.com, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] unix/dgram: peek beyond 0-sized skbs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367271734-14379-1-git-send-email-bpoirier@suse.de>
References: <kll5si$544$1@ger.gmane.org>
	<1367271734-14379-1-git-send-email-bpoirier@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 29 Apr 2013 21:44:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>
Date: Mon, 29 Apr 2013 17:42:12 -0400

> "77c1090 net: fix infinite loop in __skb_recv_datagram()" (v3.8) introduced a
> regression:
> After that commit, recv can no longer peek beyond a 0-sized skb in the queue.
> __skb_recv_datagram() instead stops at the first skb with len == 0 and results
> in the system call failing with -EFAULT via skb_copy_datagram_iovec().
> 
> When peeking at an offset with 0-sized skb(s), each one of those is received
> only once, in sequence. The offset starts moving forward again after receiving
> datagrams with len > 0.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

Applied.
