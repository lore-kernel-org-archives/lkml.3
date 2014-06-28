Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbaF1TVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:21:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbaF1RrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.4 38/43] Btrfs: fix double free in find_lock_delalloc_range
Date: Sat, 28 Jun 2014 10:46:29 -0700
Message-Id: <20140628174451.530385547@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 7d78874273463a784759916fc3e0b4e2eb141c70 upstream.

We need to NULL the cached_state after freeing it, otherwise
we might free it again if find_delalloc_range doesn't find anything.

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/extent_io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1551,6 +1551,7 @@ again:
 		 * shortening the size of the delalloc range we're searching
 		 */
 		free_extent_state(cached_state);
+		cached_state = NULL;
 		if (!loops) {
 			unsigned long offset = (*start) & (PAGE_CACHE_SIZE - 1);
 			max_bytes = PAGE_CACHE_SIZE - offset;


