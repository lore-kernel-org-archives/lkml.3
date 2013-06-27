Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3F0NAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:00:31 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57954 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3F0NA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:00:29 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Michael Buesch <m@bues.ch>, Jiri Kosina <trivial@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 6/6] ssb/trivial: replace numeric with standard PM state macros
Date: Thu, 27 Jun 2013 21:00:11 +0800
Message-ID: <1372338011-29248-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard PM state macros PCI_Dx instead of numeric 0/1/2..

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/ssb/pcihost_wrapper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/pcihost_wrapper.c b/drivers/ssb/pcihost_wrapper.c
index 32ed1fa..69161bb 100644
--- a/drivers/ssb/pcihost_wrapper.c
+++ b/drivers/ssb/pcihost_wrapper.c
@@ -38,7 +38,7 @@ static int ssb_pcihost_resume(struct pci_dev *dev)
 	struct ssb_bus *ssb = pci_get_drvdata(dev);
 	int err;
 
-	pci_set_power_state(dev, 0);
+	pci_set_power_state(dev, PCI_D0);
 	err = pci_enable_device(dev);
 	if (err)
 		return err;
-- 
1.7.1


