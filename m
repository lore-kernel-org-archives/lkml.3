Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaKLICL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:02:11 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:55074 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaKLICJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:02:09 -0500
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Varka Bhadram <varkabhadram@gmail.com>,
        "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "mcuos.com@gmail.com" <mcuos.com@gmail.com>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mtd: remove .owner field for driver using
 module_platform_driver
Thread-Topic: [PATCH] mtd: remove .owner field for driver using
 module_platform_driver
Thread-Index: AQHP/Zodyga/nHJVJEWDI5Bq8B+tKZxbPFaAgAFmDYA=
Date: Wed, 12 Nov 2014 08:02:00 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE950E8C3F0@EU-MBX-02.mgc.mentorg.com>
References: <1415701649-25915-1-git-send-email-sanjeev_sharma@mentor.com>
 <5461E761.5090702@gmail.com>
In-Reply-To: <5461E761.5090702@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sanjeev Sharma,

On 11/11/2014 03:57 PM, Sanjeev Sharma wrote:
> This patch removes the .owner field for drivers which use the 
> platform_driver_register api because this is overriden in 
> _platform_driver_register.
>
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>   drivers/mtd/nand/ams-delta.c     | 1 -
>   drivers/mtd/nand/atmel_nand.c    | 2 --
>   drivers/mtd/nand/au1550nd.c      | 1 -
>   drivers/mtd/nand/bf5xx_nand.c    | 1 -
>   drivers/mtd/nand/davinci_nand.c  | 1 -
>   drivers/mtd/nand/denali_dt.c     | 1 -
>   drivers/mtd/nand/docg4.c         | 1 -
>   drivers/mtd/nand/fsl_elbc_nand.c | 1 -
>   drivers/mtd/nand/fsl_ifc_nand.c  | 1 -
>   drivers/mtd/nand/fsl_upm.c       | 1 -
>   drivers/mtd/nand/fsmc_nand.c     | 1 -
>   drivers/mtd/nand/gpio.c          | 1 -
>   drivers/mtd/nand/jz4740_nand.c   | 1 -
>   drivers/mtd/nand/lpc32xx_mlc.c   | 1 -
>   drivers/mtd/nand/lpc32xx_slc.c   | 1 -
>   drivers/mtd/nand/mpc5121_nfc.c   | 1 -
>   drivers/mtd/nand/mxc_nand.c      | 1 -
>   drivers/mtd/nand/ndfc.c          | 1 -
>   drivers/mtd/nand/nuc900_nand.c   | 1 -
>   drivers/mtd/nand/omap2.c         | 1 -
>   drivers/mtd/nand/omap_elm.c      | 1 -
>   drivers/mtd/nand/orion_nand.c    | 1 -
>   drivers/mtd/nand/pasemi_nand.c   | 1 -
>   drivers/mtd/nand/plat_nand.c     | 1 -
>   drivers/mtd/nand/s3c2410.c       | 1 -
>   drivers/mtd/nand/sh_flctl.c      | 1 -
>   drivers/mtd/nand/sharpsl.c       | 1 -
>   drivers/mtd/nand/socrates_nand.c | 1 -
>   drivers/mtd/nand/tmio_nand.c     | 1 -
>   drivers/mtd/nand/txx9ndfmc.c     | 1 -
>   30 files changed, 31 deletions(-)

This removal of .owner field should be done for all the platform drivers which are using module_platform_driver().

Wolfram Sang <wsa@the-dreams.de> working on this change on the all the drivers. Please see [1].


[1]:https://git.kernel.org/cgit/linux/kernel/git/wsa/linux.git/log/?h=platform/remove_owner

Thanks for the information and it surely make sense to take this up in all the subsystem.

Sanjeev 

--
Thanks and Regards,
Varka Bhadram.

