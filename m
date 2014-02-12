Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaBLL2M (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 12 Feb 2014 06:28:12 -0500
Received: from fallback5.mail.ru ([94.100.176.59]:52211 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaBLL2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:28:10 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?UGF3ZWwgTW9sbA==?= <pawel.moll@arm.com>
Cc: =?UTF-8?B?TGVlIEpvbmVz?= <lee.jones@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3Jn?= 
	<linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw==?= 
	<linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAwNy8xMl0gbWZkOiBzeXNjb246IENvbnNpZGVyIHBsYXRm?=
 =?UTF-8?B?b3JtIGRhdGEgYSByZWdtYXAgY29uZmlnIG5hbWU=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Wed, 12 Feb 2014 15:27:40 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1392204460.1197803@f433.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <1392203209.3380.57.camel@hornet>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
 <20140212082657.GK15081@lee--X1>
 <1392203209.3380.57.camel@hornet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id s1CBSJwH031928

Ğ¡Ñ€ĞµĞ´Ğ°, 12 Ñ„ĞµĞ²Ñ€Ğ°Ğ»Ñ 2014, 11:06 UTC Ğ¾Ñ‚ Pawel Moll <pawel.moll@arm.com>:
> On Wed, 2014-02-12 at 08:26 +0000, Lee Jones wrote:
> > > > Use the device platform data as a regmap config
> > > > name. This is particularly useful in the regmap
> > > > debugfs when there is more than one syscon device
> > > > registered, to distinguish the register blocks.
> > > > 
> > > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > > Cc: Lee Jones <lee.jones@linaro.org>
> > > > Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> > > > ---
> > > ...
> > > > syscon_regmap_config.max_register = res->end - res->start - 3;
> > > > +	syscon_regmap_config.name = dev_get_platdata(&pdev->dev);
> > > 
> > > Is dev_name(&pdev->dev) can be used for such purpose?
> > 
> > Yes of course.
> > 
> > Either use the automatically generated name or over-ride with
> > dev->init_name prior to registration or call dev_set_name()
> > manually. Then retrieve with Alexander's suggestion.
> > 
> > Is there any technical reason why this is not possible with your
> > implementation?
> 
> Hold on, guys. Let me just point out that we're talking "non-DT"
> platform devices here (either statically defined struct
> platform_device-s or - my case - the MFD cells).
> 
> In this case device/driver matching relies completely on device name.
> Either the pdev->name must be identical (strcmp) to pdrv->name, or the
> pdev->name must be identical (strcmp again) to one of the pdev->id_table
> entries. See platform_match() in driver/base/platform.c for more
> details.
> 
> Therefore the dev_name(&pdev->dev) on a non-DT-originating sysconf
> devince will always return "sysconf.*", unless you're ready to maintain
> a growing syscon_ids[] list. If so, I will have to add three entries
> there ("sys_id", "sys_misc" and "sys_procid"). I hope you are not
> seriously considering this idea :-) After all that's what the
> platform_data was invented for.

Yeah, I gave up the idea to use the syscon_ids[] to separate devices for
non-DT case.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/mfd/syscon.c?id=5104d2656d4874c51868dc7182016e9501ec99ca
Instead, I use a hard definition for pdev->id, so that the names of
syscon-devices are different and can be obtained from the driver
it uses with syscon_regmap_lookup_by_pdevname().
I understand this topic correct?

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
