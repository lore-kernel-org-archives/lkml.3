Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaJVB12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:27:28 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:43709 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbaJVB11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:27:27 -0400
Message-ID: <544707F3.1020505@atmel.com>
Date: Wed, 22 Oct 2014 09:27:15 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Peter Rosin <peda@axentia.se>
CC: "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, "Mark Brown" <broonie@kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: atmel_ssc_dai: Track playback and
 capture CMR dividers separately.
References: <a541333cf46b4c61b790df927d4b315d@EMAIL.axentia.se> <5445BCBF.5090002@atmel.com> <dc4461593ddb4d539f2db74b69bab98c@EMAIL.axentia.se> <544620C8.4040001@atmel.com> <8559eca320324092be82f7d942606102@EMAIL.axentia.se>
In-Reply-To: <8559eca320324092be82f7d942606102@EMAIL.axentia.se>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 10/21/2014 09:05 PM, Peter Rosin wrote:
> I did some further tests, and the following program fails without the patch:

With the patch, it is OK?

> #include <sys/ioctl.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/soundcard.h>
>
> int
> main(void)
> {
> 	int fd;
> 	int format;
> 	int channels;
>
> 	if ((fd = open("/dev/dsp", O_WRONLY, 0)) == -1) {
> 		perror("open");
> 		return 1;
> 	}
> 	format = AFMT_S16_LE;
> 	if (ioctl(fd, SNDCTL_DSP_SETFMT, &format) == -1) {
> 		perror("SNDCTL_DSP_SETFMT");
> 		return 1;
> 	}
> 	channels = 2;
> 	if (ioctl(fd, SNDCTL_DSP_CHANNELS, &channels) == -1) {
> 		perror("SNDCTL_DSP_CHANNELS");
> 		return 1;
> 	}
> 	return 0;
> }
>
> Output:
> SNDCTL_DSP_CHANNELS: Device or resource busy

This return from codec or from atmel_ssc_dai?

> (I admin to having edited the above code slightly in this mail, so I might have
> introduced some silly bug, but you get what I mean, just open the device
> and request some parameters, and boom: -EBUSY)
>
> Cheers,
> Peter
>

Best Regards,
Bo Shen
