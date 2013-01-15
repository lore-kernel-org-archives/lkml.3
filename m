Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431Ab3AOXDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:03:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:48481 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934390Ab3AOW5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:57:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nickolai Zeldovich <nickolai@csail.mit.edu>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [ 52/71] staging: speakup: avoid out-of-range access in synth_init()
Date: Tue, 15 Jan 2013 14:54:49 -0800
Message-Id: <20130115225344.137251479@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

commit ae428655b826f2755a8101b27beda42a275ef8ad upstream.

Check that array index is in-bounds before accessing the synths[] array.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/speakup/synth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -342,7 +342,7 @@ int synth_init(char *synth_name)
 
 	mutex_lock(&spk_mutex);
 	/* First, check if we already have it loaded. */
-	for (i = 0; synths[i] != NULL && i < MAXSYNTHS; i++)
+	for (i = 0; i < MAXSYNTHS && synths[i] != NULL; i++)
 		if (strcmp(synths[i]->name, synth_name) == 0)
 			synth = synths[i];
 


