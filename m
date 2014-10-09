Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaJIMdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:33:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:25275 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaJIMdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:33:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,684,1406617200"; 
   d="scan'208";a="615764979"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: irina.tirdea@intel.com, daniel.baluta@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 0/7] Introduce IIO interface for Android advanced features
Date: Thu,  9 Oct 2014 15:39:38 +0300
Message-Id: <1412858385-11954-1-git-send-email-daniel.baluta@intel.com>
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

Changes since v1 (mostly based on comments from Jonathan)

	* introduce TRANSITION event instead of MOTION to better
	represent multilevel state change
	* remove pedometer channel type and steps modifier and replace it 
	with steps channel type
	* squashed together patches introducing channels and associated events
	* introduced IIO_EV_DIR_NONE
	* changed cover letter subject to reflect the changes

Daniel Baluta (4):
  iio: dummy: Add virtual registers for dummy device
  iio: core: Introduce IIO_ACTIVITY channel and TRANSITION event
  iio: dummy: Demonstrate the usage of new channel types
  iio: event_monitor: Add support for new channel types

Irina Tirdea (3):
  iio: core: Introduce IIO_EV_DIR_NONE
  iio: core: Introduce STEPS channel type, ENABLE mask and INSTANCE
    event
  iio: core: Introduce HEIGHT channel type

 Documentation/ABI/testing/sysfs-bus-iio            |  75 ++++++++
 drivers/iio/industrialio-core.c                    |   8 +
 drivers/iio/industrialio-event.c                   |  14 +-
 .../staging/iio/Documentation/iio_event_monitor.c  |  25 ++-
 drivers/staging/iio/iio_dummy_evgen.c              |  16 ++
 drivers/staging/iio/iio_dummy_evgen.h              |   6 +
 drivers/staging/iio/iio_simple_dummy.c             | 199 +++++++++++++++++++--
 drivers/staging/iio/iio_simple_dummy.h             |   7 +
 drivers/staging/iio/iio_simple_dummy_events.c      |  61 ++++++-
 include/linux/iio/iio.h                            |   1 +
 include/linux/iio/types.h                          |  12 +-
 11 files changed, 393 insertions(+), 31 deletions(-)

-- 
1.9.1

