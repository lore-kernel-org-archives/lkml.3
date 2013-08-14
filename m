Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab3HNTFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:05:12 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:39046 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab3HNTFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:05:10 -0400
MIME-Version: 1.0
In-Reply-To: <520BB19E.8040901@wwwdotorg.org>
References: <1376497533-32303-1-git-send-email-linus.walleij@linaro.org>
	<520BB19E.8040901@wwwdotorg.org>
Date: Wed, 14 Aug 2013 21:05:09 +0200
Message-ID: <CACRpkdbZZP3qowmR4djoPrNq0VnsR3ukoqLDyEC1oRFehfg74A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: improve warning messages
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 6:34 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/14/2013 10:25 AM, Linus Walleij wrote:

>>                       dev_err(pctldev->dev,
>> -                             "could not request pin %d on device %s\n",
>> -                             pins[i], pinctrl_dev_get_name(pctldev));
>> +                             "could not request pin %d from group %s on "
>> +                             "device %s\n",
>> +                             pins[i], gname, pinctrl_dev_get_name(pctldev));
>
> I think it'd be useful to print the pin name rather than pin number here.

Fixed it.

>> @@ -486,6 +499,16 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>>                       desc->mux_setting = NULL;
>>                       /* And release the pin */
>>                       pin_free(pctldev, pins[i], NULL);
>> +             } else {
>> +                     const char *gname;
>> +
>> +                     gname = pctlops->get_group_name(pctldev,
>> +                                             setting->data.mux.group);
>> +                     dev_warn(pctldev->dev,
>> +                              "not freeing pin %d as part of deactivating "
>> +                              "group %s - it is already used for some other "
>> +                              "setting",
>> +                              pins[i], gname);
>>               }
>>       }
>
> I think that will only happen if one of the pinmux_enabling_setting
> prints already happened. Is it worth adding this one?

It happens at two very distinct places in the run path, disabling a setting
may appear at a totally different place in the dmesg so I think so.

It's just below the just added code that will avoid free:ing a pin if some
other setting is muxing it, so it's this print I was talking about
with Sonic.

Yours,
Linus Walleij
