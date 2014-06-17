Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaFQGIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 02:08:02 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48088 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbaFQGIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 02:08:00 -0400
Date: Tue, 17 Jun 2014 09:07:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        ben@decadent.org.uk, lisa@xenapiadmin.com, valentina.manea.m@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check if skb_alloc returns Null in function
 fw_download_code
Message-ID: <20140617060746.GL5500@mwanda>
References: <1402975393-26830-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402975393-26830-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:23:13PM -0400, Nicholas Krause wrote:
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
> +		if (!skb) {

This test is reversed and causes a NULL dereference on the next line.

regards,
dan carpenter

>  		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
>  		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
>  		tcb_desc->queue_index = TXCMD_QUEUE;
>  		tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
>  		tcb_desc->bLastIniPkt = bLastIniPkt;
> +		}
>  
>  		seg_ptr = skb->data;
>  		for (i = 0; i < frag_length; i += 4) {
> -- 
> 1.9.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
