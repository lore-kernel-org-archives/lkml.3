Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaHRCAn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 22:00:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaHRCAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 22:00:42 -0400
Date: Sun, 17 Aug 2014 18:59:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: return -ENODEV on failure of try_module_get
Message-ID: <20140818015959.GC14301@kroah.com>
References: <1408300482-1667-1-git-send-email-arjun024@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408300482-1667-1-git-send-email-arjun024@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 12:04:42AM +0530, Arjun Sreedharan wrote:
> When __usb_find_phy_dev() does not return error and
> try_module_get() fails, return -ENODEV
> 
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> ---
>  drivers/usb/phy/phy.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> index 36b6bce..8ad3638 100644
> --- a/drivers/usb/phy/phy.c
> +++ b/drivers/usb/phy/phy.c
> @@ -232,6 +232,7 @@ struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
>  	phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
>  	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
>  		dev_dbg(dev, "unable to find transceiver\n");
> +		phy = IS_ERR(phy) ? phy : ERR_PTR(-ENODEV);

Please just spell out the if () statement, don't use ? : unless
necessary.

thanks,

greg k-h
