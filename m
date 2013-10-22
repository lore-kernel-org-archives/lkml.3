Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab3JVMYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:24:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21613 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3JVMYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:24:07 -0400
X-AuditID: cbfee68f-b7f836d000001b39-4e-52666e650e04
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1382444612.992.67.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: check all ones or zeros bitmap with
 integer data type for better mount performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Tue, 22 Oct 2013 21:23:32 +0900
In-reply-to: <000701cecf09$2b2a2280$817e6780$@samsung.com>
References: <000701cecf09$2b2a2280$817e6780$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zI93UvLQgg1tLVCz+N31ks7i0yN1i
	z96TLBaXd81hs2hdeJ7ZgdVj94LPTB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CV0f/9IXvB
	SoGKKZN/MTYw/uDpYuTkkBAwkdj3eTozhC0mceHeerYuRi4OIYFljBLv9z9ngSm6+e8QVGI6
	o8T6K0fBErwCghI/Jt8Ds5kF1CUmzVvEDGGLSOy/tZAVwtaWWLbwNVhcSOAVo8St9xkQvdoS
	948+ZQSxhQWqJKZ8vQo0h4ODDSi+eb8BRLmixNv9d8HGiAgoSfyav4gV5AZmgYWMEk+WLQPr
	ZRFQlXjQ/QRsPqeAlcTbhRD3CAlYSlx4d4gJxOYXEJU4vHA71JdKErvbO9lBBkkInGKXOHNn
	G9QgAYlvkw+BHSEhICux6QBUvaTEwRU3WCYwSs5C8vIsJC/PQvLyLCQvL2BkWcUomlqQXFCc
	lF5krFecmFtcmpeul5yfu4kREq39OxjvHrA+xJgMtH4is5Rocj4w2vNK4g2NzYwsTE1MjY3M
	Lc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6NG4rt599j4fuuqiE/XDOFW
	Wrje5Pv/Ptfrb5cd83M70LKkvuO2IFdT+CnDlB1fD5sznixcPHOx58orj5doS3sk7JQwzr6y
	5Nrqt4bhKV6RHsuv1uYmi5wyufLr9xO/fRJKPz67et55I60lfjwp2TncqObOqxuHl+1h6dEv
	5Ii8u+3vz/juykYlluKMREMt5qLiRACw8fje7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd3UvLQgg58t8hb/mz6yWVxa5G6x
	Z+9JFovLu+awWbQuPM/swOqxe8FnJo++LasYPT5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV
	8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWqmkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxjzNj56id7QbtAxZ9961gbGK/xdDFyckgImEjc/HeIDcIWk7hwbz2Q
	zcUhJDCdUWL9laMsIAleAUGJH5PvAdkcHMwC8hJHLmWDhJkF1CUmzVvEDGILCbxilLj1PgOi
	XFvi/tGnjCC2sECVxJSvV8Fa2YDim/cbQJQrSrzdf5cVxBYRUJL4NX8RK8haZoGFjBJPli0D
	62URUJV40P0EbD6ngJXE24X3WCCaLSUuvDvEBGLzC4hKHF64nRnifiWJ3e2d7BMYhWYhuXoW
	wtWzkFy9gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwXD+T2sG4ssHiEKMAB6MSD2+G
	VWqQEGtiWXFl7iFGCQ5mJRHeZt+0ICHelMTKqtSi/Pii0pzU4kOMyUCHT2SWEk3OB6acvJJ4
	Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgtLp86JrVgY0ObacZ
	dA5mnBB+vkfj88naIueAH+yXOx8lsrIrzaiYqPq8iUu4NG5zEENR389fn694MwqxrWNhSp6n
	GcXnU7PxTXNG7NkzbxM3M5/dUCw4/f7c2RO3+vFyc8QLqzCHTfkkwMT4qs/08smFcddWfp29
	u0qU4zqfTHmhw/n1Z5boKLEUZyQaajEXFScCAJ3m4rwvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-10-22 (화), 17:28 +0800, Chao Yu:
> Previously, check_block_count check valid_map with bit data type in common
> scenario that sit has all ones or zeros bitmap, it makes low mount
> performance.
> So let's check the special bitmap with integer data type instead of the bit
> one.
> 
> Signed-off-by: Tan Shu <shu.tan@samsung.com>
> Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> ---
>  fs/f2fs/segment.h |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index 7f94d78..d43ab9f 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -543,6 +543,7 @@ static inline void check_block_count(struct f2fs_sb_info
> *sbi,
>  {
>  	struct f2fs_sm_info *sm_info = SM_I(sbi);
>  	unsigned int end_segno = sm_info->segment_count - 1;
> +	int *valid_map = (int *)raw_sit->valid_map;
>  	int valid_blocks = 0;
>  	int i;
>  
> @@ -552,6 +553,19 @@ static inline void check_block_count(struct
> f2fs_sb_info *sbi,
>  	/* check boundary of a given segment number */
>  	BUG_ON(segno > end_segno);
>  
> +	/* check all ones or zeros valid_map */
> +	if (GET_SIT_VBLOCKS(raw_sit) == 0) {
> +		for (i = 0; i < SIT_VBLOCK_MAP_SIZE / sizeof(int); i++)

We cannot guarantee all the time that SIT_VBLOCK_MAP_SIZE is multiple of
sizeof(int).
How about using memcmp() with __u8?

> +			if (unlikely(valid_map[i] != 0))
> +				BUG();
> +		return;
> +	} else if (GET_SIT_VBLOCKS(raw_sit) == sbi->blocks_per_seg) {
> +		for (i = 0; i < SIT_VBLOCK_MAP_SIZE / sizeof(int); i++)
> +			if (unlikely(valid_map[i] != -1))
> +				BUG();
> +		return;
> +	}
> +
>  	/* check bitmap with valid block count */
>  	for (i = 0; i < sbi->blocks_per_seg; i++)
>  		if (f2fs_test_bit(i, raw_sit->valid_map))
> ---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jaegeuk Kim
Samsung

