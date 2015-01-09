Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbbAIIss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:48:48 -0500
Received: from dehamd003.servertools24.de ([31.47.254.18]:57633 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756945AbbAIIsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:48:45 -0500
Message-ID: <54AF95EA.90505@ladisch.de>
Date: Fri, 09 Jan 2015 09:48:42 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64;
	rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Bonser <misterpib@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2] ALSA: usb-audio: Add support for Akai
	MPC Element USB MIDI controller
References: <54AE16D8.6080302@gmail.com> <54AEFCFF.3060406@ladisch.de>
	<54AF24D6.6010701@gmail.com>
In-Reply-To: <54AF24D6.6010701@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20150109084408.137708.52109@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bonser wrote:
> On 01/08/2015 03:56 PM, Clemens Ladisch wrote:
>> Paul Bonser wrote:
>>> The Akai MPC Element incorrectly reports its bInterfaceClass as 255, but
>>> otherwise implements the USB MIDI spec correctly.
>>>
>>> This adds a quirks-table.h entry which allows the device to be
>>> recognized as a standard USB MIDI device.
>>>
>>> +++ b/sound/usb/quirks-table.h
>>> +{
>>> +	/* Akai MPC Element */
>>> +	USB_DEVICE(0x09e8, 0x0021),
>>> +	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
>>> +		.ifnum = QUIRK_ANY_INTERFACE,
>>> +		.type = QUIRK_COMPOSITE,
>>> +		.data = & (const struct snd_usb_audio_quirk[]) {
>>> +			{
>>> +				.ifnum = 0,
>>> +				.type = QUIRK_IGNORE_INTERFACE
>>> +			},
>>> +			{
>>> +				.ifnum = 1,
>>> +				.type = QUIRK_MIDI_STANDARD_INTERFACE
>>> +			},
>>> +			{
>>> +				.ifnum = -1
>>> +			}
>>> +		}
>>> +	}
>>> +},
>>
>> Why a composite quirk?  Does a single quirk entry not work?
>
> A single quirk entry results in an error message in dmesg:
> "snd-usb-audio: probe of 3-2:1.0 failed with error -5"

That message is normal for unhandled interfaces.

Does it actually prevent the device from working?


Regards,
Clemens
