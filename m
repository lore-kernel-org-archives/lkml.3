Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaBEJwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:52:12 -0500
Received: from mx0.aculab.com ([213.249.233.131]:52792 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751263AbaBEJwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:52:08 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Florian Fainelli'" <f.fainelli@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
CC: netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: RE: [PATCH V3] net/dt: Add support for overriding phy configuration
 from device tree
Thread-Topic: [PATCH V3] net/dt: Add support for overriding phy
 configuration from device tree
Thread-Index: AQHPIelDRUwlifqcQkGj3dkq2Qtm7pqmakWw
Date: Wed, 5 Feb 2014 09:51:19 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6B8BCA@AcuExch.aculab.com>
References: <7510122.cayuQ6qt8r@wuerfel>
 <1389999459-9483-1-git-send-email-matthew.garrett@nebula.com>
 <CAGVrzcZ4TFd=9KP+aoG47QbmqDJ1i23WBcEWDbzNRUfGmPvZHQ@mail.gmail.com>
In-Reply-To: <CAGVrzcZ4TFd=9KP+aoG47QbmqDJ1i23WBcEWDbzNRUfGmPvZHQ@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s159qJ8Q028231

From: Florian Fainelli
> It would be good to explain exactly how your hardware is broken
> exactly. I really do not think that such a fine-grained setting where
> you could disable, e.g: 100BaseT_Full, but allow 100BaseT_Half to
> remain usable makes that much sense. In general, Gigabit might be
> badly broken, but 100 and 10Mbits/sec should work fine. How about the
> MASTER-SLAVE bit, is overriding it really required?

There are plenty of systems out there where you'd want to disable
either HDX or FDX modes.
The MAC unit has to know whether the PHY is in HDX or FDX in order
to work properly. Many do not need to know the speed - since the
PHY is responsible for the tx/rx fifo clock.
Getting the negotiated speed out of the PHY can be difficult, while
the ANAR can easily be set.
Unfortunately it is usually impossible to disable the 'fall-back'
10M HDX.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
