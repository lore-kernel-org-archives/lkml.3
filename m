Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaJSTvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 15:51:49 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:50740 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495AbaJSTvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 15:51:48 -0400
Message-ID: <5444166E.1020000@ladisch.de>
Date: Sun, 19 Oct 2014 21:52:14 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64;
	rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Vlad Catoi <vladcatoi@gmail.com>, Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, Daniel Mack <zonque@gmail.com>,
        Eduard Gilmutdinov <edgilmutdinov@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] snd-usb-audio: Add support for Steinberg UR22 USB
	interface
References: <1413672341-3703-1-git-send-email-vladcatoi@gmail.com>
In-Reply-To: <1413672341-3703-1-git-send-email-vladcatoi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <20141019195045.578261.19380@dehamd003.servertools24.de>
X-PPP-Vhost: ladisch.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vlad Catoi wrote:
> Adding support for Steinberg UR22 USB interface via quirks table patch
>
> See Ubuntu bug report:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1317244
> Also see threads:
> http://linux-audio.4202.n7.nabble.com/Support-for-Steinberg-UR22-Yamaha-USB-chipset-0499-1509-tc82888.html#a82917
> http://www.steinberg.net/forums/viewtopic.php?t=62290
>
> Tested by at least 4 people judging by the threads.
> Did not test MIDI interface, but audio output and capture both are
> functional. Built 3.17 kernel with this driver on Ubuntu 14.04 & tested with mpg123
> Patch applied to 3.13 Ubuntu kernel works well enough for daily use.
>
> Signed-off-by: Vlad Catoi <vladcatoi@gmail.com>

Acked-by: Clemens Ladisch <clemens@ladisch.de>

> ---
>  sound/usb/quirks-table.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>
> diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
> index 223c47b..c657752 100644
> --- a/sound/usb/quirks-table.h
> +++ b/sound/usb/quirks-table.h
> @@ -385,6 +385,36 @@ YAMAHA_DEVICE(0x105d, NULL),
>  	}
>  },
>  {
> +	USB_DEVICE(0x0499, 0x1509),
> +	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
> +		/* .vendor_name = "Yamaha", */
> +		/* .product_name = "Steinberg UR22", */
> +		.ifnum = QUIRK_ANY_INTERFACE,
> +		.type = QUIRK_COMPOSITE,
> +		.data = (const struct snd_usb_audio_quirk[]) {
> +			{
> +				.ifnum = 1,
> +				.type = QUIRK_AUDIO_STANDARD_INTERFACE
> +			},
> +			{
> +				.ifnum = 2,
> +				.type = QUIRK_AUDIO_STANDARD_INTERFACE
> +			},
> +			{
> +				.ifnum = 3,
> +				.type = QUIRK_MIDI_YAMAHA
> +			},
> +			{
> +				.ifnum = 4,
> +				.type = QUIRK_IGNORE_INTERFACE
> +			},
> +			{
> +				.ifnum = -1
> +			}
> +		}
> +	}
> +},
> +{
>  	USB_DEVICE(0x0499, 0x150a),
>  	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
>  		/* .vendor_name = "Yamaha", */
