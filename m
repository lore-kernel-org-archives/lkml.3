Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab3ASBUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:20:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:57008 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab3ASBUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:20:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
        CAI Qian <caiqian@redhat.com>
Subject: [ 08/21] ext4: init pagevec in ext4_da_block_invalidatepages
Date: Fri, 18 Jan 2013 17:19:26 -0800
Message-Id: <20130119010712.801322739@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119010710.897187774@linuxfoundation.org>
References: <20130119010710.897187774@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 66bea92c69477a75a5d37b9bfed5773c92a3c4b4 upstream.

ext4_da_block_invalidatepages is missing a pagevec_init(),
which means that pvec->cold contains random garbage.

This affects whether the page goes to the front or
back of the LRU when ->cold makes it to
free_hot_cold_page()

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1424,6 +1424,8 @@ static void ext4_da_block_invalidatepage
 
 	index = mpd->first_page;
 	end   = mpd->next_page - 1;
+
+	pagevec_init(&pvec, 0);
 	while (index <= end) {
 		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
 		if (nr_pages == 0)


