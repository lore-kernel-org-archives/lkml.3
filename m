Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaA3Ktk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 05:49:40 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:36554 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051AbaA3Ktg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 05:49:36 -0500
From: Mohit Kumar <mohit.kumar@st.com>
To: <arnd@arndb.de>
Cc: Pratyush Anand <pratyush.anand@st.com>, Mohit Kumar <mohit.kumar@st.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <spear-devel@list.st.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V3 4/8] phy: Initialize phy core with subsys_initcall
Date: Thu, 30 Jan 2014 16:18:46 +0530
Message-ID: <6f2dbd4fcb99a070c07b39545d98eca58101daa0.1391077731.git.mohit.kumar@st.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <cover.1391077731.git.mohit.kumar@st.com>
References: <cover.1391077731.git.mohit.kumar@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratyush Anand <pratyush.anand@st.com>

PCIe RC drivers are initialized with subsys_initcall. Few PCIe drivers
like SPEAr13xx needs phy drivers to be initialized.

Therefore initialize phy core driver with subsys_initcall to avoid
calling of phy_get before phy_class is created.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Cc: Mohit Kumar <mohit.kumar@st.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: spear-devel@list.st.com
Cc: linux-kernel@vger.kernel.org
---
 drivers/phy/phy-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..fa73101 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -685,7 +685,7 @@ static int __init phy_core_init(void)
 
 	return 0;
 }
-module_init(phy_core_init);
+subsys_initcall(phy_core_init);
 
 static void __exit phy_core_exit(void)
 {
-- 
1.7.0.1

