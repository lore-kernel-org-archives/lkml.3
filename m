Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab3DXCsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:48:25 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:46725 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3DXCsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:48:24 -0400
MIME-Version: 1.0
Date: Wed, 24 Apr 2013 10:48:23 +0800
Message-ID: <CAPgLHd8X3pLTM5vsTnHWL3g9GNOrxVF-LkmGWp6_doFkX2_LcQ@mail.gmail.com>
Subject: [PATCH -next RESEND] gpu: host1x: drm: fix missing unlock on error
From: Wei Yongjun <weiyj.lk@gmail.com>
To: thierry.reding@avionic-design.de, tbergstrom@nvidia.com,
        amerilainen@nvidia.com, markz@nvidia.com, swarren@nvidia.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function host1x_drm_init() and
host1x_drm_exit() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
rebased on the latest linux-next.git tree.
---
 drivers/gpu/host1x/drm/drm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
index 2b561c9..0dbb9c0 100644
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -148,6 +148,7 @@ int host1x_drm_init(struct host1x_drm *host1x, struct drm_device *drm)
 				dev_err(host1x->dev,
 					"DRM setup failed for %s: %d\n",
 					dev_name(client->dev), err);
+				mutex_unlock(&host1x->clients_lock);
 				return err;
 			}
 		}
@@ -175,6 +176,7 @@ int host1x_drm_exit(struct host1x_drm *host1x)
 				dev_err(host1x->dev,
 					"DRM cleanup failed for %s: %d\n",
 					dev_name(client->dev), err);
+				mutex_unlock(&host1x->clients_lock);
 				return err;
 			}
 		}

