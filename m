Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaJWKeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:34:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:14191 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaJWKeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:34:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,774,1406617200"; 
   d="scan'208";a="619098530"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.10 backport] mei: bus: fix possible boundaries violation
Date: Thu, 23 Oct 2014 13:32:54 +0300
Message-Id: <1414060374-1879-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit cfda2794b5afe7ce64ee9605c64bef0e56a48125 upstream.

function 'strncpy' will fill whole buffer 'id.name' of fixed size (32)
with string value and will not leave place for NULL-terminator.
Possible buffer boundaries violation in following string operations.
Replace strncpy with strlcpy.

Cc: stable@vger.kernel.org # 3.10
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 99cc0b07a713..0513ea0906dd 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -71,7 +71,7 @@ static int mei_cl_device_probe(struct device *dev)
 
 	dev_dbg(dev, "Device probe\n");
 
-	strncpy(id.name, dev_name(dev), MEI_CL_NAME_SIZE);
+	strlcpy(id.name, dev_name(dev), sizeof(id.name));
 
 	return driver->probe(device, &id);
 }
-- 
1.9.3

