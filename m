Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074AbbA1UmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:42:16 -0500
Received: from axentia.se ([87.96.186.132]:48980 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932704AbbA1UmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:42:12 -0500
From: Peter Rosin <peda@axentia.se>
To: Mark Brown <broonie@kernel.org>, Peter Rosin <peda@lysator.liu.se>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/7] ASoC: pcm512x: Change register default to match
 actual content after reset
Thread-Topic: [PATCH v2 3/7] ASoC: pcm512x: Change register default to match
 actual content after reset
Thread-Index: AQHQOy5oZAdjHTWYKkW1AgJ5obvQBZzV+UiQ
Date: Wed, 28 Jan 2015 20:42:06 +0000
Message-ID: <4e50aac9e8ad4b5f8e8155ef8ca2d450@EMAIL.axentia.se>
References: <1422454572-7847-1-git-send-email-peda@lysator.liu.se>
 <1422454572-7847-4-git-send-email-peda@lysator.liu.se>
 <20150128191217.GF21293@sirena.org.uk>
In-Reply-To: <20150128191217.GF21293@sirena.org.uk>
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

Hi Mark,

First of all, thanks for taking the rest of the series!

Mark Brown wrote:
> On Wed, Jan 28, 2015 at 03:16:08PM +0100, Peter Rosin wrote:
> 
> > @@ -78,7 +78,7 @@ static const struct reg_default
> pcm512x_reg_defaults[] = {
> >  	{ PCM512x_DIGITAL_VOLUME_2,  0x30 },
> >  	{ PCM512x_DIGITAL_VOLUME_3,  0x30 },
> >  	{ PCM512x_DIGITAL_MUTE_1,    0x22 },
> > -	{ PCM512x_DIGITAL_MUTE_2,    0x00 },
> > +	{ PCM512x_DIGITAL_MUTE_2,    0x02 },
> 
> The datasheet claims these have undefined values as reserved bits - what
> would be a more robust change here would be to remove the register
> default entirely so that we take the value the hardware has, giving
> robustness against any hardware revisions.  Of course the device has rather a
> lot of such reserved bits which is unfortunate.

Given the incompleteness of the datasheets this might be safest; a lot
of the reserved areas appear to have undocumented functions. But it
works as is of course, so it is not high priority... I don't know what happens
when this particular bit is cleared, but it doesn't change anything for the
pcm5142 that I am able to detect. So, no real problem with dropping 3/7.

Cheers,
Peter

