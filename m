Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3LSRaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:30:08 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:50635 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3LSRaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:30:03 -0500
MIME-Version: 1.0
In-Reply-To: <1387470731.2353.7.camel@joe-AO722>
References: <CAOMwXhPPN2h2boAOn1=BaHuWa+9nYw=oe1u1bYHtHGyad9Kw8A@mail.gmail.com>
	<1387310726.8859.5.camel@joe-AO722>
	<CAOMwXhNVJ8HPCe6t=VkCthEiOqNtOczz5Xqy_ciM7rsqWRVOYw@mail.gmail.com>
	<1387470731.2353.7.camel@joe-AO722>
Date: Thu, 19 Dec 2013 17:30:02 +0000
X-Google-Sender-Auth: DNTAYdV4r_fyLebYIaGBz8r9r6o
Message-ID: <CAOMwXhPceCtCRvD8i7VO=QOuDX=M0gQuERwTConkrF9ohPfs=g@mail.gmail.com>
Subject: Re: Lindent formatting issues
From: Laszlo Papp <lpapp@kde.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 4:32 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2013-12-19 at 16:17 +0000, Laszlo Papp wrote:
>> On Tue, Dec 17, 2013 at 8:05 PM, Joe Perches <joe@perches.com> wrote:
> []
>> > You could also use scripts/checkpatch.pl with
>> > the --fix option.
>> >
>> > ./scripts/checkpatch.pl -f --fix <file>
>> >
>> > with various --types=<TYPE,...> options.
>> >
>> > Maybe use: https://lkml.org/lkml/2013/9/23/504
>>
>> Thanks Joe. I seem to have further issues with this tool... I tried to
>> run it on a file I patched, but it generated a lot of noise unrelated
>> to my logical change... :(
>
> checkpatch is really for patches.  Using -f is a
> convenience ability.  You can limit what messages
> checkpatch emits by using "--types=<FOO[,BAR...]>"
>
> You can show what message classifications are being
> used by adding "--show-types".
>
>> Do you happen to know what the best way is to fix it in such cases? I
>> am providing some examples below:
>>
>>         if (devattr == &sensor_dev_attr_fan1_max_alarm.dev_attr
>> -        || devattr == &sensor_dev_attr_fan1_min_alarm.dev_attr
>> -        || devattr == &sensor_dev_attr_fan1_fault.dev_attr
>> -        || devattr == &sensor_dev_attr_gpio1_alarm.dev_attr
>> -        || devattr == &sensor_dev_attr_gpio2_alarm.dev_attr) {
>> +           || devattr == &sensor_dev_attr_fan1_min_alarm.dev_attr
>> +           || devattr == &sensor_dev_attr_fan1_fault.dev_attr
>> +           || devattr == &sensor_dev_attr_gpio1_alarm.dev_attr
>> +           || devattr == &sensor_dev_attr_gpio2_alarm.dev_attr) {
>
> Well, here the general kernel style is to put
> the logical && or || test at the end of the
> previous line so:
>
>         if (devattr == &sensor_dev_attr_fan1_max_alarm.dev_attr ||
>             devattr == &sensor_dev_attr_fan1_min_alarm.dev_attr ||
>             devattr == &sensor_dev_attr_fan1_fault.dev_attr ||
>             devattr == &sensor_dev_attr_gpio1_alarm.dev_attr ||
>             devattr == &sensor_dev_attr_gpio2_alarm.dev_attr) {
>
> would likely be preferred.
>
>> -                                   int n)
>> +                                    int n)
>
> This may be indentation alignment but I don't follow
> how this is a problem.

It is a problem because it is a noise for a logical change that is not
about whitespace fixup. The kernel maintainer would probably
rightfully reject it with such a line in.

>
>> -       int sysfs_modes[4] = {0, 1, 2, 1};
>> +       int sysfs_modes[4] = { 0, 1, 2, 1 };
>
> Is this change from Lindent or checkpatch?

I have used Lindent when these lines were generated. Here is some more:

-               data->dac = 180 - (180 * pwm)/255;
+               data->dac = 180 - (180 * pwm) / 255;
        else
-               data->dac = 76 - (76 * pwm)/255;
+               data->dac = 76 - (76 * pwm) / 255;

...

-       .probe          = max6650_probe,
-       .remove         = max6650_remove,
-       .id_table       = max6650_id,
+       .probe          = max6650_probe,
+       .remove = max6650_remove,
+       .id_table = max6650_id,

...

-                        const char *buf, size_t count)
+                         const char *buf, size_t count)
