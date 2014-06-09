Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935613AbaFIXDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:03:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847AbaFIWpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.14 51/78] Bluetooth: Fix L2CAP LE debugfs entries permissions
Date: Mon,  9 Jun 2014 15:48:31 -0700
Message-Id: <20140609224814.997090128@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Ortiz <sameo@linux.intel.com>

commit 40b9397a1a61a37917b93e7d57e6f2faf3a086b4 upstream.

0466 was probably meant to be 0644, there's no reason why everyone
except root could write there.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/l2cap_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7471,9 +7471,9 @@ int __init l2cap_init(void)
 	l2cap_debugfs = debugfs_create_file("l2cap", 0444, bt_debugfs,
 					    NULL, &l2cap_debugfs_fops);
 
-	debugfs_create_u16("l2cap_le_max_credits", 0466, bt_debugfs,
+	debugfs_create_u16("l2cap_le_max_credits", 0644, bt_debugfs,
 			   &le_max_credits);
-	debugfs_create_u16("l2cap_le_default_mps", 0466, bt_debugfs,
+	debugfs_create_u16("l2cap_le_default_mps", 0644, bt_debugfs,
 			   &le_default_mps);
 
 	bt_6lowpan_init();


