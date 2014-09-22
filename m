Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaIVTHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 15:07:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52997 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaIVTHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 15:07:38 -0400
Date: Mon, 22 Sep 2014 15:07:36 -0400 (EDT)
Message-Id: <20140922.150736.400581155949686923.davem@davemloft.net>
To: clem@clem.clem-digital.net
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Corrupt Network Packets -- 3.17-rc5/rc6
From: David Miller <davem@davemloft.net>
In-Reply-To: <201409221830.s8MIUbWS002990@clem.clem-digital.net>
References: <20140922.133831.220769383344675250.davem@davemloft.net>
	<201409221830.s8MIUbWS002990@clem.clem-digital.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Sep 2014 12:07:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pete Clements <clem@clem.clem-digital.net>
Date: Mon, 22 Sep 2014 14:30:36 -0400 (EDT)

> 
> Thanks. Does not patch. Code looks not to be in the rc6 that Linus
> put out. Guess there is more to come.  (This is what I believe is
> the segment in rc6 -- at line 2179.)
> 
> 	vp->tx_ring[entry].frag[i+1].addr =
> 		cpu_to_le32(skb_frag_dma_map(
> 		&VORTEX_PCI(vp)->dev,
> 		frag,
> 		frag->page_offset, frag->size, DMA_TO_DEVICE));

Just simply change the frag->page_offset argument to zero.
