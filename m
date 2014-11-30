Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaK3Pb0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 10:31:26 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:8029 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaK3PbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 10:31:25 -0500
X-IronPort-AV: E=Sophos;i="5.07,487,1413270000"; 
   d="scan'208";a="51906536"
From: Arend van Spriel <arend@broadcom.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] fs: debugfs: add forward declaration for struct device type
Date: Sun, 30 Nov 2014 16:31:21 +0100
Message-ID: <1417361481-1136-1-git-send-email-arend@broadcom.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function debugfs_create_devm_seqfile() has a parameter of type
struct device pointer. This type needs to be forward declared to
avoid compilation issues on certain architectures and/or kernel
configurations. The function was introduced with:

  commit 98210b7f73f1db182bd9a558a031093cd166e907
  Author: Arend van Spriel <arend@broadcom.com>
  Date:   Sun Nov 9 11:31:58 2014 +0100

     debugfs: add helper function to create device related seq_file

The reported build failure for sparc64 architecture was:

  make.cross ARCH=sparc64

All warnings:

   In file included from fs/debugfs/file.c:21:0:
   include/linux/debugfs.h:105:10: warning: 'struct device' declared
   inside parameter list
             void *data));
             ^

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/linux/debugfs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 4bbe2ac..e3e9f31 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -20,6 +20,7 @@
 
 #include <linux/types.h>
 
+struct device;
 struct file_operations;
 
 struct debugfs_blob_wrapper {
-- 
1.9.1

