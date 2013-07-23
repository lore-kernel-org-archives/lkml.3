Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934596Ab3GWW1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934553Ab3GWW1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 030/103] ALSA: hda - Fix the max length of control name in generic parser
Date: Tue, 23 Jul 2013 15:25:41 -0700
Message-Id: <20130723220421.922009398@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0c055b3413868227f2e85701c4e6938c9581f0e2 upstream.

add_control_with_pfx() in hda_generic.c assumes a shorter name string
for the control element, and this resulted in the truncation of the
long but valid string like "Headphone Surround Switch" in the middle.

This patch aligns the max size to the actual limit of snd_ctl_elem_id,
44.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -840,7 +840,7 @@ static int add_control_with_pfx(struct h
 				const char *pfx, const char *dir,
 				const char *sfx, int cidx, unsigned long val)
 {
-	char name[32];
+	char name[44];
 	snprintf(name, sizeof(name), "%s %s %s", pfx, dir, sfx);
 	if (!add_control(spec, type, name, cidx, val))
 		return -ENOMEM;


