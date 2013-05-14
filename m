Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3ENOsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:48:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:11465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab3ENOsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:48:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="313414819"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH v2 0/8] add *_to_jiffies_timeout helpers to guarantee a minimum duration
Date: Tue, 14 May 2013 17:48:30 +0300
Message-Id: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a motivation of this pachset see the commit log of patch 1/8.

v2:
- s/max_t/min_t/ when clamping to MAX_JIFFY_OFFSET
- change the _min suffix to _timeout (Daniel Vetter)
- add kerneldoc (Daniel Vetter)
- turn the macros into uninlined functions
- don't convert msecs_to_jiffies() users where the intention of +1 was
  something else (Jean Delvare, Michal Kubecek)

Imre Deak (8):
  time: add *_to_jiffies_timeout helpers to guarantee a minimum
    duration
  sched: msleep: take msecs_to_jiffies_timeout into use
  drm/i915: take msecs_to_jiffies_timeout into use
  media/si4713-i2c: take usecs_to_jiffies_timeout into use
  usb/isp116x-hcd: take msecs_to_jiffies_timeout into use
  net/sunrpc: take msecs_to_jiffies_timeout into use
  net/tipc: take msecs_to_jiffies_timeout into use
  sound/oxygen_io: take msecs_to_jiffies_timeout into use

 drivers/gpu/drm/i915/intel_drv.h |    2 +-
 drivers/gpu/drm/i915/intel_i2c.c |    2 +-
 drivers/media/radio/si4713-i2c.c |    4 ++--
 drivers/usb/host/isp116x-hcd.c   |    2 +-
 include/linux/jiffies.h          |    6 ++++++
 kernel/time.c                    |   27 +++++++++++++++++++++++++++
 kernel/timer.c                   |    4 ++--
 net/sunrpc/xprtrdma/verbs.c      |    4 ++--
 net/tipc/core.h                  |    2 +-
 sound/pci/oxygen/oxygen_io.c     |    2 +-
 10 files changed, 44 insertions(+), 11 deletions(-)

-- 
1.7.10.4

