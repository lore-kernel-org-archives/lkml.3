Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbbAIAqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 19:46:17 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:52922 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbAIAqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 19:46:16 -0500
Message-ID: <54AF24D6.6010701@gmail.com>
Date: Thu, 08 Jan 2015 18:46:14 -0600
From: Paul Bonser <misterpib@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2] ALSA: usb-audio: Add support for Akai
 MPC Element USB MIDI controller
References: <54AE16D8.6080302@gmail.com> <54AEFCFF.3060406@ladisch.de>
In-Reply-To: <54AEFCFF.3060406@ladisch.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 03:56 PM, Clemens Ladisch wrote:
> Paul Bonser wrote:
>> The Akai MPC Element incorrectly reports its bInterfaceClass as 255, but
>> otherwise implements the USB MIDI spec correctly.
>>
>> This adds a quirks-table.h entry which allows the device to be
>> recognized as a standard USB MIDI device.
>>
>> Signed-off-by: Paul Bonser <misterpib@gmail.com>
>> ---
>> diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
>> index 8590a32..e869b6c 100644
>> --- a/sound/usb/quirks-table.h
>> +++ b/sound/usb/quirks-table.h
>> @@ -2516,6 +2516,28 @@ YAMAHA_DEVICE(0x7010, "UB99"),
>>  	}
>>  },
>>
>> +{
>> +	/* Akai MPC Element */
>> +	USB_DEVICE(0x09e8, 0x0021),
>> +	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
>> +		.ifnum = QUIRK_ANY_INTERFACE,
>> +		.type = QUIRK_COMPOSITE,
>> +		.data = & (const struct snd_usb_audio_quirk[]) {
>> +			{
>> +				.ifnum = 0,
>> +				.type = QUIRK_IGNORE_INTERFACE
>> +			},
>> +			{
>> +				.ifnum = 1,
>> +				.type = QUIRK_MIDI_STANDARD_INTERFACE
>> +			},
>> +			{
>> +				.ifnum = -1
>> +			}
>> +		}
>> +	}
>> +},
> 
> Why a composite quirk?  Does a single quirk entry not work?

A single quirk entry results in an error message in dmesg:
"snd-usb-audio: probe of 3-2:1.0 failed with error -5"

Adding the QUIRK_IGNORE_INTERFACE stops that.

> 
> 
> Regards,
> Clemens
> 
