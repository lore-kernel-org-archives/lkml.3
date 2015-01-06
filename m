Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbbAFBnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 20:43:50 -0500
Received: from mailout.micron.com ([137.201.242.129]:50272 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbbAFBnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 20:43:49 -0500
From: =?iso-2022-jp?B?QmVhbiBIdW8gGyRCcDlJTElMGyhCIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: Brian Norris <computersforpeace@gmail.com>, Marek Vasut <marex@denx.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "shijie8@gmail.com" <shijie8@gmail.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [V7 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Topic: [V7 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Index: AdAZzBElKC1epLrrSeWLdcIaXccAHgPhSyVw
Date: Tue, 6 Jan 2015 01:42:58 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315FF32A@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21226.003
X-TM-AS-Result: No--8.343500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>This patch adds code which enables Quad I/O mode on Micron SPI NOR flashes.

>For Micron SPI NOR flash, enabling or disabling quad I/O protocol can be done By two methods, 
>which are to use EVCR(Enhanced Volatile Configuration Register) and the ENTER QUAD I/O MODE command.
>There is no difference between these two methods. Unfortunately, for some Micron spi nor flashes,
>there no ENTER Quad I/O command(35h),such as n25q064.But for all current Micron spi nor,
>if it support quad I/O mode, using EVCR definitely be supported. It is a recommended method to
>enable Quad I/O mode by EVCR, Quad I/O protocol bit 7.When EVCR bit 7 is reset to 0,the SPI NOR flash will operate in quad I/O mode.

>This patch has been tested on N25Q512A and MT25TL256BAA1ESF.Micron spi nor of spi_nor_ids[] table all support this method.

>Signed-off-by: bean huo <beanhuo@micron.com>
>Acked-by: Marek Vasut <marex@denx.de>
>---
>v1-v2:
>	Modified to that capture wait_till_ready()
>	return value,if error,directly return its
>	the value.
> v2-v3:
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
> V6-v7:
>	Fixed up val with u8 in micron_quad_enable().
	
hi,maintainer

how about this patch,it has been updated to V7.
Please give some suggestions or if  can be accepted?

Thanks.
