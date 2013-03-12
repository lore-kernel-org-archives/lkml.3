Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3CLXGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:06:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933634Ab3CLWdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 052/100] drm/i915: Increase the RC6p threshold.
Date: Tue, 12 Mar 2013 15:31:37 -0700
Message-Id: <20130312223128.581946761@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stéphane Marchesin <marcheu@chromium.org>

commit 0920a48719f1ceefc909387a64f97563848c7854 upstream.

This increases GEN6_RC6p_THRESHOLD from 100000 to 150000. For some
reason this avoids the gen6_gt_check_fifodbg.isra warnings and
associated GPU lockups, which makes my ivy bridge machine stable.

Signed-off-by: Stéphane Marchesin <marcheu@chromium.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2572,7 +2572,7 @@ static void gen6_enable_rps(struct drm_d
 	I915_WRITE(GEN6_RC_SLEEP, 0);
 	I915_WRITE(GEN6_RC1e_THRESHOLD, 1000);
 	I915_WRITE(GEN6_RC6_THRESHOLD, 50000);
-	I915_WRITE(GEN6_RC6p_THRESHOLD, 100000);
+	I915_WRITE(GEN6_RC6p_THRESHOLD, 150000);
 	I915_WRITE(GEN6_RC6pp_THRESHOLD, 64000); /* unused */
 
 	/* Check if we are enabling RC6 */


