Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbbANI1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:27:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbbANH16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.18 079/150] ALSA: fireworks: fix an endianness bug for transaction length
Date: Tue, 13 Jan 2015 23:22:30 -0800
Message-Id: <20150114072059.421531162@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 92cb46584e104e2f4b14a44959109ffe13524a26 upstream.

Although the 't->length' is a big-endian value, it's used without any
conversion. This means that the driver always uses 'length' parameter.

Fixes: 555e8a8f7f14("ALSA: fireworks: Add command/response functionality into hwdep interface")
Reported-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/fireworks/fireworks_transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/fireworks/fireworks_transaction.c
+++ b/sound/firewire/fireworks/fireworks_transaction.c
@@ -124,7 +124,7 @@ copy_resp_to_buf(struct snd_efw *efw, vo
 	spin_lock_irq(&efw->lock);
 
 	t = (struct snd_efw_transaction *)data;
-	length = min_t(size_t, t->length * sizeof(t->length), length);
+	length = min_t(size_t, be32_to_cpu(t->length) * sizeof(u32), length);
 
 	if (efw->push_ptr < efw->pull_ptr)
 		capacity = (unsigned int)(efw->pull_ptr - efw->push_ptr);


