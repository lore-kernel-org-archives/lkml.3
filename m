Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3LBKfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:35:44 -0500
Received: from fallback4.mail.ru ([94.100.176.42]:52239 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3LBKfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:35:43 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?UGhpbGlwcGUgUsOpdG9ybmF6?= <philippe.retornaz@gmail.com>
Cc: =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FzY2hhIEhhdWVy?= <kernel@pengutronix.de>,
        =?UTF-8?B?U2hhd24gR3Vv?= <shawn.guo@linaro.org>,
        =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBSRVNFTkRdIG1mZDogbWMxM3h4eDogUmVtb3ZlIHVubmVl?=
 =?UTF-8?B?ZGVkIG1jMTN4eHhfbG9jay91bmxvY2s=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Mon, 02 Dec 2013 14:33:29 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1385980409.843563145@f327.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <529C5804.2020501@gmail.com>
References: <1385787681-7736-1-git-send-email-shc_work@mail.ru>
 <529C5804.2020501@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB2AZmrg012110

Hello.

> Le 30/11/2013 06:01, Alexander Shiyan a Ã©crit :
> > Locking is performed by regmap API so no additional locking is
> > needed. Nevertheless, keep locking in the ADC conversion routine.
> > This need for keep proper read ADC sequence when calling from adc &
> > touchscreen drivers.
> 
> You can't do that so easily !
> Regmap only protect against concurrent access to the SPI/I2C bus, but do
> not protect the driver's internal data.
> And it does not protect against a race between concurrent access at a
> higher level :
...
> It's OK to do this if you are protected by a mutex, but as soon as you
> remove it you will have concurrency between two irq_unmask/irq_mask.

irq_unmask/irq_mask and some other functions can be converted to use
mc13xxx_reg_rmw. So I'll make a patch for this first.
Thanks.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
