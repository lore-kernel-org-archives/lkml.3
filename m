Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3LQQUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:20:53 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53071 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab3LQQUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:20:20 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-sctp@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] printk: Add a DEPRECATED macro
Date: Tue, 17 Dec 2013 11:19:58 -0500
Message-Id: <1387297199-14363-2-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387297199-14363-1-git-send-email-nhorman@tuxdriver.com>
References: <1387205049-22752-1-git-send-email-nhorman@tuxdriver.com>
 <1387297199-14363-1-git-send-email-nhorman@tuxdriver.com>
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sctp has several points in its setsockopt path in which it issues deprecation
warnings.  It seems like it might be handy to macrotize such a warning so other
subsystems can use it easily

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "David S. Miller" <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org

---
Change Notes:

v3)
* Convert to using a string prefix rather than a specific pr_ macro
---
 include/linux/printk.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 6949258..26fb95c 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -88,6 +88,13 @@ struct va_format {
 #define HW_ERR		"[Hardware Error]: "
 
 /*
+ * DEPRECATED
+ * Add this to a message whenever you want to warn user space about the use
+ * of a deprecated aspect of an API so they can stop using it
+ */
+#define DEPRECATED	"[Deprecated]: "
+
+/*
  * Dummy printk for disabled debugging statements to use whilst maintaining
  * gcc's format and side-effect checking.
  */
-- 
1.8.3.1

