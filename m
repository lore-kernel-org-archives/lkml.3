Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaFEEVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaFEEVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 124/214] ALSA: hda - Fix oops caused by recent commit "Fix internal mic for Lenovo Ideapad U300s"
Date: Wed,  4 Jun 2014 21:18:07 -0700
Message-Id: <20140605041656.372911597@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 83b0c6ba999643ee8ad6329f26e1cdc870e1a920 upstream.

Make sure we don't dereference the "quirk" pointer when it is null.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4430,7 +4430,9 @@ static void apply_fixup(struct hda_codec
 	 struct conexant_spec *spec = codec->spec;
 
 	quirk = snd_pci_quirk_lookup(codec->bus->pci, quirk);
-	if (quirk && table[quirk->value]) {
+	if (!quirk)
+		return;
+	if (table[quirk->value]) {
 		snd_printdd(KERN_INFO "hda_codec: applying pincfg for %s\n",
 			    quirk->name);
 		apply_pincfg(codec, table[quirk->value]);


