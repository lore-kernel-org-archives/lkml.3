Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaBFNT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:19:57 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45499 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbaBFNTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:19:55 -0500
Message-ID: <1391692768.2843.4.camel@X1Carbon.localdomain>
Subject: Re: [PATCH] net: asix: fix bad header length bug
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ming Lei <ming.lei@canonical.com>,
        Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Feb 2014 14:19:28 +0100
In-Reply-To: <1391691384-8486-1-git-send-email-emilgoode@gmail.com>
References: <1391691384-8486-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.4 (3.11.4-2.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-06 at 13:56 +0100, Emil Goode wrote: 
> The AX88772B occasionally send rx packets that cross urb boundaries
> and the remaining partial packet is sent with no header.
> When the buffer with a partial packet is of less number of octets
> than the value of hard_header_len the buffer is discarded by the
> usbnet module. This is causing dropped packages and error messages
> in dmesg.
> 
> This can be reproduced by using ping with a packet size
> between 1965-1976.
> 
> The bug has been reported here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=29082
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
Reported-and-tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com> 
> ---
>  drivers/net/usb/asix_devices.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 9765a7d..120bb29 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -455,6 +455,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
>  	dev->net->ethtool_ops = &ax88772_ethtool_ops;
>  	dev->net->needed_headroom = 4; /* cf asix_tx_fixup() */
>  	dev->net->needed_tailroom = 4; /* cf asix_tx_fixup() */
> +	dev->net->hard_header_len = 0; /* Partial packets have no header */
>  
>  	embd_phy = ((dev->mii.phy_id & 0x1f) == 0x10 ? 1 : 0);
>  


-- 
-Igor Gnatenko

