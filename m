Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3JUI4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:56:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39904 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630Ab3JUIxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mike Miller" <mike.miller@hp.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.994552199@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 142/149] cciss: fix info leak in cciss_ioctl32_passthru()
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/cciss.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1186,6 +1186,7 @@ static int cciss_ioctl32_passthru(struct
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |=
 	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,

