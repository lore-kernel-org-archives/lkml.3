Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbbANC7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:59:47 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38435 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbANC7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:59:46 -0500
Date: Tue, 13 Jan 2015 21:59:44 -0500 (EST)
Message-Id: <20150113.215944.1703977685948196746.davem@davemloft.net>
To: lambert.quentin@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] atm: remove deprecated use of pci api
From: David Miller <davem@davemloft.net>
In-Reply-To: <20150112161042.GA11374@sloth>
References: <20150112161042.GA11374@sloth>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 Jan 2015 18:59:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Quentin Lambert <lambert.quentin@gmail.com>
Date: Mon, 12 Jan 2015 17:10:42 +0100

> @@ -2246,7 +2246,8 @@ static int eni_init_one(struct pci_dev *pci_dev,
>  		goto err_disable;
>  
>  	zero = &eni_dev->zero;
> -	zero->addr = pci_alloc_consistent(pci_dev, ENI_ZEROES_SIZE, &zero->dma);
> +	zero->addr = dma_alloc_coherent(&pci_dev->dev, ENI_ZEROES_SIZE,
> +					&zero->dma, GFP_ATOMIC);
>  	if (!zero->addr)
>  		goto err_kfree;
>  

I really would like you to look at these locations and see if
GFP_KERNEL can be used instead of GFP_ATOMIC.  I bet that nearly
all of these can, and it is preferred.

Thanks.
