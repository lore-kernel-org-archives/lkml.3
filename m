Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3KHIIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:08:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:29207 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab3KHIIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:08:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,658,1378882800"; 
   d="scan'208";a="429887175"
From: Jani Nikula <jani.nikula@intel.com>
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx@lists.freedesktop.org
Cc: jani.nikula@intel.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/i915/opregion: fix build error on CONFIG_ACPI=n
Date: Fri,  8 Nov 2013 10:10:31 +0200
Message-Id: <1383898231-23234-1-git-send-email-jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CA+r1ZhjcFpr5KKVX0pLCOP8cAyZoiYO=UyqYMJtNSV-Kt_p7xQ@mail.gmail.com>
References: <CA+r1ZhjcFpr5KKVX0pLCOP8cAyZoiYO=UyqYMJtNSV-Kt_p7xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix CONFIG_ACPI=n build fail

  CC      drivers/gpu/drm/i915/intel_opregion.o
drivers/gpu/drm/i915/intel_opregion.c: In function ‘intel_opregion_setup’:
drivers/gpu/drm/i915/intel_opregion.c:879:2: error: ‘asle_work’ undeclared (first use in this function)
drivers/gpu/drm/i915/intel_opregion.c:879:2: note: each undeclared identifier is reported only once for each function it appears in
make[4]: *** [drivers/gpu/drm/i915/intel_opregion.o] Error 1

introduced in
commit 91a60f20712179e56b7a6c3d332a5f6f9a54aa11
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Thu Oct 31 18:55:48 2013 +0200

    drm/i915: move opregion asle request handling to a work queue

Reported-by: Jim Davis <jim.epost@gmail.com>
Reference: http://lkml.kernel.org/r/CA+r1ZhjcFpr5KKVX0pLCOP8cAyZoiYO=UyqYMJtNSV-Kt_p7xQ@mail.gmail.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/intel_opregion.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 91b68dc..1b2f41c 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -876,7 +876,9 @@ int intel_opregion_setup(struct drm_device *dev)
 		return -ENOTSUPP;
 	}
 
+#ifdef CONFIG_ACPI
 	INIT_WORK(&opregion->asle_work, asle_work);
+#endif
 
 	base = acpi_os_ioremap(asls, OPREGION_SIZE);
 	if (!base)
-- 
1.7.9.5

