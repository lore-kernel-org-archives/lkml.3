Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbaGUQbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 12:31:43 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3493 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbaGUQbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 12:31:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 21 Jul 2014 09:19:16 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH] PCI/AER: Forward declare struct pci_dev to avoid warning
Date: Mon, 21 Jul 2014 19:30:43 +0300
Message-ID: <1405960243-589-1-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward declaring struct pci_dev in aer.h avoids this warning:

In file included from include/ras/ras_event.h:11:0,
                 from drivers/ras/ras.c:13:
include/linux/aer.h:38:44: warning: 'struct pci_dev’ declared inside parameter list [enabled by default]
include/linux/aer.h:38:44: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 include/linux/aer.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/aer.h b/include/linux/aer.h
index 4dbaa70..d9ec8dd 100644
--- a/include/linux/aer.h
+++ b/include/linux/aer.h
@@ -7,6 +7,8 @@
 #ifndef _AER_H_
 #define _AER_H_
 
+struct pci_dev;
+
 #define AER_NONFATAL			0
 #define AER_FATAL			1
 #define AER_CORRECTABLE			2
-- 
1.8.1.5

