Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab3CLWg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:36:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab3CLWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 083/100] usbnet: smsc95xx: fix suspend failure
Date: Tue, 12 Mar 2013 15:32:08 -0700
Message-Id: <20130312223131.872120058@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit 7643721471117d5f62ca36f328d3dc8d84af4402 upstream.

The three below functions:

	smsc95xx_enter_suspend0()
	smsc95xx_enter_suspend1()
	smsc95xx_enter_suspend2()

return > 0 in case of success, so they will cause smsc95xx_suspend()
to return > 0 and cause suspend failure.

The bug is introduced in commit 3b9f7d(smsc95xx: fix error handling
in suspend failure case).

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Cc: Steve Glendinning <steve.glendinning@shawell.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/smsc95xx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1340,6 +1340,8 @@ static int smsc95xx_enter_suspend0(struc
 	ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
 	if (ret < 0)
 		netdev_warn(dev->net, "Error reading PM_CTRL\n");
+	else
+		ret = 0;
 
 	return ret;
 }
@@ -1392,6 +1394,8 @@ static int smsc95xx_enter_suspend1(struc
 	ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
 	if (ret < 0)
 		netdev_warn(dev->net, "Error writing PM_CTRL\n");
+	else
+		ret = 0;
 
 	return ret;
 }
@@ -1413,6 +1417,8 @@ static int smsc95xx_enter_suspend2(struc
 	ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
 	if (ret < 0)
 		netdev_warn(dev->net, "Error writing PM_CTRL\n");
+	else
+		ret = 0;
 
 	return ret;
 }


