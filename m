Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3J2Slj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:41:39 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:4596 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3J2Sli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:41:38 -0400
Subject: [PATCH] cciss: return 0 from driver probe function on success, not 1
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Tue, 29 Oct 2013 13:41:35 -0500
Message-ID: <20131029184135.5505.77412.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

A return value of 1 is interpreted as an error

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index edfa251..0c004ac 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -5183,7 +5183,7 @@ reinit_after_soft_reset:
 	rebuild_lun_table(h, 1, 0);
 	cciss_engage_scsi(h);
 	h->busy_initializing = 0;
-	return 1;
+	return 0;
 
 clean4:
 	cciss_free_cmd_pool(h);

