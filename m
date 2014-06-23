Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaFWNEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:04:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbaFWNEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 42/93] drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission
Date: Mon, 23 Jun 2014 14:02:21 +0100
Message-Id: <1403528592-2163-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>

commit ec65da385d46f63740c1c9230b891a6dcbd64c71 upstream.

It hangs the hardware.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_cs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index 41b170d25c08..ff35fa18d7ed 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -96,6 +96,12 @@ static int radeon_cs_parser_relocs(struct radeon_cs_parser *p)
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

