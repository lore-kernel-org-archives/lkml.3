Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbaFQPmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:42:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015AbaFQPmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:42:03 -0400
Date: Tue, 17 Jun 2014 08:46:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: devel@driverdev.osuosl.org, ben@decadent.org.uk, lisa@xenapiadmin.com,
        valentina.manea.m@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] Check if skb_alloc returns Null in function
 fw_download_code
Message-ID: <20140617154600.GA14106@kroah.com>
References: <1403017516-4050-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403017516-4050-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 11:05:16AM -0400, Nicholas Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> index 1a95d1f..11e915e 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> @@ -61,11 +61,13 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  		}
>  
>  		skb  = dev_alloc_skb(frag_length + 4);
> +		if (skb)
> +			return 0;
>  			memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
>  			tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
>  			tcb_desc->queue_index = TXCMD_QUEUE;
>  			tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
>  			tcb_desc->bLastIniPkt = bLastIniPkt;
>  
>  		seg_ptr = skb->data;
>  		for (i = 0; i < frag_length; i += 4) {

This patch doesn't even apply, what are you doing to create it?

And does it look correct?  To me it sure does not...

thanks,

greg k-h
