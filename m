Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab3FRQWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:22:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277Ab3FRQSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:08 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [ 43/48] usb: chipidea: fix id change handling
Date: Tue, 18 Jun 2013 09:18:09 -0700
Message-Id: <20130618161732.173782430@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 0c3f3dc68bb6e6950e8cd7851e7778c550e8dfb4 upstream.

Re-enable chipidea irq even if there's no role changing to do. This is
a problem since b183c19f ("USB: chipidea: re-order irq handling to avoid
unhandled irqs"); when it manifests, chipidea irq gets disabled for good.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -279,8 +279,9 @@ static void ci_role_work(struct work_str
 
 		ci_role_stop(ci);
 		ci_role_start(ci, role);
-		enable_irq(ci->irq);
 	}
+
+	enable_irq(ci->irq);
 }
 
 static ssize_t show_role(struct device *dev, struct device_attribute *attr,


