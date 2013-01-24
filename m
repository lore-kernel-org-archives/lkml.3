Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab3AXD3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:29:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44229 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab3AXD3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Nickolai Zeldovich <nickolai@csail.mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 26/74] staging: speakup: avoid out-of-range access in synth_add()
Date: Thu, 24 Jan 2013 01:26:38 -0200
Message-Id: <1358998046-613-27-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 6102c48bd421074a33e102f2ebda3724e8d275f9 upstream.

Check that array index is in-bounds before accessing the synths[] array.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/speakup/synth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index 217fd4a..5710fc5 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -423,7 +423,7 @@ int synth_add(struct spk_synth *in_synth)
 	int i;
 	int status = 0;
 	mutex_lock(&spk_mutex);
-	for (i = 0; synths[i] != NULL && i < MAXSYNTHS; i++)
+	for (i = 0; i < MAXSYNTHS && synths[i] != NULL; i++)
 		/* synth_remove() is responsible for rotating the array down */
 		if (in_synth == synths[i]) {
 			mutex_unlock(&spk_mutex);
-- 
1.7.9.5

