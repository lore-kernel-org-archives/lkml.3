Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab3FEUxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:53:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634Ab3FEUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [ 07/33] USB: cxacru: potential underflow in cxacru_cm_get_array()
Date: Wed,  5 Jun 2013 13:52:45 -0700
Message-Id: <20130605204704.207057940@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605204702.359510786@linuxfoundation.org>
References: <20130605204702.359510786@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 2a0ebf80aa95cc758d4725f74a7016e992606a39 upstream.

The value of "offd" comes off the instance->rcv_buf[] and we used it as
the offset into an array.  The problem is that we check the upper bound
but not for negative values.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/atm/cxacru.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -686,7 +686,8 @@ static int cxacru_cm_get_array(struct cx
 {
 	int ret, len;
 	__le32 *buf;
-	int offb, offd;
+	int offb;
+	unsigned int offd;
 	const int stride = CMD_PACKET_SIZE / (4 * 2) - 1;
 	int buflen =  ((size - 1) / stride + 1 + size * 2) * 4;
 


