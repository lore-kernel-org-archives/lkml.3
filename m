Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaHULwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:52:00 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:56322 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478AbaHULv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:51:58 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: airlied@linux.ie, benjamin.gaignard@linaro.org
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] drm: sti: Make of_device_id array const
Date: Thu, 21 Aug 2014 17:19:12 +0530
Message-Id: <1408621752-20392-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions handle it as const.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/gpu/drm/sti/sti_hda.c   |    2 +-
 drivers/gpu/drm/sti/sti_hdmi.c  |    2 +-
 drivers/gpu/drm/sti/sti_tvout.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_hda.c b/drivers/gpu/drm/sti/sti_hda.c
index 72d957f..4499d27 100644
--- a/drivers/gpu/drm/sti/sti_hda.c
+++ b/drivers/gpu/drm/sti/sti_hda.c
@@ -770,7 +770,7 @@ static int sti_hda_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id hda_of_match[] = {
+static const struct of_device_id hda_of_match[] = {
 	{ .compatible = "st,stih416-hda", },
 	{ .compatible = "st,stih407-hda", },
 	{ /* end node */ }
diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
index 284e541..6a21bf2 100644
--- a/drivers/gpu/drm/sti/sti_hdmi.c
+++ b/drivers/gpu/drm/sti/sti_hdmi.c
@@ -677,7 +677,7 @@ static const struct component_ops sti_hdmi_ops = {
 	.unbind = sti_hdmi_unbind,
 };
 
-static struct of_device_id hdmi_of_match[] = {
+static const struct of_device_id hdmi_of_match[] = {
 	{
 		.compatible = "st,stih416-hdmi",
 		.data = &tx3g0c55phy_ops,
diff --git a/drivers/gpu/drm/sti/sti_tvout.c b/drivers/gpu/drm/sti/sti_tvout.c
index b69e26f..50dad20 100644
--- a/drivers/gpu/drm/sti/sti_tvout.c
+++ b/drivers/gpu/drm/sti/sti_tvout.c
@@ -624,7 +624,7 @@ static int sti_tvout_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id tvout_of_match[] = {
+static const struct of_device_id tvout_of_match[] = {
 	{ .compatible = "st,stih416-tvout", },
 	{ .compatible = "st,stih407-tvout", },
 	{ /* end node */ }
-- 
1.7.9.5

