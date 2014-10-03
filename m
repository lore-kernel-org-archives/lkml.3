Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbaJDAke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:40:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbaJCVmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tim Bird <tbird20d@gmail.com>, Peter Chen <peter.chen@freescale.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH 3.16 124/357] usb: chipidea: msm: Initialize PHY on reset event
Date: Fri,  3 Oct 2014 14:28:30 -0700
Message-Id: <20141003212937.199480906@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

commit 233c7daf4eecd1e992dc42591182cd4a892e687c upstream.

Initialize USB PHY after every Link controller reset

Cc: Tim Bird <tbird20d@gmail.com>
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/ci_hdrc_msm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -26,6 +26,7 @@ static void ci_hdrc_msm_notify_event(str
 		dev_dbg(dev, "CI_HDRC_CONTROLLER_RESET_EVENT received\n");
 		writel(0, USB_AHBBURST);
 		writel(0, USB_AHBMODE);
+		usb_phy_init(ci->transceiver);
 		break;
 	case CI_HDRC_CONTROLLER_STOPPED_EVENT:
 		dev_dbg(dev, "CI_HDRC_CONTROLLER_STOPPED_EVENT received\n");


