Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaDXJCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:02:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47166 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbaDXI4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thierry Reding <treding@nvidia.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 178/182] drm/tegra: Remove gratuitous pad field
Date: Thu, 24 Apr 2014 09:51:43 +0100
Message-Id: <1398329507-5911-179-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

commit cbfbbabb89b37f6bad05f478d906a385149f288d upstream.

The version of the drm_tegra_submit structure that was merged all the
way back in 3.10 contains a pad field that was originally intended to
properly pad the following __u64 field. Unfortunately it seems like a
different field was dropped during review that caused this padding to
become unnecessary, but the pad field wasn't removed at that time.

One possible side-effect of this is that since the __u64 following the
pad is now no longer properly aligned, the compiler may (or may not)
introduce padding itself, which results in no predictable ABI.

Rectify this by removing the pad field so that all fields are again
naturally aligned. Technically this is breaking existing userspace ABI,
but given that there aren't any (released) userspace drivers that make
use of this yet, the fallout should be minimal.

Fixes: d43f81cbaf43 ("drm/tegra: Add gr2d device")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/uapi/drm/tegra_drm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
index 73bde4e..da10687 100644
--- a/include/uapi/drm/tegra_drm.h
+++ b/include/uapi/drm/tegra_drm.h
@@ -105,7 +105,6 @@ struct drm_tegra_submit {
 	__u32 num_waitchks;
 	__u32 waitchk_mask;
 	__u32 timeout;
-	__u32 pad;
 	__u64 syncpts;
 	__u64 cmdbufs;
 	__u64 relocs;
-- 
1.9.1

