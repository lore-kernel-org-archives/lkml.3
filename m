Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaKZDFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 22:05:16 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:60622 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaKZDFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 22:05:15 -0500
Message-ID: <54754364.80705@roeck-us.net>
Date: Tue, 25 Nov 2014 19:05:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>
Subject: Re: [PATCH 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in case
 of configuration errors
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>	<1416930423-12179-2-git-send-email-bgolaszewski@baylibre.com>	<5474A72D.2000309@roeck-us.net>	<CAMpxmJUrs-3oXwYyNh26EnuZRH9bpXrmBBLKM7tmKGx=gSwyuQ@mail.gmail.com>	<5474B564.9080902@roeck-us.net>	<CAMpxmJVGE444t3gE-=u8kuK_B9rJ=0fw9ZYVuYgQRPdswiPj7Q@mail.gmail.com>	<5474C36C.1020004@roeck-us.net> <CAMpxmJUhpX+AAmOS2gcgtJGr0dkeQ7YRyae12oRoW2NkT5drBA@mail.gmail.com> <5474CAC6.8030608@roeck-us.net>
In-Reply-To: <5474CAC6.8030608@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5475436A.007F,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
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

On 11/25/2014 10:30 AM, Guenter Roeck wrote:
> On 11/25/2014 10:22 AM, Bartosz Golaszewski wrote:
>> 2014-11-25 18:59 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
>>> It seems to me this is a problem of your architecture. That doesn't
>>> make it a generic problem. Your architecture should detect that a
>>> probe was disconnected and de-instantiate the device automatically
>>> if so, and re-instantiate it if it is re-inserted. Ultimately this
>>> should be done with, for example, devicetree overlays.
>>
>> You're right and it's planned to be done this way in the future, when
>> this project exits its prototype phase (around Q2 2015). Nevertheless
>> I still think that if we're adding a set function, it should behave
>> like the getters and check the value returned by
>> i2c_smbus_write_word_swapped().
>>
>
> I do not question that. I question changing the return value to -ENODEV.
>
> Repeating my earlier question: Is the resistor value changed by software
> or by changing the probe ?
>

Looking into the available documents, I am quite sure that the resistor
is changed by replacing the probe, in other words by pulling the board
with the ina226 and replacing it with another one. Given that, configuring
the shunt resistor value with a sysfs attribute is really the wrong way
to do it; you should use probe specific devicetree overlays instead.

Guenter

