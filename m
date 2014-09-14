Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaINRc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 13:32:59 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:56708 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaINRc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 13:32:58 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jon Mason <jdmason@kudzu.us>, "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Benoit Taine <benoit.taine@lip6.fr>,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>,
        Ben Hutchings <bhutchings@solarflare.com>,
        John Stultz <john.stultz@linaro.org>,
        Christian Engelmayer <cengelma@gmx.at>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: neterion: vxge: vxge-main.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 14 Sep 2014 19:34:47 +0200
Message-Id: <1410716087-16154-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 4f40d7b..cc0485e 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3537,7 +3537,7 @@ static void vxge_device_unregister(struct __vxge_hw_device *hldev)
 	vxge_debug_entryexit(vdev->level_trace,	"%s: %s:%d", vdev->ndev->name,
 			     __func__, __LINE__);
 
-	strncpy(buf, dev->name, IFNAMSIZ);
+	strlcpy(buf, dev->name, IFNAMSIZ);
 
 	flush_work(&vdev->reset_task);
 
-- 
1.7.10.4

