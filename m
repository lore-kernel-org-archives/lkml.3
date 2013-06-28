Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3F1TUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:20:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41509 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3F1Sw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:52:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Michlmayr <tbm@cyrius.com>, Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 014/105] Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x
Date: Fri, 28 Jun 2013 11:50:36 -0700
Message-Id: <1372445527-24414-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Michlmayr <tbm@cyrius.com>

commit 99e11334dcb846f9b76fb808196c7f47aa83abb3 upstream.

Enable KW_PCIE1 on QNAP TS-11x/TS-21x devices as newer revisions
(rev 1.3) have a USB 3.0 chip from Etron on PCIe port 1.  Thanks
to Marek Vasut for identifying this issue!

Signed-off-by: Martin Michlmayr <tbm@cyrius.com>
Tested-by: Marek Vasut <marex@denx.de>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-kirkwood/ts219-setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-kirkwood/ts219-setup.c b/arch/arm/mach-kirkwood/ts219-setup.c
index 73e2b6c..3a73fc7 100644
--- a/arch/arm/mach-kirkwood/ts219-setup.c
+++ b/arch/arm/mach-kirkwood/ts219-setup.c
@@ -124,7 +124,7 @@ static void __init qnap_ts219_init(void)
 static int __init ts219_pci_init(void)
 {
 	if (machine_is_ts219())
-		kirkwood_pcie_init(KW_PCIE0);
+		kirkwood_pcie_init(KW_PCIE1 | KW_PCIE0);
 
 	return 0;
 }
-- 
1.8.1.2

