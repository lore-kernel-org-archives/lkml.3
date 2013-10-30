Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3J3BHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 21:07:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62950 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3J3BHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 21:07:07 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-0d-52705bb965ac
From: Chao Yu <chao2.yu@samsung.com>
To: "'Changman Lee'" <cm224.lee@samsung.com>, jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <001f01ced473$4c5cc9c0$e5165d40$@samsung.com>
 <002a01ced479$925505e0$b6ff11a0$@samsung.com>
 <002401ced495$01a50290$04ef07b0$@samsung.com>
 <016901ced4fe$1f0c3b00$5d24b100$@samsung.com>
In-reply-to: <016901ced4fe$1f0c3b00$5d24b100$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros bitmap
 with bitops for better mount performance
Date: Wed, 30 Oct 2013 09:05:59 +0800
Message-id: <000001ced50c$50d938a0$f28ba9e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJDVWMDlPIi5BHzS0Bii3fNyqKrlQE3RkV6AjXgZhwCsfl/XJjycvPA
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jQd2d0QVBBk8maVlc29fIZHF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxqrZpxkL
	JmlUHL3XytjAuEahi5GDQ0LARKL9TG0XIyeQKSZx4d56ti5GLg4hgemMEhfPLWOFcH4wShxY
	fooFpIpNQEViecd/JhBbRMBZYurf3cwgNrNApsSc15OhGk4ySly918kGkuAUsJJon76EEcQW
	FqiU2DV/Llgzi4CqxJOGCawgNq+ApcTPjZOhbEGJH5PvsUAM1ZJYv/M4E4QtL7F5zVtmiFMV
	JHacfc0IcYSbRNvTbewQNeISG4/cYpnAKDQLyahZSEbNQjJqFpKWBYwsqxhFUwuSC4qT0nMN
	9YoTc4tL89L1kvNzNzGCo+CZ1A7GlQ0WhxgFOBiVeHgNHuQHCbEmlhVX5h5ilOBgVhLhnX4c
	KMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1oJBAemJJanZqakFqEUyWiYNTqoHxomJCT0sf
	6y2dzfzr/M7s+dlQXdkReGiv+7O7wvUN27TvrfnHmav+/u/uWH6PG5O9IhX7BQ8J3Cp6eGVJ
	4mMJxS1ml/4mHdFULJjW/fxrKvu1697ckbfXJdzV3OZ7wUFy4+QVt9SWrjv05cC8Sz98nvjs
	L4t6zex4ZtJey9LgybOMrGb/PcjDo8RSnJFoqMVcVJwIAFPqJjN+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

> -----Original Message-----
> From: Changman Lee [mailto:cm224.lee@samsung.com]
> Sent: Wednesday, October 30, 2013 7:25 AM
> To: 'Chao Yu'; jaegeuk.kim@samsung.com
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros bitmap with
bitops for
> better mount performance
> 
> 
> As you know, if any data or function are used once, we can use some keywords
> like __initdata for data and __init for function.

Thanks for reminding me that.
I just think of that generating tmp data by func could save memory use or keep program
size small.

Regards
Yu

> 
> 
> -----Original Message-----
> From: Chao Yu [mailto:chao2.yu@samsung.com]
> Sent: Tuesday, October 29, 2013 7:52 PM
> To: 'Changman Lee'; jaegeuk.kim@samsung.com
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros
> bitmap with bitops for better mount performance
> 
> Hi Lee,
> 
> > -----Original Message-----
> > From: Changman Lee [mailto:cm224.lee@samsung.com]
> > Sent: Tuesday, October 29, 2013 3:36 PM
> > To: 'Chao Yu'; jaegeuk.kim@samsung.com
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Subject: RE: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or
> > zeros
> bitmap
> > with bitops for better mount performance
> >
> > Review attached patch, please.
> 
> Could we hide the pre calculated value by generating it in allocated memory
> by func, because the value will be no use after build_sit_entries();
> 
> Regards
> Yu
> 
> >
> > -----Original Message-----
> > From: Chao Yu [mailto:chao2.yu@samsung.com]
> > Sent: Tuesday, October 29, 2013 3:51 PM
> > To: jaegeuk.kim@samsung.com
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-f2fs-devel@lists.sourceforge.net
> > Subject: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros
> > bitmap
> with
> > bitops for better mount performance
> >
> > Previously, check_block_count check valid_map with bit data type in
> > common scenario that sit has all ones or zeros bitmap, it makes low
> > mount performance.
> > So let's check the special bitmap with integer data type instead of
> > the
> bit one.
> >
> > v1-->v2:
> >     use find_next_{zero_}bit_le for better performance and readable as
> > Jaegeuk suggested.
> > 	use neat logogram in comment as Gu Zheng suggested.
> > 	search continuous ones or zeros for better performance when checking
> 
> > mixed bitmap.
> >
> > Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > Signed-off-by: Shu Tan <shu.tan@samsung.com>
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/segment.h |   19 +++++++++++++++----
> >  1 file changed, 15 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h index
> > abe7094..a7abfa8
> > 100644
> > --- a/fs/f2fs/segment.h
> > +++ b/fs/f2fs/segment.h
> > @@ -550,8 +550,9 @@ static inline void check_block_count(struct
> > f2fs_sb_info *sbi,  {
> >  	struct f2fs_sm_info *sm_info = SM_I(sbi);
> >  	unsigned int end_segno = sm_info->segment_count - 1;
> > +	bool is_valid  = test_bit_le(0, raw_sit->valid_map) ? true : false;
> >  	int valid_blocks = 0;
> > -	int i;
> > +	int cur_pos = 0, next_pos;
> >
> >  	/* check segment usage */
> >  	BUG_ON(GET_SIT_VBLOCKS(raw_sit) > sbi->blocks_per_seg); @@ -560,9
> > +561,19 @@ static inline void check_block_count(struct f2fs_sb_info
> > +*sbi,
> >  	BUG_ON(segno > end_segno);
> >
> >  	/* check bitmap with valid block count */
> > -	for (i = 0; i < sbi->blocks_per_seg; i++)
> > -		if (f2fs_test_bit(i, raw_sit->valid_map))
> > -			valid_blocks++;
> > +	do {
> > +		if (is_valid) {
> > +			next_pos =
> > find_next_zero_bit_le(&raw_sit->valid_map,
> > +					sbi->blocks_per_seg,
> > +					cur_pos);
> > +			valid_blocks += next_pos - cur_pos;
> > +		} else
> > +			next_pos = find_next_bit_le(&raw_sit->valid_map,
> > +					sbi->blocks_per_seg,
> > +					cur_pos);
> > +		cur_pos = next_pos;
> > +		is_valid = !is_valid;
> > +	} while (cur_pos < sbi->blocks_per_seg);
> >  	BUG_ON(GET_SIT_VBLOCKS(raw_sit) != valid_blocks);  }
> >
> > --
> > 1.7.9.5
> >
> >
> >
> ----------------------------------------------------------------------------
> > --
> > Android is increasing in popularity, but the open development platform
> that
> > developers love is also attractive to malware creators. Download this
> white
> > paper to learn more about secure code signing practices that can help
> > keep Android apps secure.
> > http://pubads.g.doubleclick.net/gampad/clk?id=65839951&iu=/4140/ostg.c
> > lktr
> > k
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

