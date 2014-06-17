Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966953AbaFQVv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:51:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965856AbaFQVvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 186/212] drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission
Date: Tue, 17 Jun 2014 14:44:40 -0700
Message-Id: <1403041506-13646-187-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>

commit ec65da385d46f63740c1c9230b891a6dcbd64c71 upstream.

It hangs the hardware.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_cs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 8093a25..f2fc07c 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -97,6 +97,12 @@ static int radeon_cs_parser_relocs(struct radeon_cs_parser *p)
 			uint32_t domain = r->write_domain ?
 				r->write_domain : r->read_domains;
 
+			if (domain & RADEON_GEM_DOMAIN_CPU) {
+				DRM_ERROR("RADEON_GEM_DOMAIN_CPU is not valid "
+					  "for command submission\n");
+				return -EINVAL;
+			}
+
 			p->relocs[i].lobj.domain = domain;
 			if (domain == RADEON_GEM_DOMAIN_VRAM)
 				domain |= RADEON_GEM_DOMAIN_GTT;
-- 
1.9.1

