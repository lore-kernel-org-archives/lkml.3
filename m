Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbbAYSiS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:38:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912AbbAYSKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vasu Dev <vasu.dev@intel.com>, Jim Young <jamesx.m.young@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 119/183] i40e: adds FCoE configure option
Date: Sun, 25 Jan 2015 10:07:21 -0800
Message-Id: <20150125180815.357215506@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasu Dev <vasu.dev@intel.com>

commit 776d4e9f5c0229037707f692b386b1f2a5bac054 upstream.

Adds FCoE config option I40E_FCOE, so that FCoE can be enabled
as needed but otherwise have it disabled by default.

This also eliminate multiple FCoE config checks, instead now just
one config check for CONFIG_I40E_FCOE.

The I40E FCoE was added with 3.17 kernel and therefore this patch
shall be applied to stable 3.17 kernel also.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Jim Young <jamesx.m.young@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 5b8300a32bf5..4d61ef50b465 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -281,6 +281,17 @@ config I40E_DCB
 
 	  If unsure, say N.
 
+config I40E_FCOE
+	bool "Fibre Channel over Ethernet (FCoE)"
+	default n
+	depends on I40E && DCB && FCOE
+	---help---
+	  Say Y here if you want to use Fibre Channel over Ethernet (FCoE)
+	  in the driver. This will create new netdev for exclusive FCoE
+	  use with XL710 FCoE offloads enabled.
+
+	  If unsure, say N.
+
 config I40EVF
 	tristate "Intel(R) XL710 X710 Virtual Function Ethernet support"
 	depends on PCI_MSI
diff --git a/drivers/net/ethernet/intel/i40e/Makefile b/drivers/net/ethernet/intel/i40e/Makefile
index 4b94ddb29c24..c40581999121 100644
--- a/drivers/net/ethernet/intel/i40e/Makefile
+++ b/drivers/net/ethernet/intel/i40e/Makefile
@@ -44,4 +44,4 @@ i40e-objs := i40e_main.o \
 	i40e_virtchnl_pf.o
 
 i40e-$(CONFIG_I40E_DCB) += i40e_dcb.o i40e_dcb_nl.o
-i40e-$(CONFIG_FCOE:m=y) += i40e_fcoe.o
+i40e-$(CONFIG_I40E_FCOE) += i40e_fcoe.o
diff --git a/drivers/net/ethernet/intel/i40e/i40e_osdep.h b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
index 045b5c4b98b3..ad802dd0f67a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_osdep.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_osdep.h
@@ -78,7 +78,7 @@ do {                                                            \
 } while (0)
 
 typedef enum i40e_status_code i40e_status;
-#if defined(CONFIG_FCOE) || defined(CONFIG_FCOE_MODULE)
+#ifdef CONFIG_I40E_FCOE
 #define I40E_FCOE
-#endif /* CONFIG_FCOE or CONFIG_FCOE_MODULE */
+#endif
 #endif /* _I40E_OSDEP_H_ */


