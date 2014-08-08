Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbaHHW2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:28:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaHHUob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:44:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 175/259] drm/radeon: fix cut and paste issue for hawaii.
Date: Fri,  8 Aug 2014 13:39:58 -0700
Message-Id: <1407530482-4483-176-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 1b2c4869d8247f9e202fa8a73777c34adc62d409 upstream.

This is a halfway fix for hawaii acceleration. More fixes to come
but hopefully isolated to userspace.

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 950c94a..17649ac 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -2219,6 +2219,7 @@ static void cik_tiling_mode_table_init(struct radeon_device *rdev)
 				gb_tile_moden = 0;
 				break;
 			}
+			rdev->config.cik.macrotile_mode_array[reg_offset] = gb_tile_moden;
 			WREG32(GB_MACROTILE_MODE0 + (reg_offset * 4), gb_tile_moden);
 		}
 	} else if (num_pipe_configs == 8) {
-- 
1.9.1

