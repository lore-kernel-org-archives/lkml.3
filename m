Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab3CUSKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:10:18 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47169 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3CUSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:10:16 -0400
Message-ID: <514B4D04.6070007@Gmail.com>
Date: Thu, 21 Mar 2013 13:10:12 -0500
From: Calvin Owens <jcalvinowens@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130203 Thunderbird/17.0.2
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
CC: Ben Skeggs <bskeggs@redhat.com>, Calvin Owens <jcalvinowens@gmail.com>
Subject: [PATCH] nouveau: Fix unconditional return waiting on memory
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typo in nv50_display_flip_wait allows page flipping to run ahead before
memory has time to settle.

Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
---
 drivers/gpu/drm/nouveau/nv50_display.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
index 2db5799..96bc2f3 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -479,7 +479,7 @@ nv50_display_flip_wait(void *data)
 {
 	struct nv50_display_flip *flip = data;
 	if (nouveau_bo_rd32(flip->disp->sync, flip->chan->addr / 4) ==
-					      flip->chan->data);
+					      flip->chan->data)
 		return true;
 	usleep_range(1, 2);
 	return false;
-- 
1.7.3.4
