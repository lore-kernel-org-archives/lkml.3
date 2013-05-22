Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3EVDed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 23:34:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11438 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab3EVDeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 23:34:18 -0400
X-AuditID: cbfee691-b7fef6d000002d62-59-519c3cb83c9f
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: use ihold
Date: Wed, 22 May 2013 12:33:04 +0900
Message-id: <1369193584-2963-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369193584-2963-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369193584-2963-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zfd0dNnMCDbbuZLO4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PNgtssBdPYKh4/
	amRvYOxl7WLk4JAQMJF4sKWwi5ETyBSTuHBvPVsXIxeHkMAyRolDF+czwdSc2xUMEV/EKHH2
	yil2CKeNSWJzxw42kCI2AW2JzfsNQAaJCDBLLJh6nhGkhllgAqPE/0XvWUASwgIqEosP32IE
	sVkEVCX+32tgArF5BdwkOi50M0JcoSux+v9zdhCbU8BdYt6rrcwgthBQzasbH1khav6zSbxe
	JQMxR0Di2+RDLBCHykpsOsAMUSIpcXDFDZYJjMILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl
	5+duYoSE68QdjPcPWB9iTAYaN5FZSjQ5HxjueSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJ
	pCeWpGanphakFsUXleakFh9iZOLglGpg5NNNtToWe1njjB+X72bzCcGi31yZXkv6tnLvdfWK
	bp4y6dopO5V6ncWl9yfeb5E5GnXPqf9jh2gRw/q/Rw6ZrZ3wTuGVVlJP8/RLUXu3r1/1w2vW
	S+8dcXY5bUusZ6xbUNXq+KvK/bXSGavbutviZ1+5yn3lvIxLwosTaR+fHNn7yCH+7M+w80os
	xRmJhlrMRcWJAFLOWB5tAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd0dNnMCDc72MFtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jxZsFtloJpbBWPHzWyNzD2snYxcnBICJhInNsV3MXICWSKSVy4t56ti5GL
	Q0hgEaPE2Sun2CGcNiaJzR072EAa2AS0JTbvNwBpEBFgllgw9TwjSA2zwARGif+L3rOAJIQF
	VCQWH77FCGKzCKhK/L/XwARi8wq4SXRc6GaE2KYrsfr/c3YQm1PAXWLeq63MILYQUM2rGx9Z
	JzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHBHPpHYwrmywOMQowMGoxMP7oHZ2
	oBBrYllxZe4hRgkOZiUR3lVqcwKFeFMSK6tSi/Lji0pzUosPMSYDXTWRWUo0OR8YrXkl8YbG
	JmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwCh28vnzmLDsRNFPSdsr
	DFi+TPR5np2068yd1YtKv+Y6hV7fnlRUoGLlw19+k6lGNye5tt3w+FrhXMHPGwVuXPjWnSz6
	aW4or/298syzwn/FK6OfH5x/JoBzahV3WGXwzAN7i44c3C2RZXto7YuGjWcWpFWoGx1av8aG
	Qahz5xTGdT0ndr9avk2JpTgj0VCLuag4EQDvniSizAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the following helper function committed by Al.

commit 7de9c6ee3ecffd99e1628e81a5ea5468f7581a1f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Oct 23 11:11:40 2010 -0400

    new helper: ihold()

...

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 71aa305..efe0a12 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -172,7 +172,7 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 	f2fs_balance_fs(sbi);
 
 	inode->i_ctime = CURRENT_TIME;
-	atomic_inc(&inode->i_count);
+	ihold(inode);
 
 	set_inode_flag(F2FS_I(inode), FI_INC_LINK);
 	ilock = mutex_lock_op(sbi);
-- 
1.8.1.3.566.gaa39828

