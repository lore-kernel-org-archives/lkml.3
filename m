Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab3BSI4H (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 19 Feb 2013 03:56:07 -0500
Received: from f131.mail.ru ([94.100.178.192]:46214 "EHLO f131.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435Ab3BSI4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:56:06 -0500
X-Greylist: delayed 65798 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2013 03:56:06 EST
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>
Cc: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?B?UmVbNF06IFtQQVRDSCB2M10gbWZkOiBzeXNjb246IEFkZCBub24tRFQgc3Vw?=
 =?UTF-8?B?cG9ydA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Tue, 19 Feb 2013 12:56:01 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1361264161.333682302@f131.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <1361257381.497560655@f376.mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id r1J8uF5t020027

...
> >> >>  struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
> >> >>  {
> >> >>       struct device_node *syscon_np;
> >> >>       struct regmap *regmap;
> >> >> +     struct syscon *syscon;
> >> >> +     struct device *dev;
> >> >>
> >> >>       syscon_np = of_find_compatible_node(NULL, NULL, s);
> >> >> -     if (!syscon_np)
> >> >> +     if (syscon_np) {
> >> >> +             regmap = syscon_node_to_regmap(syscon_np);
> >> >> +             of_node_put(syscon_np);
> >> >> +
> >> >> +             return regmap;
> >> >> +     }
> >> >> +
> >> >> +     /* Fallback to search by id_entry.name string */
> >> >> +     dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> >> >> +                              syscon_match_id);
> >> >> +     if (!dev)
> >> >>               return ERR_PTR(-ENODEV);
> >> >>
> >> >> -     regmap = syscon_node_to_regmap(syscon_np);
> >> >> -     of_node_put(syscon_np);
> >> >> +     syscon = dev_get_drvdata(dev);
> >> >>
> >> >> -     return regmap;
> >> >> +     return syscon->regmap;
> >> >>  }
> >> >>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
> >> >
> >> > Since you are not actually comparing the "compatible" property here,
> >> > I would suggest adding another function here,
> >>
> >> Yes, i also think like that.
> >
> > In this case we should provide two paths for drivers which can work as with DT
> > and without DT.
> 
> Yes.

I still think the universal procedure is better for the driver.

> > In my case we can use platform_device_id.name field with
> > "compatible" string. My way in this case is transparency for driver which is
> > using "syscon".
> >
> 
> Yes, but it also brings misleading and mass.
> And i wonder even the API can cover the two type of matches, the
> caller still can't use
> the only one name for two cases since the name is different.
> So it looks to me not make too much sense to provide only one API.

The previous version of the patch keep conformity to the name of
procedure ("compatible" field in platform_data)...

So, now I'm totally confused what we do with the search function.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
