Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbbAUF6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:58:44 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:52308 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbAUF6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:58:43 -0500
MIME-Version: 1.0
In-Reply-To: <54BF221E.8000409@roeck-us.net>
References: <1421799212-2028-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <54BF221E.8000409@roeck-us.net>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 20 Jan 2015 21:58:02 -0800
Message-ID: <CAGVrzcawAF1=RPAJ+0O3B+PA7sDkstTjVjDQL_8C8a8kHL7CoA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: set parent of hwmon device
To: Guenter Roeck <linux@roeck-us.net>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel@savoirfairelinux.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-20 19:50 GMT-08:00 Guenter Roeck <linux@roeck-us.net>:
> On 01/20/2015 04:13 PM, Vivien Didelot wrote:
>>
>> Set the dsa device as the parent of the hwmon device, in order to link
>> the hwmon subsystem under the corresponding /sys/devices/platform/dsa.X/
>> sysfs directory.
>>
>> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
>> ---
>>   net/dsa/dsa.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
>> index 3731714..363102a 100644
>> --- a/net/dsa/dsa.c
>> +++ b/net/dsa/dsa.c
>> @@ -347,7 +347,7 @@ dsa_switch_setup(struct dsa_switch_tree *dst, int
>> index,
>>                 hname[j] = '\0';
>>                 scnprintf(ds->hwmon_name, sizeof(ds->hwmon_name),
>> "%s_dsa%d",
>>                           hname, index);
>> -               ds->hwmon_dev = hwmon_device_register_with_groups(NULL,
>> +               ds->hwmon_dev = hwmon_device_register_with_groups(parent,
>>                                         ds->hwmon_name, ds,
>> dsa_hwmon_groups);
>>                 if (IS_ERR(ds->hwmon_dev))
>>                         ds->hwmon_dev = NULL;
>>
>
> Looking into my old e-mail, turns out we did not add the parent device
> because
> it affected the output of the "sensors" command, and we wanted the device
> to be handled as 'virtual device' (which implies no parent). That was an
> explicit
> part of the patch set (v2 of 'net: dsa: Add support for reporting switch
> chip
> temperatures'), compared to v1, which did set the parent device.
>
> I would suggest to keep the code as is.

Maybe follow-up with a comment adding that above the call to
hwmon_device_register_with_groups()? I suspect the intent is clear if
you are deep into hwmon devices, but not necessarily for the reader ;)

>
> Thanks,
> Guenter
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Florian
