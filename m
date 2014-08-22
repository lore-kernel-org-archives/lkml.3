Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbaHVEjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:39:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46241 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaHVEja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:39:30 -0400
Date: Thu, 21 Aug 2014 21:39:29 -0700 (PDT)
Message-Id: <20140821.213929.2048600939729474726.davem@davemloft.net>
To: jonas.jensen@gmail.com
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, f.fainelli@gmail.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v5 1/2] net: moxa: clear TX descriptor length bits
From: David Miller <davem@davemloft.net>
In-Reply-To: <1408544322-32023-1-git-send-email-jonas.jensen@gmail.com>
References: <1408459784-9385-1-git-send-email-jonas.jensen@gmail.com>
	<1408544322-32023-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Aug 2014 21:39:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Jensen <jonas.jensen@gmail.com>
Date: Wed, 20 Aug 2014 16:18:42 +0200

> @@ -348,7 +348,8 @@ static int moxart_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  
>  	txdes1 = readl(desc + TX_REG_OFFSET_DESC1);
>  	txdes1 |= TX_DESC1_LTS | TX_DESC1_FTS;
> -	txdes1 &= ~(TX_DESC1_FIFO_COMPLETE | TX_DESC1_INTR_COMPLETE);
> +	txdes1 &= ~(TX_DESC1_FIFO_COMPLETE | TX_DESC1_INTR_COMPLETE |
> +		    TX_DESC1_BUF_SIZE_MASK);
>  	txdes1 |= (len & TX_DESC1_BUF_SIZE_MASK);
>  	writel(txdes1, desc + TX_REG_OFFSET_DESC1);
>  	writel(TX_DESC0_DMA_OWN, desc + TX_REG_OFFSET_DESC0);

Like others I wonder why the existing descriptor value is being read
at all.

It's inefficient and completely unnecessary, you can just compute a new
value from scratch, and that way all of these "uncleared field" issues
just automatically disappear.
