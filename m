Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3J2XZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:25:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:43221 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3J2XZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:25:16 -0400
X-AuditID: cbfee68f-b7f836d000001b39-a0-527043da26bc
From: Changman Lee <cm224.lee@samsung.com>
To: "'Chao Yu'" <chao2.yu@samsung.com>, jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <001f01ced473$4c5cc9c0$e5165d40$@samsung.com>
 <002a01ced479$925505e0$b6ff11a0$@samsung.com>
 <002401ced495$01a50290$04ef07b0$@samsung.com>
In-reply-to: <002401ced495$01a50290$04ef07b0$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros bitmap
 with bitops for better mount performance
Date: Wed, 30 Oct 2013 08:25:14 +0900
Message-id: <016901ced4fe$1f0c3b00$5d24b100$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJDVWMDlPIi5BHzS0Bii3fNyqKrlQE3RkV6AjXgZhyZB+Wu8A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY93bzgVBBq1pFv+bPrJZXN/1l8ni
	0iJ3iz17T7JYXN41h82B1WP3gs9MHn1bVjF6fN4kF8AcxWWTkpqTWZZapG+XwJUxeccEloKX
	ihUX/7UzNzBeke5i5OCQEDCRmHUtoYuRE8gUk7hwbz0biC0ksIxR4uOpTIi4icSTux+Yuhi5
	gOLTGSV6us5BOX8ZJR51/WQBqWIT0JJoP70WzBYRsJWYu/EWM4jNLJApMef1ZFaIhpmMEjvm
	PGEFSXAKWEn8W3KIEcQWFqiU2DV/LhOIzSKgKrFl7wp2EJtXwFKisfUcM4QtKPFj8j0WiKFa
	Eut3HmeCsOUlNq95ywxxqoLEjrOvGUE+ExFwklg9xQOiRERi34t3jCA3SAicY5eYvaOFFWKX
	gMS3yYdYICEhK7HpANQYSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi4z1
	ihNzi0vz0vWS83M3MUIisn8H490D1ocYk4HWT2SWEk3OB0Z0Xkm8obGZkYWpiamxkbmlGWnC
	SuK89x8mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgnDNxYajMS4fzV28//bVTtjaELbkr
	4r2WYFpxaOtWw7VlN0T5+Iz73wTe2PfRxaZs2t1jtrffm9v+/1Swy7ume0Fm9ayDoT5O9zTV
	PuTcfeo0+eKHM95NvyYw3cyLt7l+YPnq+w/834cLTg2LfmJTrbyfcfYG+7t3lsxO/m70TUIo
	VfA7p+VMGSWW4oxEQy3mouJEAEkUvyHeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQd1bzgVBBgf7LS3+N31ks7i+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPyjgksBS8VKy7+a2duYLwi3cXIySEhYCLx5O4HJghbTOLCvfVs
	XYxcHEIC0xklerrOMUE4fxklHnX9ZAGpYhPQkmg/vRbMFhGwlZi78RYziM0skCkx5/VkVoiG
	mYwSO+Y8YQVJcApYSfxbcogRxBYWqJTYNX8u2DoWAVWJLXtXsIPYvAKWEo2t55ghbEGJH5Pv
	sUAM1ZJYv/M4E4QtL7F5zVtmiFMVJHacfQ00kwPoCCeJ1VM8IEpEJPa9eMc4gVFoFpJJs5BM
	moVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEf9M6kdjCsbLA4xCnAwKvHw
	GjzIDxJiTSwrrsw9xCjBwawkwjv9OFCINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84EJKa8k
	3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGHVOC61ek/cj7dHd
	n0+XsZxSfNatstJgedn/h9VFFZxxjK/SA46Gte+5M/9f9omS6qotgmFVrrMjpFq3rk96IRTw
	LV2K7eLW+29OvQxv/xOa/tGE99n2FtfQXN5dzC/2nfULfPt9d+G5B0VBcn/LvMsX+zuahQu/
	zLx3ISjd+NSfc5EsG1QOMSqxFGckGmoxFxUnAgB4wtX/PgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As you know, if any data or function are used once, we can use some keywords
like __initdata for data and __init for function.


-----Original Message-----
From: Chao Yu [mailto:chao2.yu@samsung.com] 
Sent: Tuesday, October 29, 2013 7:52 PM
To: 'Changman Lee'; jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
linux-f2fs-devel@lists.sourceforge.net
Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros
bitmap with bitops for better mount performance

Hi Lee,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@samsung.com]
> Sent: Tuesday, October 29, 2013 3:36 PM
> To: 'Chao Yu'; jaegeuk.kim@samsung.com
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; 
> linux-f2fs-devel@lists.sourceforge.net
> Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or 
> zeros
bitmap
> with bitops for better mount performance
> 
> Review attached patch, please.

Could we hide the pre calculated value by generating it in allocated memory
by func, because the value will be no use after build_sit_entries();

Regards
Yu

> 
> -----Original Message-----
> From: Chao Yu [mailto:chao2.yu@samsung.com]
> Sent: Tuesday, October 29, 2013 3:51 PM
> To: jaegeuk.kim@samsung.com
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; 
> linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros 
> bitmap
with
> bitops for better mount performance
> 
> Previously, check_block_count check valid_map with bit data type in 
> common scenario that sit has all ones or zeros bitmap, it makes low 
> mount performance.
> So let's check the special bitmap with integer data type instead of 
> the
bit one.
> 
> v1-->v2:
>     use find_next_{zero_}bit_le for better performance and readable as 
> Jaegeuk suggested.
> 	use neat logogram in comment as Gu Zheng suggested.
> 	search continuous ones or zeros for better performance when checking

> mixed bitmap.
> 
> Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Signed-off-by: Shu Tan <shu.tan@samsung.com>
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/segment.h |   19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index 
> abe7094..a7abfa8
> 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -550,8 +550,9 @@ static inline void check_block_count(struct 
> f2fs_sb_info *sbi,  {
>  	struct f2fs_sm_info *sm_info = SM_I(sbi);
>  	unsigned int end_segno = sm_info->segment_count - 1;
> +	bool is_valid  = test_bit_le(0, raw_sit->valid_map) ? true : false;
>  	int valid_blocks = 0;
> -	int i;
> +	int cur_pos = 0, next_pos;
> 
>  	/* check segment usage */
>  	BUG_ON(GET_SIT_VBLOCKS(raw_sit) > sbi->blocks_per_seg); @@ -560,9
> +561,19 @@ static inline void check_block_count(struct f2fs_sb_info 
> +*sbi,
>  	BUG_ON(segno > end_segno);
> 
>  	/* check bitmap with valid block count */
> -	for (i = 0; i < sbi->blocks_per_seg; i++)
> -		if (f2fs_test_bit(i, raw_sit->valid_map))
> -			valid_blocks++;
> +	do {
> +		if (is_valid) {
> +			next_pos =
> find_next_zero_bit_le(&raw_sit->valid_map,
> +					sbi->blocks_per_seg,
> +					cur_pos);
> +			valid_blocks += next_pos - cur_pos;
> +		} else
> +			next_pos = find_next_bit_le(&raw_sit->valid_map,
> +					sbi->blocks_per_seg,
> +					cur_pos);
> +		cur_pos = next_pos;
> +		is_valid = !is_valid;
> +	} while (cur_pos < sbi->blocks_per_seg);
>  	BUG_ON(GET_SIT_VBLOCKS(raw_sit) != valid_blocks);  }
> 
> --
> 1.7.9.5
> 
> 
>
----------------------------------------------------------------------------
> --
> Android is increasing in popularity, but the open development platform
that
> developers love is also attractive to malware creators. Download this
white
> paper to learn more about secure code signing practices that can help 
> keep Android apps secure.
> http://pubads.g.doubleclick.net/gampad/clk?id=65839951&iu=/4140/ostg.c
> lktr
> k
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

