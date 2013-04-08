Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670Ab3DHIKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:10:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19499 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934484Ab3DHIKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:10:37 -0400
X-AuditID: cbfee68e-b7f946d000001e37-16-51627b7cabab
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: write checkpoint before starting FG_GC
Date: Mon, 08 Apr 2013 17:09:41 +0900
Message-id: <1365408581-22997-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zY92a6qRAgyerWS2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyljUvY+x4DFrxZzF
	C1kbGG+wdDFyckgImEi07XzPCmGLSVy4t56ti5GLQ0hgGaNE4/U2Rpiilif3mSAS0xkllm1f
	wgzhtDFJzGo5xt7FyMHBJqAtsXm/AUiDiACzxIKp5xlBapgFJjBK/F/0HmydsICtxJJWiHUs
	AqoS+16dZgexeQXcJbbefscGsU1XYvX/5+wgzRICj9kk7vz/yATRICDxbfIhFpBlEgKyEpsO
	MEPUS0ocXHGDZQKj4AJGhlWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIUHYt4Px5gHrQ4zJ
	QOMmMkuJJucDgzivJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYwbNmw/1CNosYdPQ2LrhGP/wpdsOJSfsThMMGWx9+pCXgn9Fwer2u5zdF8SiOHc
	EPCgf/2xiVOWbjLbUM1+VeSrtt3UiSt41EuZGK78eyiuHsF6aWXpn8zz89WDV7KxKx2ts/z9
	auK8VUVuCh5HZ768uOrT9j2H/oSt6el7tkq53MWp2uHBv66LSizFGYmGWsxFxYkAxe2M51gC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQd2a6qRAgz1SFtd3/WWyuLTI3WLP
	3pMsFpd3zWFzYPHYveAzk0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8eb
	mhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYALVNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsS
	BNdjZIAGEtYxZizq3sdY8Ji1Ys7ihawNjDdYuhg5OSQETCRantxngrDFJC7cW8/WxcjFISQw
	nVFi2fYlzBBOG5PErJZj7F2MHBxsAtoSm/cbgDSICDBLLJh6nhGkhllgAqPE/0XvwaYKC9hK
	LGl9zwpiswioSux7dZodxOYVcJfYevsdG8Q2XYnV/5+zT2DkXsDIsIpRNLUguaA4KT3XUK84
	Mbe4NC9dLzk/dxMjOMCfSe1gXNlgcYhRgINRiYdX8kdioBBrYllxZe4hRgkOZiUR3kV5SYFC
	vCmJlVWpRfnxRaU5qcWHGJOBtk9klhJNzgdGX15JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOF
	BNITS1KzU1MLUotgtjBxcEo1MM7TSTcQWFgb8uVg4j7WCxl3IjqSvsxuMap8vLi49tGbv9a/
	7rDpbxBgvHLyROUv64lbD1wVk5v+bYvwjjvfpi2z+P5N6MI5XfNZMq0rrv+LNr+SdOLwp41S
	k3McJT2Xt8TrG13Tub/34naPUz3sUR3rL4UHT9kqeOOp5Ma2zhuBTUUv9lzZ8rJLiaU4I9FQ
	i7moOBEAH7kjf7QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be aware of prefree and free sections during FG_GC, let's start with
write_checkpoint().

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/gc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 83cec8f..37b05e1 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -669,8 +669,10 @@ gc_more:
 	if (!(sbi->sb->s_flags & MS_ACTIVE))
 		goto stop;
 
-	if (gc_type == BG_GC && has_not_enough_free_secs(sbi, nfree))
+	if (gc_type == BG_GC && has_not_enough_free_secs(sbi, nfree)) {
 		gc_type = FG_GC;
+		write_checkpoint(sbi, false);
+	}
 
 	if (!__get_victim(sbi, &segno, gc_type, NO_CHECK_TYPE))
 		goto stop;
-- 
1.8.1.3.566.gaa39828

