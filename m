Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab3FOIxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 04:53:22 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:41333 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab3FOIxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 04:53:21 -0400
Message-ID: <51BC2B7A.5030009@gmail.com>
Date: Sat, 15 Jun 2013 16:53:14 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: airlied@linux.ie
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau: fix a memory leak.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cleanup extra stat if this object was a notifier,it should free the
notifier.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
  drivers/gpu/drm/nouveau/nouveau_abi16.c | 3 +--
  1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c 
b/drivers/gpu/drm/nouveau/nouveau_abi16.c
index 1c4c6c9..b5252ff 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -483,8 +483,7 @@ nouveau_abi16_ioctl_gpuobj_free(ABI16_IOCTL_ARGS)
      /* cleanup extra state if this object was a notifier */
      list_for_each_entry(ntfy, &chan->notifiers, head) {
          if (ntfy->handle == fini->handle) {
-            nouveau_mm_free(&chan->heap, &ntfy->node);
-            list_del(&ntfy->head);
+            nouveau_abi16_ntfy_fini(chan, ntfy);
              break;
          }
      }
-- 
1.8.1.2

