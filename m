Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbaLJUPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:15:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47409 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaLJUPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:15:53 -0500
Date: Wed, 10 Dec 2014 15:15:50 -0500 (EST)
Message-Id: <20141210.151550.855246066396941606.davem@davemloft.net>
To: cyrille.pitchen@atmel.com
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, soren.brinkmann@xilinx.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/macb: add TX multiqueue support for gem
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418223831-30435-2-git-send-email-cyrille.pitchen@atmel.com>
References: <1418223831-30435-1-git-send-email-cyrille.pitchen@atmel.com>
	<1418223831-30435-2-git-send-email-cyrille.pitchen@atmel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 12:15:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBAKG33k008613

From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Date: Wed, 10 Dec 2014 16:03:51 +0100

> +	netdev_vdbg(bp->dev, "macb_tx_error_task: q = %u, t = %u, h = %u\n",
> +		    queue - bp->queues, queue->tx_tail, queue->tx_head);

This and another change int his patch adds build warnings because
"ptr1 - ptr2" is a ptrdiff_t, which is a long int on some platforms:

drivers/net/ethernet/cadence/macb.c: In function ¡macb_tx_error_task¢:
drivers/net/ethernet/cadence/macb.c:504:2: warning: format ¡%u¢ expects argument of type ¡unsigned int¢, but argument 4 has type ¡long int¢ [-Wformat]
drivers/net/ethernet/cadence/macb.c: In function ¡macb_interrupt¢:
drivers/net/ethernet/cadence/macb.c:988:3: warning: format ¡%u¢ expects argument of type ¡unsigned int¢, but argument 4 has type ¡long int¢ [-Wformat]
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
