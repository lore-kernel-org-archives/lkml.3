Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaFSCl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:41:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbaFSCl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:41:56 -0400
Date: Wed, 18 Jun 2014 19:45:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: devel@driverdev.osuosl.org, ben@decadent.org.uk, lisa@xenapiadmin.com,
        valentina.manea.m@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192e: check return value of dev_skb_alloc
Message-ID: <20140619024555.GA30672@kroah.com>
References: <1403144681-6902-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403144681-6902-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 10:24:41PM -0400, Nicholas Krause wrote:
> Checks if dev_skb_alloc returns Null in function, fw_download_code.
> If the return value of dev_skb_alloc is NULL return false and exit
> this function.
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> index 1a95d1f..38ae236 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> @@ -62,6 +62,8 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  
>  		skb  = dev_alloc_skb(frag_length + 4);
>  		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
> +		if (!skb)
> +			return !rt_status;
>  		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
>  		tcb_desc->queue_index = TXCMD_QUEUE;
>  		tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;

As writing emails to you seems like dumping stuff into a vacuum, I'm
going to just delete this message and start ignoring your mail like you
seem to be ignoring mine...

Best of luck,

greg k-h
