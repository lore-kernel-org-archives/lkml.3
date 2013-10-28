Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3J1E7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 00:59:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56462 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3J1E7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 00:59:22 -0400
Date: Mon, 28 Oct 2013 00:59:20 -0400 (EDT)
Message-Id: <20131028.005920.1658700440523107416.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: kevin.curtis@farsite.co.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/8] farsync: Fix confusion about DMA address and
 buffer offset types
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382935885.3524.38.camel@deadeye.wl.decadent.org.uk>
References: <1382910704.2994.46.camel@deadeye.wl.decadent.org.uk>
	<20131028.002627.2095063739326406659.davem@davemloft.net>
	<1382935885.3524.38.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 27 Oct 2013 21:59:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 28 Oct 2013 04:51:25 +0000

> On Mon, 2013-10-28 at 00:26 -0400, David Miller wrote:
>> From: Ben Hutchings <ben@decadent.org.uk>
>> Date: Sun, 27 Oct 2013 21:51:44 +0000
>> 
>> > -     dbg(DBG_TX, "In fst_tx_dma %p %p %d\n", skb, mem, len);
>> > +     dbg(DBG_TX, "In fst_tx_dma %x %x %d\n", (u32)skb, mem, len);
>> 
>> Please use %p for the skb pointer instead of casting it (which btw
>> will introduce a warning on 64-bit).
> 
> skb is the DMA address of the data in the sk_buff.  Yes, this is really
> unusual naming.

Hmmm, Ok then I guess. :-/
