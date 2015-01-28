Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbbA2BWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:22:52 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:50387 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbbA2BWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:22:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: akpm@linux-foundation.org
Cc: Chris Mason <clm@fb.com>, Davide Libenzi <davidel@xmailserver.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] eventfs: avoid unused variable warning
Date: Wed, 28 Jan 2015 16:10:28 +0100
Message-ID: <88925492.FKoyo2trpD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:KE/XJbJLtG4D+hePLyWCBA1F5qz1jZy7SnrjIOOISXRZSw7a8Zi
 InyZz6EGnjHd9rezwn9DZ5Fk9ED4Gmbj6HINNFy8Oot1lLFUmDMXm5VlaIQqcOe+8ygkz18
 UNGjDmus08Wp6/tIdGh5unz18JHIT2cvOQ6yXQpKBuqeka9vEkVr3jzdpmXa+PBM7zI79OB
 FT3DhoNKtcbqRO3f6dZIA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An optimization patch from Chris Mason causes build warnings about
an unused variable.

The patch that broke this is currently in the akpm-current series,
so this fixup can be folded into the original patch. I was expecting
multiple people to send a patch for this, so I waited a bit at first.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 567162b87a5c5f  ("eventfd: don't take the spinlock in eventfd_poll")

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 439e6f0177f3..303ddc43dbee 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -118,7 +118,6 @@ static unsigned int eventfd_poll(struct file *file, poll_table *wait)
 {
 	struct eventfd_ctx *ctx = file->private_data;
 	unsigned int events = 0;
-	unsigned long flags;
 	unsigned int count;
 
 	poll_wait(file, &ctx->wqh, wait);

