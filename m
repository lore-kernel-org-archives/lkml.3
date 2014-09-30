Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaI3Vhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:37:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60950 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbaI3Vhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 057/103] ALSA: core: fix buffer overflow in snd_info_get_line()
Date: Tue, 30 Sep 2014 14:31:02 -0700
Message-Id: <1412112708-27356-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit ddc64b278a4dda052390b3de1b551e59acdff105 upstream.

snd_info_get_line() documents that its last parameter must be one
less than the buffer size, but this API design guarantees that
(literally) every caller gets it wrong.

Just change this parameter to have its obvious meaning.

Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/info.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/info.c b/sound/core/info.c
index e79baa1..08070e1 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -679,7 +679,7 @@ int snd_info_card_free(struct snd_card *card)
  * snd_info_get_line - read one line from the procfs buffer
  * @buffer: the procfs buffer
  * @line: the buffer to store
- * @len: the max. buffer size - 1
+ * @len: the max. buffer size
  *
  * Reads one line from the buffer and stores the string.
  *
@@ -699,7 +699,7 @@ int snd_info_get_line(struct snd_info_buffer *buffer, char *line, int len)
 			buffer->stop = 1;
 		if (c == '\n')
 			break;
-		if (len) {
+		if (len > 1) {
 			len--;
 			*line++ = c;
 		}
-- 
1.9.1

