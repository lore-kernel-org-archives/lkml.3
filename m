Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3H0BLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:11:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3H0BHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [ 71/74] mei: dont have to clean the state on power up
Date: Mon, 26 Aug 2013 18:09:09 -0700
Message-Id: <20130827010439.051281714@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 99f22c4ef24cf87b0dae6aabe6b5e620b62961d9 upstream.

When powering up, we don't have to clean up the device state
nothing is connected.

Tested-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -143,7 +143,8 @@ void mei_reset(struct mei_device *dev, i
 
 	dev->hbm_state = MEI_HBM_IDLE;
 
-	if (dev->dev_state != MEI_DEV_INITIALIZING) {
+	if (dev->dev_state != MEI_DEV_INITIALIZING &&
+	    dev->dev_state != MEI_DEV_POWER_UP) {
 		if (dev->dev_state != MEI_DEV_DISABLED &&
 		    dev->dev_state != MEI_DEV_POWER_DOWN)
 			dev->dev_state = MEI_DEV_RESETTING;


