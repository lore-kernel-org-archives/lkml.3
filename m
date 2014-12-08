Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaLHIv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:51:26 -0500
Received: from mailout.micron.com ([137.201.242.129]:40853 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaLHIvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:51:24 -0500
From: =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marex@denx.de>
CC: "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
Subject: RE: [V6 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Topic: [V6 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Index: AdAQWnqsiImr5KpARvijPY3FrXHl/QCZ7LrQ
Date: Mon, 8 Dec 2014 08:50:39 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315F03C4@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315EF2C5@NTXXIAMBX02.xacn.micron.com>
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315EF2C5@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21158.005
x-tm-as-result: No--34.490700-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.

>For Micron SPI NOR flash,enabling or disabling quad I/O protocol can be done By two methods, which are to 
>use EVCR(Enhanced Volatile Configuration Register) and the ENTER QUAD I/O MODE command.There is no 
>difference between these two methods.Unfortunately,for some Micron spi nor flashes,there no ENTER Quad 
>I/O command(35h),such as n25q064.But for all current Micron spi nor,if it support quad I/O mode,using 
>EVCR definitely be supported.It is a recommended method to enable Quad I/O mode by EVCR,Quad I/O protocol 
>bit 7.When EVCR bit 7 is reset to 0,the SPI NOR flash will operate in quad I/O mode.

>This patch has been tested on N25Q512A and MT25TL256BAA1ESF.Micron spi nor of spi_nor_ids[] table all 
>support this method.

>Signed-off-by: bean huo <beanhuo@micron.com>
>Acked-by: Marek Vasut <marex@denx.de>
>---
>v1-v2:
>	Modified to that capture wait_till_ready()
>	return value,if error,directly return its
>	the value.
 >v2-v3:
>	Directly use the reurning error value of
>	read_reg and write_reg,instead of -EINVAL.
> v3-v4:
>	Modify commit logs that wraped into 80 columns.
> v4-v5:
>	Rebuild new patch based on latest linux-mtd.
> v5-v6:
>	Rebuild patch based on latest l2-mtd.
>	add some comments.
>	Add SPI_NOR_QUAD_READ flag in the spi_nor_ids[] for Micron spi nor.

Hi,Brian

This patch is based on the latest l2-mtd,I don't know if can pass?
I have one question is that about following code.
I have added our Mciron quad flag into spi_nor_ids[] table,but line over 80 characters,
If I divided one line into two lines,this will make spi_nor_ids[] table look ugly.I also find that
There are other venders configure line that also over 80 characters,such as Spansion,Catalyst.
So I don't divide my following configure line into two two lines,I don't know if this can 
Be accepted?
 
+	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K | SPI_NOR_QUAD_READ) },
+	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
+	{ "n25q512ax3",  INFO(0x20ba20, 0, 64 * 1024, 1024, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
+	{ "n25q00",      INFO(0x20ba21, 0, 64 * 1024, 2048, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
 


