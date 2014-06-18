Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaFRWJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:09:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaFRWJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:09:34 -0400
Date: Wed, 18 Jun 2014 15:13:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: devel@driverdev.osuosl.org, lisa@xenapiadmin.com, ben@decadent.org.uk,
        valentina.manea.m@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixes no Null check of dev_skb_alloc in fw_download_code
Message-ID: <20140618221332.GA8693@kroah.com>
References: <1403126778-3563-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403126778-3563-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 05:26:18PM -0400, Nicholas Krause wrote:
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 4 ++++
>  1 file changed, 4 insertions(+)

Some more meta-comments.  Your subject: should give people a clue as to
where in the kernel you are changing.  This patch would be:
	Subject: staging: rtl8192e: check return value of dev_skb_alloc

And then in the body of the patch changelog area, explain why you are
doing this.

> 
> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> index 1a95d1f..1a90546 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
> @@ -61,6 +61,10 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
>  		}
>  
>  		skb  = dev_alloc_skb(frag_length + 4);
> +		if (!skb) {
> +			rt_status = false;
> +			return rt_status;
> +		}

Does that really look like the correct thing to be doing here?  Surely
you can delete 2 lines of this patch, right?

thanks,

greg k-h
