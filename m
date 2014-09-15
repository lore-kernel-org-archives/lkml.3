Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaIOSHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:07:37 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:50982
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997AbaIOSHK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:07:10 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 11/11] staging: comedi: remove comedi_fc module
Thread-Topic: [PATCH 11/11] staging: comedi: remove comedi_fc module
Thread-Index: AQHP0OMSxUqg/Ohm40+ctR61Gn4T65wCfNjA
Date: Mon, 15 Sep 2014 18:07:07 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FA1B2F@P3PWEX4MB008.ex4.secureserver.net>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
 <1410785167-28506-12-git-send-email-abbotti@mev.co.uk>
In-Reply-To: <1410785167-28506-12-git-send-email-abbotti@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 15, 2014 5:46 AM, Ian Abbott wrote:
> All the exported functions in the "comedi_fc" module have been migrated
> to the core "comedi" module and renamed, so it is now just a dummy
> module.  Remove it.
>
> Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> ---
> drivers/staging/comedi/Kconfig             | 31 ------------------------
>  drivers/staging/comedi/drivers/Makefile    |  1 -
>  drivers/staging/comedi/drivers/comedi_fc.c | 38 ------------------------------
>  3 files changed, 70 deletions(-)
>  delete mode 100644 drivers/staging/comedi/drivers/comedi_fc.c
>
> diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
> index fd5f939..ea4948f 100644
> --- a/drivers/staging/comedi/Kconfig
> +++ b/drivers/staging/comedi/Kconfig

[snip]

> @@ -678,7 +667,6 @@ config COMEDI_ADDI_APCI_2200
>  config COMEDI_ADDI_APCI_3120
>  	tristate "ADDI-DATA APCI_3120/3001 support"
>  	depends on VIRT_TO_BUS
> -	select COMEDI_FC
>  	---help---
>  	  Enable support for ADDI-DATA APCI_3120/3001 cards

Ian,

I'm not sure of the patch order for this series and your:
" [PATCH 0/4] staging: comedi: addi_apci_3120: redo DMA buffer allocation"

This patch has a conflict with 3/4 of that series:

config COMEDI_ADDI_APCI_3120
	tristate "ADDI-DATA APCI_3120/3001 support"
	depends on HAS_DMA
	select COMEDI_FC
	---help---
	  Enable support for ADDI-DATA APCI_3120/3001 cards

Regards,
Hartley

