Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbaLWS6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:58:24 -0500
Received: from www.osadl.org ([62.245.132.105]:34167 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaLWS6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:58:23 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-usb@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] gadget: cleanup on stack DECLARE_COMPLETIONs
Date: Tue, 23 Dec 2014 19:50:14 +0100
Message-Id: <1419360614-23898-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixups for incorrect use of DECLARE_COMPLETION. see also commit
6e9a4738 ("completions: lockdep annotate on stack completions")

patch is against 3.18.0 linux-next

This was only code reviewed and compile tested

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/usb/gadget/udc/fsl_qe_udc.c   |    2 +-
 drivers/usb/gadget/udc/fsl_udc_core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/fsl_qe_udc.c b/drivers/usb/gadget/udc/fsl_qe_udc.c
index 795c99c..e0822f1 100644
--- a/drivers/usb/gadget/udc/fsl_qe_udc.c
+++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
@@ -2630,7 +2630,7 @@ static int qe_udc_remove(struct platform_device *ofdev)
 	struct qe_udc *udc = platform_get_drvdata(ofdev);
 	struct qe_ep *ep;
 	unsigned int size;
-	DECLARE_COMPLETION(done);
+	DECLARE_COMPLETION_ONSTACK(done);

 	usb_del_gadget_udc(&udc->gadget);

diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/udc/fsl_udc_core.c
index 2df8074..c3830ad 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2529,7 +2529,7 @@ static int __exit fsl_udc_remove(struct platform_device *pdev)
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);

-	DECLARE_COMPLETION(done);
+	DECLARE_COMPLETION_ONSTACK(done);

 	if (!udc_controller)
 		return -ENODEV;
--
1.7.10.4

