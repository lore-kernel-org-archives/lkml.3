Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbaFJULQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:11:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35374 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbaFJTwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 139/160] drm/radeon: check buffer relocation offset
Date: Tue, 10 Jun 2014 12:46:19 -0700
Message-Id: <1402429600-20477-140-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Liu <leo.liu@amd.com>

commit 695daf1a8e731a4b5b89de89a61f32a4d7ad7094 upstream.

Signed-off-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_uvd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_uvd.c b/drivers/gpu/drm/radeon/radeon_uvd.c
index 60a0044..c085917 100644
--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -465,6 +465,10 @@ static int radeon_uvd_cs_reloc(struct radeon_cs_parser *p,
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
1.9.1

