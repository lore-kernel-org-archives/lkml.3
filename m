Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaDANDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:03:51 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56698 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaDANDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:03:48 -0400
Message-ID: <533AB930.7050402@gmail.com>
Date: Tue, 01 Apr 2014 15:03:44 +0200
From: Neil Armstrong <superna9999@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org, chad@dahc.us, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com
Subject: [PATCH] Staging: silicom: fix dangerous if condition in bpctl_mod.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch script returns the following warning:
ERROR: do not use assignment in if condition
+                       if (((dev_num = get_dev_idx(dev->ifindex)) ==
            -1) |

This patch fixes the if condition by splitting it.

Signed-off-by: Neil Armstrong <superna9999@gmail.com>
---
 drivers/staging/silicom/bpctl_mod.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 6b9365b..3b4db2a 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -220,8 +220,12 @@ static int bp_device_event(struct notifier_block *unused,
 			if (netif_carrier_ok(dev))
 				return NOTIFY_DONE;
 
-			if (((dev_num = get_dev_idx(dev->ifindex)) == -1) ||
-			    (!(pbpctl_dev = &bpctl_dev_arr[dev_num])))
+			dev_num = get_dev_idx(dev->ifindex);
+			if (dev_num == -1)
+				return NOTIFY_DONE;
+
+			pbpctl_dev = &bpctl_dev_arr[dev_num];
+			if (!pbpctl_dev)
 				return NOTIFY_DONE;
 
 			if ((is_bypass_fn(pbpctl_dev)) == 1)
-- 
1.7.0.4
