Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbbAGAuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 19:50:37 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:42436 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbbAGAuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 19:50:35 -0500
MIME-Version: 1.0
In-Reply-To: <CADYu308MmdGeajFTDt38zZSy7K2VKbDppuqmiJn=1ZwL5d1vmw@mail.gmail.com>
References: <1419782872-2991-1-git-send-email-aniroop.mathur@gmail.com>
	<alpine.LNX.2.00.1412291302470.1680@pobox.suse.cz>
	<CADYu308MmdGeajFTDt38zZSy7K2VKbDppuqmiJn=1ZwL5d1vmw@mail.gmail.com>
Date: Tue, 6 Jan 2015 16:50:34 -0800
Message-ID: <CAF8JNh+gzA_m-mMjjAdBz6WyyFemTU26VDOLufOJXJ5DMkK2yg@mail.gmail.com>
Subject: Re: [PATCH] hid: Initialize battery_no to -1 & correct its format string
From: Ping Cheng <pinglinux@gmail.com>
To: Aniroop Mathur <aniroop.mathur@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jason Gerecke <killertofu@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        a.mathur@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

The relevant code was introduced by
d70420b914c98a3758674c6e9858810e0ab4ea30. Can you take a look and let
us know if Aniroop's patch fits your original thought or not?

Thanks,

Ping

On Tue, Jan 6, 2015 at 6:32 AM, Aniroop Mathur <aniroop.mathur@gmail.com> wrote:
> Dear Mr. Jason and Mr. Ping,
>
> Please update about below patch.
> Except avoiding subtraction, there is also a need to avoid negative
> battery name which may come due to %ld, so need to change to %lu.
>
> Thanks,
> Aniroop
>
> On Mon, Dec 29, 2014 at 5:33 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>> On Sun, 28 Dec 2014, Aniroop Mathur wrote:
>>
>>> From: Aniroop Mathur <a.mathur@samsung.com>
>>>
>>> This patch initializes battery_no to -1 to avoid extra subtraction
>>> operation performed everytime wacom battery is initialized
>>
>> This is so femto-optimization, that I don't really care deeply. Adding
>> Jason and Ping to CC. If they want this, I'll apply the patch.
>>
>>> and correct format string of unsigned long from %ld to %lu.
>>>
>>> Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
>>> ---
>>>  drivers/hid/wacom_sys.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
>>> index 129fd33..4b5ff84 100644
>>> --- a/drivers/hid/wacom_sys.c
>>> +++ b/drivers/hid/wacom_sys.c
>>> @@ -919,17 +919,17 @@ static int wacom_ac_get_property(struct power_supply *psy,
>>>
>>>  static int wacom_initialize_battery(struct wacom *wacom)
>>>  {
>>> -     static atomic_t battery_no = ATOMIC_INIT(0);
>>> +     static atomic_t battery_no = ATOMIC_INIT(-1);
>>>       int error;
>>>       unsigned long n;
>>>
>>>       if (wacom->wacom_wac.features.quirks & WACOM_QUIRK_BATTERY) {
>>> -             n = atomic_inc_return(&battery_no) - 1;
>>> +             n = atomic_inc_return(&battery_no);
>>>
>>>               wacom->battery.properties = wacom_battery_props;
>>>               wacom->battery.num_properties = ARRAY_SIZE(wacom_battery_props);
>>>               wacom->battery.get_property = wacom_battery_get_property;
>>> -             sprintf(wacom->wacom_wac.bat_name, "wacom_battery_%ld", n);
>>> +             sprintf(wacom->wacom_wac.bat_name, "wacom_battery_%lu", n);
>>>               wacom->battery.name = wacom->wacom_wac.bat_name;
>>>               wacom->battery.type = POWER_SUPPLY_TYPE_BATTERY;
>>>               wacom->battery.use_for_apm = 0;
>>> @@ -937,7 +937,7 @@ static int wacom_initialize_battery(struct wacom *wacom)
>>>               wacom->ac.properties = wacom_ac_props;
>>>               wacom->ac.num_properties = ARRAY_SIZE(wacom_ac_props);
>>>               wacom->ac.get_property = wacom_ac_get_property;
>>> -             sprintf(wacom->wacom_wac.ac_name, "wacom_ac_%ld", n);
>>> +             sprintf(wacom->wacom_wac.ac_name, "wacom_ac_%lu", n);
>>>               wacom->ac.name = wacom->wacom_wac.ac_name;
>>>               wacom->ac.type = POWER_SUPPLY_TYPE_MAINS;
>>>               wacom->ac.use_for_apm = 0;
>>> --
>>> 1.9.1
>>>
>>
>> --
>> Jiri Kosina
>> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
