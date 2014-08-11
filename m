Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaHKNyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:54:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:63446 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbaHKNye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:54:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,841,1400050800"; 
   d="scan'208";a="574986900"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Jon Mason <jon.mason@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, jani.nikula@intel.com
Subject: [PATCH 0/4] module: add support for unsafe, tainting parameters
Date: Mon, 11 Aug 2014 16:52:18 +0300
Message-Id: <cover.1407764272.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.9.1
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a generic version of Daniel's patch [1] letting us have unsafe
module parameters (experimental, debugging, testing, etc.) that taint
the kernel when set. Quoting Daniel,

"""
Users just love to set random piles of options since surely enabling all
the experimental stuff helps. Later on we get bug reports because it all
fell apart.

Even more fun when it's labelled a regression when some change only just
made the feature possible (e.g. stolen memory fixes suddenly making fbc
possible).

Make it clear that users are playing with fire here.
"""

Patches 1-3 add the core functionality, patch 4 is our use case as an
example.

BR,
Jani.

[1] http://lkml.kernel.org/r/1394011994-30604-1-git-send-email-daniel.vetter@ffwll.ch


Jani Nikula (4):
  module: rename KERNEL_PARAM_FL_NOARG to avoid confusion
  module: make it possible to have unsafe, tainting module params
  module: add module_param_unsafe and module_param_named_unsafe
  drm/i915: taint the kernel if unsafe module parameters are set

 drivers/gpu/drm/i915/i915_params.c  |  8 ++---
 drivers/tty/serial/8250/8250_core.c |  2 +-
 include/linux/moduleparam.h         | 64 +++++++++++++++++++++++++++++++------
 kernel/module.c                     |  2 +-
 kernel/params.c                     | 17 ++++++++--
 security/apparmor/lsm.c             |  4 +--
 6 files changed, 76 insertions(+), 21 deletions(-)

-- 
1.9.1

