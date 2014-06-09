Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302AbaFIIwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:52:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58467 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754955AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 051/146] drm/radeon: check buffer relocation offset
Date: Mon,  9 Jun 2014 10:49:46 +0200
Message-Id: <682e4b9154ce8143805ef2ce2977be7fc845c1b5.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leo Liu <leo.liu@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 695daf1a8e731a4b5b89de89a61f32a4d7ad7094 upstream.

Signed-off-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_uvd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_uvd.c b/drivers/gpu/drm/radeon/radeon_uvd.c
index 83936473f8e4..a656b1a7e10a 100644
--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -464,6 +464,10 @@ static int radeon_uvd_cs_reloc(struct radeon_cs_parser *p,
 	cmd = radeon_get_ib_value(p, p->idx) >> 1;
 
 	if (cmd < 0x4) {
+		if (end <= start) {
+			DRM_ERROR("invalid reloc offset %X!\n", offset);
+			return -EINVAL;
+		}
 		if ((end - start) < buf_sizes[cmd]) {
 			DRM_ERROR("buffer (%d) to small (%d / %d)!\n", cmd,
 				  (unsigned)(end - start), buf_sizes[cmd]);
-- 
1.9.3

