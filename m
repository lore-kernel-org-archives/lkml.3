Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967227Ab3HIF5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 01:57:10 -0400
Received: from f416.i.mail.ru ([185.5.136.87]:52938 "EHLO f416.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966964Ab3HIF5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 01:57:08 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?R3VlbnRlciBSb2Vjaw==?= <linux@roeck-us.net>
Cc: =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@kernel.org>,
        =?UTF-8?B?V2VpIE5p?= <wni@nvidia.com>, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        khali@linux-fr.org, MLongnecker@nvidia.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?B?UHJvcG9zYWw6IEkyQyBkZXZpY2UgcG93ZXIgKFdhczogaHdtb246IChsbTkw?=
 =?UTF-8?B?KSBBZGQgcG93ZXIgY29udHJvbCk=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Fri, 09 Aug 2013 09:57:00 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1376027820.695103970@f416.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
In-Reply-To: <52040DE2.50201@roeck-us.net>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <20130808211825.GN6427@sirena.org.uk>
 <52040DE2.50201@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r795vF3d007938

Hi all.

Instead of adding the support of regulators in each device, let's think about
whether it is possible to create a global regulator for any device on the I2C bus.

I see it like this:
We add an extra field in the i2c_board_info structure "power_name" and handle
it in the i2c_device_{probe/remove} functions.

The question remains how to maintain such regulator in the PM functions,
but we can discuss it.

Changes like this, will remove existing regulators from drivers and allows to
use power regulator for any I2C device.
If such idea is good, such changes could be made to other devices (SPI, w1, etc.).
Thanks.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
