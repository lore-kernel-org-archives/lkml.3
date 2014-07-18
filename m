Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761540AbaGRNhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:37:00 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17687 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761906AbaGRNNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:13:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 083/170] drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission
Date: Fri, 18 Jul 2014 14:11:28 +0200
Message-Id: <20badb285d5c13d6c4c8ab2a47203d73378da50b.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Olšák <marek.olsak@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ec65da385d46f63740c1c9230b891a6dcbd64c71 upstream.

It hangs the hardware.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_cs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index b2b8b38f0319..ed9a997c99a3 100644
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
2.0.0

