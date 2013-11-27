Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab3K0A4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:56:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3K0A4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lukasz Flis <l.flis@cyfronet.pl>, Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3.4 32/39] block: properly stack underlying max_segment_size to DM device
Date: Tue, 26 Nov 2013 16:56:56 -0800
Message-Id: <20131127005621.297249774@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit d82ae52e68892338068e7559a0c0657193341ce4 upstream.

Without this patch all DM devices will default to BLK_MAX_SEGMENT_SIZE
(65536) even if the underlying device(s) have a larger value -- this is
due to blk_stack_limits() using min_not_zero() when stacking the
max_segment_size limit.

1073741824

before patch:
65536

after patch:
1073741824

Reported-by: Lukasz Flis <l.flis@cyfronet.pl>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-settings.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -143,6 +143,7 @@ void blk_set_stacking_limits(struct queu
 	lim->discard_zeroes_data = 1;
 	lim->max_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
+	lim->max_segment_size = UINT_MAX;
 
 	lim->max_sectors = BLK_DEF_MAX_SECTORS;
 }


