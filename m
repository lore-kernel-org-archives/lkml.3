Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaLTUnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:43:18 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:54891 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449AbaLTUnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:43:15 -0500
Message-ID: <1419108192.27548.7.camel@x220>
Subject: Re: [PATCH]  bluetooth: Add hci_h4p driver
From: Paul Bolle <pebolle@tiscali.nl>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Date: Sat, 20 Dec 2014 21:43:12 +0100
In-Reply-To: <20141220202314.GA8484@amd>
References: <20141213223727.GA13894@amd> <20141220202314.GA8484@amd>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Dec 2014 20:43:13.0137 (UTC) FILETIME=[92BDEE10:01D01C95]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel,

On Sat, 2014-12-20 at 21:23 +0100, Pavel Machek wrote:
> --- a/drivers/bluetooth/Kconfig
> +++ b/drivers/bluetooth/Kconfig
> @@ -243,4 +243,13 @@ config BT_WILINK
>  	  Say Y here to compile support for Texas Instrument's WiLink7 driver
>  	  into the kernel or say M to compile it as module (btwilink).
>  
> +config BT_NOKIA_H4P
> +	tristate "HCI driver with H4 Nokia extensions"
> +	help
> +	  Bluetooth HCI driver with H4 extensions.  This driver provides
> +	  support for H4+ Bluetooth chip with vendor-specific H4 extensions.
> +
> +	  Say Y here to compile support for h4 extended devices into the kernel
> +	  or say M to compile it as module (btnokia_h4p).

Will this module be called btnokia_h4p or ...

> +
>  endmenu
> diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
> index 9fe8a87..624ef3fc 100644
> --- a/drivers/bluetooth/Makefile
> +++ b/drivers/bluetooth/Makefile
> @@ -31,4 +31,7 @@ hci_uart-$(CONFIG_BT_HCIUART_ATH3K)	+= hci_ath.o
>  hci_uart-$(CONFIG_BT_HCIUART_3WIRE)	+= hci_h5.o
>  hci_uart-objs				:= $(hci_uart-y)
>  
> +obj-$(CONFIG_BT_NOKIA_H4P)      += nokia_h4p.o

... nokia_h4p?

> +nokia_h4p-objs := nokia_core.o nokia_fw.o nokia_uart.o
> +
>  ccflags-y += -D__CHECK_ENDIAN__

Or did I miss some make magic here?

Thanks,


Paul Bolle

