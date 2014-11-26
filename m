Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbaKZTFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:05:51 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56609 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaKZTFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:05:49 -0500
Message-ID: <54762443.90701@roeck-us.net>
Date: Wed, 26 Nov 2014 11:04:35 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Benoit Cousson <bcousson@baylibre.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case
 of configuration errors
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>	<1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>	<5474A72D.2000309@roeck-us.net>	<CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>	<5474B564.9080902@roeck-us.net>	<CAMpxmJVGE444t3gE-=u8kuK_B9rJ=0fw9ZYVuYgQRPdswiPj7Q@mail.gmail.com>	<5474C36C.1020004@roeck-us.net> <CAMpxmJUhpX+AAmOS2gcgtJGr0dkeQ7YRyae12oRoW2NkT5drBA@mail.gmail.com> <5474CAC6.8030608@roeck-us.net> <54754364.80705@roeck-us.net> <54759F8A.20303@baylibre.com>
In-Reply-To: <54759F8A.20303@baylibre.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.5476248C.0232,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 01:38 AM, Benoit Cousson wrote:
> Hi Guenter,
>
> On 26/11/2014 04:05, Guenter Roeck wrote:
>
> [...]
>
>> Looking into the available documents, I am quite sure that the resistor
>> is changed by replacing the probe, in other words by pulling the board
>> with the ina226 and replacing it with another one. Given that, configuring
>> the shunt resistor value with a sysfs attribute is really the wrong way
>> to do it; you should use probe specific devicetree overlays instead.
>
> Unfortunately, that's not dynamic enough for all the use cases we need to support with the probes.
> In fact, most customers will rather put the shunts on their board and thus use a shunt-less version of the probe to do the measurement. In that case, there is no way we can hard code, even in a DTS, the shunt value.
>
> That's for that kind of usage that we do need to be able to set the shunt value at runtime. The probe in that case can be pluged dynamically on different board jumpers to do the measurement.
>
> Later, thanks to the web UI, the user will be able to configure the shunt value based on the way they were plugged to its boards.
>
> sysfs seems to be the easiest way to do that. I don't think DT overlay can handle that, since it is depend of the targeted system and not on the measurement system.
>

I just noticed that you did not copy the lm-sensors mailing list.

I am not really happy with this, and want to get some more feedback
from the list before I accept more or less arbitrary attributes.
Jean, any comments ?

Thanks,
Guenter

