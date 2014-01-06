Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbaAFWll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:41:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968AbaAFWlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sage Weil <sage@inktank.com>
Subject: [PATCH 3.10 099/129] rbd: fix a couple warnings
Date: Mon,  6 Jan 2014 14:38:48 -0800
Message-Id: <20140106223902.432997808@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit e976cad0f0dbe5440a4ca38e29e1f932d9319125 upstream.

gcc isn't quite smart enough and generates these warnings:

drivers/block/rbd.c: In function 'rbd_img_request_fill':
drivers/block/rbd.c:1266:22: warning: 'bio_list' may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/block/rbd.c:2186:14: note: 'bio_list' was declared here
drivers/block/rbd.c:2247:10: warning: 'pages' may be used uninitialized in this function [-Wmaybe-uninitialized]

even though they are initialized for their respective code paths.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2173,9 +2173,9 @@ static int rbd_img_request_fill(struct r
 	struct rbd_obj_request *obj_request = NULL;
 	struct rbd_obj_request *next_obj_request;
 	bool write_request = img_request_write_test(img_request);
-	struct bio *bio_list;
+	struct bio *bio_list = 0;
 	unsigned int bio_offset = 0;
-	struct page **pages;
+	struct page **pages = 0;
 	u64 img_offset;
 	u64 resid;
 	u16 opcode;


