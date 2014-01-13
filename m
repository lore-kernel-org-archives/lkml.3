Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaAMQCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:02:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53126 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaAMQCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 069/208] staging: comedi: drivers: fix return value of comedi_load_firmware()
Date: Mon, 13 Jan 2014 15:58:30 +0000
Message-Id: <1389628849-1614-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: H Hartley Sweeten <hsweeten@visionengravers.com>

commit c6236c0ce39c809c336ca929f68cf8ad02cf94e0 upstream.

Some of the callback functions that upload the firmware in the comedi
drivers return a positive value indicating the number of bytes sent
to the device. Detect this condition and just return '0' to indicate
a successful upload.

Reported-by: Bernd Porr <mail@berndporr.me.uk>
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index b3b5125..0ea7c93 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -365,7 +365,7 @@ int comedi_load_firmware(struct comedi_device *dev,
 		release_firmware(fw);
 	}
 
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 EXPORT_SYMBOL_GPL(comedi_load_firmware);
 
-- 
1.8.3.2

