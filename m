Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab3EFUuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:50:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab3EFUrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:47:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 093/115] nfsd: use kmem_cache_free() instead of kfree()
Date: Mon,  6 May 2013 13:45:29 -0700
Message-Id: <20130506203105.159760861@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 2c44a23471d048118e49b616d08df0729cdbd9f1 upstream.

memory allocated by kmem_cache_alloc() should be freed using
kmem_cache_free(), not kfree().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -261,7 +261,7 @@ kmem_cache *slab)
 		min_stateid = 0;
 	return stid;
 out_free:
-	kfree(stid);
+	kmem_cache_free(slab, stid);
 	return NULL;
 }
 


