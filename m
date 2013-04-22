Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab3DVOh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:37:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51619 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984Ab3DVOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Grant Likely" <grant.likely@secretlab.ca>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Rob Herring" <rob.herring@calxeda.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.250320091@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [45/75] of: introduce helper to manage boolean
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

commit fa4d34ccd0914ac87336ea2c17e9370dfecef286 upstream.

of_property_read_bool

Search for a property in a device node.
Returns true if the property exist false otherwise.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Rob Herring <rob.herring@calxeda.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/of.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -336,6 +336,22 @@ static inline int of_machine_is_compatib
 #define of_match_node(_matches, _node)	NULL
 #endif /* CONFIG_OF */
 
+/**
+ * of_property_read_bool - Findfrom a property
+ * @np:		device node from which the property value is to be read.
+ * @propname:	name of the property to be searched.
+ *
+ * Search for a property in a device node.
+ * Returns true if the property exist false otherwise.
+ */
+static inline bool of_property_read_bool(const struct device_node *np,
+					 const char *propname)
+{
+	struct property *prop = of_find_property(np, propname, NULL);
+
+	return prop ? true : false;
+}
+
 static inline int of_property_read_u32(const struct device_node *np,
 				       const char *propname,
 				       u32 *out_value)

