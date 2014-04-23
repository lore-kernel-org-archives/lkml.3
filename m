Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaDWM3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:29:13 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56633 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbaDWM3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:29:02 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v4 3/3] usb: chipidea: msm: Initialize offset of the capability registers
Date: Wed, 23 Apr 2014 15:28:04 +0300
Message-Id: <1398256084-6815-4-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398256084-6815-1-git-send-email-iivanov@mm-sol.com>
References: <1398256084-6815-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Since commit 62bb84e (usb: gadget: ci13xxx: convert to platform device)
start address of the capability registers is not passed correctly to
udc_probe(). Fix this.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/chipidea/ci_hdrc_msm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index 736aeb2..d72b9d2 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -47,6 +47,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)

 static struct ci_hdrc_platform_data ci_hdrc_msm_platdata = {
 	.name			= "ci_hdrc_msm",
+	.capoffset		= DEF_CAPOFFSET,
 	.flags			= CI_HDRC_REGS_SHARED |
 				  CI_HDRC_REQUIRE_TRANSCEIVER |
 				  CI_HDRC_DISABLE_STREAMING,
--
1.8.3.2

