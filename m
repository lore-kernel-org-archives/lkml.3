Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105Ab3CTJaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:30:52 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42329 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab3CTJaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:30:46 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 09/30] compat: embrace LINUX_BACKPORT() for v2.6.31
Date: Wed, 20 Mar 2013 02:22:34 -0700
Message-Id: <1363771375-31715-10-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/linux/compat-2.6.31.h |   65 +++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 42 deletions(-)

diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index ce90f0a..096c131 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -25,25 +25,19 @@
 #define ADVERTISED_10000baseKR_Full    (1 << 19)
 #define ADVERTISED_10000baseR_FEC      (1 << 20)
 
-/*
- * These macros allow us to backport rfkill without any
- * changes on cfg80211 through compat.diff. Note that this
- * file will be included by rfkill_backport.h so we must
- * not conflict with things there.
- */
-#define rfkill_get_led_trigger_name	backport_rfkill_get_led_trigger_name
-#define rfkill_set_led_trigger_name	backport_rfkill_set_led_trigger_name
-#define rfkill_set_hw_state	backport_rfkill_set_hw_state
-#define rfkill_set_sw_state	backport_rfkill_set_sw_state
-#define rfkill_init_sw_state	backport_rfkill_init_sw_state
-#define rfkill_set_states	backport_rfkill_set_states
-#define rfkill_pause_polling	backport_rfkill_pause_polling
-#define rfkill_resume_polling	backport_rfkill_resume_polling
-#define rfkill_blocked		backport_rfkill_blocked
-#define rfkill_alloc		backport_rfkill_alloc
-#define rfkill_register		backport_rfkill_register
-#define rfkill_unregister	backport_rfkill_unregister
-#define rfkill_destroy		backport_rfkill_destroy
+#define rfkill_get_led_trigger_name LINUX_BACKPORT(rfkill_get_led_trigger_name)
+#define rfkill_set_led_trigger_name LINUX_BACKPORT(rfkill_set_led_trigger_name)
+#define rfkill_set_hw_state LINUX_BACKPORT(rfkill_set_hw_state)
+#define rfkill_set_sw_state LINUX_BACKPORT(rfkill_set_sw_state)
+#define rfkill_init_sw_state LINUX_BACKPORT(rfkill_init_sw_state)
+#define rfkill_set_states LINUX_BACKPORT(rfkill_set_states)
+#define rfkill_pause_polling LINUX_BACKPORT(rfkill_pause_polling)
+#define rfkill_resume_polling LINUX_BACKPORT(rfkill_resume_polling)
+#define rfkill_blocked LINUX_BACKPORT(rfkill_blocked)
+#define rfkill_alloc LINUX_BACKPORT(rfkill_alloc)
+#define rfkill_register LINUX_BACKPORT(rfkill_register)
+#define rfkill_unregister LINUX_BACKPORT(rfkill_unregister)
+#define rfkill_destroy LINUX_BACKPORT(rfkill_destroy)
 
 #ifndef ERFKILL
 #if !defined(CONFIG_ALPHA) && !defined(CONFIG_MIPS) && !defined(CONFIG_PARISC) && !defined(CONFIG_SPARC)
@@ -63,29 +57,14 @@
 #endif
 #endif
 
-/*
- * These changes allow us to backport and forward port
- * the driver/net/mdio module. What we do is simply
- * rename the exported symbols to other symbols and
- * rely on the fact that compat-drivers will take care
- * of renaming that module. This allows in-place drivers
- * to use the old module and have the newer supplied
- * drivers through compat-drivers to use the new bacported
- * module.
- *
- * XXX: maybe we should have a COMPAT_EXPORT_SYMBOL() that
- * takes care of renaming the symbols with a compat_ prefix?
- * There are other ideas of using a separate namespace for
- * modules supplied by compat -- someone already did the work
- * but never sent the patches ;) who are you out there ?
- */
-#define mdio45_probe			compat_mdio45_probe
-#define mdio_set_flag			compat_mdio_set_flag
-#define mdio45_links_ok			compat_mdio45_links_ok
-#define mdio45_nway_restart		compat_mdio45_nway_restart
-#define mdio45_ethtool_gset_npage	compat_mdio45_ethtool_gset_npage
-#define mdio45_ethtool_spauseparam_an	compat_mdio45_ethtool_spauseparam_an
-#define mdio_mii_ioctl			compat_mdio_mii_ioctl
+#define mdio45_probe LINUX_BACKPORT(mdio45_probe)
+#define mdio_set_flag LINUX_BACKPORT(mdio_set_flag)
+#define mdio45_links_ok LINUX_BACKPORT(mdio45_links_ok)
+#define mdio45_nway_restart LINUX_BACKPORT(mdio45_nway_restart)
+
+#define mdio45_ethtool_gset_npage LINUX_BACKPORT(mdio45_ethtool_gset_npage)
+#define mdio45_ethtool_spauseparam_an LINUX_BACKPORT(mdio45_ethtool_spauseparam_an)
+#define mdio_mii_ioctl LINUX_BACKPORT(mdio_mii_ioctl)
 
 #ifndef NETDEV_PRE_UP
 #define NETDEV_PRE_UP		0x000D
@@ -245,7 +224,9 @@ typedef struct {
 	long long counter;
 } atomic64_t;
 
+#define atomic64_read LINUX_BACKPORT(atomic64_read)
 extern long long atomic64_read(const atomic64_t *v);
+#define atomic64_add_return LINUX_BACKPORT(atomic64_add_return)
 extern long long atomic64_add_return(long long a, atomic64_t *v);
 
 #define atomic64_inc_return(v)          atomic64_add_return(1LL, (v))
-- 
1.7.10.4

