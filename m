Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbaAGAFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:05:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaAFWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bernd Porr <mail@berndporr.me.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3.12 011/144] staging: comedi: drivers: fix return value of comedi_load_firmware()
Date: Mon,  6 Jan 2014 14:36:12 -0800
Message-Id: <20140106223745.652140120@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/comedi/drivers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -417,7 +417,7 @@ int comedi_load_firmware(struct comedi_d
 		release_firmware(fw);
 	}
 
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 EXPORT_SYMBOL_GPL(comedi_load_firmware);
 


