Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3L0TDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 14:03:12 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:57433 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab3L0TDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 14:03:11 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Dec 2013 14:03:10 EST
Date: Fri, 27 Dec 2013 19:57:55 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] r8152: change some definitions
Message-ID: <20131227185755.GA29006@electric-eye.fr.zoreil.com>
References: <1388111649-1014-1-git-send-email-hayeswang@realtek.com>
 <1388111649-1014-4-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388111649-1014-4-git-send-email-hayeswang@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
[...]
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index b8bc3eb..a8ea848 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
[...]
> @@ -274,6 +274,9 @@ enum rtl_register_content {
>  #define RTL8152_MAX_TX		10
>  #define RTL8152_MAX_RX		10
>  #define INTBUFSIZE		2
> +#define CRC_SIZE		4

ETH_FCS_LEN ?

[...]
> @@ -1215,7 +1220,7 @@ static void rx_bottom(struct r8152 *tp)
>  
>  			stats = rtl8152_get_stats(netdev);
>  
> -			pkt_len -= 4; /* CRC */
> +			pkt_len -= CRC_SIZE; /* CRC */
>  			rx_data += sizeof(struct rx_desc);

Nit: you may remove the trailing "/* CRC */" in the same patch.

-- 
Ueimor
