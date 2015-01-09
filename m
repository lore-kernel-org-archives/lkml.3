Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbbAIMdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:33:31 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63342 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbbAIMd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:33:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAN+gG=GqwUHqv-7YAt++N-xmuxjV+C8mPkbX8ZfHiqqkWvnu+Q@mail.gmail.com>
References: <1419782872-2991-1-git-send-email-aniroop.mathur@gmail.com>
	<alpine.LNX.2.00.1412291302470.1680@pobox.suse.cz>
	<CADYu308MmdGeajFTDt38zZSy7K2VKbDppuqmiJn=1ZwL5d1vmw@mail.gmail.com>
	<CAF8JNh+gzA_m-mMjjAdBz6WyyFemTU26VDOLufOJXJ5DMkK2yg@mail.gmail.com>
	<CAN+gG=GqwUHqv-7YAt++N-xmuxjV+C8mPkbX8ZfHiqqkWvnu+Q@mail.gmail.com>
Date: Fri, 9 Jan 2015 18:03:26 +0530
Message-ID: <CADYu30-SENoMymHMYRQ5T==-C-iiMN789DMJx1jty592b+EQ9Q@mail.gmail.com>
Subject: Re: [PATCH] hid: Initialize battery_no to -1 & correct its format string
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        Ping Cheng <pingc@wacom.com>, Jiri Kosina <jkosina@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aniroop Mathur <a.mathur@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mr. Benjamin,

On Wed, Jan 7, 2015 at 7:20 AM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> On Tue, Jan 6, 2015 at 7:50 PM, Ping Cheng <pinglinux@gmail.com> wrote:
>> Hi Benjamin,
>>
>> The relevant code was introduced by
>> d70420b914c98a3758674c6e9858810e0ab4ea30. Can you take a look and let
>> us know if Aniroop's patch fits your original thought or not?
>
> Hehe, indeed, that's my code.
>
> I would agree with Jiri, I really do not care. This code is called
> only once at initialization and I am pretty sure it will not change
> the time to initialize the device (I am confident the compiler will do
> something better than blindly following the code).
>
> So either way it is good. But I have a slight preference to initialize
> the variable to 0 and keep the unsigned in the name.
>
> Cheers,
> Benjamin
>

Atleast, there is a need to fix format specifier of "n" variable.
"n" is declared as unsigned long so %ld should be changed to %lu.

Thanks !!

>>
>> Thanks,
>>
>> Ping
>>
>> On Tue, Jan 6, 2015 at 6:32 AM, Aniroop Mathur <aniroop.mathur@gmail.com> wrote:
>>> Dear Mr. Jason and Mr. Ping,
>>>
>>> Please update about below patch.
>>> Except avoiding subtraction, there is also a need to avoid negative
>>> battery name which may come due to %ld, so need to change to %lu.
>>>
>>> Thanks,
>>> Aniroop
>>>
>>> On Mon, Dec 29, 2014 at 5:33 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>>>> On Sun, 28 Dec 2014, Aniroop Mathur wrote:
>>>>
>>>>> From: Aniroop Mathur <a.mathur@samsung.com>
>>>>>
>>>>> This patch initializes battery_no to -1 to avoid extra subtraction
>>>>> operation performed everytime wacom battery is initialized
>>>>
>>>> This is so femto-optimization, that I don't really care deeply. Adding
>>>> Jason and Ping to CC. If they want this, I'll apply the patch.
>>>>
>>>>> and correct format string of unsigned long from %ld to %lu.
>>>>>
>>>>> Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
>>>>> ---
>>>>>  drivers/hid/wacom_sys.c | 8 ++++----
>>>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
>>>>> index 129fd33..4b5ff84 100644
>>>>> --- a/drivers/hid/wacom_sys.c
>>>>> +++ b/drivers/hid/wacom_sys.c
>>>>> @@ -919,17 +919,17 @@ static int wacom_ac_get_property(struct power_supply *psy,
>>>>>
>>>>>  static int wacom_initialize_battery(struct wacom *wacom)
>>>>>  {
>>>>> -     static atomic_t battery_no = ATOMIC_INIT(0);
>>>>> +     static atomic_t battery_no = ATOMIC_INIT(-1);
>>>>>       int error;
>>>>>       unsigned long n;
>>>>>
>>>>>       if (wacom->wacom_wac.features.quirks & WACOM_QUIRK_BATTERY) {
>>>>> -             n = atomic_inc_return(&battery_no) - 1;
>>>>> +             n = atomic_inc_return(&battery_no);
>>>>>
>>>>>               wacom->battery.properties = wacom_battery_props;
>>>>>               wacom->battery.num_properties = ARRAY_SIZE(wacom_battery_props);
>>>>>               wacom->battery.get_property = wacom_battery_get_property;
>>>>> -             sprintf(wacom->wacom_wac.bat_name, "wacom_battery_%ld", n);
>>>>> +             sprintf(wacom->wacom_wac.bat_name, "wacom_battery_%lu", n);
>>>>>               wacom->battery.name = wacom->wacom_wac.bat_name;
>>>>>               wacom->battery.type = POWER_SUPPLY_TYPE_BATTERY;
>>>>>               wacom->battery.use_for_apm = 0;
>>>>> @@ -937,7 +937,7 @@ static int wacom_initialize_battery(struct wacom *wacom)
>>>>>               wacom->ac.properties = wacom_ac_props;
>>>>>               wacom->ac.num_properties = ARRAY_SIZE(wacom_ac_props);
>>>>>               wacom->ac.get_property = wacom_ac_get_property;
>>>>> -             sprintf(wacom->wacom_wac.ac_name, "wacom_ac_%ld", n);
>>>>> +             sprintf(wacom->wacom_wac.ac_name, "wacom_ac_%lu", n);
>>>>>               wacom->ac.name = wacom->wacom_wac.ac_name;
>>>>>               wacom->ac.type = POWER_SUPPLY_TYPE_MAINS;
>>>>>               wacom->ac.use_for_apm = 0;
>>>>> --
>>>>> 1.9.1
>>>>>
>>>>
>>>> --
>>>> Jiri Kosina
>>>> SUSE Labs
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-input" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
