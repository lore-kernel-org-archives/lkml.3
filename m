Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbaCUADQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:03:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760100AbaCUADJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.13 001/149] zram: avoid null access when fail to alloc meta
Date: Thu, 20 Mar 2014 17:02:44 -0700
Message-Id: <20140321000436.570091810@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minchan Kim <minchan@kernel.org>

commit db5d711e2db776f18219b033e5dc4fb7e4264dd7 upstream.

zram_meta_alloc could fail so caller should check it.  Otherwise, your
system will hang.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -621,6 +621,8 @@ static ssize_t disksize_store(struct dev
 
 	disksize = PAGE_ALIGN(disksize);
 	meta = zram_meta_alloc(disksize);
+	if (!meta)
+		return -ENOMEM;
 	down_write(&zram->init_lock);
 	if (zram->init_done) {
 		up_write(&zram->init_lock);


