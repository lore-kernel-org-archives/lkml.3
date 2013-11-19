Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3KSJdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:33:46 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:18819 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab3KSJdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:33:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 19 Nov 2013 01:27:45 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <swarren@nvidia.com>, <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <swarren@wwwdotorg.org>,
        <galak@codeaurora.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lorenzo.pieralisi@arm.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv5 1/9] of: introduce of_property_for_earch_phandle_with_args()
Date: Tue, 19 Nov 2013 11:33:05 +0200
Message-ID: <1384853593-32202-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
References: <1384853593-32202-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following pattern of code is tempting:

  for (i = 0; !of_parse_phandle_with_args(np, list, cells, i, args); i++)

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v5:
New patch for v5.
---
 include/linux/of.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 276c546..131fef5 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -613,6 +613,9 @@ static inline int of_property_read_u32(const struct device_node *np,
 		s;						\
 		s = of_prop_next_string(prop, s))
 
+#define of_property_for_each_phandle_with_args(np, list, cells, i, args) \
+	for (i = 0; !of_parse_phandle_with_args(np, list, cells, i, args); i++)
+
 #if defined(CONFIG_PROC_FS) && defined(CONFIG_PROC_DEVICETREE)
 extern void proc_device_tree_add_node(struct device_node *, struct proc_dir_entry *);
 extern void proc_device_tree_add_prop(struct proc_dir_entry *pde, struct property *prop);
-- 
1.8.1.5

