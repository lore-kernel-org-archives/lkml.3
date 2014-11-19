Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaKSKGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:06:55 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:32898 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbaKSKGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:06:52 -0500
Message-ID: <546C6BB9.4040705@gmail.com>
Date: Wed, 19 Nov 2014 13:06:49 +0300
From: Dmitry Tunin <hanipouspilot@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michel Memeteau - EKIMIA <contact@ekimia.fr>
CC: Marcel Holtmann <marcel@holtmann.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath3k: Add support of MCI 13d3:3408 bt device
References: <CANoib0HW2umPpzzerYNq1fMMnkYxOa78o5X90-K=eNEnTGSO1w@mail.gmail.com> <F01422F2-5F7C-406A-A06B-2C2CE96B9E3A@holtmann.org> <546C3CCE.400@gmail.com> <CAKxAHQ4intUoy2qv9ftTJL_c2JN3kYn8bC_Jk9=93rvvXNE80Q@mail.gmail.com> <CAKxAHQ5wDG=Bi4bLUsN5A9r4Y82444Ysnuppy+8REf7qUh1nmg@mail.gmail.com>
In-Reply-To: <CAKxAHQ5wDG=Bi4bLUsN5A9r4Y82444Ysnuppy+8REf7qUh1nmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that I am too stupid.
It is neither AR3012 or AR3011 device.
It is AR9565 with sflash.
Probably it makes sense to do a separate section for these devices.

But still
{ USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_IGNORE },
works better than

{ USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_ATH3012 },

With the latter I have some issues with turning bt on and off.

19.11.2014 12:40, Michel Memeteau - EKIMIA wrote:
> Hi,
>
> I tried to understand why this "0x13d3, 0x3408" device support
> wouldn't go in btusb as it's really close to IMC BT chip found in
> Realtek Wifi devices which is on the path to go in btusb [1]
>
> then I guess there is a lot of code that could be shared to support
> all IMC usb devices in the btusb module.
>
> Regards.
>
> [1] https://github.com/lwfinger/rtl8723au_bt/tree/new
>
>   <------------------------------------------------------------------------------------------------------------------>
>   Michel Memeteau  - Directeur.
>
>   Notre Boutique Ordinateurs GNU/Linux : http://shop.ekimia.fr
>   49 chemin de l'union 13720 La Bouilladisse - France.
>   Fixe :  +33 (0) 972308334   Mobile : +33(0) 624808051
>   <------------------------------------------------------------------------------------------------------------------>
>
>   2014-11-19 7:46 GMT+01:00 Dmitry Tunin <hanipouspilot@gmail.com>:
>> Hi Marcel,
>>
>> Here is information from /sys/kernel/debug/usb/devices
>>
>> T:  Bus=01 Lev=02 Prnt=03 Port=00 Cnt=01 Dev#= 20 Spd=12 MxCh= 0
>> D:  Ver= 1.10 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs= 1
>> P:  Vendor=13d3 ProdID=3408 Rev= 0.02
>> C:* #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
>> A:  FirstIf#= 0 IfCount= 2 Cls=e0(wlcon) Sub=01 Prot=01
>> I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
>> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
>> E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
>> I:* If#= 1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
>> I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
>> I:  If#= 1 Alt= 2 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
>> I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
>> I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
>> I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
>> E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
>> E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
>>
>>
>> I hope this mail client is OK now.
>>
>> Add support for bluetooth MCI WB335 (AR9565) Wi-Fi+bt module.
>> It is AR3011 device according to iProduct == 0.
>> So btusb should be blacklisted
>> I submitted a wrong patch before asif  it was an AR3012 device,
>> but it works both ways. This is the right one.
>>
>> Signed-off-by: Dmitry Tunin<hanipouspilot@gmail.com>
>>
>> ---
>>
>> diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
>> index d85ced2..3b53116 100644
>> --- a/drivers/bluetooth/ath3k.c
>> +++ b/drivers/bluetooth/ath3k.c
>> @@ -69,6 +69,7 @@ static const struct usb_device_id ath3k_table[] = {
>>       { USB_DEVICE(0x0CF3, 0x3002) },
>>       { USB_DEVICE(0x0CF3, 0xE019) },
>>       { USB_DEVICE(0x13d3, 0x3304) },
>> +    { USB_DEVICE(0x13d3, 0x3408) },
>>
>>       /* Atheros AR9285 Malbec with sflash firmware */
>>       { USB_DEVICE(0x03F0, 0x311D) },
>> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
>> index edfc17b..bbf5c1c 100644
>> --- a/drivers/bluetooth/btusb.c
>> +++ b/drivers/bluetooth/btusb.c
>> @@ -146,6 +146,7 @@ static const struct usb_device_id blacklist_table[] = {
>>       { USB_DEVICE(0x0cf3, 0x3002), .driver_info = BTUSB_IGNORE },
>>       { USB_DEVICE(0x0cf3, 0xe019), .driver_info = BTUSB_IGNORE },
>>       { USB_DEVICE(0x13d3, 0x3304), .driver_info = BTUSB_IGNORE },
>> +    { USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_IGNORE },
>>
>>       /* Atheros AR9285 Malbec with sflash firmware */
>>       { USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },
>>
>>
>> 19.11.2014 01:56, Marcel Holtmann wrote:
>>> Hi Dmitry,
>>>
>>>> Add support for bluetooth MCI WB335 (AR9565) Wi-Fi+bt module.
>>>> It is AR3011 device according to iProduct == 0.
>>>> So btusb should be blacklisted
>>>> I submitted a wrong patch before asif  it was an AR3012 device,
>>>> but it works both ways. This is the right one.
>>> include the device details from /sys/kernel/debug/usb/devices.
>>>
>>>> Signed-off-by: Dmitry Tunin <hanipouspilot@gmail.com>
>>>> are */
>>> No idea what this are */ is.
>>>
>>>> ---
>>>>
>>>> diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
>>>> index d85ced2..3b53116 100644
>>>> --- a/drivers/bluetooth/ath3k.c
>>>> +++ b/drivers/bluetooth/ath3k.c
>>>> @@ -69,6 +69,7 @@ static const struct usb_device_id ath3k_table[] = {
>>>>    { USB_DEVICE(0x0CF3, 0x3002) },
>>>>    { USB_DEVICE(0x0CF3, 0xE019) },
>>>>    { USB_DEVICE(0x13d3, 0x3304) },
>>>> + { USB_DEVICE(0x13d3, 0x3408) },
>>>>
>>>>    /* Atheros AR9285 Malbec with sflash firmware */
>>>>    { USB_DEVICE(0x03F0, 0x311D) },
>>>> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
>>>> index edfc17b..bbf5c1c 100644
>>>> --- a/drivers/bluetooth/btusb.c
>>>> +++ b/drivers/bluetooth/btusb.c
>>>> @@ -146,6 +146,7 @@ static const struct usb_device_id blacklist_table[] = {
>>>    { USB_DEVICE(0x0cf3, 0x3002), .driver_info = BTUSB_IGNORE },
>>>>    { USB_DEVICE(0x0cf3, 0xe019), .driver_info = BTUSB_IGNORE },
>>>>    { USB_DEVICE(0x13d3, 0x3304), .driver_info = BTUSB_IGNORE },
>>>> + { USB_DEVICE(0x13d3, 0x3408), .driver_info = BTUSB_IGNORE },
>>> Fix whitespace here or use a proper mail client.
>>>
>>> Regards
>>>
>>> Marcel
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

