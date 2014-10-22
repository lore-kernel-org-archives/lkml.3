Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaJVEtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 00:49:15 -0400
Received: from axentia.se ([87.96.186.132]:7728 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaJVEtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 00:49:13 -0400
From: Peter Rosin <peda@axentia.se>
To: Bo Shen <voice.shen@atmel.com>
CC: "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, "Mark Brown" <broonie@kernel.org>
Subject: RE: [alsa-devel] [PATCH] ASoC: atmel_ssc_dai: Track playback and
 capture CMR dividers separately.
Thread-Topic: [alsa-devel] [PATCH] ASoC: atmel_ssc_dai: Track playback and
 capture CMR dividers separately.
Thread-Index: Ac/saz/Ebhtl/6cSQtuv8Muf3bNWIgBK9e7bAAahiEA=
Date: Wed, 22 Oct 2014 04:47:21 +0000
Message-ID: <c61abc1ef0f341c2be04e3d7b07d97de@EMAIL.axentia.se>
References: <a541333cf46b4c61b790df927d4b315d@EMAIL.axentia.se>
 <5445BCBF.5090002@atmel.com>
 <dc4461593ddb4d539f2db74b69bab98c@EMAIL.axentia.se>
 <544620C8.4040001@atmel.com>
 <8559eca320324092be82f7d942606102@EMAIL.axentia.se>
 <544707F3.1020505@atmel.com>
In-Reply-To: <544707F3.1020505@atmel.com>
Accept-Language: en-US, sv-SE
Content-Language: sv-SE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [217.210.101.82]
x-gfi-smtp-submission: 1
x-gfi-smtp-hellodomain: EMAIL.axentia.se
x-gfi-smtp-remoteip: 192.168.2.5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Hi Peter,
> 
> On 10/21/2014 09:05 PM, Peter Rosin wrote:
> > I did some further tests, and the following program fails without the patch:
> 
> With the patch, it is OK?

Yes.

> > #include <sys/ioctl.h>
> > #include <unistd.h>
> > #include <fcntl.h>
> > #include <sys/soundcard.h>
> >
> > int
> > main(void)
> > {
> > 	int fd;
> > 	int format;
> > 	int channels;
> >
> > 	if ((fd = open("/dev/dsp", O_WRONLY, 0)) == -1) {
> > 		perror("open");
> > 		return 1;
> > 	}
> > 	format = AFMT_S16_LE;
> > 	if (ioctl(fd, SNDCTL_DSP_SETFMT, &format) == -1) {
> > 		perror("SNDCTL_DSP_SETFMT");
> > 		return 1;
> > 	}
> > 	channels = 2;
> > 	if (ioctl(fd, SNDCTL_DSP_CHANNELS, &channels) == -1) {
> > 		perror("SNDCTL_DSP_CHANNELS");
> > 		return 1;
> > 	}
> > 	return 0;
> > }
> >
> > Output:
> > SNDCTL_DSP_CHANNELS: Device or resource busy
> 
> This return from codec or from atmel_ssc_dai?

This -EBUSY definitely comes from atmel_ssc_set_dai_sysclk, when my
card-driver tries to set ATMEL_SSC_CMR_DIV. With the patch, it works.
(the codec is spdif-transmitter, since the i2c interface of the actual tfa9879
codec is not directly reachable from the linux cpu, but that has nothing to
do with this issue).

> > (I admin to having edited the above code slightly in this mail, so I
s/admin/admit/
> > might have introduced some silly bug, but you get what I mean, just
> > open the device and request some parameters, and boom: -EBUSY)

Cheers,
Peter

