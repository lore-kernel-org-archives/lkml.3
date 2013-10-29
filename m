Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab3J2XPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:15:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16275 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3J2XPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:15:20 -0400
X-AuditID: cbfee68f-b7f836d000001b39-c2-5270418674a6
From: Changman Lee <cm224.lee@samsung.com>
To: "'Chao Yu'" <chao2.yu@samsung.com>, jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <001f01ced473$4c5cc9c0$e5165d40$@samsung.com>
 <002a01ced479$925505e0$b6ff11a0$@samsung.com>
 <002301ced48e$c615e010$5241a030$@samsung.com>
In-reply-to: <002301ced48e$c615e010$5241a030$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros bitmap
 with bitops for better mount performance
Date: Wed, 30 Oct 2013 08:15:18 +0900
Message-id: <016701ced4fc$bb7afe10$3270fa30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJDVWMDlPIi5BHzS0Bii3fNyqKrlQE3RkV6AasaQhSZDDkQAA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zA902x4Igg6eHpCz+N31ks7i+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4+/HmoI/
	6hXTr21ibWB8qtDFyMkhIWAiMen8fXYIW0ziwr31bF2MXBxCAssYJR50zmOHKbpw/jgzRGI6
	o8SFzqcsEM5fRol3j96CVbEJaEm0n17LAmKLCNhKzN14ixnEZhbIlJjzejIrRMNMRontmyYw
	gSQ4Bawk9r3bywZiCwtUSuyaPxcsziKgKnH8yx6wQbwClhJTlx1ggrAFJX5MvscCMVRLYv3O
	40wQtrzE5jVvmSFOVZDYcfY1I8QRThLzPrxih6gRkdj34h0jyBESAqfYJda8us8CsUxA4tvk
	Q0A2B1BCVmLTAag5khIHV9xgmcAoMQvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelFxnrFSfm
	Fpfmpesl5+duYoTEZf8OxrsHrA8xJgOtn8gsJZqcD4zrvJJ4Q2MzIwtTE1NjI3NLM9KElcR5
	7z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAOOmPrdOmesNfFvuelWdNlBXbo/bTLKiq
	cRfPnrg5U7yVlk8Te7i7eNdC5qgZyzXva29xfbiVYevyhB03ljrySH33cLnLaJ/eHnqebV1C
	fL3dtp9TXkeIKnCk9ueGTnn1XUs/JqA5ViiPYaZntu2RPs1Fzxf/XuW3Yb/3h6Kel7fKfBLF
	1x7sU2Ipzkg01GIuKk4EAPVja9HhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQd02x4IggxO3RS3+N31ks7i+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePvx5qCP+oV069tYm1gfKrQxcjJISFgInHh/HFmCFtM4sK99Wxd
	jFwcQgLTGSUudD5lgXD+Mkq8e/SWHaSKTUBLov30WhYQW0TAVmLuxltg3cwCmRJzXk9mhWiY
	ySixfdMEJpAEp4CVxL53e9lAbGGBSold8+eCxVkEVCWOf9kDNohXwFJi6rIDTBC2oMSPyfdY
	IIZqSazfeZwJwpaX2LzmLdSpChI7zr5mhDjCSWLeh1fsEDUiEvtevGOcwCg0C8moWUhGzUIy
	ahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgqP+mdQOxpUNFocYBTgYlXh4DR7k
	BwmxJpYVV+YeYpTgYFYS4Z1+HCjEm5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cCElFcSb2hs
	YmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjIE/dm2acLgs6cA7E/0D
	xzXmvT9zMHFOo7nr1OAFRv/zj8XKGcyS+rimaoEXY9v0PQ94xB5MZDu0aK+iXkr3Ac49vBOd
	DfqN5M32FV9mCPq6IHFvDO/swovpU/df5fOY1ez3JN/v7LWpEuL8R60U2X2evN9yIWVenyLX
	xreBhifNl93fMGHuh24lluKMREMt5qLiRADAhecCPgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Firstly,
Thanks. You're right. And I don't know it would be optimized but considering
pipeline.

for ( i =0; i < SIT_VBLOCK_MAP_SIZE; i += 4) {
    valid_blocks += bit_count_byte(raw_sit->valid_map[i];
    valid_blocks += bit_count_byte(raw_sit->valid_map[i+1];
    valid_blocks += bit_count_byte(raw_sit->valid_map[i+2];
    valid_blocks += bit_count_byte(raw_sit->valid_map[i+3];
}

Secondly,
I think also your patch is good in lots of case NOT aging for long time.

-----Original Message-----
From: Chao Yu [mailto:chao2.yu@samsung.com] 
Sent: Tuesday, October 29, 2013 7:07 PM
To: 'Changman Lee'; jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
linux-f2fs-devel@lists.sourceforge.net
Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros
bitmap with bitops for better mount performance

Hi Lee,

It's a good point.

Firstly, In your patch:
	/* check bitmap with valid block count */
 	for (i = 0; i < sbi->blocks_per_seg; i++)
-		if (f2fs_test_bit(i, raw_sit->valid_map))
-			valid_blocks++;
+		valid_blocks += bit_count_byte(raw_sit->valid_map[i]);
+
 	BUG_ON(GET_SIT_VBLOCKS(raw_sit) != valid_blocks);  }

for (i = 0; i < sbi->blocks_per_seg; i++) should be replace with for (i = 0;
i < SIT_VBLOCK_MAP_SIZE; i++)

Secondly, I tested your patch and mine
with SD and emmc with all zeros bitmap.
It shows my patch takes litter time.
Could you test and compare the performance of two patches.

--
1.7.10.4


> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@samsung.com]
> Sent: Tuesday, October 29, 2013 3:36 PM
> To: 'Chao Yu'; jaegeuk.kim@samsung.com
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros
bitmap
> with bitops for better mount performance
> 
> Review attached patch, please.
> 
> -----Original Message-----
> From: Chao Yu [mailto:chao2.yu@samsung.com]
> Sent: Tuesday, October 29, 2013 3:51 PM
> To: jaegeuk.kim@samsung.com
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros bitmap
with
> bitops for better mount performance
> 
> Previously, check_block_count check valid_map with bit data type in common
> scenario that sit has all ones or zeros bitmap, it makes low mount
> performance.
> So let's check the special bitmap with integer data type instead of the
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
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index abe7094..a7abfa8
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
> paper to learn more about secure code signing practices that can help keep
> Android apps secure.
> http://pubads.g.doubleclick.net/gampad/clk?id=65839951&iu=/4140/ostg.clktr
> k
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

