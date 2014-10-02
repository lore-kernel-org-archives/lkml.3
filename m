Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaJBRB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:01:57 -0400
Received: from p3plex2out04.prod.phx3.secureserver.net ([184.168.131.18]:48529
	"EHLO p3plex2out04.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753443AbaJBRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:01:54 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "luca.ellero@brickedbrain.com" <luca.ellero@brickedbrain.com>,
        "lisovy@gmail.com" <lisovy@gmail.com>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Richard Weinberger" <richard@nod.at>
Subject: RE: [PATCH] drivers/staging/comedi/Kconfig: Let COMEDI_II_PCI20KC
 depend on HAS_IOMEM
Thread-Topic: [PATCH] drivers/staging/comedi/Kconfig: Let COMEDI_II_PCI20KC
 depend on HAS_IOMEM
Thread-Index: AQHP3k4gow5hFBlhm02F4sKBzxlCjZwdB36A
Date: Thu, 2 Oct 2014 17:01:53 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FCE627@P3PWEX4MB008.ex4.secureserver.net>
References: <542D640E.6010200@gmail.com>
In-Reply-To: <542D640E.6010200@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s92H22EL007419

On Thursday, October 02, 2014 7:41 AM, Chen Gang wrote:
> COMEDI_II_PCI20KC needs HAS_IOMEM, so depend on it. The related error (
> with allmodconfig under um):
>
>     CC [M]  drivers/staging/comedi/drivers/ii_pci20kc.o
>   drivers/staging/comedi/drivers/ii_pci20kc.c: In function â€˜ii20k_attachâ€™:
>   drivers/staging/comedi/drivers/ii_pci20kc.c:442:2: error: implicit declaration of function â€˜ioremapâ€™ [-Werror=implicit-function-declaration]
>     dev->mmio = ioremap(membase, II20K_SIZE);
>     ^
>   drivers/staging/comedi/drivers/ii_pci20kc.c:442:12: warning: assignment makes pointer from integer without a cast [enabled by default]
>     dev->mmio = ioremap(membase, II20K_SIZE);
>               ^
>   drivers/staging/comedi/drivers/ii_pci20kc.c: In function â€˜ii20k_detachâ€™:
>   drivers/staging/comedi/drivers/ii_pci20kc.c:512:3: error: implicit declaration of function â€˜iounmapâ€™ [-Werror=implicit-function-declaration]
>      iounmap(dev->mmio);
>      ^
>
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/staging/comedi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
> index a8bc2b5..b709736 100644
> --- a/drivers/staging/comedi/Kconfig
> +++ b/drivers/staging/comedi/Kconfig
> @@ -426,6 +426,7 @@ config COMEDI_AIO_IIRO_16
>  
>  config COMEDI_II_PCI20KC
>  	tristate "Intelligent Instruments PCI-20001C carrier support"
> +	depends on HAS_IOMEM
>  	---help---
>  	  Enable support for Intelligent Instruments PCI-20001C carrier
>  	  PCI-20001, PCI-20006 and PCI-20341

This seems appropriate.

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
