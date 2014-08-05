Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaHEMJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:09:04 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:59400 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaHEMJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:09:01 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI/AER: Make linux/aer.h standalone includable
Date: Tue,  5 Aug 2014 14:08:55 +0200
Message-Id: <1407240535-19564-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The header file references u16, u32 and struct pci_dev types, but they
are not defined in the header nor does the header pull in the necessary
includes for them. This causes build breakage when the file is included
without any of the dependencies being satisfied from somewhere else.

Fix this by including linux/types.h (for u16 and u32) and by adding a
forward-declaration of struct pci_dev.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/linux/aer.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/aer.h b/include/linux/aer.h
index 4dbaa7081530..04bcf33a3e3a 100644
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@ -7,6 +7,10 @@
 #ifndef _AER_H_
 #define _AER_H_
 
+#include <linux/types.h>
+
+struct pci_dev;
+
 #define AER_NONFATAL			0
 #define AER_FATAL			1
 #define AER_CORRECTABLE			2
-- 
2.0.4

