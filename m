Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab3HGIpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:45:17 -0400
Received: from f434.i.mail.ru ([185.5.136.105]:47672 "EHLO f434.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab3HGIpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:45:12 -0400
X-Greylist: delayed 4662 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Aug 2013 04:45:12 EDT
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
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzJdIGh3bW9uOiAobG05MCkgQWRkIHBvd2VyIGNvbnRy?=
 =?UTF-8?B?b2w=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Wed, 07 Aug 2013 12:45:05 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1375865105.562600640@f434.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
In-Reply-To: <52020047.1080705@nvidia.com>
References: <1375858358-15070-1-git-send-email-wni@nvidia.com>
 <5201FC2C.4030908@roeck-us.net>
 <52020047.1080705@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r778jPDb024956

> On 08/07/2013 03:50 PM, Guenter Roeck wrote:
> > On 08/07/2013 12:32 AM, Wei Ni wrote:
> >> On 08/07/2013 03:27 PM, Alexander Shiyan wrote:
> >>>> The device lm90 can be controlled by the vdd rail.
> >>>> Adding the power control support to power on/off the vdd rail.
> >>>> And make sure that power is enabled before accessing the device.
> >>>>
> >>>> Signed-off-by: Wei Ni <wni@nvidia.com>
> >>>> ---
> >>>>   drivers/hwmon/lm90.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >>> [...]
> >>>> +	if (!data->lm90_reg) {
> >>>> +		data->lm90_reg = regulator_get(&client->dev, "vdd");
> >>>> +		if (IS_ERR_OR_NULL(data->lm90_reg)) {
> >>>> +			if (PTR_ERR(data->lm90_reg) == -ENODEV)
> >>>> +				dev_info(&client->dev,
> >>>> +					 "No regulator found for vdd. Assuming vdd is always powered.");
> >>>> +			else
> >>>> +				dev_warn(&client->dev,
> >>>> +					 "Error [%ld] in getting the regulator handle for vdd.\n",
> >>>> +					 PTR_ERR(data->lm90_reg));
> >>>> +			data->lm90_reg = NULL;
> >>>> +			mutex_unlock(&data->update_lock);
> >>>> +			return -ENODEV;
> >>>> +		}
> >>>> +	}
> >>>> +	if (is_enable) {
> >>>> +		ret = regulator_enable(data->lm90_reg);
> >>>> +		msleep(POWER_ON_DELAY);
> >>>
> >>> Can this delay be handled directly from regulator?
> >>
> >> I think it should be handled in the device driver.
> >> Because there have different delay time to wait devices stable.
> >>
> > 
> > Then why does no other caller of regulator_enable() need this ?
> > I don't think lm90 is so much different to other users of regulator
> > functionality.
> 
> May be I'm wrong. I noticed that in lm90 SPEC, the max of "SMBus Clock
> Low Time" is 25ms, so I supposed that it may need about 20ms to stable
> after power on.
> 
> Anyway, if I remove this delay, the driver also works fine, so I will
> remove it in my next patch.

I originally had in mind that regulator API contain own delay option.
E.g. reg-fixed-voltage && gpio-regulator contains "startup-delay-us" property.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
