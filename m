Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab3GRPQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:16:34 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:62737 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3GRPQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:16:32 -0400
Message-ID: <51E806CD.9080009@gmail.com>
Date: Thu, 18 Jul 2013 10:16:29 -0500
From: Chris J Arges <christopherarges@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Torstein Hegge <hegge@resisty.net>
CC: alsa-devel@alsa-project.org, martin@meltin.net,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Eldad Zack <eldad@fogrefinery.com>, Trulan Martin <trulanm@gmail.com>,
        Damien Zammit <damien@zamaudio.com>, Mark Hills <mark@xwax.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: usb-audio: Add quirk for Focusrite Scarlett 18i8
References: <1374095558-9949-1-git-send-email-christopherarges@gmail.com> <20130717235323.GA21885@pvv.ntnu.no>
In-Reply-To: <20130717235323.GA21885@pvv.ntnu.no>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 06:53 PM, Torstein Hegge wrote:
> On Wed, Jul 17, 2013 at 16:12:12 -0500, Chris J Arges wrote:
>> This patch is similar to commit 1762a59d8e8b5e99f6f4a0f292b40f3cacb108ba.
>> The same non-standard interface descriptor causes snd_usb_create_mixer()
>> to fail for the Focusrite Scarlett 18i8 as well.
> 
> Did you test this on a recent kernel? I don't think this quirk or the quirk
> introduced by 1762a59d "ALSA: usb-audio: Add quirk for Focusrite Scarlett
> 18i6" is necessary since kernel 3.9, as it includes:
> 
> 4d7b86c98 "ALSA: snd-usb: mixer: propagate errors up the call chain"
> 83ea5d18d "ALSA: snd-usb: mixer: ignore -EINVAL in snd_usb_mixer_controls()"
> 61ac51301 "ALSA: usb: Parse UAC2 extension unit like for UAC1"
> 
> Those were tested on a Focusrite Scarlett 8i6, but the lsusb output
> from 18i6 and 8i6 looks similar,
> http://www.mail-archive.com/alsa-user@lists.sourceforge.net/msg29426.html
> http://www.mail-archive.com/alsa-user@lists.sourceforge.net/msg27776.html
> I'm guessing the 18i8 isn't that different.
> 

Re-testing this, I see that you are right. The mixer still doesn't work,
but at least its usable for playback/recording/midi.
Ignore this patch then.

Thanks,
--chris j arges

> 
> Torstein
> 
>> ---
>>  sound/usb/quirks-table.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 46 insertions(+)
>>
>> diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
>> index 7f1585b..b954ec5 100644
>> --- a/sound/usb/quirks-table.h
>> +++ b/sound/usb/quirks-table.h
>> @@ -3232,6 +3232,52 @@ YAMAHA_DEVICE(0x7010, "UB99"),
>>  		}
>>  	}
>>  },
>> +{
>> +	/*
>> +	 * Focusrite Scarlett 18i8
>> +	 *
>> +	 * Avoid mixer creation similar to the Scarlett 18i6 interface.
>> +	 */
>> +	USB_DEVICE(0x1235, 0x8014),
>> +	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
>> +		.vendor_name = "Focusrite",
>> +		.product_name = "Scarlett 18i8",
>> +		.ifnum = QUIRK_ANY_INTERFACE,
>> +		.type = QUIRK_COMPOSITE,
>> +		.data = & (const struct snd_usb_audio_quirk[]) {
>> +			{
>> +				/* InterfaceSubClass 1 (Control Device) */
>> +				.ifnum = 0,
>> +				.type = QUIRK_IGNORE_INTERFACE
>> +			},
>> +			{
>> +				.ifnum = 1,
>> +				.type = QUIRK_AUDIO_STANDARD_INTERFACE
>> +			},
>> +			{
>> +				.ifnum = 2,
>> +				.type = QUIRK_AUDIO_STANDARD_INTERFACE
>> +			},
>> +			{
>> +				/* InterfaceSubClass 1 (Control Device) */
>> +				.ifnum = 3,
>> +				.type = QUIRK_IGNORE_INTERFACE
>> +			},
>> +			{
>> +				.ifnum = 4,
>> +				.type = QUIRK_MIDI_STANDARD_INTERFACE
>> +			},
>> +			{
>> +				/* InterfaceSubClass 1 (Device Firmware Update) */
>> +				.ifnum = 5,
>> +				.type = QUIRK_IGNORE_INTERFACE
>> +			},
>> +			{
>> +				.ifnum = -1
>> +			}
>> +		}
>> +	}
>> +},
>>  
>>  {
>>  	/*
>> -- 
>> 1.7.9.5

