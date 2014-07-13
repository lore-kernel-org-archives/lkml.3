Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaGMA4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 20:56:06 -0400
Received: from mail-yk0-f178.google.com ([209.85.160.178]:64517 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaGMA4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 20:56:00 -0400
Date: Sat, 12 Jul 2014 21:50:09 -0300
From: Lucas Tanure <tanure@linux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] staging: android: Clean up binder_buffer_size()
Message-ID: <20140713005009.GA1926@archDesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel coding style. Remove useless else statement after return.

Signed-off-by: Lucas Tanure <tanure@linux.com>
---
 drivers/staging/android/binder.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index cfe4bc8..1a0966b 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -451,8 +451,7 @@ static size_t binder_buffer_size(struct binder_proc *proc,
 {
 	if (list_is_last(&buffer->entry, &proc->buffers))
 		return proc->buffer + proc->buffer_size - (void *)buffer->data;
-	else
-		return (size_t)list_entry(buffer->entry.next,
+	return (size_t)list_entry(buffer->entry.next,
 			struct binder_buffer, entry) - (size_t)buffer->data;
 }
 
-- 
2.0.1

