Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab3GEFWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 01:22:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GEFWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 01:22:19 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-95-51d6580906eb
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] f2fs: fix readdir incorrectness
Date: Fri, 05 Jul 2013 14:22:10 +0900
Message-id: <1373001730-6928-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t8zI13OiGuBBj2TlSyu7/rLZHFpkbvF
	nr0nWSwu75rDZnH+73FWB1aP3Qs+M3n0bVnF6PF5k5zHpidvmQJYorhsUlJzMstSi/TtErgy
	Ns0+zl7Qx1OxcvUp5gbGQ5xdjJwcEgImEue3fWWEsMUkLtxbzwZiCwksY5RoWG3ZxcgBVtPf
	kQYRXsQocf2HC4TdxiRx4LoWSAmbgLbE5v0GIGERAWaJBVPPA03k4mAW2MoocXLTIrCRwgIG
	ElOefmUBsVkEVCVmLW4Fi/MKuEks/rmHGeIEXYlFJw6ygjRLCLxmk2jct48JokFA4tvkQywQ
	98hKbDoAVS8pcXDFDZYJjIILGBlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYoQE5IQdjPcO
	WB9iTAYaN5FZSjQ5HxjQeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUX
	leakFh9iZOLglGpgrGUUY2Rh+dpd2aRxb6GZ5QEHLvXlFs15yWdnht5tlWe5eF84eTkf4+YH
	akG/d5W87lv9edqERZdPPZl246L6z8h4VvadCtvLUqZKPz/G88LsxX6hwvKNzfuD/i5/l3G+
	xl51bt2vZRcF/h11OZOQpDmh1/q9+JN5P24H517cq3GhR29S9JK8lUosxRmJhlrMRcWJALkS
	OVReAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jAV3OiGuBBrs+y1pc3/WXyeLSIneL
	PXtPslhc3jWHzeL83+OsDqweuxd8ZvLo27KK0ePzJjmPTU/eMgWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZmyafZy9oI+nYuXqU8wNjIc4uxg5OCQETCT6O9K6GDmB
	TDGJC/fWs4HYQgKLGCWu/3CBsNuYJA5c1wIpZxPQlti83wAkLCLALLFg6nnGLkYuDmaBrYwS
	JzctAusVFjCQmPL0KwuIzSKgKjFrcStYnFfATWLxzz3MELt0JRadOMg6gZF7ASPDKkbR1ILk
	guKk9FwjveLE3OLSvHS95PzcTYzggH8mvYNxVYPFIUYBDkYlHt4H9VcDhVgTy4orcw8xSnAw
	K4nwerwHCvGmJFZWpRblxxeV5qQWH2JMBto+kVlKNDkfGI15JfGGxiZmRpZGZhZGJubmpAkr
	ifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cBYksG/WVEkc+ME2YKTp6SEgq4E9Ha77X4jleW6
	e90dEYGgK71s+x5t4Q28e7Ku/MfseqvXzr6N/UdFyywk59VeXF/w/vb2gtodS/tLjvg880oy
	C+FIlMlMfeuz5FFzaYq7uPC56VJ5knea+aWfm63cF7S8IFi0PotHYUU9T6J8z/y+idy/Diqx
	FGckGmoxFxUnAgD0GT7TvAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the previous Al Viro's readdir patch set, there occurs a bug when running
xfstest: 006 as follows.

[Error output]
alpha size = 4, name length = 6, total files = 4096, nproc=1
1023 files created
rm: cannot remove `/mnt/f2fs/permname.15150/a': Directory not empty

[Correct output]
alpha size = 4, name length = 6, total files = 4096, nproc=1
4097 files created

This bug is due to the misupdate of directory position in ctx.
So, this patch fixes this.

CC: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 9d1cd42..8008d60 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -634,7 +634,6 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 			if (bit_pos >= NR_DENTRY_IN_BLOCK)
 				break;
 
-			ctx->pos += bit_pos - start_bit_pos;
 			de = &dentry_blk->dentry[bit_pos];
 			if (de->file_type < F2FS_FT_MAX)
 				d_type = f2fs_filetype_table[de->file_type];
@@ -643,8 +642,10 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 			if (!dir_emit(ctx,
 				      dentry_blk->filename[bit_pos],
 				      le16_to_cpu(de->name_len),
-				      le32_to_cpu(de->ino), d_type))
+				      le32_to_cpu(de->ino), d_type)) {
+				ctx->pos += bit_pos - start_bit_pos;
 				goto success;
+			}
 			slots = GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 			bit_pos += slots;
 		}
-- 
1.8.3.1.437.g0dbd812

