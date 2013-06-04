Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab3FDOYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:24:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46704 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3FDOHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 18/70] USB: cxacru: potential underflow in cxacru_cm_get_array()
Date: Tue,  4 Jun 2013 15:06:34 +0100
Message-Id: <1370354846-14213-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 2a0ebf80aa95cc758d4725f74a7016e992606a39 upstream.

The value of "offd" comes off the instance->rcv_buf[] and we used it as
the offset into an array.  The problem is that we check the upper bound
but not for negative values.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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

