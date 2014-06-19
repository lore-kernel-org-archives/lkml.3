Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbaFSF3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:29:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36076 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaFSF3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:29:14 -0400
Date: Thu, 19 Jun 2014 08:29:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        ben@decadent.org.uk, lisa@xenapiadmin.com, valentina.manea.m@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192e: check return value of dev_skb_alloc
Message-ID: <20140619052910.GP5500@mwanda>
References: <1403144681-6902-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403144681-6902-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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

What's this !rt_status?  Just return false.

regards,
dan carpenter

