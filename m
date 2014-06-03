Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaFCLkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:40:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43241 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaFCLkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Leo Liu <leo.liu@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 013/138] drm/radeon: check buffer relocation offset
Date: Tue,  3 Jun 2014 12:37:39 +0100
Message-Id: <1401795584-22664-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Liu <leo.liu@amd.com>

commit 695daf1a8e731a4b5b89de89a61f32a4d7ad7094 upstream.

Signed-off-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_uvd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_uvd.c b/drivers/gpu/drm/radeon/radeon_uvd.c
index 26b107d13be1..af81d123db80 100644
--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -454,6 +454,10 @@ static int radeon_uvd_cs_reloc(struct radeon_cs_parser *p,
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

