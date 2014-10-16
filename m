Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaJPImw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:42:52 -0400
Received: from mailout.micron.com ([137.201.242.129]:26754 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaJPImr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:42:47 -0400
From: bpqw <bpqw@micron.com>
To: Rafal Milecki <zajec5@gmail.com>
CC: Brian Norris <computersforpeace@gmail.com>, Marek Vasut <marex@denx.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
Subject: RE: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
Thread-Topic: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
Thread-Index: AQHP6Rj7oWZwUNDmiUaIxe5rb6fQoJwyZjXw
Date: Thu, 16 Oct 2014 08:41:54 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315E6FE5@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
	<CACna6rw4g1wWPv+VgL8WeA9rz-j8A6k+4bN7D=MQ9OU-BinToA@mail.gmail.com>
	<A765B125120D1346A63912DDE6D8B6315E6F6F@NTXXIAMBX02.xacn.micron.com>
 <CACna6rxNbPzSYbe9GjQCSAeB8FgVi6ZpgKo=AB=6nYc4QcqN1g@mail.gmail.com>
In-Reply-To: <CACna6rxNbPzSYbe9GjQCSAeB8FgVi6ZpgKo=AB=6nYc4QcqN1g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21030.000
X-TM-AS-Result: No--0.514600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9G8guxA004072


>I really wasn't looking into details yet and I'm aware my patch does something else. I just say we should first fix the regression and then base next patches on top of that regression fix. I'm not NACKing your changes :)

I will take into account for your patch,and will cover all these isse in my next version patch.

By the way ,I still don't understand why you specify id NULL in you patch:

+	if (id) {
+		info = (void *)id->driver_data;
+		if (info->jedec_id) {
+			dev_warn(dev,
+				 "passed SPI device ID (%s) contains JEDEC, ignoring it, driver should be fixed!\n",
+				 id->name);
+			id = NULL;
 		}
 	}
 
+	if (!id) {
+		id = nor->read_id(nor);
+		if (IS_ERR(id))
+			return PTR_ERR(id);
+	}
+	info = (void *)id->driver_data;
+
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
