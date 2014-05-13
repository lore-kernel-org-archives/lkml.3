Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaEMGng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:43:36 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57399 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaEMGnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:43:35 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: mmarek@suse.cz, akpm@linux-foundation.org,
        michael.opdenacker@free-electrons.com, prarit@redhat.com,
        tkhai@yandex.ru, nasa4836@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scripts/tags.sh: add regular expression replacement pattern for memcg
Date: Tue, 13 May 2014 14:43:20 +0800
Message-Id: <1399963400-7982-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 2.0.0-rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Marek.

Since previous one has got no replies. I resend it again.
This patch purely add regex pattern only. And I've tested it, it works.

---<8---
Currently, no regular expression replacement pattern for PageCgroug*
defined, which causes quite a few pain while reading code. Just get
rid of it.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 scripts/tags.sh | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index f2c5b00..7d3ebfe 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -187,6 +187,10 @@ exuberant()
 	--regex-c++='/TESTCLEARFLAG_FALSE\(([^,)]*).*/TestClearPage\1/' \
 	--regex-c++='/__TESTCLEARFLAG_FALSE\(([^,)]*).*/__TestClearPage\1/' \
 	--regex-c++='/_PE\(([^,)]*).*/PEVENT_ERRNO__\1/'		\
+	--regex-c++='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'		\
+	--regex-c++='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'		\
+	--regex-c++='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
+	--regex-c++='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
 	--regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
 	--regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
 	--regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'	\
@@ -244,6 +248,10 @@ emacs()
 	--regex='/__CLEARPAGEFLAG_NOOP(\([^,)]*\).*/__ClearPage\1/' \
 	--regex='/TESTCLEARFLAG_FALSE(\([^,)]*\).*/TestClearPage\1/' \
 	--regex='/__TESTCLEARFLAG_FALSE(\([^,)]*\).*/__TestClearPage\1/' \
+	--regex='/TESTPCGFLAG\(([^,)]*).*/PageCgroup\1/'	\
+	--regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'	\
+	--regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'	\
+	--regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
 	--regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'		\
 	--regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
 	--regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'
-- 
2.0.0-rc1

