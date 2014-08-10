Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaHJU1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 16:27:04 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:50887 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaHJU1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 16:27:01 -0400
Message-ID: <53E7D587.9040303@gmail.com>
Date: Sun, 10 Aug 2014 22:26:47 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Olof Johansson <olof@lixom.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, Felipe Balbi <balbi@ti.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] drivers: net: davinci_cpdma: drop devm_kfree of devm_kzalloc'd
 data
References: <20140810195819.GA3880@himangi-Dell>
In-Reply-To: <20140810195819.GA3880@himangi-Dell>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 09:58 PM, Himangi Saraogi wrote:
> devm_kfree should not have to be explicitly used.
> 
> The Coccinelle semantic patch that fixes this problem is as follows:
> 
> // <smpl>
> @@
> expression x,d;
> @@
> 
> x = devm_kzalloc(...)
> ...
> ?-devm_kfree(d,x);
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Acked-by: Daniel Mack <zonque@gmail.com>

However, you need to resend this patch after 3.17-rc1 has been released
and the net-next branch was opened again.


Thanks,
Daniel


> ---
>  drivers/net/ethernet/ti/davinci_cpdma.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
> index 4a000f6..af673f5 100644
> --- a/drivers/net/ethernet/ti/davinci_cpdma.c
> +++ b/drivers/net/ethernet/ti/davinci_cpdma.c
> @@ -512,7 +512,6 @@ struct cpdma_chan *cpdma_chan_create(struct cpdma_ctlr *ctlr, int chan_num,
>  	spin_lock_irqsave(&ctlr->lock, flags);
>  	if (ctlr->channels[chan_num]) {
>  		spin_unlock_irqrestore(&ctlr->lock, flags);
> -		devm_kfree(ctlr->dev, chan);
>  		return ERR_PTR(-EBUSY);
>  	}
>  
> 

