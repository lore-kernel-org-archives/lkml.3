Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3FTFSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 01:18:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49385 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3FTFSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 01:18:16 -0400
Date: Wed, 19 Jun 2013 22:18:15 -0700 (PDT)
Message-Id: <20130619.221815.1630968197223302672.davem@davemloft.net>
To: lkundrak@v3.sk
Cc: buytenh@wantstofly.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mv643xx_eth: Fix a DMA-API error handling warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371576808-21907-1-git-send-email-lkundrak@v3.sk>
References: <1371576808-21907-1-git-send-email-lkundrak@v3.sk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>
Date: Tue, 18 Jun 2013 19:33:28 +0200

> We check the failure status just prior to unmap, since it would be too much of
> a hassle to roll back commands we already started to enqueue if we handled it
> just after the map.
> 
> This way we at least avoid a lockup on reclaim, the card presumably didn't
> succeed DMA-ing to a bogus address anyway.

You have to handle it at map time, I don't care how complicated it is.

As is, when a DMA mapping failure occurs the chip is crapping into
random memory.  At that point, who cares what you decide to do about
it at unmap time?

This patch is unacceptable, sorry.
