Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab3E1D5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:57:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52711 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758953Ab3E1Dyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jason Cooper" <jason@lakedaemon.net>,
        "Marek Vasut" <marex@denx.de>, "Andrew Lunn" <andrew@lunn.ch>,
        "Martin Michlmayr" <tbm@cyrius.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.436541183@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [31/94] Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-kirkwood/ts219-setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

