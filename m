Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3IRP5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:57:50 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:50677 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3IRP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:57:48 -0400
Message-ID: <1379519865.1522.37.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 007/007] WAN Drivers: Update farsync driver and
 introduce fsflex driver
From: Ben Hutchings <bhutchings@solarflare.com>
To: Kevin Curtis <Kevin.Curtis@farsite.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Dermot Smith" <dermot.smith@farsite.com>
Date: Wed, 18 Sep 2013 16:57:45 +0100
In-Reply-To: <E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA6@SOLO.hq.farsitecommunications.com>
References: <E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA6@SOLO.hq.farsitecommunications.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20158.002
X-TM-AS-Result: No--17.938800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 11:12 +0100, Kevin Curtis wrote:
> Farsite Communications FarSync driver update
> 
> Patch 7 of 7
> 
> Update the help text and description for farsync configuration in the Kernel.
> Build farsync and fsflex when the farsync driver is selected.

fsflex seems to be an entirely independent module and should have its
own config option.

Ben.

> Signed-off-by: Kevin Curtis <kevin.curtis@farsite.com>
> 
> ---
> 
> diff -uprN -X linux-3.10.1/Documentation/dontdiff linux-3.10.1/drivers/net/wan/Kconfig linux-3.10.1_new/drivers/net/wan/Kconfig
> --- linux-3.10.1/drivers/net/wan/Kconfig	2013-07-13 19:42:41.000000000 +0100
> +++ linux-3.10.1_new/drivers/net/wan/Kconfig	2013-07-31 14:11:05.792775800 +0100
> @@ -248,11 +248,11 @@ config C101
>  	  If unsure, say N.
>  
>  config FARSYNC
> -	tristate "FarSync T-Series support"
> +	tristate "FarSync T-Series and Flex support"
>  	depends on HDLC && PCI
>  	---help---
> -	  Support for the FarSync T-Series X.21 (and V.35/V.24) cards by
> -	  FarSite Communications Ltd.
> +	  Support for the FarSync T-Series and FarSync Flex X.21 (and
> +          V.35/V.24) ports by FarSite Communications Ltd.
>  
>  	  Synchronous communication is supported on all ports at speeds up to
>  	  8Mb/s (128K on V.24) using synchronous PPP, Cisco HDLC, raw HDLC,
> diff -uprN -X linux-3.10.1/Documentation/dontdiff linux-3.10.1/drivers/net/wan/Makefile linux-3.10.1_new/drivers/net/wan/Makefile
> --- linux-3.10.1/drivers/net/wan/Makefile	2013-07-13 19:42:41.000000000 +0100
> +++ linux-3.10.1_new/drivers/net/wan/Makefile	2013-07-26 09:14:15.345354002 +0100
> @@ -16,7 +16,7 @@ obj-$(CONFIG_HDLC_X25)		+= hdlc_x25.o
>  obj-$(CONFIG_HOSTESS_SV11)	+= z85230.o	hostess_sv11.o
>  obj-$(CONFIG_SEALEVEL_4021)	+= z85230.o	sealevel.o
>  obj-$(CONFIG_COSA)		+= cosa.o
> -obj-$(CONFIG_FARSYNC)		+= farsync.o
> +obj-$(CONFIG_FARSYNC)		+= farsync.o fsflex.o
>  obj-$(CONFIG_DSCC4)             += dscc4.o
>  obj-$(CONFIG_X25_ASY)		+= x25_asy.o
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

