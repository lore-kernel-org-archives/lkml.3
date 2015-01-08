Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbbAHWC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:02:26 -0500
Received: from dehamd003.servertools24.de ([31.47.254.18]:41878 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbbAHWCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:02:25 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 17:02:24 EST
Message-ID: <54AEFCFF.3060406@ladisch.de>
Date: Thu, 08 Jan 2015 22:56:15 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Bonser <misterpib@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2] ALSA: usb-audio: Add support for Akai
	MPC Element USB MIDI controller
References: <54AE16D8.6080302@gmail.com>
In-Reply-To: <54AE16D8.6080302@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20150108215227.330530.63235@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bonser wrote:
> The Akai MPC Element incorrectly reports its bInterfaceClass as 255, but
> otherwise implements the USB MIDI spec correctly.
>
> This adds a quirks-table.h entry which allows the device to be
> recognized as a standard USB MIDI device.
>
> Signed-off-by: Paul Bonser <misterpib@gmail.com>
> ---
> diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
> index 8590a32..e869b6c 100644
> --- a/sound/usb/quirks-table.h
> +++ b/sound/usb/quirks-table.h
> @@ -2516,6 +2516,28 @@ YAMAHA_DEVICE(0x7010, "UB99"),
>  	}
>  },
>
> +{
> +	/* Akai MPC Element */
> +	USB_DEVICE(0x09e8, 0x0021),
> +	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
> +		.ifnum = QUIRK_ANY_INTERFACE,
> +		.type = QUIRK_COMPOSITE,
> +		.data = & (const struct snd_usb_audio_quirk[]) {
> +			{
> +				.ifnum = 0,
> +				.type = QUIRK_IGNORE_INTERFACE
> +			},
> +			{
> +				.ifnum = 1,
> +				.type = QUIRK_MIDI_STANDARD_INTERFACE
> +			},
> +			{
> +				.ifnum = -1
> +			}
> +		}
> +	}
> +},

Why a composite quirk?  Does a single quirk entry not work?


Regards,
Clemens
