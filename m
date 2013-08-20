Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3HTC0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:26:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab3HTC0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:26:42 -0400
Date: Mon, 19 Aug 2013 22:26:32 -0400
From: Dave Jones <davej@redhat.com>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Fix apparent cut-and-paste error in super_90_validate
Message-ID: <20130820022632.GA12899@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, neilb@suse.de,
	linux-raid@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting a variable to itself probably wasn't the intention here.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9f13e13..b9cb9e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1180,7 +1180,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 			mddev->bitmap_info.offset =
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
-				mddev->bitmap_info.space;
+				mddev->bitmap_info.default_space;
 		}
 
 	} else if (mddev->pers == NULL) {
