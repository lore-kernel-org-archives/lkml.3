Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab3JKTjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:39:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431Ab3JKTjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:39:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Miller <mike.miller@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 003/110] cciss: fix info leak in cciss_ioctl32_passthru()
Date: Fri, 11 Oct 2013 12:37:43 -0700
Message-Id: <20131011193807.972672488@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 58f09e00ae095e46ef9edfcf3a5fd9ccdfad065e upstream.

The arg64 struct has a hole after ->buf_size which isn't cleared.  Or if
any of the calls to copy_from_user() fail then that would cause an
information leak as well.

This was assigned CVE-2013-2147.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1189,6 +1189,7 @@ static int cciss_ioctl32_passthru(struct
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |=
 	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,


