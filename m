Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaGHBD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:03:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaGGXyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Naohiro Aota <naota@elisp.net>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.15 063/122] dm era: check for a non-NULL metadata object before closing it
Date: Mon,  7 Jul 2014 16:57:05 -0700
Message-Id: <20140707235736.162813379@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 989f26f5ad308f40a95f280bf9cd75e558d4f18d upstream.

era_ctr() may call era_destroy() before era->md is initialized so
era_destory() must only close the metadata object if it is not NULL.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-era-target.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1391,7 +1391,8 @@ static int era_is_congested(struct dm_ta
 
 static void era_destroy(struct era *era)
 {
-	metadata_close(era->md);
+	if (era->md)
+		metadata_close(era->md);
 
 	if (era->wq)
 		destroy_workqueue(era->wq);


