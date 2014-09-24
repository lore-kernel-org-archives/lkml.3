Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaIXJi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:38:56 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:61226 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaIXJir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:38:47 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Heiko Schocher <hs@denx.de>, linux-usb@vger.kernel.org
Cc: Heiko Schocher <hs@denx.de>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Oliver Neukum <oliver@neukum.name>, netdev@vger.kernel.org,
        linux-api@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Macpaul Lin <macpaul@gmail.com>
Subject: Re: [PATCH] usb: gadget: f_rndis: fix usb_interface_descriptor for rndis
In-Reply-To: <1411541339-32400-1-git-send-email-hs@denx.de>
Organization: http://mina86.com/
References: <1411541339-32400-1-git-send-email-hs@denx.de>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140924:oliver@neukum.name::E2ClQiT1ZJmoMXg/:00000000000000000000000000000000000000000000gx2
X-Hashcash: 1:20:140924:balbi@ti.com::XyC4jHnf/LmLkw9E:000000ufG
X-Hashcash: 1:20:140924:linux-usb@vger.kernel.org::xmeQ09MTFSDEIjBC:0000000000000000000000000000000000000xkk
X-Hashcash: 1:20:140924:andrzej.p@samsung.com::KScOsq7KfCwfSNEL:00000000000000000000000000000000000000001gcc
X-Hashcash: 1:20:140924:hs@denx.de::D1kROGUekV+Uh/BZ:00000001dHf
X-Hashcash: 1:20:140924:dan.carpenter@oracle.com::ihzSS2N20ZKpYFKI:00000000000000000000000000000000000001Wwl
X-Hashcash: 1:20:140924:hs@denx.de::bQ4C1UMyUw8IeMYE:00000002o8B
X-Hashcash: 1:20:140924:gregkh@suse.de::rzmdilWCSJZFH3OE:0002dz2
X-Hashcash: 1:20:140924:macpaul@gmail.com::ppb+ktJyK6yYDOCF:000000000000000000000000000000000000000000002cMo
X-Hashcash: 1:20:140924:kyungmin.park@samsung.com::xng13jIQAq/ciA2S:0000000000000000000000000000000000002gBd
X-Hashcash: 1:20:140924:linux-api@vger.kernel.org::vK9eqOhjfiPww4XN:00000000000000000000000000000000000028fY
X-Hashcash: 1:20:140924:linux-kernel@vger.kernel.org::BQpPm4dtMB/mi4cY:0000000000000000000000000000000008sJy
X-Hashcash: 1:20:140924:netdev@vger.kernel.org::qmkOHJblSt3ziVSE:000000000000000000000000000000000000000AL7X
Date: Wed, 24 Sep 2014 11:38:40 +0200
Message-ID: <xa1tbnq59x3z.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24 2014, Heiko Schocher <hs@denx.de> wrote:
> use the values for RNDIS over Ethernet as defined in
> http://www.usb.org/developers/defined_class
> (search for RDNIS):
>
> - baseclass: 0xef (miscellaneous)
> - subclass: 0x04
> - protocol: 0x01
>
> with this setings the file in Documentation/usb/linux.inf is
> obsolete.
>
> Signed-off-by: Heiko Schocher <hs@denx.de>
>
> ---
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Oliver Neukum <oliver@neukum.name>
> Cc: netdev@vger.kernel.org
> Cc: linux-api@vger.kernel.org
> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: Macpaul Lin <macpaul@gmail.com>
>
> Tested with the "USB Compliance test suite which runs Windows", see:
> http://www.usb.org/developers/tools/usb20_tools/#usb20cv
>
>  drivers/net/usb/cdc_ether.c           | 6 +++---
>  drivers/usb/core/generic.c            | 6 +++---
>  drivers/usb/gadget/function/f_rndis.c | 6 +++---
>  include/uapi/linux/usb/cdc.h          | 3 +++
>  4 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
> index 2a32d91..9c216c2 100644
> --- a/drivers/net/usb/cdc_ether.c
> +++ b/drivers/net/usb/cdc_ether.c
> @@ -35,9 +35,9 @@
>  
>  static int is_rndis(struct usb_interface_descriptor *desc)
>  {
> -	return (desc->bInterfaceClass == USB_CLASS_COMM &&
> -		desc->bInterfaceSubClass == 2 &&
> -		desc->bInterfaceProtocol == 0xff);
> +	return (desc->bInterfaceClass == USB_CLASS_MISC &&
> +		desc->bInterfaceSubClass == USB_CDC_SUBCLASS_RNDIS &&
> +		desc->bInterfaceProtocol == USB_CDC_RNDIS_PROTO_ETH);
>  }

Does that mean that new kernels will stop working with old RNDIs
gadgets because they stop recognising them as RNDIS?  I feel like this
function should accept both, i.e.:

	return (desc->bInterfaceClass == USB_CLASS_COMM &&
		desc->bInterfaceSubClass == 2 &&
		desc->bInterfaceProtocol == 0xff) ||
	       (desc->bInterfaceClass == USB_CLASS_MISC &&
		desc->bInterfaceSubClass == USB_CDC_SUBCLASS_RNDIS &&
		desc->bInterfaceProtocol == USB_CDC_RNDIS_PROTO_ETH);

>  
>  static int is_activesync(struct usb_interface_descriptor *desc)
> diff --git a/drivers/usb/core/generic.c b/drivers/usb/core/generic.c
> index 358ca8d..a2a4e05 100644
> --- a/drivers/usb/core/generic.c
> +++ b/drivers/usb/core/generic.c
> @@ -28,9 +28,9 @@ static inline const char *plural(int n)
>  
>  static int is_rndis(struct usb_interface_descriptor *desc)
>  {
> -	return desc->bInterfaceClass == USB_CLASS_COMM
> -		&& desc->bInterfaceSubClass == 2
> -		&& desc->bInterfaceProtocol == 0xff;
> +	return desc->bInterfaceClass == USB_CLASS_MISC
> +		&& desc->bInterfaceSubClass == USB_CDC_SUBCLASS_RNDIS
> +		&& desc->bInterfaceProtocol == USB_CDC_RNDIS_PROTO_ETH;
>  }

Ditto.

>  
>  static int is_activesync(struct usb_interface_descriptor *desc)
> diff --git a/drivers/usb/gadget/function/f_rndis.c b/drivers/usb/gadget/function/f_rndis.c
> index ddb09dc..cc06046 100644
> --- a/drivers/usb/gadget/function/f_rndis.c
> +++ b/drivers/usb/gadget/function/f_rndis.c
> @@ -117,9 +117,9 @@ static struct usb_interface_descriptor rndis_control_intf = {
>  	/* .bInterfaceNumber = DYNAMIC */
>  	/* status endpoint is optional; this could be patched later */
>  	.bNumEndpoints =	1,
> -	.bInterfaceClass =	USB_CLASS_COMM,
> -	.bInterfaceSubClass =   USB_CDC_SUBCLASS_ACM,
> -	.bInterfaceProtocol =   USB_CDC_ACM_PROTO_VENDOR,
> +	.bInterfaceClass =	USB_CLASS_MISC,
> +	.bInterfaceSubClass =   USB_CDC_SUBCLASS_RNDIS,
> +	.bInterfaceProtocol =   USB_CDC_RNDIS_PROTO_ETH,
>  	/* .iInterface = DYNAMIC */
>  };
>  
> diff --git a/include/uapi/linux/usb/cdc.h b/include/uapi/linux/usb/cdc.h
> index b6a9cdd..8e8fc85 100644
> --- a/include/uapi/linux/usb/cdc.h
> +++ b/include/uapi/linux/usb/cdc.h
> @@ -12,6 +12,7 @@
>  #include <linux/types.h>
>  
>  #define USB_CDC_SUBCLASS_ACM			0x02
> +#define USB_CDC_SUBCLASS_RNDIS			0x04
>  #define USB_CDC_SUBCLASS_ETHERNET		0x06
>  #define USB_CDC_SUBCLASS_WHCM			0x08
>  #define USB_CDC_SUBCLASS_DMM			0x09
> @@ -31,6 +32,8 @@
>  #define USB_CDC_ACM_PROTO_AT_CDMA		6
>  #define USB_CDC_ACM_PROTO_VENDOR		0xff
>  
> +#define USB_CDC_RNDIS_PROTO_ETH			1
> +
>  #define USB_CDC_PROTO_EEM			7
>  
>  #define USB_CDC_NCM_PROTO_NTB			1

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
