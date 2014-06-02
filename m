Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaFBC1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 22:27:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55400 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbaFBC1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 22:27:06 -0400
Date: Sun, 01 Jun 2014 19:27:05 -0700 (PDT)
Message-Id: <20140601.192705.693805935389177182.davem@davemloft.net>
To: benoit.taine@lip6.fr
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] lpc_eth: Use resource_size instead of computation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401290047-30005-3-git-send-email-benoit.taine@lip6.fr>
References: <1401290047-30005-1-git-send-email-benoit.taine@lip6.fr>
	<1401290047-30005-3-git-send-email-benoit.taine@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Jun 2014 19:27:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benoit Taine <benoit.taine@lip6.fr>
Date: Wed, 28 May 2014 17:14:07 +0200

> @@ -1419,8 +1419,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
>  
>  	netdev_dbg(ndev, "IO address start     :0x%08x\n",
>  			res->start);
> -	netdev_dbg(ndev, "IO address size      :%d\n",
> -			res->end - res->start + 1);
> +	netdev_dbg(ndev, "IO address size      :%d\n", resource_size(res));
>  	netdev_dbg(ndev, "IO address (mapped)  :0x%p\n",
>  			pldat->net_base);

Please replace all of this with %pR as suggested by Joe, thanks.
