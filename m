Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbaBFVxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:53:34 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:59091 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbaBFVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:53:32 -0500
Message-ID: <1391723609.1782.2.camel@x220>
Subject: [PATCH 3.13] mei: mei_hbm_dispatch() returns void
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Date: Thu, 06 Feb 2014 22:53:29 +0100
In-Reply-To: <20140206213953.GA1524@kroah.com>
References: <20140204211036.967663852@linuxfoundation.org>
	 <20140204211038.509274283@linuxfoundation.org>
	 <1391722055.22187.7.camel@x220> <20140206213953.GA1524@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2014 21:53:30.0305 (UTC) FILETIME=[DF6BF310:01CF2385]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building hbm.o for v3.13.2 triggers a GCC warning:
    drivers/misc/mei/hbm.c: In function 'mei_hbm_dispatch':
    drivers/misc/mei/hbm.c:596:3: warning: 'return' with a value, in function returning void [enabled by default]
       return 0;
       ^

GCC is correct, obviously. So let's return void instead of zero here.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only.

 drivers/misc/mei/hbm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 5d9e687..7ba6c4c 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -593,7 +593,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 	 */
 	if (dev->hbm_state == MEI_HBM_IDLE) {
 		dev_dbg(&dev->pdev->dev, "hbm: state is idle ignore spurious messages\n");
-		return 0;
+		return;
 	}
 
 	switch (mei_msg->hbm_cmd) {
-- 
1.8.5.3

