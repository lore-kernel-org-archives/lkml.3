Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760825AbaJCX7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:59:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbaJCVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tommi Rantala <tt.rantala@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 041/238] ALSA: core: fix buffer overflow in snd_info_get_line()
Date: Fri,  3 Oct 2014 14:29:16 -0700
Message-Id: <20141003212914.976378473@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/info.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -679,7 +679,7 @@ int snd_info_card_free(struct snd_card *
  * snd_info_get_line - read one line from the procfs buffer
  * @buffer: the procfs buffer
  * @line: the buffer to store
- * @len: the max. buffer size - 1
+ * @len: the max. buffer size
  *
  * Reads one line from the buffer and stores the string.
  *
@@ -699,7 +699,7 @@ int snd_info_get_line(struct snd_info_bu
 			buffer->stop = 1;
 		if (c == '\n')
 			break;
-		if (len) {
+		if (len > 1) {
 			len--;
 			*line++ = c;
 		}


