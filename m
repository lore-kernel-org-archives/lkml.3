Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913Ab3CLWti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:49:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964843Ab3CLWog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sean Connor <sconnor004@allyinics.org>, Takashi Iwai <tiwai@suse.de>
Subject: [ 13/21] ALSA: ice1712: Initialize card->private_data properly
Date: Tue, 12 Mar 2013 15:44:15 -0700
Message-Id: <20130312223246.666834181@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223245.109098379@linuxfoundation.org>
References: <20130312223245.109098379@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Connor <sconnor004@allyinics.org>

commit 69a4cfdd444d1fe5c24d29b3a063964ac165d2cd upstream.

Set card->private_data in snd_ice1712_create for fixing NULL
dereference in snd_ice1712_remove().

Signed-off-by: Sean Connor <sconnor004@allyinics.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/ice1712/ice1712.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2595,6 +2595,8 @@ static int __devinit snd_ice1712_create(
 	snd_ice1712_proc_init(ice);
 	synchronize_irq(pci->irq);
 
+	card->private_data = ice;
+
 	err = pci_request_regions(pci, "ICE1712");
 	if (err < 0) {
 		kfree(ice);


