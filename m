Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbbA1FC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:02:26 -0500
Received: from mail.kernel.org ([198.145.29.136]:39107 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933959AbbA1EUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:20:03 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anatol Pomozov <anatol.pomozov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 068/177] ALSA: pcm: use the same dma mmap codepath both for arm and arm64
Date: Wed, 28 Jan 2015 12:08:22 +0800
Message-Id: <1422418236-12852-135-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anatol Pomozov <anatol.pomozov@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/core/pcm_native.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index d776291..3a90793 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3171,7 +3171,7 @@ static const struct vm_operations_struct snd_pcm_vm_ops_data_fault = {
 
 #ifndef ARCH_HAS_DMA_MMAP_COHERENT
 /* This should be defined / handled globally! */
-#ifdef CONFIG_ARM
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
 #define ARCH_HAS_DMA_MMAP_COHERENT
 #endif
 #endif
-- 
1.9.1

