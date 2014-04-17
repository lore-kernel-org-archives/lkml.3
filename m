Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaDQHSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:18:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42008 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaDQHSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:18:46 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7fcd6d00000315b-e6-534f8054ae21
Content-transfer-encoding: 8BIT
Message-id: <1397719003.7727.24.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: fix wrong number of max_nid when init
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 17 Apr 2014 16:16:43 +0900
In-reply-to: <000c01cf5a06$46b1ba30$d4152e90$@samsung.com>
References: <000c01cf5a06$46b1ba30$d4152e90$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zY92QBv9gg5NPzSz+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZbxf/Je1YDVXxY5b
	BQ2MKzi6GDk5JARMJN60bmODsMUkLtxbD2RzcQgJLGOU+LH4KCNM0YXuCcwQiUWMEjPPXGIB
	SfAKCEr8mHwPyObgYBaQlzhyKRskzCygLjFp3iKo+leMEsdfT2eHqNeR6Jv/nxXEFhbwlvh+
	7BMTSC+bgLbE5v0GIGEhAUWJt/vvgpWICChJ/Jq/iBViZqbEvaYZzCA2i4CqxOqzc8FO4BSw
	krjyrIcRotdSYv2n2WA1/AKiEocXbmeGuF9JYnd7JzvIPRICh9glVn15zQIxSEDi2+RDYPdL
	CMhKbDoAVS8pcXDFDZYJjBKzkHw5C+HLWUi+XMDIvIpRNLUguaA4Kb3IUK84Mbe4NC9dLzk/
	dxMjJNp6dzDePmB9iDEZaONEZinR5HxgtOaVxBsamxlZmJqYGhuZW5qRJqwkzpv0MClISCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2NFSZfGvB8+h6pl2JflxT8OKRK/MaNbaf2l3RLB6gs4
	D1S3Nnpf224o1aAs/qp3tr6Rz+xFAb909uywdH2vcPLMZ9GzXTUr8taZu5eXH9xztKNXj53p
	vsJMw92JJxZ0c01J4/uYWPH7jIimiHGUmsTdkF3us3dG9F75/bzo7zHfTR9D4/YJPFJiKc5I
	NNRiLipOBAAp/7gFzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd2QBv9gg5ePjSz+N31ks7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWa8X/yXtWA1V8WOWwUNjCs4uhg5OSQETCQudE9ghrDFJC7cW8/WxcjFISSw
	iFFi5plLLCAJXgFBiR+T7wHZHBzMAvISRy5lg4SZBdQlJs1bxAxR/4pR4vjr6ewQ9ToSffP/
	s4LYwgLeEt+PfWIC6WUT0JbYvN8AJCwkoCjxdv9dsBIRASWJX/MXsULMzJS41zQD7B4WAVWJ
	1Wfngp3AKWAlceVZDyNEr6XE+k+zwWr4BUQlDi/cDnW/ksTu9k72CYxCs5BcPQvh6llIrl7A
	yLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziWn0nvYFzVYHGIUYCDUYmHl/O3X7AQa2JZ
	cWXuIUYJDmYlEd7oWv9gId6UxMqq1KL8+KLSnNTiQ4zJQIdPZJYSTc4Hppm8knhDYxMzI0sj
	MwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamCsWes88Serz+oorhXvIxvEJP7f
	y1op+p7Vn6nzsBjP9yMyzG8vZxuttnnD6iD8TJV1eUzgStUeSVYLuwtdHPNv/H18aaJq/u3p
	//IPKGgz8/RPfGLw4IFose/zebP//amacTWvg0fyzstpzaq5XtMOZ9xfbxoRvXTNdI7PmYuv
	3Ps856n/JAl3JZbijERDLeai4kQAqsZRFikDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-04-17 (목), 14:27 +0800, Chao Yu:
> Since max_nid value was minus three in previous commit:
> 'b63da15e8b475245026bdf2096853683f189706b', Our last three nids could not be
> used ever, but 0/node nid/meta nid is still occupied.
> And also our ra_meta_pages() could not readahead the last block of NAT.

What is the root problem in there?
IIRC, the max_nid should not be turned back since that can cause an
infinite loop during build_free_nids() under a test using whole the
nids.

> Let's fix the wrong calculation of this value, and left the reserved nids there.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 84f9b7b..3f0bb50 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1860,7 +1860,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
>  	nat_blocks = nat_segs << le32_to_cpu(sb_raw->log_blocks_per_seg);
>  
>  	/* not used nids: 0, node, meta, (and root counted as valid node) */
> -	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks - 3;
> +	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks;
>  	nm_i->fcnt = 0;
>  	nm_i->nat_cnt = 0;
>  	nm_i->ram_thresh = DEF_RAM_THRESHOLD;

-- 
Jaegeuk Kim
Samsung

