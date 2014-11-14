Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaKNFNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:13:53 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:16662 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbaKNFNw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:13:52 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'perex@perex.cz'" <perex@perex.cz>, "'tiwai@suse.de'" <tiwai@suse.de>,
        "'joe@perches.com'" <joe@perches.com>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Fri, 14 Nov 2014 13:13:45 +0800
Subject: [PATCH] 6fire: Convert byte_rev_table uses to bitrev8
Thread-Topic: [PATCH] 6fire: Convert byte_rev_table uses to bitrev8
Thread-Index: Ac//ycOD9bcU0tYhTmyRn6gG/G9r+w==
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D1829C@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the inline function instead of directly indexing the array.

This allows some architectures with hardware instructions for bit
reversals to eliminate the array.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 sound/usb/6fire/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/6fire/firmware.c b/sound/usb/6fire/firmware.c
index 3b02e54..2e39c3f 100644
--- a/sound/usb/6fire/firmware.c
+++ b/sound/usb/6fire/firmware.c
@@ -316,7 +316,7 @@ static int usb6fire_fw_fpga_upload(
 
 	while (c != end) {
 		for (i = 0; c != end && i < FPGA_BUFSIZE; i++, c++)
-			buffer[i] = byte_rev_table[(u8) *c];
+			buffer[i] = bitrev8((u8) *c);
 
 		ret = usb6fire_fw_fpga_write(device, buffer, i);
 		if (ret < 0) {
-- 
2.1.1
