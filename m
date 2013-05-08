Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3EHHOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 03:14:43 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:62688 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3EHHOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 03:14:42 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 0/6] Second set of fixes for ux500 ASoC drivers
Date: Wed,  8 May 2013 09:14:15 +0200
Message-Id: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are some others fixes for various small issues I found while
testing the ux500 ASoC driver on -next.

Patch 1 adds some missing declarations for AD controls that were causing
some weird behaviour in alsamixer, as the default state was outside the
declared range.

Patch 2 fixes a kernel crash when opening and closing the audio device
without sending any data.

Patch 3 drops pinctrl code altogether from the driver.  The actual
implementation is buggy as the pins are only registered to the playback
interfaces, which gives a bunch of warnings during kernel startup and
also kills the capture interface by setting the shared pins to hi-z mode
even if that's still active.  As putting those pins in high-z is not
really needed and was removed from the internal STE driver anyway, I'm
just dropping that code form here as well.  In parallel, I'm sending a
pinctrl patch to declare those pin as a hog.

Patches 4 to 6 fixes some weirdness with time slot usage.  After this
series the driver seems to work fine for both capture and playback
interface (tested on a snowball v11).

Thanks,
Fabio


Fabio Baltieri (6):
  ASoC: ab8500-codec: Add missing ad_to_slot definitions
  ASoC: ux500: Do not clear state if already idle
  ASoC: ux500: Drop pinctrl sleep support
  ASoC: ux500: Update tx tdm slots configuration
  ASoC: ux500: Swap even/odd AD slot definitions
  ASoC: ux500: Use the first two AD slots for capture

 sound/soc/codecs/ab8500-codec.c | 39 +++++++++++++++------------
 sound/soc/codecs/ab8500-codec.h | 36 ++++++++++++-------------
 sound/soc/ux500/mop500_ab8500.c |  4 +--
 sound/soc/ux500/ux500_msp_i2s.c | 58 +++--------------------------------------
 sound/soc/ux500/ux500_msp_i2s.h |  6 -----
 5 files changed, 46 insertions(+), 97 deletions(-)

-- 
1.8.2

