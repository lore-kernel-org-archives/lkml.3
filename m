Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaKJMoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:44:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:10698 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaKJMoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:44:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,352,1413270000"; 
   d="scan'208";a="634415409"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, knaack.h@gmx.de
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        irina.tirdea@intel.com, daniel.baluta@inte.com
Subject: [PATCH v4 0/7] Introduce IIO interface for Android advanced features
Date: Mon, 10 Nov 2014 14:45:28 +0200
Message-Id: <1415623535-24337-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a new interface for supporting some of the composite
sensors in Android [1]. First supported sensors are activity and pedometer.

This is a follow up of the discussion about adding new channels to IIO
initiated some time ago on IIO list [2].

A device that has the activity/pedometer functionality is Freescale's MMA9553L ([3]).

Because we don't have yet the hardware, to demonstrate these new channels we
update iio_dummy kernel module and iio_event_monitor test program. We want
to get an early feedback about extending the IIO interface in the correct
direction.

[1] http://source.android.com/devices/sensors/composite_sensors.html
[2] http://marc.info/?l=linux-iio&m=138374342831057&w=2
[3] http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf

Changes since v3:
	* rebased on latest togreg branch (head at 5e62863aea)
	* fix typos reported by Hartmut

Changes since v2: (comments from Jonathan and Hartmut)
	* dropped the RFC tag
	* use int instead of unsigned long for ret in iio_evgen_poke
	* remove TRANSITION event and use THRESHOLD instead
	* remove IIO_HEIGHT channel and use CALIBHEIGHT mask instead
	* adapt iio_dummy modules and iio_event_monitor to reflect IIO
	  interface changes.

Daniel Baluta (4):
  iio: dummy: Add virtual registers for dummy device
  iio: core: Introduce IIO_ACTIVITY channel
  iio: dummy: Demonstrate the usage of new channel types
  iio: event_monitor: Add support for new channel types

Irina Tirdea (3):
  iio: core: Introduce IIO_EV_DIR_NONE
  iio: core: Introduce STEPS channel, ENABLE mask and INSTANCE event
  iio: core: Introduce IIO_CHAN_INFO_CALIBHEIGHT

 Documentation/ABI/testing/sysfs-bus-iio            |  74 ++++++++
 drivers/iio/industrialio-core.c                    |   8 +
 drivers/iio/industrialio-event.c                   |  13 +-
 .../staging/iio/Documentation/iio_event_monitor.c  |  23 ++-
 drivers/staging/iio/iio_dummy_evgen.c              |  17 ++
 drivers/staging/iio/iio_dummy_evgen.h              |   6 +
 drivers/staging/iio/iio_simple_dummy.c             | 199 +++++++++++++++++++--
 drivers/staging/iio/iio_simple_dummy.h             |   7 +
 drivers/staging/iio/iio_simple_dummy_events.c      |  66 ++++++-
 include/linux/iio/iio.h                            |   2 +
 include/linux/iio/types.h                          |  10 +-
 11 files changed, 395 insertions(+), 30 deletions(-)

-- 
1.9.1

