Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3BROjy (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 18 Feb 2013 09:39:54 -0500
Received: from fallback8.mail.ru ([94.100.176.136]:50727 "EHLO
	fallback8.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3BROjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 09:39:53 -0500
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>
Cc: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <b29396@freescale.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbNl06IFtQQVRDSF0gbWZkOiBzeXNjb246IEFkZGVkIHN1cHBvcnQgZm9y?=
 =?UTF-8?B?IHVzaW5nIHBsYXRmb3JtIGRyaXZlciByZXNvdXJjZXM=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Mon, 18 Feb 2013 18:39:24 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361198364.496836323@f245.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
References: <1359990040-5339-1-git-send-email-shc_work@mail.ru> <1360252328.221651004@f364.mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id r1IEe0Pq024029

Hello.

...
> >> >> Thanks for the patch adding non-dt support. :-)
> >> >>
> >> >> On Mon, Feb 04, 2013 at 07:00:40PM +0400, Alexander Shiyan wrote:
> >> >> > This patch adds support usage platform driver resources, i.e.
> >> >> > possibility works without oftree support. Additionally patch
> >> >> > removes CONFIG_OF dependency and adds helper for accessing
> >> >> > regmap by searching device by its name.
> >> > ...
> >> >> > +static int syscon_match_name(struct device *dev, void *data)
> >> >> > +{
> >> >> > +   return !strcmp(dev_name(dev), (const char *)data);
> >> >> > +}
> >> >> > +
> >> >> > +struct regmap *syscon_regmap_lookup_by_name(const char *name)
> >> >> > +{
> >> >> > +   struct syscon *syscon;
> >> >> > +   struct device *dev;
> >> >> > +
> >> >> > +   dev = driver_find_device(&syscon_driver.driver, NULL, (void *)name,
> >> >> > +                            syscon_match_name);
> >> >> > +   if (!dev)
> >> >> > +           return ERR_PTR(-EPROBE_DEFER);
> >> >> > +
> >> >> > +   syscon = dev_get_drvdata(dev);
> >> >> > +
> >> >> > +   return syscon->regmap;
> >> >> > +}
> >> >> > +
> >> >>
> >> >> How about syscon_dev_to_regmap(struct device *dev) as the exist dt version
> >> >> syscon_node_to_regmap since it's not affected by the name change of devices?
> >> >
> >> > I am not completely understand what you mean. In my version which doing
> >> > search regmap by name, we can call this function with desired device name,
> >> > then use regmap:
> >> > struct regmap *r = syscon_regmap_lookup_by_name("syscon.1");
> >> >
> >>
> >> My concern is that this API may be used by other client drivers, if we hardcode
> >> the device name in those drivers, once the device name is changed,
> >> all those drivers need change too.
> >> For dt case, we use device node to find regmap, so does not care about the name.
> >>
> >> > You suggest use "struct device" as parameter?
> >>
> >> A device pointer.
> >>
> >> > I do not know what we should
> >> > use as parameter to the function in this case, since we can get "struct device"
> >> > only when register this device,
> >>
> >> If we have a platform_device, then we have its device pointer, right?
> >>
> >> > i.e. in board support code, not from anywhere,
> >> > for example from another driver.
> >> > Fixme please.
> >> >
> >> My understanding is that in board support code, we can have the
> >> platform device instance
> >> of that syscon compatible device, then we can use it as the platform
> >> data parameter for those devices driver who wants to use it.
> >> Then in client driver, it can call:
> >> syscon_dev_to_regmap(syscon_compatible_dev)
> >> to find the regmap.
> >> Just like dt working way, the device node usually uses a phandle pointing to
> >> the syscon compatible node which it wants to use.
> >
> > This is not as easy as it seems.
> > All devices that will use "syscon" driver, in this case should have a platform_data
> > record.
> 
> Yes, that's the same way as the dt version does.
> 
> > I think that it can create problems with using these drivers as modules.
> 
> What problems do you think?

I've changed my opinion ;)

> > Alternatively, we can create additional (virtual) "compatible" text property in syscon
> > private data structure and use it to find the proper device. What is your opinion?
> >
> 
> Hmm, i can't see why we need that.
> IMO, for non-dt, we can just use platform_device_id to match devices.

Unfortunately platform_device_id.name field have a length limitation. But, of course,
this is a other theme for discussion. So, I'll send new version of patch.
Thanks!

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
