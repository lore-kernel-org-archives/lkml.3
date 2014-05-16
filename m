Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaEPMsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:48:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49534 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753052AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>
Date: Fri, 16 May 2014 13:47:20 +0100
Message-ID: <lsq.1400244440.622159978@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 03/34] ext4: use i_size_read in ext4_unaligned_aio()
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 6e6358fc3c3c862bfe9a5bc029d3f8ce43dc9765 upstream.

We haven't taken i_mutex yet, so we need to use i_size_read().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -80,7 +80,7 @@ ext4_unaligned_aio(struct inode *inode,
 	size_t count = iov_length(iov, nr_segs);
 	loff_t final_size = pos + count;
 
-	if (pos >= inode->i_size)
+	if (pos >= i_size_read(inode))
 		return 0;
 
 	if ((pos & blockmask) || (final_size & blockmask))

