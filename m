Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3JGPUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:20:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53117 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab3JGPUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:20:49 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Widawsky <benjamin.widawsky@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the drm-intel tree
Date: Mon,  7 Oct 2013 17:18:45 +0200
Message-Id: <1381159127-11067-3-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381159127-11067-1-git-send-email-treding@nvidia.com>
References: <1381159127-11067-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the drm-intel tree got a conflict in:

	drivers/gpu/drm/i915/intel_dp.c

caused by commits 0cc4b69 (drm/i915: Mask LPSP to get PSR working even with
Power Well in use by audio.) and 18b5992 (drm/i915: Calculate PSR register
offsets from base + gen). I fixed it up (see below). Please verify that the
resolution looks correct.

Thanks,
Thierry
---
diff --cc drivers/gpu/drm/i915/intel_dp.c
index bc6579e,c4c280c..f349931
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@@ -1549,8 -1558,8 +1558,8 @@@ static void intel_edp_psr_setup(struct 
  	intel_edp_psr_write_vsc(intel_dp, &psr_vsc);
  
  	/* Avoid continuous PSR exit by masking memup and hpd */
- 	I915_WRITE(EDP_PSR_DEBUG_CTL, EDP_PSR_DEBUG_MASK_MEMUP |
+ 	I915_WRITE(EDP_PSR_DEBUG_CTL(dev), EDP_PSR_DEBUG_MASK_MEMUP |
 -		   EDP_PSR_DEBUG_MASK_HPD);
 +		   EDP_PSR_DEBUG_MASK_HPD | EDP_PSR_DEBUG_MASK_LPSP);
  
  	intel_dp->psr_setup_done = true;
  }
