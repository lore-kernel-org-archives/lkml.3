Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaJBIor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:44:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaJBIop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:44:45 -0400
Message-ID: <1412239495.32060.8.camel@linux-0dmf.site>
Subject: Re: [PATCH net] r8152: autoresume before setting MAC address
From: Oliver Neukum <oneukum@suse.de>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Thu, 02 Oct 2014 10:44:55 +0200
In-Reply-To: <1394712342-15778-55-Taiwan-albertk@realtek.com>
References: <1394712342-15778-55-Taiwan-albertk@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 16:26 +0800, Hayes Wang wrote:
> Resume the device before setting the MAC address.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 604ef21..e823358 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -1007,9 +1007,16 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
>  {
>  	struct r8152 *tp = netdev_priv(netdev);
>  	struct sockaddr *addr = p;
> +	int ret;
> +
> +	ret = usb_autopm_get_interface(tp->intf);
> +	if (ret < 0)
> +		goto out1;
>  
> -	if (!is_valid_ether_addr(addr->sa_data))
> -		return -EADDRNOTAVAIL;

It would be more legant to check validity before you do
the pm operation. Error handling would be simpler.

	Regards
		Oliver


