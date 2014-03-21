Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaCUTyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:54:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaCUTyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:54:38 -0400
Date: Fri, 21 Mar 2014 15:54:03 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>,
        linux-mtd@lists.infradead.org
Subject: [RFC PATCH] UBI: fix rb_tree node comparison in add_map
Message-ID: <20140321195403.GA32529@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comparisons used in add_vol() shouldn't be identical.  Pretty sure
the following is correct but it is completely untested.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/mtd/ubi/fastmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

NOTE: I stumbled upon this code while implementing some rb_tree code
      (and looking for some existing rb_tree code as a reference).

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index ead8613..60c7a20 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -125,9 +125,9 @@ static struct ubi_ainf_volume *add_vol(struct ubi_attach_info *ai, int vol_id,
 		parent = *p;
 		av = rb_entry(parent, struct ubi_ainf_volume, rb);
 
-		if (vol_id > av->vol_id)
+		if (vol_id < av->vol_id)
 			p = &(*p)->rb_left;
-		else if (vol_id > av->vol_id)
+		else
 			p = &(*p)->rb_right;
 	}
 
