Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3FDRAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:00:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3FDRAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:00:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 33/75] USB: cxacru: potential underflow in cxacru_cm_get_array()
Date: Tue,  4 Jun 2013 09:55:17 -0700
Message-Id: <1370364959-9475-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 2a0ebf80aa95cc758d4725f74a7016e992606a39 upstream.

The value of "offd" comes off the instance->rcv_buf[] and we used it as
the offset into an array.  The problem is that we check the upper bound
but not for negative values.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/atm/cxacru.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index b7eb86a..8a7eb77 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -686,7 +686,8 @@ static int cxacru_cm_get_array(struct cxacru_data *instance, enum cxacru_cm_requ
 {
 	int ret, len;
 	__le32 *buf;
-	int offb, offd;
+	int offb;
+	unsigned int offd;
 	const int stride = CMD_PACKET_SIZE / (4 * 2) - 1;
 	int buflen =  ((size - 1) / stride + 1 + size * 2) * 4;
 
-- 
1.8.1.2

