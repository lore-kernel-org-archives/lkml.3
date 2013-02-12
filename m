Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab3BLWG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:06:56 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57674 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3BLWGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:06:54 -0500
Date: Tue, 12 Feb 2013 17:06:50 -0500 (EST)
Message-Id: <20130212.170650.89534546100043269.davem@davemloft.net>
To: tipecaml@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        mugunthanvnm@ti.com, zonque@gmail.com, hotforest@gmail.com,
        Julia.Lawall@lip6.fr, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: remove redundant NULL check.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1360706086-31506-1-git-send-email-tipecaml@gmail.com>
References: <1360706086-31506-1-git-send-email-tipecaml@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyril Roelandt <tipecaml@gmail.com>
Date: Tue, 12 Feb 2013 22:54:46 +0100

> cpdma_chan_destroy() on a NULL pointer is a no-op, so the NULL check in
> cpdma_ctlr_destroy() can safely be removed.
> 
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
 ...
> @@ -450,8 +450,7 @@ int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr)
>  		cpdma_ctlr_stop(ctlr);
>  
>  	for (i = 0; i < ARRAY_SIZE(ctlr->channels); i++) {
> -		if (ctlr->channels[i])
> -			cpdma_chan_destroy(ctlr->channels[i]);
> +		cpdma_chan_destroy(ctlr->channels[i]);
>  	}

SInce this is now a single statement basic block, remove the
surrounding braces.
