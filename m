Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab3DDMez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:34:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64432 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759797Ab3DDMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:32:45 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 6/8] staging: android: binder: fix BC_FREE_BUFFER ioctl declaration
Date: Thu,  4 Apr 2013 13:32:36 +0100
Message-Id: <1365078758-28674-7-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
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
---
 drivers/staging/android/binder.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index 5b9909f..8789baa 100644
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

