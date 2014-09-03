Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaICGCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:02:12 -0400
Received: from relmlor3.renesas.com ([210.160.252.173]:26896 "EHLO
	relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754601AbaICGCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:02:10 -0400
X-IronPort-AV: E=Sophos;i="5.04,455,1406559600"; 
   d="scan'208";a="168203309"
Message-ID: <5406AEDB.2040702@renesas.com>
Date: Wed, 3 Sep 2014 15:02:03 +0900
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>, Felipe Balbi <balbi@ti.com>,
        kuninori morimoto <kuninori.morimoto.gx@renesas.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: USB_RENESAS_USBHS_UDC should depend on HAS_DMA
References: <1409340700-2033-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1409340700-2033-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [211.11.155.147]
X-ClientProxiedBy: HKXPR06CA015.apcprd06.prod.outlook.com (10.141.129.45) To
 HKNPR06MB322.apcprd06.prod.outlook.com (10.141.38.16)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 032334F434
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019014)(6049001)(6009001)(51704005)(479174003)(199003)(24454002)(189002)(76482001)(21056001)(101416001)(46102001)(23756003)(64126003)(77982001)(90102001)(102836001)(79102001)(33656002)(76176999)(87266999)(99396002)(50986999)(54356999)(4396001)(50466002)(65816999)(19580405001)(80316001)(86362001)(31966008)(74662001)(74502001)(19580395003)(83322001)(92566001)(92726001)(87976001)(83072002)(85852003)(42186005)(64706001)(47776003)(20776003)(95666004)(85306004)(81342001)(106356001)(105586002)(66066001)(65956001)(80022001)(65806001)(77096002)(107046002)(36756003)(81542001);DIR:OUT;SFP:1102;SCL:1;SRVR:HKNPR06MB322;H:[10.161.20.147];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: renesas.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

(2014/08/30 4:31), Geert Uytterhoeven wrote:
> If NO_DMA=y:
> 
> drivers/built-in.o: In function `usbhsg_dma_map_ctrl':
> mod_gadget.c:(.text+0x53b226): undefined reference to `usb_gadget_map_request'
> mod_gadget.c:(.text+0x53b242): undefined reference to `usb_gadget_unmap_request'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/usb/gadget/udc/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
> index 5151f947a4f5..00171d436cf8 100644
> --- a/drivers/usb/gadget/udc/Kconfig
> +++ b/drivers/usb/gadget/udc/Kconfig
> @@ -163,7 +163,7 @@ config USB_R8A66597
>  
>  config USB_RENESAS_USBHS_UDC
>  	tristate 'Renesas USBHS controller'
> -	depends on USB_RENESAS_USBHS
> +	depends on USB_RENESAS_USBHS && HAS_DMA
>  	help
>  	   Renesas USBHS is a discrete USB host and peripheral controller chip
>  	   that supports both full and high speed USB 2.0 data transfers.
> 

Acked-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda

