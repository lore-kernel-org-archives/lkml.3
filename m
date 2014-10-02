Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaJBNiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:38:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:3775 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbaJBNiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:38:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="599806568"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel.baluta@intel.com, irina.tirdea@intel.com
Subject: [RFC PATCH]  iio: Introduce activity channel
Date: Thu,  2 Oct 2014 16:43:51 +0300
Message-Id: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a new interface for supporting some of the composite
sensors in Android [1]. First supported sensors are motion and pedometer.

This is a follow up of the discussion about adding new channels to IIO
initiated some time ago on IIO list [2].

A device that has the motion/pedometer functionality is Freescale's MMA9553L ([3]).

Because we don't have yet the hardware, to demonstrate this new channel we 
update iio_dummy kernel module and iio_event_monitor test program. We want
to get an early feedback about extending the IIO interface in the correct
direction.

[1] http://source.android.com/devices/sensors/composite_sensors.html
[2] http://marc.info/?l=linux-iio&m=138374342831057&w=2
[3] http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf

Daniel Baluta (5):
  iio: dummy: Introduce virtual registers for dummy device
  iio: core: Introduce IIO_ACTIVITY channel
  iio: core: Introduce new MOTION event
  iio: dummy: Demonstrate the usage of activity channel
  iio: event_monitor: Add support for activity channel

Irina Tirdea (3):
  iio: core: Introduce pedometer STEP counter modifier
  iio: core: Introduce ENABLE channel info mask
  iio: core: Introduce new STEP_DETECT event

 Documentation/ABI/testing/sysfs-bus-iio            | 28 +++++++
 drivers/iio/industrialio-core.c                    |  7 ++
 drivers/iio/industrialio-event.c                   |  2 +
 .../staging/iio/Documentation/iio_event_monitor.c  | 16 ++++
 drivers/staging/iio/iio_dummy_evgen.c              | 16 ++++
 drivers/staging/iio/iio_dummy_evgen.h              |  7 ++
 drivers/staging/iio/iio_simple_dummy.c             | 87 ++++++++++++++++++++--
 drivers/staging/iio/iio_simple_dummy.h             |  4 +
 drivers/staging/iio/iio_simple_dummy_events.c      | 37 +++++++--
 include/linux/iio/iio.h                            |  1 +
 include/linux/iio/types.h                          | 10 ++-
 11 files changed, 201 insertions(+), 14 deletions(-)

-- 
1.9.1

