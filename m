Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaKLA7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 19:59:19 -0500
Received: from mailout.micron.com ([137.201.242.129]:58444 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaKLA7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 19:59:17 -0500
From: bpqw <bpqw@micron.com>
To: Graham Moore <grmoore@opensource.altera.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>, bpqw <bpqw@micron.com>
Subject: RE: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Topic: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Index: AQHP+W8IEF9rxWxnKkG/zeWVIWCG6Zxb9qNUgAA3tsA=
Date: Wed, 12 Nov 2014 00:58:31 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315EB0DA@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
 <201409251211.57183.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
 <201409261046.07132.marex@denx.de>
 <A765B125120D1346A63912DDE6D8B6315EA24E@NTXXIAMBX02.xacn.micron.com>
 <54613259.4070903@opensource.altera.com>
 <alpine.DEB.2.02.1411111336010.1356@lava-test-server>
In-Reply-To: <alpine.DEB.2.02.1411111336010.1356@lava-test-server>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21094.003
x-tm-as-result: No--37.430400-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Hi, I'm having trouble with this patch using a Cadence QSPI controller and Micron n25q00 part.

>I can use quad commands in Extended SPI mode, but I can't make this EVCR Quad mode work.


Yes,but if you use quad commands in Extended spi mode,only for Quad commands,the command line is DQ0,
Address/data line is DQ0,DQ1,DQ2 and DQ3(1-x-4). 
But if in Quad I/O mode,for all the commands,the command/address/data line will be 4,they are DQ0,DQ1,DQ2 and DQ3(4-x-4).

>The Cadence QSPI Controller has fields to configure the quad transfer, and can support quad opcode, 
>quad address, and quad data, or some combination.  There is a chart in the docs which shows the combinations for various read commands.

>Problem is, I've tried all of the combinations and all I get is FF with this EVCR patch.

This maybe your spi controller is still extended mode, 
Once EVCR bit 7 is set to 0, the spi nor device will operate in quad I/O.Command-address-data line is 4-x-4.
So after send WRITE EVCR command , spi controller also  must transfer to quad I/O Mode,and set its Command-address-data line also
Should be 4-x-4 .

>If I don't set the quad mode in the EVCR, then I can use quad read commands no problem.
Yes,you don't set the quad mode in the EVCR,you can use quad read commands,but this patch is for enable Micron SPI nor Quad I/O mode,
If you want to enable it ,you must set EVCR.

>Bottom line, with the Cadence QSPI controller, if I use quad commands in Extended SPI mode, then all good.  If I use this EVCR quad mode, then all bad.

>Anybody else have a Cadence QSPI controller and using EVCR quad mode successfully?

>Thanks,
>Graham Moore

Hi,Brian

Whether this patch can be merged?thanks.
