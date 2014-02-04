Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936575AbaBDXH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:07:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716AbaBDVAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:00:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Aristov <aristov.alexander@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.4 25/37] ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]
Date: Tue,  4 Feb 2014 13:01:01 -0800
Message-Id: <20140204210056.719973196@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210055.992134150@linuxfoundation.org>
References: <20140204210055.992134150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 770bd4bf2e664939a9dacd3d26ec9ff7a3933210 upstream.

The lack of comma leads to the wrong channel for an SPDIF channel.
Unfortunately this wasn't caught by compiler because it's still a
valid expression.

Reported-by: Alexander Aristov <aristov.alexander@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/rme9652/rme9652.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -285,7 +285,7 @@ static char channel_map_9636_ds[26] = {
 	/* ADAT channels are remapped */
 	1, 3, 5, 7, 9, 11, 13, 15,
 	/* channels 8 and 9 are S/PDIF */
-	24, 25
+	24, 25,
 	/* others don't exist */
 	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
 };


