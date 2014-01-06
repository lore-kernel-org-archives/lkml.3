Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000AbaAGALn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:11:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbaAFWiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Peter Chen <peter.chen@freescale.com>
Subject: [PATCH 3.12 027/144] usb: chipidea: host: Only disable the vbus regulator if it is not NULL
Date: Mon,  6 Jan 2014 14:36:28 -0800
Message-Id: <20140106223746.103454233@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit cc5c9eb67f912cb2c349b04063ff9f444affbc59 upstream.

Commit 40ed51a4b (usb: chipidea: host: add vbus regulator
control) introduced a smatch complaint because regulator_disable() is called
without checking whether ci->platdata->reg_vbus is not NULL.

Fix this by adding the check.

This patch is needed for 3.12 stable

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/host.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/host.c
+++ b/drivers/usb/chipidea/host.c
@@ -88,7 +88,8 @@ static int host_start(struct ci_hdrc *ci
 	return ret;
 
 disable_reg:
-	regulator_disable(ci->platdata->reg_vbus);
+	if (ci->platdata->reg_vbus)
+		regulator_disable(ci->platdata->reg_vbus);
 
 put_hcd:
 	usb_put_hcd(hcd);


