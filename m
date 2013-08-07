Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3HGKYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:24:16 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56339 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491Ab3HGKYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:24:13 -0400
Date: Wed, 7 Aug 2013 12:17:35 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 07/26] OF platform: export of_amba_device_create()
Message-ID: <71fa88b1d6a6800037e8da193b5d2b5a76cf417e.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed because the pci-amba bus will create one or more amba devices
for each probed pci device. We cannot create all the devices belonging to
the same amba bus with just one call to of_platform_populate()

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/of/platform.c       |   17 +++++++++--------
 include/linux/of_platform.h |    6 +++++-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index b0d1ff8..57c6bbe 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -249,10 +249,10 @@ struct platform_device *of_platform_device_create(struct device_node *np,
 EXPORT_SYMBOL(of_platform_device_create);
 
 #ifdef CONFIG_ARM_AMBA
-static struct amba_device *of_amba_device_create(struct device_node *node,
-						 const char *bus_id,
-						 void *platform_data,
-						 struct device *parent)
+struct amba_device *of_amba_device_create(struct device_node *node,
+					  const char *bus_id,
+					  void *platform_data,
+					  struct device *parent)
 {
 	struct amba_device *dev;
 	const void *prop;
@@ -304,14 +304,15 @@ err_free:
 	return NULL;
 }
 #else /* CONFIG_ARM_AMBA */
-static struct amba_device *of_amba_device_create(struct device_node *node,
-						 const char *bus_id,
-						 void *platform_data,
-						 struct device *parent)
+struct amba_device *of_amba_device_create(struct device_node *node,
+					  const char *bus_id,
+					  void *platform_data,
+					  struct device *parent)
 {
 	return NULL;
 }
 #endif /* CONFIG_ARM_AMBA */
+EXPORT_SYMBOL(of_amba_device_create);
 
 /**
  * of_devname_lookup() - Given a device node, lookup the preferred Linux name
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 05cb4a9..6cd5ac2 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -59,10 +59,14 @@ extern struct platform_device *of_device_alloc(struct device_node *np,
 					 struct device *parent);
 extern struct platform_device *of_find_device_by_node(struct device_node *np);
 
-/* Platform devices and busses creation */
+/* Platform and amba devices and busses creation */
 extern struct platform_device *of_platform_device_create(struct device_node *np,
 						   const char *bus_id,
 						   struct device *parent);
+extern struct amba_device *of_amba_device_create(struct device_node *node,
+						 const char *bus_id,
+						 void *platform_data,
+						 struct device *parent);
 
 extern int of_platform_bus_probe(struct device_node *root,
 				 const struct of_device_id *matches,
-- 
1.7.7.2
