Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963AbaFQUOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 16:14:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964925AbaFQUOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 16:14:54 -0400
Date: Tue, 17 Jun 2014 13:18:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: devel@driverdev.osuosl.org, ben@decadent.org.uk, lisa@xenapiadmin.com,
        valentina.manea.m@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] Check if skb_alloc returns Null in function
 fw_download_code
Message-ID: <20140617201851.GC6061@kroah.com>
References: <1403021232-6469-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403021232-6469-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 12:07:12PM -0400, Nicholas Krause wrote:
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
> +		if (!skb)
> +			return 0;
>  			memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
>  			tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);

Again, look at this code and tell me if it now looks correct after your
change...

thanks,

greg k-h
