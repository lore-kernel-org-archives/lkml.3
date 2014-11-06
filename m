Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaKFWwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:52:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaKFWn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:58 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 079/162] ALSA: pcm: use the same dma mmap codepath both for arm and arm64
Date: Thu,  6 Nov 2014 14:35:43 -0800
Message-Id: <1415313426-9622-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatol Pomozov <anatol.pomozov@gmail.com>

commit a011e213f3700233ed2a676f1ef0a74a052d7162 upstream.

This avoids following kernel crash when try to playback on arm64

[  107.497203] [<ffffffc00046b310>] snd_pcm_mmap_data_fault+0x90/0xd4
[  107.503405] [<ffffffc0001541ac>] __do_fault+0xb0/0x498
[  107.508565] [<ffffffc0001576a0>] handle_mm_fault+0x224/0x7b0
[  107.514246] [<ffffffc000092640>] do_page_fault+0x11c/0x310
[  107.519738] [<ffffffc000081100>] do_mem_abort+0x38/0x98

Tested: backported to 3.14 and tried to playback on arm64 machine

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/pcm_native.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 01a5e05..566b0f6 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3189,7 +3189,7 @@ static const struct vm_operations_struct snd_pcm_vm_ops_data_fault = {
 
 #ifndef ARCH_HAS_DMA_MMAP_COHERENT
 /* This should be defined / handled globally! */
-#ifdef CONFIG_ARM
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
 #define ARCH_HAS_DMA_MMAP_COHERENT
 #endif
 #endif
-- 
1.9.1

