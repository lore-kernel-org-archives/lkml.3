Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbaIOUQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:16:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaIOTrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:47:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Doug Ledford <dledford@redhat.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.14 089/114] RDMA/uapi: Include socket.h in rdma_user_cm.h
Date: Mon, 15 Sep 2014 12:26:29 -0700
Message-Id: <20140915192644.204608599@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Ledford <dledford@redhat.com>

commit db1044d458a287c18c4d413adc4ad12e92e253b5 upstream.

added struct sockaddr_storage to rdma_user_cm.h without also adding an
include for linux/socket.h to make sure it is defined.  Systemtap
needs the header files to build standalone and cannot rely on other
files to pre-include other headers, so add linux/socket.h to the list
of includes in this file.

Fixes: ee7aed4528f ("RDMA/ucma: Support querying for AF_IB addresses")
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/rdma/rdma_user_cm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/uapi/rdma/rdma_user_cm.h
+++ b/include/uapi/rdma/rdma_user_cm.h
@@ -34,6 +34,7 @@
 #define RDMA_USER_CM_H
 
 #include <linux/types.h>
+#include <linux/socket.h>
 #include <linux/in6.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_user_sa.h>


