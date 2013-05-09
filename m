Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3EIW0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:26:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3EIW0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 40/73] drm/i915: dont intel_crt_init on any ULT machines
Date: Thu,  9 May 2013 15:25:30 -0700
Message-Id: <20130509222530.535451095@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit c40c0f5bd5b0f09e4386d2cf26c96c89c45ee539 upstream.

We may have DDI_BUF_CTL(PORT_A) configured with 2 lanes and still not
have CRT, so just check for !IS_ULT. This problem happened on a real
machine and resulted in a very ugly dmesg.

Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8326,7 +8326,7 @@ static void intel_setup_outputs(struct d
 		I915_WRITE(PFIT_CONTROL, 0);
 	}
 
-	if (!(HAS_DDI(dev) && (I915_READ(DDI_BUF_CTL(PORT_A)) & DDI_A_4_LANES)))
+	if (!IS_ULT(dev))
 		intel_crt_init(dev);
 
 	if (HAS_DDI(dev)) {


