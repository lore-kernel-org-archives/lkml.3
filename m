Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab3BSJ6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:58:46 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:51690 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851Ab3BSJ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:58:44 -0500
MIME-Version: 1.0
In-Reply-To: <1361264161.333682302@f131.mail.ru>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru>
	<1361257381.497560655@f376.mail.ru>
	<1361264161.333682302@f131.mail.ru>
Date: Tue, 19 Feb 2013 17:58:43 +0800
Message-ID: <CAP1dx+ybgio3y-BURHLa1BnCMAABoZXrrMm5CUf5CEGtBk6=Kw@mail.gmail.com>
Subject: Re: Re[4]: [PATCH v3] mfd: syscon: Add non-DT support
From: Dong Aisheng <dong.aisheng@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 February 2013 16:56, Alexander Shiyan <shc_work@mail.ru> wrote:
> ...
>> >> >>  struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
>> >> >>  {
>> >> >>       struct device_node *syscon_np;
>> >> >>       struct regmap *regmap;
>> >> >> +     struct syscon *syscon;
>> >> >> +     struct device *dev;
>> >> >>
>> >> >>       syscon_np = of_find_compatible_node(NULL, NULL, s);
>> >> >> -     if (!syscon_np)
>> >> >> +     if (syscon_np) {
>> >> >> +             regmap = syscon_node_to_regmap(syscon_np);
>> >> >> +             of_node_put(syscon_np);
>> >> >> +
>> >> >> +             return regmap;
>> >> >> +     }
>> >> >> +
>> >> >> +     /* Fallback to search by id_entry.name string */
>> >> >> +     dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
>> >> >> +                              syscon_match_id);
>> >> >> +     if (!dev)
>> >> >>               return ERR_PTR(-ENODEV);
>> >> >>
>> >> >> -     regmap = syscon_node_to_regmap(syscon_np);
>> >> >> -     of_node_put(syscon_np);
>> >> >> +     syscon = dev_get_drvdata(dev);
>> >> >>
>> >> >> -     return regmap;
>> >> >> +     return syscon->regmap;
>> >> >>  }
>> >> >>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
>> >> >
>> >> > Since you are not actually comparing the "compatible" property here,
>> >> > I would suggest adding another function here,
>> >>
>> >> Yes, i also think like that.
>> >
>> > In this case we should provide two paths for drivers which can work as with DT
>> > and without DT.
>>
>> Yes.
>
> I still think the universal procedure is better for the driver.
>

Why?
I did not see your reply on my other comments on the problems of using universal
procedure?
Please let me know if you think they're not issues.

>> > In my case we can use platform_device_id.name field with
>> > "compatible" string. My way in this case is transparency for driver which is
>> > using "syscon".
>> >
>>
>> Yes, but it also brings misleading and mass.
>> And i wonder even the API can cover the two type of matches, the
>> caller still can't use
>> the only one name for two cases since the name is different.
>> So it looks to me not make too much sense to provide only one API.
>
> The previous version of the patch keep conformity to the name of
> procedure ("compatible" field in platform_data)...
>
> So, now I'm totally confused what we do with the search function.
>

You can do as you currently do but with a different API for non-dt.

Regards
Dong Aisheng
