Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3KFGAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 01:00:51 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36280 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3KFGAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 01:00:49 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-fa-5279db0f5ae7
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'???'" <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?J8y35q0n?= <shu.tan@samsung.com>
References: <000001ceda8d$5b185bd0$11491370$@samsung.com>
 <5279BA67.4040906@cn.fujitsu.com>
 <000101cedaae$bb7ed820$327c8860$@samsung.com> <5279D078.8080803@cn.fujitsu.com>
In-reply-to: <5279D078.8080803@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH] f2fs: avoid to use a NULL point in
 destroy_segment_manager
Date: Wed, 06 Nov 2013 13:59:13 +0800
Message-id: <000201cedab5$89f0f9d0$9dd2ed70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQECxHgARzzGwNztGb8VlYqYPj89CQHEf8caAfZG76oC9eybaJt6VeHw
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jAV3+25VBBpO+mlk8bz/AbHF9118m
	i0uL3C327D3JYnF51xw2i9aF55kd2Dz+H5zE7LF7wWcmj74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MroeqNZ0CFScWfDZqYGxj6BLkZODgkBE4npm9pYIWwxiQv31rN1MXJxCAksYpQ40vqK
	HcL5wShxaephdpAqNgEVieUd/5lAbBEBDYlpU/czgRQxC+xklNi9fgsrRMd6Rokr/0+ygVRx
	CuhJbJnWDmRzcAgLxEhsuw+2mkVAVaLn4HmwEl4BS4kpr7czQ9iCEj8m32MBsZmBFvQv2sAG
	YWtLPHl3AepUBYkdZ18zQhzhJjH18zRmiBpxiY1HbrFMYBSahWTULCSjZiEZNQtJywJGllWM
	oqkFyQXFSem5hnrFibnFpXnpesn5uZsYwZHxTGoH48oGi0OMAhyMSjy8CfKVQUKsiWXFlbmH
	GCU4mJVEeDfsAwrxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLg
	lGpgnLP/5AOjOWYb/PKKP2nYnNGbfm0uy9Ysn2Uier4xb9af4ru77p9gkvT5otwq3XVaor9u
	TTYqY1TOur7LoSJseW+P9Iesg0ly3972KR2r70vtE/+3iv3+zwQlTtOzpoWClkI8ZZEzpjnW
	R4Zu1lF7fsGbaYrU5dPNHzxmsLD2n+u1YQqcfYBXiaU4I9FQi7moOBEAnhH6PIgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu, 

Thanks for your reviewing!

Regards
Yu

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Wednesday, November 06, 2013 1:16 PM
> To: Chao Yu
> Cc: '???'; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 'Ì·æ­'
> Subject: Re: [f2fs-dev] [PATCH] f2fs: avoid to use a NULL point in destroy_segment_manager
> 
> On 11/06/2013 01:10 PM, Chao Yu wrote:
> 
> > Hi Gu,
> >
> >> -----Original Message-----
> >> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> >> Sent: Wednesday, November 06, 2013 11:41 AM
> >> To: Chao Yu
> >> Cc: ???; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; Ì·æ­
> >> Subject: Re: [f2fs-dev] [PATCH] f2fs: avoid to use a NULL point in destroy_segment_manager
> >>
> >> On 11/06/2013 09:12 AM, Chao Yu wrote:
> >>
> >>> A NULL point should avoid to be used in destroy_segment_manager after allocating memory fail for f2fs_sm_info.
> >>
> >> Though without this patch it still can work well, because if it failed
> >> to allocate f2fs_sm_info, the sit_info, free_info... all were NULL, and
> >> the destory path(e.g. destroy_dirty_segmap) can deal with them well.
> >
> > I think it could not work well. Without this patch we may got a segment
> > fault in DIRTY_I(sbi) at the following code if it failed to allocate
> > f2fs_sm_info memory(sbi->sm_info). Right?
> 
> Yes, you're right. SIT_I generates sit_info from f2fs_sm_info.
> Sorry for my mistake.:(
> 
> Regards,
> Gu
> 
> >
> > static void destroy_dirty_segmap(struct f2fs_sb_info *sbi)
> > {
> > 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
> >
> >> IMO, this patch is still a good catch.
> >>
> >> Regards,
> >> Gu
> >>
> >>>
> >>> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> >>> ---
> >>>  fs/f2fs/segment.c |    2 ++
> >>>  1 file changed, 2 insertions(+)
> >>>
> >>> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> >>> index 3d4d5fc..ff363e6
> >>> --- a/fs/f2fs/segment.c
> >>> +++ b/fs/f2fs/segment.c
> >>> @@ -1744,6 +1744,8 @@ static void destroy_sit_info(struct f2fs_sb_info *sbi)
> >>>  void destroy_segment_manager(struct f2fs_sb_info *sbi)
> >>>  {
> >>>  	struct f2fs_sm_info *sm_info = SM_I(sbi);
> >>> +	if (!sm_info)
> >>> +		return;
> >>>  	destroy_dirty_segmap(sbi);
> >>>  	destroy_curseg(sbi);
> >>>  	destroy_free_segmap(sbi);
> >
> >
> >
> 
> 
> =

