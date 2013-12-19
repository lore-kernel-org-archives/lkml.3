Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab3LSQSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:18:03 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:62335 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3LSQSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:18:01 -0500
MIME-Version: 1.0
In-Reply-To: <1387310726.8859.5.camel@joe-AO722>
References: <CAOMwXhPPN2h2boAOn1=BaHuWa+9nYw=oe1u1bYHtHGyad9Kw8A@mail.gmail.com>
	<1387310726.8859.5.camel@joe-AO722>
Date: Thu, 19 Dec 2013 16:17:58 +0000
X-Google-Sender-Auth: HcE_XhXaUl4brC8xNvO3k2D2K0g
Message-ID: <CAOMwXhNVJ8HPCe6t=VkCthEiOqNtOczz5Xqy_ciM7rsqWRVOYw@mail.gmail.com>
Subject: Re: Lindent formatting issues
From: Laszlo Papp <lpapp@kde.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 8:05 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2013-12-17 at 15:06 +0000, Laszlo Papp wrote:
>> ./scripts/Lindent seems to be working OK, but there are a few minor
>> issues like this:
>>
>> static struct i2c_driver max6651_driver = {
>>         .driver = {
>> -               .name = "gpio-max6651",
>> -               .owner = THIS_MODULE,
>> -       },
>> +                  .name = "gpio-max6651",
>> +                  .owner = THIS_MODULE,
>> +                  },
>>
>> Is there an option or something to mkae it work automatically? I am
>> referring to the "}," line which should not have changed.
>
> Assuming that was a copy/paste translation of
> tabs to spaces, the first form is more common
> in kernel sources and Lindent isn't doing the
> right thing here.
>
> You could also use scripts/checkpatch.pl with
> the --fix option.
>
> ./scripts/checkpatch.pl -f --fix <file>
>
> with various --types=<TYPE,...> options.
>
> Maybe use: https://lkml.org/lkml/2013/9/23/504

Thanks Joe. I seem to have further issues with this tool... I tried to
run it on a file I patched, but it generated a lot of noise unrelated
to my logical change... :(

Do you happen to know what the best way is to fix it in such cases? I
am providing some examples below:

        if (devattr == &sensor_dev_attr_fan1_max_alarm.dev_attr
-        || devattr == &sensor_dev_attr_fan1_min_alarm.dev_attr
-        || devattr == &sensor_dev_attr_fan1_fault.dev_attr
-        || devattr == &sensor_dev_attr_gpio1_alarm.dev_attr
-        || devattr == &sensor_dev_attr_gpio2_alarm.dev_attr) {
+           || devattr == &sensor_dev_attr_fan1_min_alarm.dev_attr
+           || devattr == &sensor_dev_attr_fan1_fault.dev_attr
+           || devattr == &sensor_dev_attr_gpio1_alarm.dev_attr
+           || devattr == &sensor_dev_attr_gpio2_alarm.dev_attr) {

....


-                                   int n)
+                                    int n)

....

-       int sysfs_modes[4] = {0, 1, 2, 1};
+       int sysfs_modes[4] = { 0, 1, 2, 1 };

etc.
