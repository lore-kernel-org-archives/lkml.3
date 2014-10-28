Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbaJ1Gky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:40:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbaJ1DuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:50:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anatol Pomozov <anatol.pomozov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 059/100] ALSA: pcm: use the same dma mmap codepath both for arm and arm64
Date: Tue, 28 Oct 2014 11:35:44 +0800
Message-Id: <20141028033503.243347051@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033500.670583608@linuxfoundation.org>
References: <20141028033500.670583608@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm_native.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3189,7 +3189,7 @@ static const struct vm_operations_struct
 
 #ifndef ARCH_HAS_DMA_MMAP_COHERENT
 /* This should be defined / handled globally! */
-#ifdef CONFIG_ARM
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64)
 #define ARCH_HAS_DMA_MMAP_COHERENT
 #endif
 #endif


