Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbbAUQ1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:27:06 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:61184 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbbAUQ1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:27:01 -0500
Date: Wed, 21 Jan 2015 11:26:59 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Message-ID: <1206541390.69577.1421857619949.JavaMail.root@mail>
In-Reply-To: <CAGVrzcawAF1=RPAJ+0O3B+PA7sDkstTjVjDQL_8C8a8kHL7CoA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: set parent of hwmon device
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter, Florian,

>>> -               ds->hwmon_dev = hwmon_device_register_with_groups(NULL,
>>> +               ds->hwmon_dev = hwmon_device_register_with_groups(parent,
>>>                                         ds->hwmon_name, ds, dsa_hwmon_groups);
>>>                 if (IS_ERR(ds->hwmon_dev))
>>>                         ds->hwmon_dev = NULL;
>>
>> Looking into my old e-mail, turns out we did not add the parent
>> device because it affected the output of the "sensors" command, and
>> we wanted the device to be handled as 'virtual device' (which implies
>> no parent). That was an explicit part of the patch set (v2 of 'net:
>> dsa: Add support for reporting switch chip temperatures'), compared
>> to v1, which did set the parent device.

I don't know about the "sensors" output, but I found that convenient
from the sysfs side to have a hierarchy of sub-devices logically exposed
at the same place, i.e.:

	# ls /sys/devices/platform/dsa.0
	driver    hwmon    net    ...

>> I would suggest to keep the code as is.

> Maybe follow-up with a comment adding that above the call to
> hwmon_device_register_with_groups()? I suspect the intent is clear if
> you are deep into hwmon devices, but not necessarily for the reader ;)

Thanks,
-v
