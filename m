Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaKLBUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:20:08 -0500
Received: from mailout.micron.com ([137.201.242.129]:12692 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaKLBUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:03 -0500
From: bpqw <bpqw@micron.com>
To: Jagan Teki <jagannadh.teki@gmail.com>,
        Graham Moore <grmoore@opensource.altera.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: bpqw <bpqw@micron.com>, Marek Vasut <marex@denx.de>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: RE: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Topic: [V5 PATCH 1/1] driver:mtd:spi-nor: Add quad I/O support for
 Micron spi nor
Thread-Index: AQHP+W8IEF9rxWxnKkG/zeWVIWCG6Zxb9qNUgACAWAD//729kA==
Date: Wed, 12 Nov 2014 01:19:18 +0000
Message-ID: <A765B125120D1346A63912DDE6D8B6315EB0E1@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315DCC46@NTXXIAMBX02.xacn.micron.com>
	<201409251211.57183.marex@denx.de>
	<A765B125120D1346A63912DDE6D8B6315DCDF1@NTXXIAMBX02.xacn.micron.com>
	<201409261046.07132.marex@denx.de>
	<A765B125120D1346A63912DDE6D8B6315EA24E@NTXXIAMBX02.xacn.micron.com>
	<54613259.4070903@opensource.altera.com>
	<alpine.DEB.2.02.1411111336010.1356@lava-test-server>
 <CAD6G_RQFV9LfBzVbureBiCneW+PpLzSdUCyz9L6D+EhE4gT+WA@mail.gmail.com>
In-Reply-To: <CAD6G_RQFV9LfBzVbureBiCneW+PpLzSdUCyz9L6D+EhE4gT+WA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21094.003
X-TM-AS-Result: No-1.154700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAC4Nv2q014660

>I have almost verified all the micros parts for operating quad mode and the quad enable bit is 
>volatile by default and no need to set it on software.

>Why this code is meant for - does micron has changed this bit operation on newly added parts?

>thanks!
>--
>Jagan.

For Micron Spi norflash,if you want to make it work Quad I/O mode,you can do it by set
Two registers,Nonvolatile Configuration resister(NVCR) and Enhanced volatile confuration register(EVCR),
but according to spi-nor.c,and micron spi nor,we recommend that if want to enable Micron spi nor Quad I/O
mode,the best way is to set EVCR.
Of course,you can use Quad/Dual operation command to read/write Micron spi nor in the spi nor Extended I/O mode.
But their command-address-data is different.

The purpose of this patch is only to enable Micron spi nor Quad I/O mode,if want to make Micron spi nor work 
Under Quad I/O mode.

Hi,Brian

How about this patch?Please give me some tips,thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
