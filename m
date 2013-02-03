Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3BCPXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:23:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34124 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769Ab3BCOzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:06 -0500
Message-Id: <20130203144645.999442872@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Nickolai Zeldovich <nickolai@csail.mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 022/128] staging: speakup: avoid out-of-range access in synth_add()
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit 6102c48bd421074a33e102f2ebda3724e8d275f9 upstream.

Check that array index is in-bounds before accessing the synths[] array.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/speakup/synth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index b91d22b..7616f05 100644
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


