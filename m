Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaAGNLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:11:15 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:46016 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaAGNLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:11:06 -0500
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 21:11:05 +0800
Message-ID: <CAPgLHd886_=FOPw5MFRRzdpfRU63nW=eR0sVF+vAzw7TnHHByA@mail.gmail.com>
Subject: [PATCH -next] xen-platform: fix error return code in platform_pci_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: yongjun_wei@trendmicro.com.cn, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, otherwise the error condition cann't be
reflected from the return value.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/xen/platform-pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index f1947ac..a1361c3 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -156,7 +156,8 @@ static int platform_pci_init(struct pci_dev *pdev,
 
 	max_nr_gframes = gnttab_max_grant_frames();
 	grant_frames = alloc_xen_mmio(PAGE_SIZE * max_nr_gframes);
-	if (gnttab_setup_auto_xlat_frames(grant_frames))
+	ret = gnttab_setup_auto_xlat_frames(grant_frames);
+	if (ret)
 		goto out;
 	ret = gnttab_init();
 	if (ret)

