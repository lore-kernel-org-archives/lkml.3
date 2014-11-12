Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbaKLCdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:33:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934980AbaKLBrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:47:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3.14 184/203] mm: Remove false WARN_ON from pagecache_isize_extended()
Date: Wed, 12 Nov 2014 10:17:34 +0900
Message-Id: <20141112011551.122446875@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit f55fefd1a5a339b1bd08c120b93312d6eb64a9fb upstream.

The WARN_ON checking whether i_mutex is held in
pagecache_isize_extended() was wrong because some filesystems (e.g.
XFS) use different locks for serialization of truncates / writes. So
just remove the check.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/truncate.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -649,7 +649,6 @@ void pagecache_isize_extended(struct ino
 	struct page *page;
 	pgoff_t index;
 
-	WARN_ON(!mutex_is_locked(&inode->i_mutex));
 	WARN_ON(to > inode->i_size);
 
 	if (from >= to || bsize == PAGE_CACHE_SIZE)


