Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbaEAJdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:33:01 -0400
Received: from mx0.aculab.com ([213.249.233.131]:52739 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754273AbaEAJc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:32:59 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alexey Charkov'" <alchark@gmail.com>, Roger Luethi <rl@hellgate.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jan Moskyto Matejka" <mq@suse.cz>
Subject: RE: [PATCH] net: via-rhine: Fix compiler warning re: pointer
 casting on 64bit
Thread-Topic: [PATCH] net: via-rhine: Fix compiler warning re: pointer
 casting on 64bit
Thread-Index: AQHPZGx7cEiQwilsXEOcYzELSJTgfZsrdpMg
Date: Thu, 1 May 2014 09:30:58 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F703980@AcuExch.aculab.com>
References: <063D6719AE5E284EB5DD2968C1650D6D0F702D00@AcuExch.aculab.com>
 <1398859589-22346-1-git-send-email-alchark@gmail.com>
In-Reply-To: <1398859589-22346-1-git-send-email-alchark@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s419XBAW013278

From: Alexey Charkov [mailto:alchark@gmail.com]
...
> This patch removes the cast altogether, and instead stores an actual
> pointer to u8 in match->data. All instances of 'revision' are also
> unified to u8 instead of an assortment of different integer types,
> in line with the definition of 'revision' in struct pci_dev.
...
> +static u8 vt8500_revision = 0x84;
>  static struct of_device_id rhine_of_tbl[] = {
> -	{ .compatible = "via,vt8500-rhine", .data = (void *)0x84 },
> +	{ .compatible = "via,vt8500-rhine", .data = &vt8500_revision },
>  	{ }	/* terminate list */

Actually the above looks strange.
Why does the vt8500 have a revision number of 0x84 ?
Surely it should be 0x85, or even 0x8500 (or decimal 85000).

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
