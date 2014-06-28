Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaF1Ueu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 16:34:50 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:33262 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaF1Ueg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 16:34:36 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney.cavm@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 3/3] MIPS: OCTEON: add interface & port definitions for D-Link DSR-1000N
Date: Sat, 28 Jun 2014 23:34:10 +0300
Message-Id: <1403987650-6194-4-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403987650-6194-1-git-send-email-aaro.koskinen@iki.fi>
References: <1403987650-6194-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add interface & port definitions for D-Link DSR-1000N.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 .../cavium-octeon/executive/cvmx-helper-board.c     | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
index 6c871a5..5dfef84 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-helper-board.c
@@ -186,6 +186,15 @@ int cvmx_helper_board_get_mii_address(int ipd_port)
 			return 7 - ipd_port;
 		else
 			return -1;
+	case CVMX_BOARD_TYPE_CUST_DSR1000N:
+		/*
+		 * Port 2 connects to Broadcom PHY (B5081). Other ports (0-1)
+		 * connect to a switch (BCM53115).
+		 */
+		if (ipd_port == 2)
+			return 8;
+		else
+			return -1;
 	}
 
 	/* Some unknown board. Somebody forgot to update this function... */
@@ -274,6 +283,18 @@ cvmx_helper_link_info_t __cvmx_helper_board_link_get(int ipd_port)
 			return result;
 		}
 		break;
+	case CVMX_BOARD_TYPE_CUST_DSR1000N:
+		if (ipd_port == 0 || ipd_port == 1) {
+			/* Ports 0 and 1 connect to a switch (BCM53115). */
+			result.s.link_up = 1;
+			result.s.full_duplex = 1;
+			result.s.speed = 1000;
+			return result;
+		} else {
+			/* Port 2 uses a Broadcom PHY (B5081). */
+			is_broadcom_phy = 1;
+		}
+		break;
 	}
 
 	phy_addr = cvmx_helper_board_get_mii_address(ipd_port);
-- 
2.0.0

