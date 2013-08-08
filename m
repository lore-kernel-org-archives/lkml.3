Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816Ab3HHKBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:01:04 -0400
Received: from fallback4.mail.ru ([94.100.176.42]:53448 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934087Ab3HHKBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:01:02 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?V2VpIE5p?= <wni@nvidia.com>
Cc: =?UTF-8?B?R3VlbnRlciBSb2Vjaw==?= <linux@roeck-us.net>,
        =?UTF-8?B?c3dhcnJlbkB3d3dkb3Rvcmcub3Jn?= <swarren@wwwdotorg.org>,
        =?UTF-8?B?bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw==?= 
	<linux-kernel@vger.kernel.org>,
        =?UTF-8?B?bG0tc2Vuc29yc0BsbS1zZW5zb3JzLm9yZw==?= 
	<lm-sensors@lm-sensors.org>,
        =?UTF-8?B?bGludXgtdGVncmFAdmdlci5rZXJuZWwub3Jn?= 
	<linux-tegra@vger.kernel.org>,
        =?UTF-8?B?TWF0dGhldyBMb25nbmVja2Vy?= <MLongnecker@nvidia.com>,
        =?UTF-8?B?a2hhbGlAbGludXgtZnIub3Jn?= <khali@linux-fr.org>,
        =?UTF-8?B?bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3Jn?= 
	<linux-arm-kernel@lists.infradead.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MiAxLzNdIGh3bW9uOiAobG05MCkgQWRkIHBvd2VyIGNv?=
 =?UTF-8?B?bnRyb2w=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Thu, 08 Aug 2013 13:57:14 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1375955834.368114617@f197.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
In-Reply-To: <52036920.4050808@nvidia.com>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <520359E9.1000600@roeck-us.net>
 <52036920.4050808@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r78A19Ok000573

> On 08/08/2013 04:42 PM, Guenter Roeck wrote:
> > On 08/07/2013 11:56 PM, Wei Ni wrote:
> >> The device lm90 can be controlled by the vdd rail.
> >> Adding the power control support to power on/off the vdd rail.
> >> And make sure that power is enabled before accessing the device.
> >>
> >> Signed-off-by: Wei Ni <wni@nvidia.com>
> >> ---
> >>   drivers/hwmon/lm90.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
[...]
> > I consider the messages unnecessary and confusing. You are polluting the log
> > of pretty much every PC user who has one of the supported chips in the system,
> > and of everyone else not using regulators for this chip.
> 
> Ok, I will remove these codes.
> So I will write something like:
> if (!IS_ERR(data->lm90_reg)) {
>     ret = regulator_enable(data->lm90_reg);
>     if (ret < 0) {
>         dev_err();
>         return ret;
>     }
> } else {
>     if (PTR_ERR(data->lm90_reg) == -EPROBE_DEFER)
>         return -EPRPBE_DEFER;
> 
>         data->lm90_reg = !!IS_ERR(data->lm90_reg);

No. You do not need this line.

Just use in remove():
if (!IS_ERR(data->lm90_reg))
regulator_disable(data->lm90_reg);

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
