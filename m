Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbbAQGet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 01:34:49 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57765 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbbAQGes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 01:34:48 -0500
From: Shailendra Verma <shailendra.capricorn@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Shailendra Verma <shailendra.capricorn@gmail.com>
Subject: [PATCH 2/2] ION handle already destroyed in ion_free.
Date: Sat, 17 Jan 2015 12:04:21 +0530
Message-Id: <1421476461-18070-1-git-send-email-shailendra.capricorn@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
---
 drivers/staging/android/ion/ion.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 9e56d32..0d2b9a3 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1279,7 +1279,6 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
		if (IS_ERR(handle))
			return PTR_ERR(handle);
		ion_free(client, handle);
-		ion_handle_put(handle);
		break;
	}
	case ION_IOC_SHARE:
--
1.7.9.5
