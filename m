Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbbAGCOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:14:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038AbbAGCHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 3.14 30/52] thermal: Fix error path in thermal_init()
Date: Tue,  6 Jan 2015 18:06:58 -0800
Message-Id: <20150107020600.039948151@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis.henriques@canonical.com>

commit 9d367e5e7b05c71a8c1ac4e9b6e00ba45a79f2fc upstream.

thermal_unregister_governors() and class_unregister() were being called in
the wrong order.

Fixes: 80a26a5c22b9 ("Thermal: build thermal governors into thermal_sys module")
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thermal/thermal_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1824,10 +1824,10 @@ static int __init thermal_init(void)
 
 exit_netlink:
 	genetlink_exit();
-unregister_governors:
-	thermal_unregister_governors();
 unregister_class:
 	class_unregister(&thermal_class);
+unregister_governors:
+	thermal_unregister_governors();
 error:
 	idr_destroy(&thermal_tz_idr);
 	idr_destroy(&thermal_cdev_idr);


