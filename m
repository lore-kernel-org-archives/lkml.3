Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbbAIPL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:11:28 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:47545 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbbAIPLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:11:24 -0500
Message-ID: <54AFEF9A.5030000@gmail.com>
Date: Fri, 09 Jan 2015 09:11:22 -0600
From: Paul Bonser <misterpib@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2] ALSA: usb-audio: Add support for Akai
 MPC Element USB MIDI controller
References: <54AE16D8.6080302@gmail.com>	<54AEFCFF.3060406@ladisch.de>	<54AF24D6.6010701@gmail.com>	<54AF95EA.90505@ladisch.de> <s5h7fwwcksc.wl-tiwai@suse.de>
In-Reply-To: <s5h7fwwcksc.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/09/2015 04:26 AM, Takashi Iwai wrote:
> At Fri, 09 Jan 2015 09:48:42 +0100,
> Clemens Ladisch wrote:
>>
>> Paul Bonser wrote:
>>> On 01/08/2015 03:56 PM, Clemens Ladisch wrote:
>>>> Paul Bonser wrote:
>>>>> The Akai MPC Element incorrectly reports its bInterfaceClass as 255, but
>>>>> otherwise implements the USB MIDI spec correctly.
>>>>>
>>>>> This adds a quirks-table.h entry which allows the device to be
>>>>> recognized as a standard USB MIDI device.
>>>>>
>>>>> +++ b/sound/usb/quirks-table.h
>>>>> +{
>>>>> +	/* Akai MPC Element */
>>>>> +	USB_DEVICE(0x09e8, 0x0021),
>>>>> +	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
>>>>> +		.ifnum = QUIRK_ANY_INTERFACE,
>>>>> +		.type = QUIRK_COMPOSITE,
>>>>> +		.data = & (const struct snd_usb_audio_quirk[]) {
>>>>> +			{
>>>>> +				.ifnum = 0,
>>>>> +				.type = QUIRK_IGNORE_INTERFACE
>>>>> +			},
>>>>> +			{
>>>>> +				.ifnum = 1,
>>>>> +				.type = QUIRK_MIDI_STANDARD_INTERFACE
>>>>> +			},
>>>>> +			{
>>>>> +				.ifnum = -1
>>>>> +			}
>>>>> +		}
>>>>> +	}
>>>>> +},
>>>>
>>>> Why a composite quirk?  Does a single quirk entry not work?
>>>
>>> A single quirk entry results in an error message in dmesg:
>>> "snd-usb-audio: probe of 3-2:1.0 failed with error -5"
>>
>> That message is normal for unhandled interfaces.
> 
> It's still not good to show a message, so using QUIRK_IGNORE_INTERFACE
> is good enough as a workaround.  So I applied it as is to for-next
> branch now.  Though...
> 
>> Does it actually prevent the device from working?
> 
> ... it's still interesting why it needs a special handling.  If we
> find out more and have a better fix, let's put on top of the current
> patch.

Interface 0 is the empty audio control interface (with no endpoints)
that standard USB MIDI devices have, but as with interface 1, it has its
bInterfaceClass set to 255 instead of 1.

As far as I can tell the error does not prevent the device itself from
working. I tried using QUIRK_AUDIO_STANDARD_INTERFACE and I believe it
had the same error. I'm guessing this is because it has no endpoints, so
the driver doesn't know what to do with it?
