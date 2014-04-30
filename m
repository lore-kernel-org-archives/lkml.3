Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbaD3NMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:12:22 -0400
Received: from fallback7.mail.ru ([94.100.176.135]:55192 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552AbaD3NMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:12:21 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?SmFuIE1vc2t5dG8gTWF0ZWprYQ==?= <mq@suse.cz>
Cc: =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>,
        =?UTF-8?B?SmlyaSBTbGFieQ==?= <jslaby@suse.cz>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gW2xpbnV4LW5leHRdIHNlcmlhbDogc2MxNmlzN3h4OiBm?=
 =?UTF-8?B?aXggZGVmaW5lZC1idXQtbm90LXVzZWQgd2FybmluZ3M=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.0]
Date: Wed, 30 Apr 2014 17:10:03 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1398863403.902420096@f316.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1398863224-19900-1-git-send-email-mq@suse.cz>
References: <1398863224-19900-1-git-send-email-mq@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3UDCW3S007696

Wed, 30 Apr 2014 15:07:04 +0200 Ğ¾Ñ‚ Jan Moskyto Matejka <mq@suse.cz>:
> drivers/tty/serial/sc16is7xx.c:1060:12: warning: 'sc16is7xx_probe' defined but not used [-Wunused-function]
>  static int sc16is7xx_probe(struct device *dev,
>             ^
> drivers/tty/serial/sc16is7xx.c:1176:12: warning: 'sc16is7xx_remove' defined but not used [-Wunused-function]
>  static int sc16is7xx_remove(struct device *dev)
>             ^
> drivers/tty/serial/sc16is7xx.c:1215:29: warning: 'regcfg' defined but not used [-Wunused-variable]
>  static struct regmap_config regcfg = {
>                              ^
> 
> Fixed these warnings by #ifdef-ing them to CONFIG_REGMAP_I2C and
> recursively #ifdef-ing also some other functions that got defined but not used.
> 
> Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
> ---
>  drivers/tty/serial/sc16is7xx.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
> index 7206a64..bd76277 100644
> --- a/drivers/tty/serial/sc16is7xx.c
> +++ b/drivers/tty/serial/sc16is7xx.c
> @@ -389,6 +389,7 @@ static const struct sc16is7xx_devtype sc16is762_devtype = {
>  	.nr_uart	= 2,
>  };
>  
> +#ifdef CONFIG_REGMAP_I2C
>  static bool sc16is7xx_regmap_volatile(struct device *dev, unsigned int reg)

No. This is not a good way.
The Kconfig  should be patched for dependency of I2C.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
