Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaFEA0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:26:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaFDXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>, Darren Hart <dvhart@linux.intel.com>,
        Mika Kuoppala <mika.kuoppala@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.14 116/228] drm/i915/vlv: reset VLV media force wake request register
Date: Wed,  4 Jun 2014 16:22:25 -0700
Message-Id: <20140604232351.767451532@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 05adaf1f101f25f40f12c29403e6488f0e45f6b6 upstream.

Media force wake get hangs the machine when the system is booted without
displays attached. The assumption is that (at least some versions of)
the firmware has skipped some initialization in that case.

Empirical evidence suggests we need to reset the media force wake
request register in addition to the render one to avoid hangs.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=75895
Reported-by: Imre Deak <imre.deak@intel.com>
Reported-by: Darren Hart <dvhart@linux.intel.com>
Tested-by: Darren Hart <dvhart@linux.intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_uncore.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/i915/intel_uncore.c
+++ b/drivers/gpu/drm/i915/intel_uncore.c
@@ -177,6 +177,8 @@ static void vlv_force_wake_reset(struct
 {
 	__raw_i915_write32(dev_priv, FORCEWAKE_VLV,
 			   _MASKED_BIT_DISABLE(0xffff));
+	__raw_i915_write32(dev_priv, FORCEWAKE_MEDIA_VLV,
+			   _MASKED_BIT_DISABLE(0xffff));
 	/* something from same cacheline, but !FORCEWAKE_VLV */
 	__raw_posting_read(dev_priv, FORCEWAKE_ACK_VLV);
 }


