Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaDOB44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:56:56 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57102 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDOB4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:56:55 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: airlied@linux.ie
Cc: bskeggs@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau/clk: fix possible NULL pointer dereference
Date: Tue, 15 Apr 2014 10:56:49 +0900
Message-ID: <3009531.aHrQhHYAOc@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It need to be checking NULL before dereferencing.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/gpu/drm/nouveau/core/subdev/clock/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
index dd62bae..a586d030 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/base.c
@@ -290,9 +290,9 @@ nouveau_pstate_new(struct nouveau_clock *clk, int idx)
 		return 0;
 
 	pstate = kzalloc(sizeof(*pstate), GFP_KERNEL);
-	cstate = &pstate->base;
 	if (!pstate)
 		return -ENOMEM;
+	cstate = &pstate->base;
 
 	INIT_LIST_HEAD(&pstate->list);
 
-- 
1.7.4.4


