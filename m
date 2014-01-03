Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaACQHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:07:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaACQHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:07:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/7] Make for_each_child_of_node() reference its args when
 CONFIG_OF=n
From: David Howells <dhowells@redhat.com>
To: akpm@linux-foundation.org
Cc: Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        dhowells@redhat.com, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Jan 2014 16:07:23 +0000
Message-ID: <20140103160723.8153.14334.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make for_each_child_of_node() reference its args when CONFIG_OF=n to avoid
warnings like:

	drivers/leds/leds-pwm.c:88:22: warning: unused variable 'node' [-Wunused-variable]
	  struct device_node *node = pdev->dev.of_node;
			      ^

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Grant Likely <grant.likely@linaro.org>
cc: Rob Herring <robh+dt@kernel.org>
cc: devicetree@vger.kernel.org
---

 include/linux/of.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 276c546980d8..70c64ba17fa5 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -377,8 +377,13 @@ static inline bool of_have_populated_dt(void)
 	return false;
 }
 
+/* Kill an unused variable warning on a device_node pointer */
+static inline void __of_use_dn(const struct device_node *np)
+{
+}
+
 #define for_each_child_of_node(parent, child) \
-	while (0)
+	while (__of_use_dn(parent), __of_use_dn(child), 0)
 
 #define for_each_available_child_of_node(parent, child) \
 	while (0)

