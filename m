Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab3FMSaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:30:06 -0400
Received: from etezian.org ([198.101.225.253]:56452 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758980Ab3FMS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:29:00 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 00/19] misc: bh1770glc features and fixes
Date: Thu, 13 Jun 2013 20:20:34 +0200
Message-Id: <cover.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset contains a collection of new features and fixes for
the bh1770glc driver for the BH1770 and SFH7770 proximity
and ambient light sensor device.

In few words this is what it brings:
- /dev/input/event interface
- removal obsolete and wrong parameters
- new relevant parameters for glass attenuation and glass
  factor, lux compensation due to the LED cover or ink
- improvments of the threshold usage
- corrections of the device rates and default LED current
- general code cleanup

These patches have been applied on top of mainline master, but
they could be easily applied on top of any branch since they
don't affect any core code.

Thanks,
Andi

Andi Shyti (7):
  bh1770glc: added input device interface
  bh1770glc: removed proximity adjustement
  bh1770glc: split read result function
  bh1770glc: logic change in the proximity read
  bh1770glc: use min_t instead of min
  bh1770glc: use kstrtoul instead of strict_strtoul
  bh1770glc: removed lux_read_raw_result() function

Onur Atilla (12):
  bh1770glc: different glass attenuation parameters
  bh1770glc: lux0_glass_factor & lux0_comp_factor on sysfs
  bh1770glc: Added raw lux output file for ALS to sysfs
  bh1770glc: Removed obsolete offset settings from SFH7770 code
  bh1770glc: Introduced dynamic threshold
  bh1770glc: Code cleaning and aligning in source code
  bh1770glc: Modified the neutral glass attenuation value
  bh1770glc: Modified scaler variable
  bh1770glc: Added sanity check for scf
  bh1770glc: Implemented switch for interrupt operation
  bh1770glc: Corrected proximity sensor rates
  bh1770glc: Proximity sensor LED current update

 drivers/misc/bh1770glc.c      |  411 +++++++++++++++++++++++++++--------------
 include/linux/i2c/bh1770glc.h |   30 +--
 2 files changed, 289 insertions(+), 152 deletions(-)

-- 
1.7.10.4

