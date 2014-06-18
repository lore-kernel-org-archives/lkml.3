Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaFRSOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:14:16 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:34594 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaFRSOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:14:14 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [PATCH v2 0/10] Batch of cleanup patches for cros_ec
Date: Wed, 18 Jun 2014 11:13:57 -0700
Message-Id: <1403115247-8853-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a batch of cleanup patches picked from the ChromeOS 3.8 kernel
tree and applied to ToT.  Most of these patches were authored by Bill
Richardson (CCed).  Where appropriate I've squashed patches together,
though I have erred on the side of keeping patches logically distinct
rather than squashing into one big cleanup patch.

There is very little functionality added by this series, but this gets
us closer to how things look in the ChromeOS tree so we can add more
patches atop it.  In general I took the oldest patches from our tree
and stopped picking when I got to a reasonable patch size (10
patches).  There are about 5 more cleanup patches still in the
ChromeOS tree, then some more major functionality patches.

Note that I didn't take the "cros_ec_dev" userspace inteface, the
"LPC" implementation, the "vboot context" implementation, and patches
relating to exynos5250-spring when picking patches.  These bits are
very separate (and big!) and can be added and debated separately after
we've got cleanup in.  Whenever patches touched those pieces of the
code I ignored that part of the patch.  In general I did take cleanup
code that was intended to make it easier to later add these bits.

I have tested basic functionality of these patches on exynos5250-snow
and exynos5420-peach-pit.

Changes in v2:
- Include example printouts before/after in commit message.
- Removed unneeded "ret" variable.
- Added common function to cros_ec.c
- Changed to dev_dbg() as per http://crosreview.com/66726
- IRQs should be optional => move EC interrupt to keyboard.

Andrew Bresticker (1):
  mfd: cros_ec: move EC interrupt to cros_ec_keyb

Bill Richardson (8):
  mfd: cros_ec: Fix the comment on cros_ec_remove()
  mfd: cros_ec: Allow static din/dout buffers with cros_ec_register()
  mfd: cros_ec: Tweak struct cros_ec_device for clarity
  mfd: cros_ec: Use struct cros_ec_command to communicate with the EC
  mfd: cros_ec: cleanup: remove unused fields from struct cros_ec_device
  mfd: cros_ec: cleanup: Remove EC wrapper functions
  mfd: cros_ec: Check result code from EC messages
  mfd: cros_ec: ec_dev->cmd_xfer() returns number of bytes received from
    EC

Simon Glass (1):
  mdf: cros_ec: Detect in-progress commands

 drivers/i2c/busses/i2c-cros-ec-tunnel.c |  17 +++--
 drivers/input/keyboard/cros_ec_keyb.c   |  70 ++++++++++++--------
 drivers/mfd/cros_ec.c                   |  97 ++++++++--------------------
 drivers/mfd/cros_ec_i2c.c               |  37 +++++------
 drivers/mfd/cros_ec_spi.c               |  36 +++++------
 include/linux/mfd/cros_ec.h             | 110 +++++++++++++++++---------------
 6 files changed, 172 insertions(+), 195 deletions(-)

-- 
2.0.0.526.g5318336

