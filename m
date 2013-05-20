Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3ETLWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:22:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56012 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3ETKwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mika Kuoppala <mika.kuoppala@intel.com>, Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 022/115] fbcon: when font is freed, clear also vc_font.data
Date: Mon, 20 May 2013 11:50:22 +0100
Message-Id: <1369047116-9378-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Kuoppala <mika.kuoppala@linux.intel.com>

commit e6637d5427d2af9f3f33b95447bfc5347e5ccd85 upstream.

commit ae1287865f5361fa138d4d3b1b6277908b54eac9
Author: Dave Airlie <airlied@redhat.com>
Date:   Thu Jan 24 16:12:41 2013 +1000

    fbcon: don't lose the console font across generic->chip driver switch

uses a pointer in vc->vc_font.data to load font into the new driver.
However if the font is actually freed, we need to clear the data
so that we don't reload font from dangling pointer.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=892340
Signed-off-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/console/fbcon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 18ded2d..a01317c 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1228,6 +1228,8 @@ static void fbcon_deinit(struct vc_data *vc)
 finished:
 
 	fbcon_free_font(p, free_font);
+	if (free_font)
+		vc->vc_font.data = NULL;
 
 	if (!con_is_bound(&fb_con))
 		fbcon_exit();
-- 
1.8.1.2

