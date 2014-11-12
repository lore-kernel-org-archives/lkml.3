Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbaKLBbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:31:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbaKLBa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:30:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Torsten Fleischer <to-fleischer@t-online.de>,
        Peter Chen <peter.chen@freescale.com>
Subject: [PATCH 3.17 221/319] usb: chipidea: Fix oops when removing the ci_hdrc module
Date: Wed, 12 Nov 2014 10:15:59 +0900
Message-Id: <20141112011029.337936450@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Fleischer <to-fleischer@t-online.de>

commit 9680b60ed79edaf52f84b65cbb20859bbb26cb68 upstream.

The call of 'kfree(ci->hw_bank.regmap)' in ci_hdrc_remove() sometimes causes
a kernel oops when removing the ci_hdrc module.

Since there is no separate memory allocated for the ci->hw_bank.regmap array,
there is no need to free it.

Signed-off-by: Torsten Fleischer <to-fleischer@t-online.de>
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -732,7 +732,6 @@ static int ci_hdrc_remove(struct platfor
 	ci_role_destroy(ci);
 	ci_hdrc_enter_lpm(ci, true);
 	usb_phy_shutdown(ci->transceiver);
-	kfree(ci->hw_bank.regmap);
 
 	return 0;
 }


