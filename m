Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaDRGiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 02:38:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62947 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaDRGhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 02:37:09 -0400
X-AuditID: cbfee68f-b7f156d00000276c-a2-5350c813ad1d
Message-id: <1397802904.4283.1.camel@kjgkr>
Subject: Re: f2fs: BUG_ON() is triggered when mount valid f2fs filesystem
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Andrey Tsyvarev <tsyvarev@ispras.ru>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 18 Apr 2014 15:35:04 +0900
In-reply-to: <5350C06A.4090807@ispras.ru>
References: <52F320FC.50803@ispras.ru> <534BC29B.3020408@ispras.ru>
 <1397559864.7727.5.camel@kjgkr> <534E494C.7050909@ispras.ru>
 <1397691337.7727.18.camel@kjgkr> <534F2A32.9030405@ispras.ru>
 <1397720720.7727.28.camel@kjgkr> <5350C06A.4090807@ispras.ru>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zA13hEwHBBp8uc1nsWLeT3eLSIneL
	y7vmsFksvxznwOIx499URo/dCz4zeXzeJBfAHMVlk5Kak1mWWqRvl8CVcenQTtaC4wIVs/Yt
	ZW1gvMvbxcjJISFgItG45B4zhC0mceHeerYuRi4OIYFljBJXl59i6mLkACua26oMEZ/OKLFw
	8g1WCOcVo8SyrdtZQLp5BbQlGh5OAZskLOApsXHqFbBmNqD45v0GIGEhAUWJt/vvsoLYIgJ6
	Eh9fbWUCmcMs0MgosaZlIyNIgkVAVWLz33NMIDangKZEw7E/UMuamCQuNz5hA0nwC4hKHF64
	HWwZs4C6xKR5i6BeUJLY3d7JDhGXl9i85i0zxHGCEj8m32MBGSQhcIpd4vCZZVDbBCS+TT7E
	AvGmrMSmA1BzJCUOrrjBMoFRYhaSFbOQjJ2FZOwCRuZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ
	+bmbGCEx17+D8e4B60OMyUArJzJLiSbnA2M2ryTe0NjMyMLUxNTYyNzSjDRhJXHe+w+TgoQE
	0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwbipz2MJ98H7oRfcdzx5dtouT6Xh8J1fcz/6Fy6nS
	ZWvuW8pPfvo1y+GVajpDbLp/4zFvNqHNwjsZ+heXLlqfN8fWsEba/PC1Sz3qz+fu27DB2eNF
	b7UIi2uP6NdlnKduhPF1XixL7J8pY70oauWETp0KaaGd94In7GmZ1JVjNq/McS/TTa3jSizF
	GYmGWsxFxYkAuRD7Lc8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQV3hEwHBBhe2sFnsWLeT3eLSIneL
	y7vmsFksvxznwOIx499URo/dCz4zeXzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxv
	amZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtExJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9I
	EFyPkQEaSFjHmHHp0E7WguMCFbP2LWVtYLzL28XIwSEhYCIxt1W5i5ETyBSTuHBvPVsXIxeH
	kMB0RomFk2+wQjivGCWWbd3OAlLFK6At0fBwCjOILSzgKbFx6hUmkEFsQPHN+w1AwkICihJv
	999lBbFFBPQkPr7aygQyh1mgkVFiTctGRpAEi4CqxOa/55hAbE4BTYmGY3+gljUxSVxufMIG
	kuAXEJU4vHA72DJmAXWJSfMWMUOcqiSxu72THSIuL7F5zVtmiOMEJX5MvscygVFoFpKWWUjK
	ZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOKKfSe1gXNlgcYhRgINRiYdXQC8g
	WIg1say4MvcQowQHs5IIr3IpUIg3JbGyKrUoP76oNCe1+BBjMtB7E5mlRJPzgckmryTe0NjE
	zMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYJ767nnl9xmdxPoXqeDfh
	4jVBgh9S7xsVPfvvcvzWxvf52TktW49LbNsuevjLq12LHx25sOd/fdLSg9In3+zT+hsW3Oy+
	zzz3C4vDoqkp65v/Fz397fR64eKpj7aIeryScJWbP3tmT/+kKq5JBydOMw3e+uTUZZu6a9Wh
	bzM6r15xZsl/y9b3crESS3FGoqEWc1FxIgD36yXJLAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the explanation.
The following patch will resolve the issue.
Thanks,

>From 2048e7458c982f4297da9d3366ab29224ae2e8b0 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Fri, 18 Apr 2014 15:21:04 +0900
Subject: [PATCH] f2fs: avoid BUG_ON when mouting corrupted image having
 garbage blocks

If the disk has some garbage blocks, F2FS is able to face with BUG_ON
when
recovering direct node blocks.
This patch detects the error case and avoids that prior to reaching
BUG_ON.

Alexey Khoroshilov addressed the potential security issues as follows.
"An ability to trigger a BUG_ON assert by mounting a crafted image is
usually considered as a local denial of service [1-3]. As far as I
understand, the reason is that some kernel data may become inconsistent
that can lead to further problems.

[1] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3353
[2] http://www.openwall.com/lists/oss-security/2011/06/24/4
[3] http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-2928
etc."

Reported-by: Andrey Tsyvarev <tsyvarev@ispras.ru>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 6ebdba1..64755f4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1609,6 +1609,11 @@ int recover_inode_page(struct f2fs_sb_info *sbi,
struct page *page)
 	struct node_info old_ni, new_ni;
 	struct page *ipage;
 
+	get_node_info(sbi, ino, &old_ni);
+
+	if (unlikely(old_ni.blk_addr != NULL_ADDR))
+		return -EINVAL;
+
 	ipage = grab_cache_page(NODE_MAPPING(sbi), ino);
 	if (!ipage)
 		return -ENOMEM;
@@ -1616,7 +1621,6 @@ int recover_inode_page(struct f2fs_sb_info *sbi,
struct page *page)
 	/* Should not use this inode  from free nid list */
 	remove_free_nid(NM_I(sbi), ino);
 
-	get_node_info(sbi, ino, &old_ni);
 	SetPageUptodate(ipage);
 	fill_node_footer(ipage, ino, ino, 0, true);
 
-- 
1.8.4.474.g128a96c




-- 
Jaegeuk Kim
Samsung

