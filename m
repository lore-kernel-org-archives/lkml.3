Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbaFIJLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:11:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58443 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 052/146] drm/tegra: Remove gratuitous pad field
Date: Mon,  9 Jun 2014 10:49:47 +0200
Message-Id: <760728fb2347e1de2061f34d8628a145c7c599f0.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/uapi/drm/tegra_drm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/uapi/drm/tegra_drm.h b/include/uapi/drm/tegra_drm.h
index 73bde4eaf16c..da106879b021 100644
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
1.9.3

