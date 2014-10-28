Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaJ1Dhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:37:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbaJ1Dhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.17 051/146] mei: bus: fix possible boundaries violation
Date: Tue, 28 Oct 2014 11:33:13 +0800
Message-Id: <20141028033345.624119190@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/misc/mei/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -70,7 +70,7 @@ static int mei_cl_device_probe(struct de
 
 	dev_dbg(dev, "Device probe\n");
 
-	strncpy(id.name, dev_name(dev), sizeof(id.name));
+	strlcpy(id.name, dev_name(dev), sizeof(id.name));
 
 	return driver->probe(device, &id);
 }


