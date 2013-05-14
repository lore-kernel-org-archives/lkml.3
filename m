Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3ENOtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:49:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:22295 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443Ab3ENOtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:49:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,671,1363158000"; 
   d="scan'208";a="337415924"
From: Imre Deak <imre.deak@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Eduardo Valentin <edubezval@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-media@vger.kernel.org
Subject: [PATCH v2 4/8] media/si4713-i2c: take usecs_to_jiffies_timeout into use
Date: Tue, 14 May 2013 17:48:34 +0300
Message-Id: <1368542918-8861-5-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
References: <1368542918-8861-1-git-send-email-imre.deak@intel.com>
In-Reply-To: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usecs_to_jiffies_timeout instead of open-coding the same.

Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/media/radio/si4713-i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index fe16088..e12f058 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -233,7 +233,7 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
 
 	/* Wait response from interrupt */
 	if (!wait_for_completion_timeout(&sdev->work,
-				usecs_to_jiffies(usecs) + 1))
+				usecs_to_jiffies_timeout(usecs)))
 		v4l2_warn(&sdev->sd,
 				"(%s) Device took too much time to answer.\n",
 				__func__);
@@ -470,7 +470,7 @@ static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
 
 	/* Wait response from STC interrupt */
 	if (!wait_for_completion_timeout(&sdev->work,
-			usecs_to_jiffies(usecs) + 1))
+			usecs_to_jiffies_timeout(usecs)))
 		v4l2_warn(&sdev->sd,
 			"%s: device took too much time to answer (%d usec).\n",
 				__func__, usecs);
-- 
1.7.10.4

