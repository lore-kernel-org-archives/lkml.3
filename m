Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967290AbaFQVxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:53:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967264AbaFQVxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:53:12 -0400
Date: Tue, 17 Jun 2014 14:57:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: devel@driverdev.osuosl.org, lisa@xenapiadmin.com, ben@decadent.org.uk,
        valentina.manea.m@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] Fixes function fw_download_code to check for Null
 return from dev_skb_alloc
Message-ID: <20140617215709.GA20496@kroah.com>
References: <1403039881-16050-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403039881-16050-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of things wrong here, please step back, and slow down.

Your subject, this really isn't "v2", is it?

On Tue, Jun 17, 2014 at 05:18:01PM -0400, Nicholas Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

You aren't saying what you are doing here in the body of the patch, why
not?

> ---
>  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> index 11e915e..e4c8224 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> @@ -62,12 +62,14 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  
>  		skb  = dev_alloc_skb(frag_length + 4);
>  		if (!skb){
> +			rt_status = false;
> +			return rt_status;
> +		}

Again, this patch will not apply to the tree, you are making it against
your previous patch, which was rejected.  There is no way I can take
this, right?

Please start over and try again from a "clean" kernel tree.

thanks,

greg k-h
