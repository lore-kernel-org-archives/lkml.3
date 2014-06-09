Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497AbaFIWvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:51:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933368AbaFIWqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.10 18/40] dm cache: always split discards on cache block boundaries
Date: Mon,  9 Jun 2014 15:48:49 -0700
Message-Id: <20140609224839.785692022@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heinz Mauelshagen <heinzm@redhat.com>

commit f1daa838e861ae1a0fb7cd9721a21258430fcc8c upstream.

The DM cache target cannot cope with discards that span multiple cache
blocks, so each discard bio that spans more than one cache block must
get split by the DM core.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-cache-target.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1954,6 +1954,8 @@ static int cache_create(struct cache_arg
 	ti->num_discard_bios = 1;
 	ti->discards_supported = true;
 	ti->discard_zeroes_data_unsupported = true;
+	/* Discard bios must be split on a block boundary */
+	ti->split_discard_bios = true;
 
 	cache->features = ca->features;
 	ti->per_bio_data_size = get_per_bio_data_size(cache);


