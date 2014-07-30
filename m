Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaG3Bpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:45:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8291 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbaG3Bpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:45:39 -0400
X-AuditID: cbfee61b-f79f86d00000144c-53-53d84e41dea9
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
 <1406328445-63707-8-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1406328445-63707-8-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 08/11] f2fs: fix wrong condition for unlikely
Date: Wed, 30 Jul 2014 09:44:43 +0800
Message-id: <009901cfab97$f2981be0$d7c853a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQH0/sFA7oYZ7Fd/hcfctysO+ZeFcgGwpqWem1+rvIA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jQV1HvxvBBisPGFk8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlbHu3X+mgjd8FY93
	XmVsYNzJ08XIySEhYCLR/XATC4QtJnHh3nq2LkYuDiGB6YwSX2/Og3J+MEpcvHGTDaSKTUBF
	YnnHfyYQW0RATaJ33xQwm1kgU2JC/wt2EFtIoFpi3tsrYHFOAWeJTxd+gdnCAj4Sa7sng21j
	EVCVmNr0ixHE5hWwlPjavI4JwhaU+DH5HgvETC2J9TuPQ82Xl9i85i0zxKUKEjvOvmaEiItL
	bDxyiwXiHiuJmd+3sk9gFJqFZNQsJKNmIRk1C0n7AkaWVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjBof9MegfjqgaLQ4wCHIxKPLwz/l8PFmJNLCuuzD3EKMHBrCTC+1XuRrAQb0piZVVq
	UX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYOTqkGRnMZyecmytPnh7cucOK4
	LVR8elLiz6fCTHZ8zhVf7zRETJ+y79+RuoXvVU4emMaoOe/gNYYlwds4n00xa3zMdVj22a0n
	zgtOsjhJ+T6umsCSLp9X/O3w3vVX0049fhk/75PvlqW10/RNaq7a+R5etSztVp61w3bdg2XL
	DvQviZyjE33Qeu8dQ0YlluKMREMt5qLiRADHxLRVeQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, July 26, 2014 6:47 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 08/11] f2fs: fix wrong condition for unlikely
> 
> This patch fixes the wrongly used unlikely condition.
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/checkpoint.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 42a16c1..36b0d47 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -932,7 +932,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
>  	/* Here, we only have one bio having CP pack */
>  	sync_meta_pages(sbi, META_FLUSH, LONG_MAX);
> 
> -	if (unlikely(!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG))) {
> +	if (!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) {

Maybe use likely(!is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)) or

if (unlikely(is_set_ckpt_flags(ckpt, CP_ERROR_FLAG)))
	return;

is more appropriate. How do you think?

>  		clear_prefree_segments(sbi);
>  		release_dirty_inode(sbi);
>  		F2FS_RESET_SB_DIRT(sbi);
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> Want fast and easy access to all the code in your enterprise? Index and
> search up to 200,000 lines of code with a free copy of Black Duck
> Code Sight - the same software that powers the world's largest code
> search on Ohloh, the Black Duck Open Hub! Try it now.
> http://p.sf.net/sfu/bds
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

