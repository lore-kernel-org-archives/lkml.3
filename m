Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422632AbaDPPNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:13:49 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:56864 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344AbaDPPNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:13:48 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: mmarek@suse.cz, akpm@linux-foundation.org,
        michael.opdenacker@free-electrons.com, prarit@redhat.com,
        tkhai@yandex.ru, nasa4836@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/tags.sh: add pattern for DEFINE_HASHTABLE
Date: Wed, 16 Apr 2014 23:13:34 +0800
Message-Id: <1397661214-4218-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 scripts/tags.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 7122fea..a5d27db 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -205,7 +205,8 @@ exuberant()
 	--regex-c='/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/'	\
 	--regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'		\
 	--regex-c='/(^\s)OFFSET\((\w*)/\2/v/'				\
-	--regex-c='/(^\s)DEFINE\((\w*)/\2/v/'
+	--regex-c='/(^\s)DEFINE\((\w*)/\2/v/'				\
+	--regex-c='/DEFINE_HASHTABLE\((\w*)/\1/v/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -254,7 +255,8 @@ emacs()
 	--regex='/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/' \
 	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
 	--regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
-	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'
+	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'\
+	--regex='/DEFINE_HASHTABLE\((\w*)/\1/v/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
-- 
1.9.0.GIT

