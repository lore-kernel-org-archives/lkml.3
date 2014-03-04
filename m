Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbaCDUmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:42:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbaCDUEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3.13 163/172] dm cache: move hook_info into common portion of per_bio_data structure
Date: Tue,  4 Mar 2014 12:04:07 -0800
Message-Id: <20140304200304.919825681@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit c6eda5e81c4fcc77185117255c7419eda771f67f upstream.

Commit c9d28d5d ("dm cache: promotion optimisation for writes")
incorrectly placed the 'hook_info' member in the writethrough-only
portion of the per_bio_data structure.

Given that the overwrite optimization may be used for writeback the
'hook_info' member must be placed above the 'cache' member of the
per_bio_data structure.  Any members above 'cache' are available from
both writeback and writethrough modes' per_bio_data structure.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -283,6 +283,7 @@ struct per_bio_data {
 	bool tick:1;
 	unsigned req_nr:2;
 	struct dm_deferred_entry *all_io_entry;
+	struct dm_hook_info hook_info;
 
 	/*
 	 * writethrough fields.  These MUST remain at the end of this
@@ -291,7 +292,6 @@ struct per_bio_data {
 	 */
 	struct cache *cache;
 	dm_cblock_t cblock;
-	struct dm_hook_info hook_info;
 	struct dm_bio_details bio_details;
 };
 


