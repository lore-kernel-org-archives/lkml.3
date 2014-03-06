Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaCFRYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:24:36 -0500
Received: from p3plex2out03.prod.phx3.secureserver.net ([184.168.131.16]:44083
	"EHLO p3plex2out03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbaCFRYe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:24:34 -0500
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/5] Staging: comedi: addi-data: tidy up digital input
 register map defines in hwdrv_apci1564.c
Thread-Topic: [PATCH 1/5] Staging: comedi: addi-data: tidy up digital input
 register map defines in hwdrv_apci1564.c
Thread-Index: AQHPOQ0v1RnzFX99Yk6taZQqNnEgj5rUTg7Q
Date: Thu, 6 Mar 2014 17:24:33 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825DA424F@P3PWEX4MB008.ex4.secureserver.net>
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com>
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

On Thursday, March 06, 2014 12:25 AM, Chase Southwood wrote:
> This patch for hwdrv_apci1564.c fixes the register map defines for the
> digital input registers such that they are all the real offsets to each
> register, rather than a mix of real offsets and adders to those offsets.
> Additionally, the defines have been renamed to assist with shortening
> some lines in excess of 80 characters.
>
> Further, some of the old defines were being used incorrectly in the
> i_APCI1564_Reset() function.  Upon swapping the old defines out for the
> new ones in this function, their use has been corrected.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---

Chase,

Looks good. I have a couple minor nitpicks...

The commit message above is a bit wordy. We already know it's a patch for
hwdrv_apci1564.c from the $SUBJECT.

> .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 78 +++++++++-------------
>  1 file changed, 31 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> index 2b47fa1..d178a3b 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> @@ -47,11 +47,6 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
>  #define APCI1564_ADDRESS_RANGE				128
>  
>  /* DIGITAL INPUT-OUTPUT DEFINE */
> -/* Input defines */
> -#define APCI1564_DIGITAL_IP				0x04
> -#define APCI1564_DIGITAL_IP_INTERRUPT_MODE1		4
> -#define APCI1564_DIGITAL_IP_INTERRUPT_MODE2		8
> -#define APCI1564_DIGITAL_IP_IRQ				16
>  
>  /* Output defines */
>  #define APCI1564_DIGITAL_OP				0x18
> @@ -63,9 +58,6 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
>  #define ADDIDATA_OR					0
>  #define ADDIDATA_AND					1
>  
> -/* Digital Input Interrupt Status */
> -#define APCI1564_DIGITAL_IP_INTERRUPT_STATUS		12
> -
>  /* Digital Output Interrupt Status */
>  #define APCI1564_DIGITAL_OP_INTERRUPT_STATUS		8
>  
> @@ -99,6 +91,15 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
>  #define APCI1564_TCW_WARN_TIMEVAL			24
>  #define APCI1564_TCW_WARN_TIMEBASE			28
>  
> +/*
> + * devpriv->i_IobaseAmcc Register Map
> + */
> +#define APCI1564_DI_REG				0x04
> +#define APCI1564_DI_INT_MODE1_REG			0x08
> +#define APCI1564_DI_INT_MODE2_REG			0x0c
> +#define APCI1564_DI_INT_STATUS_REG			0x10
> +#define APCI1564_DI_IRQ_REG				0x14

Please align the values.

Thanks,
Hartley

