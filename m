Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105Ab3DPRpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:45:14 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47103 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964879Ab3DPRpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:45:12 -0400
Message-ID: <516D8E24.9020308@gmail.com>
Date: Tue, 16 Apr 2013 19:45:08 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: alsa-devel@alsa-project.org
CC: Russell King <linux@arm.linux.org.uk>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] sound: ASoC: multiple DAIs/codecs on single audio stream
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am rewriting Marvell Kirkwood/Dove audio driver and I am having
a hard time to match the controllers features to ASoC API.

The controller has a dma controller for one playback buffer. It can
play the stream to both I2S and SPDIF interfaces with independent mute.

Now, for example, I have a board with i2s codec and spdif tx diode
connected to the above controller:

DMA (platform) -+-> I2S (dai) ----> I2S_Codec (codec)
                 |
                 +-> SPDIF (dai) --> SPDIF_TX (codec)

Is there any way in the current ASoC API to have the above setup?

I tried to attach two codecs to a single DAI and that will already
create two playback streams with two buffers. I guess it will also
happen if I have two DAIs connected to the same platform driver?

For an API for SoC audio, shouldn't there be some relation between
platform, DAI, and codec, e.g.:
- a platform represents a single audio stream buffer
- a platform can be attached to one or more DAIs,
- a DAI can be attached to one codec only

Regards,
   Sebastian
