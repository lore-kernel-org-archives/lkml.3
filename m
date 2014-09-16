Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaIPIm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:42:58 -0400
Received: from mx0.aculab.com ([213.249.233.131]:42825 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752169AbaIPImz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:42:55 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Rickard Strandqvist'" <rickard_strandqvist@spectrumdigital.se>
CC: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Stephane Grosjean" <s.grosjean@peak-system.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Christopher R. Baker" <cbaker@rec.ri.cmu.edu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: can: usb: peak_usb: pcan_usb_core.c: Cleaning up
 missing null-terminate in conjunction with strncpy
Thread-Topic: [PATCH] net: can: usb: peak_usb: pcan_usb_core.c: Cleaning up
 missing null-terminate in conjunction with strncpy
Thread-Index: AQHP0S56zQu5zQn7kU2S3rLDe5otg5wDcIdw
Date: Tue, 16 Sep 2014 08:40:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17493206@AcuExch.aculab.com>
References: <1410715898-15904-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <063D6719AE5E284EB5DD2968C1650D6D17491F2B@AcuExch.aculab.com>
 <5416A65D.6010500@pengutronix.de>
 <063D6719AE5E284EB5DD2968C1650D6D17491F83@AcuExch.aculab.com>
 <CAFo99gb9Rqnc7HrPbN7UVyQwPv_a=fxAbe+FTtm+9GgsjG7StA@mail.gmail.com>
In-Reply-To: <CAFo99gb9Rqnc7HrPbN7UVyQwPv_a=fxAbe+FTtm+9GgsjG7StA@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8G8h5lq026070

From: Rickard Strandqvist 
> > 2014-09-15 10:47 GMT+02:00 David Laight <David.Laight@aculab.com>:
...
> > Or:
> >     char name[sizeof netdev->name];
> >     memcpy(name, netdev->name, sizeof netdev->name);
> >
...
> I liked the variant:
> char name[sizeof(netdev->name)];
> 
> But dislike and do not understand what the point would be with memcpy variant.

The memcpy() will be a lot faster than any of the string copy functions
because it doesn't need to worry about the terminator.
In many cases it will be inlined to a short series of load and stores.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
