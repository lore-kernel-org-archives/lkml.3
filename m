Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816Ab3CLXFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:05:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab3CLWdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        max <manikulin@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 056/100] drm/i915: Turn off hsync and vsync on ADPA when disabling crt
Date: Tue, 12 Mar 2013 15:31:41 -0700
Message-Id: <20130312223129.014407474@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

commit f40ebd6bcbbd0d30591f42dc16be52b5086a366b upstream.

According to PRM we need to disable hsync and vsync even though ADPA is
disabled. The previous code did infact do the opposite so we fix it.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=56359
Tested-by: max <manikulin@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_crt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -88,7 +88,7 @@ static void intel_disable_crt(struct int
 	u32 temp;
 
 	temp = I915_READ(crt->adpa_reg);
-	temp &= ~(ADPA_HSYNC_CNTL_DISABLE | ADPA_VSYNC_CNTL_DISABLE);
+	temp |= ADPA_HSYNC_CNTL_DISABLE | ADPA_VSYNC_CNTL_DISABLE;
 	temp &= ~ADPA_DAC_ENABLE;
 	I915_WRITE(crt->adpa_reg, temp);
 }


