Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757Ab3GSHLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:11:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31315 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3GSHLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:11:11 -0400
X-AuditID: cbfee68e-b7f276d000002279-7f-51e8e68d25b4
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] firmware: google: replace strict_strtoul() with kstrtoul()
Date: Fri, 19 Jul 2013 16:11:09 +0900
Message-id: <001001ce844f$24aaa8d0$6dfffa70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6ETvSpZ8Mv/6giSV2zG3W929Zlpw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zQ93eZy8CDd7t0rGYs34Nm8XlhZdY
	LS7vmsPmwOxxYsZvFo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DK+P7nKFPBFtaKTTceMjYw
	7mDpYuTkkBAwkWi+NZcNwhaTuHBvPZDNxSEksIxRov3DPFaYohdve8AahASmM0q82WsAYf9i
	lOj64QhiswmoSXz5cpgdxBYR0JVY9XwXM4jNLOAk8XPLTLBeYQFviY4Xa5lAbBYBVYlDPw6C
	2bwClhJ/p71ghbAFJX5MvscC0aslsX7ncSYIW15i85q3zBD3KEjsOPuaEWKXnsSrnutQu0Qk
	9r14xwjygITAPHaJZy+WsEEsE5D4NvkQ0FAOoISsxKYDUHMkJQ6uuMEygVFsFpLVs5CsnoVk
	9SwkKxYwsqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECImovh2MNw9YH2JMBlo/kVlKNDkf
	GJF5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamD0
	6t/QGHPL+gjHru9G5sIPpH5sfSB5czbLpYl/A7x7uCIbJ2vliTX0vVql7NQw4/j0y5+Lz0pq
	O81myjrk7mfS/E9tr+qS1rrO8qsTVqtZmxhedL9a1q7sHH1P3JJTWeJHbuH022fPGLltm2N3
	xkBa4wnfZV9Dzq4fratmBT6KURF5nPZxr5MSS3FGoqEWc1FxIgDssYISvgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoG7vsxeBBidfaVjMWb+GzeLywkus
	Fpd3zWFzYPY4MeM3i0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZnz/c5SpYAtrxaYbDxkbGHewdDFyckgImEi8eNsDZYtJXLi3ng3EFhKYzijxZq8B
	hP2LUaLrhyOIzSagJvHly2F2EFtEQFdi1fNdzCA2s4CTxM8tM8HmCAt4S3S8WMsEYrMIqEoc
	+nEQzOYVsJT4O+0FK4QtKPFj8j0WiF4tifU7jzNB2PISm9e8ZYa4R0Fix9nXjBC79CRe9VyH
	2iUise/FO8YJjAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj
	OF6fSe1gXNlgcYhRgINRiYf3wZfngUKsiWXFlbmHGCU4mJVEeH8lvwgU4k1JrKxKLcqPLyrN
	SS0+xJgM9OlEZinR5HxgKskriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoR
	zBYmDk6pBkamORMDooPsTgRf4Jm32F9683rZaZeWWebkvrzmy6oadO6ijMvu2ZHWd93aH247
	L/nOLLlvQavtgYWHWjZabWopt/WS7G7bM5HxlvHENKOy0nuPl/wPX/h9jo1MzRThTJVWDqkl
	V5krS39Hztswa6KV/O8bS1fm5D5msCt+LBhaqeR+T3Gv3W4lluKMREMt5qLiRABFnLG6GwMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/firmware/google/gsmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index acba0b9..6eb535f 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -525,7 +525,7 @@ static ssize_t gsmi_clear_eventlog_store(struct kobject *kobj,
 		u32 data_type;
 	} param;
 
-	rc = strict_strtoul(buf, 0, &val);
+	rc = kstrtoul(buf, 0, &val);
 	if (rc)
 		return rc;
 
-- 
1.7.10.4


