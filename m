Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaAFUJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:09:34 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:49346 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754806AbaAFUJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:09:33 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2014 15:09:33 EST
From: Shuah Khan <shuah.kh@samsung.com>
To: gregkh@linuxfoundation.org, rjw@rjwysocki.net
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] drivers/bus: Add Legacy PM OPS usage check and warning to bus_register()
Date: Mon,  6 Jan 2014 13:03:21 -0700
Message-Id: <1b1d24cd7140784f96b9d1fee9cace9da04a88f5.1389034060.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1389034060.git.shuah.kh@samsung.com>
References: <cover.1389034060.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1389034060.git.shuah.kh@samsung.com>
References: <cover.1389034060.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Legacy PM OPS usage checks to bus_register() function. If Legacy PM OPS
usage is found, print warning message to indicate that the driver code needs
updating to use Dev PM OPS interfaces. This will help serve as a way to track
drivers that still use Legacy PM OPS and fix them.

The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
resume(struct device *) bus level interfaces.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/bus.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 73f6c29..e8753a7 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -916,6 +916,9 @@ int bus_register(struct bus_type *bus)
 		goto bus_groups_fail;
 
 	pr_debug("bus: '%s': registered\n", bus->name);
+	if (bus->suspend || bus->resume)
+		pr_warn("bus '%s' needs updating - use pm pointer.\n",
+			bus->name);
 	return 0;
 
 bus_groups_fail:
-- 
1.8.3.2

