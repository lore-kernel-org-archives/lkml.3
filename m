Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaJ0TEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:04:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52824 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaJ0TED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:04:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 031/105] mei: bus: fix possible boundaries violation
Date: Mon, 27 Oct 2014 11:56:06 -0700
Message-Id: <1414436240-13879-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit cfda2794b5afe7ce64ee9605c64bef0e56a48125 upstream.

function 'strncpy' will fill whole buffer 'id.name' of fixed size (32)
with string value and will not leave place for NULL-terminator.
Possible buffer boundaries violation in following string operations.
Replace strncpy with strlcpy.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/mei/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 4bc7d62..9a07bba 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -71,7 +71,7 @@ static int mei_cl_device_probe(struct device *dev)
 
 	dev_dbg(dev, "Device probe\n");
 
-	strncpy(id.name, dev_name(dev), sizeof(id.name));
+	strlcpy(id.name, dev_name(dev), sizeof(id.name));
 
 	return driver->probe(device, &id);
 }
-- 
1.9.1

