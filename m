Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab3LBVas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:30:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3LBTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:07:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.4 25/60] ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()
Date: Mon,  2 Dec 2013 11:06:06 -0800
Message-Id: <20131202190335.757831181@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit dcb9917ba041866686fe152850364826c4622a36 upstream.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/xattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1270,6 +1270,7 @@ retry:
 					new_extra_isize = s_min_extra_isize;
 					kfree(is); is = NULL;
 					kfree(bs); bs = NULL;
+					brelse(bh);
 					goto retry;
 				}
 				error = -1;


