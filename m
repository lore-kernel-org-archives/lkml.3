Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3JJPt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:49:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52945 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3JJPtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 067/104] staging: vt6656: [BUG] iwctl_siwencodeext return if device not open
Date: Thu, 10 Oct 2013 08:41:55 -0700
Message-Id: <1381419752-29733-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 5e8c3d3e41b0bf241e830a1ee0752405adecc050 upstream.

Don't allow entry to iwctl_siwencodeext if device not open.

This fixes a race condition where wpa supplicant/network manager
enters the function when the device is already closed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/vt6656/iwctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 9f2f1be..e37dcb5 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1637,6 +1637,9 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	if (pMgmt == NULL)
 		return -EFAULT;
 
+	if (!(pDevice->flags & DEVICE_FLAGS_OPENED))
+		return -ENODEV;
+
 	buf = kzalloc(sizeof(struct viawget_wpa_param), GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
-- 
1.8.1.2

