Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaI3GUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:20:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22369 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaI3GUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:20:18 -0400
X-AuditID: cbfee61a-f79c06d000004e71-a6-542a4ba04005
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1411707287-21760-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1411707287-21760-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 1/4] f2fs: check the use of macros on block
	counts and addresses
Date: Tue, 30 Sep 2014 14:19:36 +0800
Message-id: <006201cfdc76$9a361140$cea233c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQItKDz0C3nt+QliyKLU0bX9xXNWW5temtvw
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t9jAd0F3lohBjNvGFk8WT+L2eLSIneL
	y7vmsDkwe2xa1cnmsXvBZyaPz5vkApijuGxSUnMyy1KL9O0SuDKefdzGWHCQr2L/jQVMDYx7
	OLsYOTkkBEwktu2aywZhi0lcuLceyObiEBJYxChxra+LHcL5wSjxfu0PVpAqNgEVieUd/5lA
	bBEBNYnefVOAbA4OZgEPiV3HSkFMIQEnibd7ikAqOAWcJS4engRWLSyQKLHr2gNGEJtFQFVi
	wb2vzCA2r4ClxPbHr9ghbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxxp4LEjrOvGSEuMJJY
	tHoaVI24xMYjt1gmMArNQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT8
	3E2M4GB/JrWDcWWDxSFGAQ5GJR5eDnmtECHWxLLiytxDjBIczEoivGrmQCHelMTKqtSi/Pii
	0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2M6vXn9b/xTGYS3a+p7y6/bYbM
	1ZrpEfkCC/t9nizot7/zdrv+1ubJDOEVNyZILj/I6rTqRqfTxOVOEyfvMd3evGpn/27/DYLR
	O/LZ3FgXvooKfLJMt3jeYsEfr1cs0l7F/IXX8pmHoVGte1a5vFueRHQI6xNPi5PeAaf65lg7
	6v/e6PG930NZiaU4I9FQi7moOBEAxid2/nICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Friday, September 26, 2014 12:55 PM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 1/4] f2fs: check the use of macros on block counts and addresses
> 
> This patch cleans up the existing and new macros for readability.
> 
> Rule is like this.
> 
>          ,-----------------------------------------> MAX_BLKADDR -,
>          |  ,------------- TOTAL_BLKS ----------------------------,
>          |  |                                                     |
>          |  ,- seg0_blkaddr   ,----- sit/nat/ssa/main blkaddress  |
> block    |  | (SEG0_BLKADDR)  | | | |   (e.g., MAIN_BLKADDR)      |
> address  0..x................ a b c d .............................
>             |                                                     |
> global seg# 0...................... m .............................
>             |                       |                             |
>             |                       `------- MAIN_SEGS -----------'
>             `-------------- TOTAL_SEGS ---------------------------'
>                                     |                             |
>  seg#                               0..........xx..................
> 
> = Note =
>  o GET_SEGNO_FROM_SEG0 : blk address -> global segno
>  o GET_SEGNO           : blk address -> segno
>  o START_BLOCK         : segno -> starting block address
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Looks good!

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

I see SM_I(sbi)->segment_count in check_seg_range/check_block_count still
not be instead with TOTAL_SEGS(sbi), how about insteading these together?

Regards,
Yu

