Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945AbaE3Qoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:44:44 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:41669
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053AbaE3Qom convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:44:42 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/6] staging: comedi: addi_apci_1564: introduce
 apci1564_private struct
Thread-Topic: [PATCH 3/6] staging: comedi: addi_apci_1564: introduce
 apci1564_private struct
Thread-Index: AQHPe8Go+I5KCyos4EeI/XVkdz1A3JtZU5zg
Date: Fri, 30 May 2014 16:44:41 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825E83D84@P3PWEX4MB008.ex4.secureserver.net>
References: <1401424853-21683-1-git-send-email-chase.southwood@gmail.com>
 <1401424963-22202-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1401424963-22202-1-git-send-email-chase.southwood@gmail.com>
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

On Thursday, May 29, 2014 9:43 PM, Chase Southwood wrote:
> The addi_private struct defined in addi-data/addi_common.h is very bloated
> and contains many fields which addi_apci_1564 does not require.  In the
> interest of eventually removing this driver's dependency on
> addi_common.h, we can create a private data struct specifically for
> addi_apci_1564 containing only the fields it will actually use.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 164 +++++++++++----------
>  drivers/staging/comedi/drivers/addi_apci_1564.c    |  34 ++---
>  2 files changed, 102 insertions(+), 96 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> index f974bd2..054e731 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> @@ -49,7 +49,7 @@
>  #define APCI1564_COUNTER4				3
>  
>  /*
> - * devpriv->i_IobaseAmcc Register Map
> + * devpriv->amcc_iobase Register Map
>   */
>  #define APCI1564_DI_REG					0x04
>  #define APCI1564_DI_INT_MODE1_REG			0x08
> @@ -93,6 +93,12 @@
>  static unsigned int ui_InterruptStatus_1564;
>  static unsigned int ui_InterruptData, ui_Type;

These static variables could also go into the new private data struct.
But, hopefully you will be removing them eventually anyway.

>  
> +struct apci1564_private {
> +	unsigned int amcc_iobase;	/* base of AMCC I/O registers */
> +	unsigned char timer_select_mode;
> +	unsigned char mode_select_register;
> +};
> +

The new private data struct should really be defined in the driver (addi_apci_1564.c)
before the include of hwdrv_apci1564.c . Then you don't have to move it later.

Other than that:

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

