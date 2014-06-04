Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaFDXXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaFDXXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Gajdusek <atx@atx.name>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.10 022/103] hwmon: (emc1403) fix inverted store_hyst()
Date: Wed,  4 Jun 2014 16:24:45 -0700
Message-Id: <20140604232547.571352309@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Gajdusek <atx@atx.name>

commit 17c048fc4bd95efea208a1920f169547d8588f1f upstream.

Attempts to set the hysteresis value to a temperature below the target
limit fails with "write error: Numerical result out of range" due to
an inverted comparison.

Signed-off-by: Josef Gajdusek <atx@atx.name>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
[Guenter Roeck: Updated headline and description]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/emc1403.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -162,7 +162,7 @@ static ssize_t store_hyst(struct device
 	if (retval < 0)
 		goto fail;
 
-	hyst = val - retval * 1000;
+	hyst = retval * 1000 - val;
 	hyst = DIV_ROUND_CLOSEST(hyst, 1000);
 	if (hyst < 0 || hyst > 255) {
 		retval = -ERANGE;


