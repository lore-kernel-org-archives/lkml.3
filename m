Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbbARAUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:20:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbbARAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:20:03 -0500
Date: Sat, 17 Jan 2015 16:13:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Sean Cleator <seancleator@hotmail.co.uk>
Cc: David Matlack <matlackdavid@gmail.com>, devel@driverdev.osuosl.org,
        Vincent Heuken <me@vincentheuken.com>, linux-kernel@vger.kernel.org,
        Lior Dotan <liodot@gmail.com>,
        Christopher Harrer <charrer@alacritech.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Staging: slicoss: Fix long line issues in slicoss.c
Message-ID: <20150118001331.GA32461@kroah.com>
References: <BLU436-SMTP26EFE4C56ADB4FB217BA7EE97B0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP26EFE4C56ADB4FB217BA7EE97B0@phx.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 01:53:18PM +0000, Sean Cleator wrote:
> A patch to the slicoss.c file to fix some of the long line issues found by the
> checkpath.pl tool
>  
> Signed-off-by: Sean Cleator <seancleator@hotmail.co.uk>
> 
> ---
>  drivers/staging/slicoss/slicoss.c | 39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> index 56ca3b6..4df4a7e 100644
> --- a/drivers/staging/slicoss/slicoss.c
> +++ b/drivers/staging/slicoss/slicoss.c
> @@ -498,12 +498,14 @@ static int slic_card_download(struct adapter *adapter)
>  			slic_reg32_write(&slic_regs->slic_wcs,
>  					 baseaddress + codeaddr, FLUSH);
>  			/* Write out instruction to low addr */
> -			slic_reg32_write(&slic_regs->slic_wcs, instruction, FLUSH);
> +			slic_reg32_write(&slic_regs->slic_wcs,
> +					instruction, FLUSH);
>  			instruction = *(u32 *)(fw->data + index);
>  			index += 4;
>  
>  			/* Write out instruction to high addr */
> -			slic_reg32_write(&slic_regs->slic_wcs, instruction, FLUSH);
> +			slic_reg32_write(&slic_regs->slic_wcs,
> +					instruction, FLUSH);
>  			instruction = *(u32 *)(fw->data + index);
>  			index += 4;
>  		}
> @@ -1533,14 +1535,18 @@ retry_rcvqfill:
>  				dev_err(dev, "%s: LOW 32bits PHYSICAL ADDRESS == 0\n",
>  					__func__);
>  				dev_err(dev, "skb[%p] PROBLEM\n", skb);
> -				dev_err(dev, "         skbdata[%p]\n", skb->data);
> +				dev_err(dev, "         skbdata[%p]\n",
> +						skb->data);
>  				dev_err(dev, "         skblen[%x]\n", skb->len);
>  				dev_err(dev, "         paddr[%p]\n", paddr);
>  				dev_err(dev, "         paddrl[%x]\n", paddrl);
>  				dev_err(dev, "         paddrh[%x]\n", paddrh);
> -				dev_err(dev, "         rcvq->head[%p]\n", rcvq->head);
> -				dev_err(dev, "         rcvq->tail[%p]\n", rcvq->tail);
> -				dev_err(dev, "         rcvq->count[%x]\n", rcvq->count);
> +				dev_err(dev, "         rcvq->head[%p]\n",
> +						rcvq->head);
> +				dev_err(dev, "         rcvq->tail[%p]\n",
> +						rcvq->tail);
> +				dev_err(dev, "         rcvq->count[%x]\n",
> +						rcvq->count);
>  				dev_err(dev, "SKIP THIS SKB!!!!!!!!\n");
>  				goto retry_rcvqfill;
>  			}


This change makes the code look worse, don't you think?  Please don't do
that.

thanks,

greg k-h
