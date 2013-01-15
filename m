Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291Ab3AOXCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:02:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:48499 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934396Ab3AOW50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:57:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [ 53/71] staging: speakup: avoid out-of-range access in synth_add()
Date: Tue, 15 Jan 2013 14:54:50 -0800
Message-Id: <20130115225344.198310861@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 6102c48bd421074a33e102f2ebda3724e8d275f9 upstream.

Check that array index is in-bounds before accessing the synths[] array.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/speakup/synth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -423,7 +423,7 @@ int synth_add(struct spk_synth *in_synth
 	int i;
 	int status = 0;
 	mutex_lock(&spk_mutex);
-	for (i = 0; synths[i] != NULL && i < MAXSYNTHS; i++)
+	for (i = 0; i < MAXSYNTHS && synths[i] != NULL; i++)
 		/* synth_remove() is responsible for rotating the array down */
 		if (in_synth == synths[i]) {
 			mutex_unlock(&spk_mutex);


