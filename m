Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3J2Hgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:36:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18416 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3J2Hgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:36:43 -0400
X-AuditID: cbfee691-b7f866d000001b8c-39-526f65793d1f
From: Changman Lee <cm224.lee@samsung.com>
To: "'Chao Yu'" <chao2.yu@samsung.com>, jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <001f01ced473$4c5cc9c0$e5165d40$@samsung.com>
In-reply-to: <001f01ced473$4c5cc9c0$e5165d40$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros bitmap
 with bitops for better mount performance
Date: Tue, 29 Oct 2013 16:36:24 +0900
Message-id: <002a01ced479$925505e0$b6ff11a0$@samsung.com>
MIME-version: 1.0
Content-type: multipart/mixed;
 boundary="----=_NextPart_000_002B_01CED4C5.023E3480"
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJDVWMDlPIi5BHzS0Bii3fNyqKrlZkiQjFg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t8zI93K1Pwggy2nlSz+N31ks7i+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY97VF6wF
	jcYVX25fYW1g/KHZxcjJISFgItH24T4bhC0mceHeeiCbi0NIYBmjxJcHOxlhiiY0/mCFSCxi
	lGja3MIE4fxllHjU+JEdpIpNQEui/fRaFhBbRMBWYu7GW8wgNrNApsSc15NZQWwhAUuJ3Xce
	gcU5BawkPnw5AmYLC1RK7Jo/lwnEZhFQlTh+aTOYzQtUf6NrFiuELSjxY/I9FoiZoRJbL15l
	gbhOQWLH2deMEHuNJOafXMwIUSMise/FO0aQQyUEWjkkJt48zwyxQEDi2+RDQM0cQAlZiU0H
	mCHmSEocXHGDZQKj+Cwk62YhWTcLydhZQN3MAnoSbRsZIcLyEtvfzmGGCBdInNvABhHWlli2
	8DUzhJ0rcf7wWaYFjByrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUJie+IOxvsHrA8xTmQE
	unYis5Rocj4wOeSVxBsamxlZmJqYGhuZW5rRUlhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrx
	IUYmDk6pBsa456f4tJ5e3PBM7nlp7Karn9/tPO1cJPwwZn9Yv5iupk/RxH81SZa1L2oSLzDu
	/11p73bs7jTT94XN70PiQ0Qnu3y2nrXinmLBxzfHnQvPtbvdn+ByVqxBZLd2dMDtUrmp/tE/
	b5/OsV0r9Sjkj2Xsu9cvPospO88WebInet07ofMKebrLdxcqsRRnJBpqMRcVJwIAl+cj+DID	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGJsWRmVeSWpSXmKPExsVy+t9jAd3K1Pwggzs7pS3+N31ks7i+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPe1ResBY3GFV9uX2FtYPyh2cXIySEhYCIxofEHK4QtJnHh3nq2
	LkYuDiGBRYwSTZtbmCCcv4wSjxo/soNUsQloSbSfXssCYosI2ErM3XiLGcRmFsiUmPN6Mtgk
	IQFLid13HoHFOQWsJD58OQJmCwtUSuyaP5cJxGYRUJU4fmkzmM0LVH+jaxYrhC0o8WPyPRaI
	maESWy9eZYG4TkFix9nXjBB7jSTmn1zMCFEjIrHvxTvGCYyCs5C0z0LSPgtJ2SxGDiBbT6Jt
	IyNEWF5i+9s5zBDhAolzG9ggwtoSyxa+ZoawcyXOHz7LtICRYxWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGcOJ4JrWDcWWDxSFGAQ5GJR7eB8z5QUKsiWXFlbmHGFWA5jzasPoCoxRLXn5e
	qpII745goDRvSmJlVWpRfnxRaU5q8SHG/YzAgJnILCWanA9Md3kl8YbGJmZGlkZmFkYm5uaD
	R1hJnPdAq3WgkEB6YklqdmpqQWoRzAtMHJxSDYxZMRk9zavKFv5j0VOrnXahx62wrK15jYG4
	phzXGqEp36U/r8hZY75k454pW7m+b+CYs3bq/nJp0bdhE6suF50pWurwKO2i5ES7I0wCyxsa
	dd4wSxuyBcfuqDa48eW+iMukY28V0ux/N3LP1mWafo0xRzb5DGfm6Qvt0hn64QH6kqFbOWct
	fKnEUpyRaKjFXFScCABQIv06yQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_002B_01CED4C5.023E3480
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Review attached patch, please.

-----Original Message-----
From: Chao Yu [mailto:chao2.yu@samsung.com] 
Sent: Tuesday, October 29, 2013 3:51 PM
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros bitmap
with bitops for better mount performance

Previously, check_block_count check valid_map with bit data type in common
scenario that sit has all ones or zeros bitmap, it makes low mount
performance.
So let's check the special bitmap with integer data type instead of the bit
one.

v1-->v2:
    use find_next_{zero_}bit_le for better performance and readable as
Jaegeuk suggested.
	use neat logogram in comment as Gu Zheng suggested.
	search continuous ones or zeros for better performance when checking
mixed bitmap.

Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Signed-off-by: Shu Tan <shu.tan@samsung.com>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.h |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index abe7094..a7abfa8
100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -550,8 +550,9 @@ static inline void check_block_count(struct f2fs_sb_info
*sbi,  {
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
 	unsigned int end_segno = sm_info->segment_count - 1;
+	bool is_valid  = test_bit_le(0, raw_sit->valid_map) ? true : false;
 	int valid_blocks = 0;
-	int i;
+	int cur_pos = 0, next_pos;
 
 	/* check segment usage */
 	BUG_ON(GET_SIT_VBLOCKS(raw_sit) > sbi->blocks_per_seg); @@ -560,9
+561,19 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
 	BUG_ON(segno > end_segno);
 
 	/* check bitmap with valid block count */
-	for (i = 0; i < sbi->blocks_per_seg; i++)
-		if (f2fs_test_bit(i, raw_sit->valid_map))
-			valid_blocks++;
+	do {
+		if (is_valid) {
+			next_pos =
find_next_zero_bit_le(&raw_sit->valid_map,
+					sbi->blocks_per_seg,
+					cur_pos);
+			valid_blocks += next_pos - cur_pos;
+		} else
+			next_pos = find_next_bit_le(&raw_sit->valid_map,
+					sbi->blocks_per_seg,
+					cur_pos);
+		cur_pos = next_pos;
+		is_valid = !is_valid;
+	} while (cur_pos < sbi->blocks_per_seg);
 	BUG_ON(GET_SIT_VBLOCKS(raw_sit) != valid_blocks);  }
 
--
1.7.9.5


----------------------------------------------------------------------------
--
Android is increasing in popularity, but the open development platform that
developers love is also attractive to malware creators. Download this white
paper to learn more about secure code signing practices that can help keep
Android apps secure.
http://pubads.g.doubleclick.net/gampad/clk?id=65839951&iu=/4140/ostg.clktrk
_______________________________________________
Linux-f2fs-devel mailing list
Linux-f2fs-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

------=_NextPart_000_002B_01CED4C5.023E3480
Content-Type: application/octet-stream;
	name="0001-f2fs-use-pre-calculated-value-to-get-sum-of-valid-bl.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-f2fs-use-pre-calculated-value-to-get-sum-of-valid-bl.patch"

>From 05ca99b07e28e1fe970e0ed547b51f93a9c0b94c Mon Sep 17 00:00:00 2001=0A=
From: Changman Lee <cm224.lee@samsung.com>=0A=
Date: Tue, 29 Oct 2013 16:34:43 +0900=0A=
Subject: [PATCH] f2fs: use pre-calculated value to get sum of valid =
blocks=0A=
=0A=
Using pre-calculated value is more fast than looking into bitmap on=0A=
runnnig time.=0A=
=0A=
Signed-off-by: Changman Lee <cm224.lee@samsung.com>=0A=
---=0A=
 fs/f2fs/f2fs.h    |    1 +=0A=
 fs/f2fs/hash.c    |   24 ++++++++++++++++++++++++=0A=
 fs/f2fs/segment.h |    4 ++--=0A=
 3 files changed, 27 insertions(+), 2 deletions(-)=0A=
=0A=
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h=0A=
index a61cc5f..288be6a 100644=0A=
--- a/fs/f2fs/f2fs.h=0A=
+++ b/fs/f2fs/f2fs.h=0A=
@@ -71,6 +71,7 @@ static inline bool f2fs_crc_valid(__u32 blk_crc, void =
*buf, size_t buf_size)=0A=
 	return f2fs_crc32(buf, buf_size) =3D=3D blk_crc;=0A=
 }=0A=
 =0A=
+extern int bit_count_byte(unsigned char);=0A=
 /*=0A=
  * For checkpoint manager=0A=
  */=0A=
diff --git a/fs/f2fs/hash.c b/fs/f2fs/hash.c=0A=
index 6eb8d26..2dd9b5a 100644=0A=
--- a/fs/f2fs/hash.c=0A=
+++ b/fs/f2fs/hash.c=0A=
@@ -99,3 +99,27 @@ f2fs_hash_t f2fs_dentry_hash(const char *name, size_t =
len)=0A=
 	f2fs_hash =3D cpu_to_le32(hash & ~F2FS_HASH_COL_BIT);=0A=
 	return f2fs_hash;=0A=
 }=0A=
+=0A=
+static const int bits_in_byte[256] =3D {=0A=
+	0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,=0A=
+	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,=0A=
+	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,=0A=
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,=0A=
+	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,=0A=
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,=0A=
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,=0A=
+	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,=0A=
+	1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,=0A=
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,=0A=
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,=0A=
+	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,=0A=
+	2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,=0A=
+	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,=0A=
+	3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,=0A=
+	4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8,=0A=
+};=0A=
+=0A=
+int bit_count_byte(unsigned char n)=0A=
+{=0A=
+	return bits_in_byte[n];=0A=
+}=0A=
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h=0A=
index abe7094..d5aa4cc 100644=0A=
--- a/fs/f2fs/segment.h=0A=
+++ b/fs/f2fs/segment.h=0A=
@@ -561,8 +561,8 @@ static inline void check_block_count(struct =
f2fs_sb_info *sbi,=0A=
 =0A=
 	/* check bitmap with valid block count */=0A=
 	for (i =3D 0; i < sbi->blocks_per_seg; i++)=0A=
-		if (f2fs_test_bit(i, raw_sit->valid_map))=0A=
-			valid_blocks++;=0A=
+		valid_blocks +=3D bit_count_byte(raw_sit->valid_map[i]);=0A=
+=0A=
 	BUG_ON(GET_SIT_VBLOCKS(raw_sit) !=3D valid_blocks);=0A=
 }=0A=
 =0A=
-- =0A=
1.7.10.4=0A=
=0A=

------=_NextPart_000_002B_01CED4C5.023E3480--

