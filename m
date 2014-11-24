Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaKXVQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:16:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaKXVQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:16:06 -0500
Date: Mon, 24 Nov 2014 16:16:03 -0500 (EST)
Message-Id: <20141124.161603.798932139185654908.davem@davemloft.net>
To: mst@redhat.com
Cc: linux-kernel@vger.kernel.org, dborkman@redhat.com, edumazet@google.com,
        atzm@stratosphere.co.jp, hannes@stressinduktion.org,
        therbert@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: fix sparse warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416828696-3989-1-git-send-email-mst@redhat.com>
References: <1416828696-3989-1-git-send-email-mst@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Nov 2014 13:16:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 24 Nov 2014 13:32:16 +0200

> af_packet produces lots of these:
> 	net/packet/af_packet.c:384:39: warning: incorrect type in return expression (different modifiers)
> 	net/packet/af_packet.c:384:39:    expected struct page [pure] *
> 	net/packet/af_packet.c:384:39:    got struct page *
> 
> this seems to be because sparse does not realize that _pure
> refers to function, not the returned pointer.
> 
> Tweak code slightly to avoid the warning.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied, please report the sparse bug if you haven't already.

Thanks.
