Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935598AbaICXQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:16:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156AbaICWQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3.16 024/125] mei: reset client connection state on timeout
Date: Wed,  3 Sep 2014 15:06:21 -0700
Message-Id: <20140903220624.390759392@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 3e37ebb7183f0c4eb92a88c60657ac319c01b3e9 upstream.

On connection timeout we leave the connecting client in
connecting state. Since a new connection is stalled till
previous connection is completed in this case no new connection
is possible till the user space does release the file handle.
Therefore on timeout we move the client to disconnected state.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -616,6 +616,7 @@ int mei_cl_connect(struct mei_cl *cl, st
 	mutex_lock(&dev->device_lock);
 
 	if (cl->state != MEI_FILE_CONNECTED) {
+		cl->state = MEI_FILE_DISCONNECTED;
 		/* something went really wrong */
 		if (!cl->status)
 			cl->status = -EFAULT;


