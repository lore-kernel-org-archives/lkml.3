Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaJPICG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:02:06 -0400
Received: from mailout.micron.com ([137.201.242.129]:15146 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaJPICC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:02:02 -0400
From: =?utf-8?B?QmVhbiBIdW8g6ZyN5paM5paMIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
To: Rafal Milecki <zajec5@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
Subject: RE: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
Thread-Topic: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
Thread-Index: AQHP6ROhG57jwc2EF0C6Q8aiR7XicZwyWLkw
Date: Thu, 16 Oct 2014 08:00:51 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315E6F6F@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
 <CACna6rw4g1wWPv+VgL8WeA9rz-j8A6k+4bN7D=MQ9OU-BinToA@mail.gmail.com>
In-Reply-To: <CACna6rw4g1wWPv+VgL8WeA9rz-j8A6k+4bN7D=MQ9OU-BinToA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21028.001
x-tm-as-result: No--41.228900-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9G82DVo003867

>There are a lot of changes happening/requested around this code. I also proposed some patch touching this code, see https://patchwork.ozlabs.org/patch/377917/

>Right now there is a slow ongoing work on fixing some m25p80 regression, which also may touch the code you change. So I'll suggest postponing this patch until we get a regression fixed and then work on this hacky code again.


Thanks for your concerns.But for the same deivce id with the different extended id and
the same device name with the different device id issue, in your patch,this doesn't take
into account. I have encountered this situation. for example:


first condition (for the same deivce id with the different extended id):

	{ "n25q064",     INFO(0x20ba17, 0, 64 * 1024,  128, 0) },
	{ "n25ml064",    INFO(0x20ba17, 0x1234, 64 * 1024,  256, 0) },//right device data
	{ "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024,  256, 0) },
	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K) },
	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K) },

second condition(the same device id with the different device name):

 	{ "n25tl28",     INFO(0x20ba17, 0, 64 * 1024,  128, 0) },
	{ "n25ml028",     INFO(0x20ba17, 0, 64 * 1024,  256, 0) },//right device data
	{ "n25q128a13",  INFO(0x20ba18, 0, 64 * 1024,  256, 0) },
	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K) },
	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K) },
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
