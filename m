Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab3GDJzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:55:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49464 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134Ab3GDJyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:54:41 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v6 3/6] staging: android: binder: fix BC_FREE_BUFFER ioctl declaration
Date: Thu,  4 Jul 2013 10:54:45 +0100
Message-Id: <1372931688-18553-4-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372931688-18553-1-git-send-email-serban.constantinescu@arm.com>
References: <1372931688-18553-1-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BinderDriverCommands mirror the ioctl usage. Thus the size of the
structure passed through the interface should be used to generate the
ioctl No.

The change reflects the type being passed from the user space-a pointer
to a binder_buffer. This change should not affect the existing 32bit
user space since BC_FREE_BUFFER is computed as:

   #define _IOW(type,nr,size)         \
      ((type) << _IOC_TYPESHIFT) |    \
      ((nr)   << _IOC_NRSHIFT) |      \
      ((size) << _IOC_SIZESHIFT))

and for a 32bit compiler BC_FREE_BUFFER will have the same computed
value. This change will also ease our work in differentiating
BC_FREE_BUFFER from COMPAT_BC_FREE_BUFFER.

The change does not affect existing 32bit ABI.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
Acked-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/binder.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index 6515dd2..b55bba9 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -265,7 +265,7 @@ enum binder_driver_command_protocol {
 	 * Else you have acquired a primary reference on the object.
 	 */
 
-	BC_FREE_BUFFER = _IOW('c', 3, int),
+	BC_FREE_BUFFER = _IOW('c', 3, void *),
 	/*
 	 * void *: ptr to transaction data received on a read
 	 */
-- 
1.7.9.5

