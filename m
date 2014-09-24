Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbaIXM0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:26:31 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50750 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbaIXMZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:25:36 -0400
Message-ID: <5422B83A.8030406@gmail.com>
Date: Wed, 24 Sep 2014 19:25:30 +0700
From: Lars Melin <larsm17@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Heiko Schocher <hs@denx.de>, linux-usb@vger.kernel.org
CC: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.name>,
        netdev@vger.kernel.org, linux-api@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Macpaul Lin <macpaul@gmail.com>
Subject: Re: [PATCH] usb: gadget: f_rndis: fix usb_interface_descriptor for
 rndis
References: <1411541339-32400-1-git-send-email-hs@denx.de>
In-Reply-To: <1411541339-32400-1-git-send-email-hs@denx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-24 13:48, Heiko Schocher wrote:
> use the values for RNDIS over Ethernet as defined in
> http://www.usb.org/developers/defined_class
> (search for RDNIS):
>
> - baseclass: 0xef (miscellaneous)
> - subclass: 0x04
> - protocol: 0x01
>
That is usb class, it is not the same thing as communication device class.
> --- a/include/uapi/linux/usb/cdc.h
> +++ b/include/uapi/linux/usb/cdc.h
> @@ -12,6 +12,7 @@
>   #include <linux/types.h>
>   
>   #define USB_CDC_SUBCLASS_ACM			0x02
> +#define USB_CDC_SUBCLASS_RNDIS			0x04
No, no, no.
There is no CDC_SUBCLASS_RNDIS and you can not define one over an 
already used cdc subclass number,  0x04 is  Multi-Channel Control Model

