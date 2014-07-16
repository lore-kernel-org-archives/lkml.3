Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbaGPNGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:06:45 -0400
Received: from w-smtp-out-7.wedos.net ([46.28.106.5]:37377 "EHLO
	we2-f167.wedos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932801AbaGPNGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:06:41 -0400
Date: Wed, 16 Jul 2014 15:06:36 +0200
From: Josef Gajdusek <atx@atx.name>
To: linux-iio@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, jic23@kernel.org,
        linux-kernel@vger.kernel.org, pmeerw@pmeerw.net,
        dan.carpenter@oracle.com, lars@metafoo.de
Subject: [PATCH v4 (staging-next) 0/5] staging:iio:hmc5843: Few adjustments
 and support for hmc5983
Message-ID: <20140716130635.GA3315@dashie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series modifies the hmc5843 driver to support the hmc5983 i2c and
spi interfaces.

v2:
	* Reverted the changed order of iio unregister and setting hmc mode to sleep

v3:
	* Fixed bug introduced in the first patch
	* Readded few comment lines which have gone missing in the hmc5843.c ->
	  hmc5843_core.c move

v4: 
    * Changes suggested by Lars in https://lkml.org/lkml/2014/7/14/968
	  * The i2c and spi drivers are now user-selectable with the core driver
	    being selected automatically
	  * The regmap_config structs in both _spi and _i2c files are now static
	  * The iio_dev allocation is now done in the common function
	  * pm ops are now defined in the header file and the same definition is
	    shared between both interface-specific drivers
	* regmap tables in hmc5843.h are not longer static (this fixed bunch of 
	  variable not used warnings)

Rebased v4 on top of staging-next

Josef Gajdusek (5):
  staging:iio:hmc5843: Added regmap support
  staging:iio:hmc5843: Split hmc5843.c to multiple files
  staging:iio:hmc5843: register <-> value arrays now can have different
    lengths
  staging:iio:hmc5843: Add support for i2c hmc5983
  staging:iio:hmc5843: Add support for spi hmc5983

 drivers/staging/iio/magnetometer/Kconfig        |  30 +-
 drivers/staging/iio/magnetometer/Makefile       |   4 +-
 drivers/staging/iio/magnetometer/hmc5843.c      | 652 ------------------------
 drivers/staging/iio/magnetometer/hmc5843.h      |  86 ++++
 drivers/staging/iio/magnetometer/hmc5843_core.c | 638 +++++++++++++++++++++++
 drivers/staging/iio/magnetometer/hmc5843_i2c.c  |  74 +++
 drivers/staging/iio/magnetometer/hmc5843_spi.c  |  73 +++
 7 files changed, 900 insertions(+), 657 deletions(-)
 delete mode 100644 drivers/staging/iio/magnetometer/hmc5843.c
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843.h
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843_core.c
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843_i2c.c
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843_spi.c

-- 
1.8.5.5

