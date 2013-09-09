Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3IIFjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:39:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61150 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3IIFju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:39:50 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-a3-522d5f25ea21
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'Suman Anna'" <s-anna@ti.com>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] iommu/omap: Remove casting the return value which is a void
 pointer
Date: Mon, 09 Sep 2013 14:39:49 +0900
Message-id: <005601cead1e$ffe78470$ffb68d50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6tHvqUz/W8YEirQwmsXLZ7N3w7pA==
Content-language: ko
x-cr-hashedpuzzle: GSlZ HRyP L/pA QFLA RMY4 TuV6 YJw+ a5Rw bbud e8JZ rAUF uRrG
 xeWg 0e4/ 2IZV
 6GuV;5;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBqAG8AcgBvAEAAOABiAHkAdABlAHMALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBzAC0AYQBuAG4AYQBAAHQAaQAuAGMAbwBtAA==;Sosha1_v1;7;{4EC1CE94-D57B-4BA9-8BBB-61D2AA1B2671};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 09 Sep 2013 05:39:40
 GMT;WwBQAEEAVABDAEgAXQAgAGkAbwBtAG0AdQAvAG8AbQBhAHAAOgAgAFIAZQBtAG8AdgBlACAAYwBhAHMAdABpAG4AZwAgAHQAaABlACAAcgBlAHQAdQByAG4AIAB2AGEAbAB1AGUAIAB3AGgAaQBjAGgAIABpAHMAIABhACAAdgBvAGkAZAAgAHAAbwBpAG4AdABlAHIA
x-cr-puzzleid: {4EC1CE94-D57B-4BA9-8BBB-61D2AA1B2671}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zY13VeN0gg5e7tSzmrF/DZnF54SVW
	i87ZG9gtLu+aw2ax99c+VgdWjycH5zF5nJjxm8Wjb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVcfp7G2vBJbaKy2fusDYwXmLtYuTkkBAwkbi7fA87hC0mceHeerYuRi4OIYFljBL/
	n6xmgilasH4pK0RiEaNE35MXTBDOL0aJjgNrwUaxCahJfPlyGGgUB4eIgL5EW4sGSA2zQBuj
	xIV961hAaoQFwiT63/0Gm8oioCoxf/5tMJtXwFZi8+spULagxI/J98DqmQW0JNbvPM4EYctL
	bF7zlhlkvoSAusSjv7ogYREBPYklCw6yQZSISOx78Y4RZK+EwBVWidlbbrBBfGAqceLJFqjE
	I3aJNZ/fskIcISDxbfIhFoihshKbDjBD1EtKHFxxg2UCo8QsJCfNQnLSLCQnzUKyewEjyypG
	0dSC5ILipPQiY73ixNzi0rx0veT83E2MkGjt38F494D1IcZkoPUTmaVEk/OB0Z5XEm9obGZk
	YWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbdZ+rDiids/JFh
	tHCTXuPmC82SWcKaZV9XR8zp1fdxfydSGGevE9NrUa3rs82hu/7Vx8uu23R8VquWC0l4PP24
	tycv7DrD5YlVk7/Pt7MN8buq5NH21lrP+lOUv9GKR9kpAX/eJDDVPeNWP6o41/H+rDNbzNQn
	PeMX3Lo41KLCqz1C4srhE0osxRmJhlrMRcWJANnFsxDsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV3VeN0gg0+n1CzmrF/DZnF54SVW
	i87ZG9gtLu+aw2ax99c+VgdWjycH5zF5nJjxm8Wjb8sqRo/jN7YzeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHH6extrwSW2istn7rA2MF5i7WLk5JAQMJFY
	sH4plC0mceHeerYuRi4OIYFFjBJ9T14wQTi/GCU6DqwFq2ITUJP48uUwexcjB4eIgL5EW4sG
	SA2zQBujxIV961hAaoQFwiT63/1mArFZBFQl5s+/DWbzCthKbH49BcoWlPgx+R5YPbOAlsT6
	nceZIGx5ic1r3jKDzJcQUJd49FcXJCwioCexZMFBNogSEYl9L94xguyVELjCKjF7yw02iA9M
	JU482cI4gVFoFpIVs5CsmIVkxSwksxYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4F
	z6R3MK5qsDjEKMDBqMTDe0NQN0iINbGsuDL3EKMEB7OSCO/55zpBQrwpiZVVqUX58UWlOanF
	hxiTgSEwkVlKNDkfmKbySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOF
	iYNTqoHR67ZZyi8Zz4DmFtO1EhsDzKzlnqee5OB6Puu1VEWFywt2iapyo19/KrteLZK5cOf9
	/wOTu1WXTVnAuv7kd88OhyOvTn7JizU3kNx98aDz1jUHXF5lh9QkBU7PNbK0DL32dJmU9KLT
	UWH3OJvyLD5eY9V9//+4bIjmT+mX+1qsJFaf7LBOKpNQYinOSDTUYi4qTgQAdJb+v0kDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting the return value which is a void pointer is redundant.
The conversion from void pointer to any other pointer type is
guaranteed by the C programming language.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/iommu/omap-iopgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/omap-iopgtable.h b/drivers/iommu/omap-iopgtable.h
index f4003d5..b6f9a51 100644
--- a/drivers/iommu/omap-iopgtable.h
+++ b/drivers/iommu/omap-iopgtable.h
@@ -95,4 +95,4 @@ static inline phys_addr_t omap_iommu_translate(u32 d, u32 va, u32 mask)
 #define iopte_offset(iopgd, da)	(iopgd_page_vaddr(iopgd) + iopte_index(da))
 
 #define to_iommu(dev)							\
-	((struct omap_iommu *)platform_get_drvdata(to_platform_device(dev)))
+	(platform_get_drvdata(to_platform_device(dev)))
-- 
1.7.10.4


