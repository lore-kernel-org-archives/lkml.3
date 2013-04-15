Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab3DOCr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:47:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933490Ab3DOCnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:43:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 13/27] GFS2: return error if malloc failed in gfs2_rs_alloc()
Date: Sun, 14 Apr 2013 19:43:12 -0700
Message-Id: <20130415024232.346690958@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415024231.351969241@linuxfoundation.org>
References: <20130415024231.351969241@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 441362d06be349430d06e37286adce4b90e6ce96 upstream.

The error code in gfs2_rs_alloc() is set to ENOMEM when error
but never be used, instead, gfs2_rs_alloc() always return 0.
Fix to return 'error'.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/rgrp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -576,7 +576,7 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 	RB_CLEAR_NODE(&ip->i_res->rs_node);
 out:
 	up_write(&ip->i_rw_mutex);
-	return 0;
+	return error;
 }
 
 static void dump_rs(struct seq_file *seq, const struct gfs2_blkreserv *rs)


