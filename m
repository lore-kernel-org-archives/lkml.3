Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbaBJMkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:40:22 -0500
Received: from mx0.aculab.com ([213.249.233.131]:57842 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752569AbaBJMkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:40:18 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Oliver Neukum'" <oliver@neukum.org>, Emil Goode <emilgoode@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, Ming Lei <ming.lei@canonical.com>,
        Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2 v2] usbnet: fix bad header length bug
Thread-Topic: [PATCH 1/2 v2] usbnet: fix bad header length bug
Thread-Index: AQHPJlqkw0kHlid8F0OrAYQNEJXNB5qua8oA
Date: Mon, 10 Feb 2014 12:39:07 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6BBDD0@AcuExch.aculab.com>
References: <1391987174-21828-1-git-send-email-emilgoode@gmail.com>
	 <1392014458.21271.6.camel@linux-fkkt.site> <20140210115812.GA4278@lianli>
 <1392034947.2082.30.camel@linux-fkkt.site>
In-Reply-To: <1392034947.2082.30.camel@linux-fkkt.site>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1ACeTR1029935

From: Oliver Neukum
> <censored>. Oh well. But how about merging it with FLAG_MULTI_PACKET?
> I really don't want to add more flags. There is a point where enough
> flags make absurd having a common code. We are closing in on that point.

Any sub-driver that supports multi-packet either has to use stupidly
long URB and/or set the rx_urb_size to a multiple of the usb transfer
size.

It will also have to detect illegal short headers.

Actually it might be worth double-checking the encapsulations used.
IIRC the ax88179_178a uses different headers for tx and rx.
So there might be some that support multi-packet but still have
a short(ish) limit on the bulk receive size (before the short fragment).

I'm sat at the wrong desk to look at the code...

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
