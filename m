Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaBKTEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:04:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaBKTEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:04:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 3.13 001/120] mei: mei_hbm_dispatch() returns void
Date: Tue, 11 Feb 2014 11:04:02 -0800
Message-Id: <20140211184823.540928241@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

Building hbm.o for v3.13.2 triggers a GCC warning:
    drivers/misc/mei/hbm.c: In function 'mei_hbm_dispatch':
    drivers/misc/mei/hbm.c:596:3: warning: 'return' with a value, in function returning void [enabled by default]
       return 0;
       ^

GCC is correct, obviously. So let's return void instead of zero here.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Compile tested only.

 drivers/misc/mei/hbm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -593,7 +593,7 @@ void mei_hbm_dispatch(struct mei_device
 	 */
 	if (dev->hbm_state == MEI_HBM_IDLE) {
 		dev_dbg(&dev->pdev->dev, "hbm: state is idle ignore spurious messages\n");
-		return 0;
+		return;
 	}
 
 	switch (mei_msg->hbm_cmd) {


