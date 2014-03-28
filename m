Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaC1RbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:31:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaC1Ray (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Kenneth Graunke <kenneth.w.graunke@intel.com>,
        Art Runyan <arthur.j.runyan@intel.com>,
        "Kumar, Kiran S" <kiran.s.kumar@intel.com>,
        Ben Widawsky <ben@bwidawsk.net>, Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.13 04/46] drm/i915: Fix PSR programming
Date: Fri, 28 Mar 2014 10:31:48 -0700
Message-Id: <20140328173135.233702392@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <benjamin.widawsky@intel.com>

commit 24bd9bf54d45d28089251cdf62bf14323d1aa827 upstream.

| has a higher precedence than ?. Therefore, the calculation doesn't do
at all what you would expect. Thanks to Ken for convincing me that this
was indeed the issue. Send me back to C programmer school, please.

I'm sort of surprised PSR was continuing to work for people. It should
be broken IMO (and it was broken for me, but I had assumed it never
worked).

Regression from:
commit ed8546ac1f99b850879f07b1e9b06b42fb0a36d9
Author: Ben Widawsky <benjamin.widawsky@intel.com>
Date:   Mon Nov 4 22:45:05 2013 -0800

    drm/i915/bdw: Support eDP PSR

Cc: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Cc: Kenneth Graunke <kenneth.w.graunke@intel.com>
Cc: Art Runyan <arthur.j.runyan@intel.com>
Reported-by: "Kumar, Kiran S" <kiran.s.kumar@intel.com>
Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1634,7 +1634,7 @@ static void intel_edp_psr_enable_source(
 		val |= EDP_PSR_LINK_DISABLE;
 
 	I915_WRITE(EDP_PSR_CTL(dev), val |
-		   IS_BROADWELL(dev) ? 0 : link_entry_time |
+		   (IS_BROADWELL(dev) ? 0 : link_entry_time) |
 		   max_sleep_time << EDP_PSR_MAX_SLEEP_TIME_SHIFT |
 		   idle_frames << EDP_PSR_IDLE_FRAME_SHIFT |
 		   EDP_PSR_ENABLE);


