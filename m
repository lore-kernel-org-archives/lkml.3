Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaGCIlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:41:35 -0400
Received: from mx0.aculab.com ([213.249.233.131]:60840 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751031AbaGCIlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:41:32 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Stefan Klug'" <stefan.klug@baslerweb.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][RFC] USB: zerocopy support for usbfs
Thread-Topic: [PATCH][RFC] USB: zerocopy support for usbfs
Thread-Index: AQHPlpMFL9uP+IUGEEyniU1IREIvbZuOBe9A
Date: Thu, 3 Jul 2014 08:40:21 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1726BEF0@AcuExch.aculab.com>
References: <Pine.LNX.4.44L0.1407021355060.874-100000@iolanthe.rowland.org>
 <53B50AB7.2090709@baslerweb.com>
In-Reply-To: <53B50AB7.2090709@baslerweb.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s638fjQj005744

From: Stefan Klug
...
> Is there any way to check if the host controller supports arbitrary
> alignment?
> If I read the xhci spec correctly arbitrary alignment is explicitly
> permitted.

Not entirely.
The xhci spec has a few limits on the alignment of transfer buffer.
They seem to be designed to make life difficult for the kernel!
1) Transfer buffers cannot be longer than 64k.
2) Transfer buffers cannot cross 64k address boundaries.
3) The end of a ring segment must occur on a USB packet boundary.

The current xhci driver doesn't implement check 3 - which causes
certain devices to fail (notable the ax88179_178a usb3 ethernet).

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
