Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab3CSQeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:34:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44944 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3CSQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:34:00 -0400
Date: Tue, 19 Mar 2013 12:33:59 -0400 (EDT)
Message-Id: <20130319.123359.2245221095583640859.davem@davemloft.net>
To: aeschlimann@gmail.com
Cc: khc@pm.waw.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        c.aeschlimann@acn-group.ch
Subject: Re: [PATCH] ixp4xx_eth: set the device dma_coherent_mask
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363708765-20778-1-git-send-email-c.aeschlimann@acn-group.ch>
References: <1363708765-20778-1-git-send-email-c.aeschlimann@acn-group.ch>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Mar 2013 09:34:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christophe Aeschlimann <aeschlimann@gmail.com>
Date: Tue, 19 Mar 2013 16:59:25 +0100

> Without the mask it is impossible to take the network interface up
> since it returns the following error:
> 
>> net eth1: coherent DMA mask is unset
>> ifconfig: SIOCSIFFLAGS: Cannot allocate memory
> 
> Tested on an out-of-tree ixp425 based board.
> 
> Signed-off-by: Christophe Aeschlimann <c.aeschlimann@acn-group.ch>
 ...
> @@ -1398,6 +1398,7 @@ static int eth_init_one(struct platform_device *pdev)
>  		return -ENOMEM;
>  
>  	SET_NETDEV_DEV(dev, &pdev->dev);
> +	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);

Hmmm, shouldn't this be the default value, set by the bus layer or
similar?
