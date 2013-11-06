Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3KFDri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 22:47:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6466 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab3KFDrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 22:47:37 -0500
X-IronPort-AV: E=Sophos;i="4.93,643,1378828800"; 
   d="scan'208";a="8957774"
Message-ID: <5279BA67.4040906@cn.fujitsu.com>
Date: Wed, 06 Nov 2013 11:41:27 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: ??? <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        =?GB2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: Re: [f2fs-dev] [PATCH] f2fs: avoid to use a NULL point in destroy_segment_manager
References: <000001ceda8d$5b185bd0$11491370$@samsung.com>
In-Reply-To: <000001ceda8d$5b185bd0$11491370$@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 11:45:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/06 11:45:42,
	Serialize complete at 2013/11/06 11:45:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 09:12 AM, Chao Yu wrote:

> A NULL point should avoid to be used in destroy_segment_manager after allocating memory fail for f2fs_sm_info.

Though without this patch it still can work well, because if it failed
to allocate f2fs_sm_info, the sit_info, free_info... all were NULL, and
the destory path(e.g. destroy_dirty_segmap) can deal with them well.
IMO, this patch is still a good catch. 

Regards,
Gu

> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/segment.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 3d4d5fc..ff363e6
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -1744,6 +1744,8 @@ static void destroy_sit_info(struct f2fs_sb_info *sbi)
>  void destroy_segment_manager(struct f2fs_sb_info *sbi)
>  {
>  	struct f2fs_sm_info *sm_info = SM_I(sbi);
> +	if (!sm_info)
> +		return;
>  	destroy_dirty_segmap(sbi);
>  	destroy_curseg(sbi);
>  	destroy_free_segmap(sbi);


