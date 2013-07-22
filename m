Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3GVMvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:51:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59036 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3GVMve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:51:34 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7f096d0000043fc-88-51ed2ad57916
Content-transfer-encoding: 8BIT
Message-id: <1374497479.26443.20.camel@kjgkr>
Subject: Re: [PATCH] f2fs: add the missing delection of orphan inode entry in
 write_orphan_inodes()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 22 Jul 2013 21:51:19 +0900
In-reply-to: <51E8F65F.9040007@cn.fujitsu.com>
References: <51E8F65F.9040007@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zfd2rWm8DDTr+c1o8bz/AbHFpkbvF
	5V1z2ByYPf4fnMTssXvBZyaPz5vkApijuGxSUnMyy1KL9O0SuDJWf7vEXHCdvWL5zGnsDYyT
	2boYOTkkBEwkdk3/zgJhi0lcuLceKM7FISSwjFHi4KG/jDBFvWueskMkFjFKfD19ACzBKyAo
	8WPyPaBuDg5mAXmJI5eyQcLMAuoSk+YtYoaof80o8Wj/elaIel2Jvy9amEFsYYFUifdvOxlB
	etkEtCU27zcACQsJKEq83X8XrFxEQE3i2btLTBAzEyQenu8Hi7MIqEpc/3wOLM4poCfxp/sL
	I0SvrsT/J7PBxvMLiEocXridGeJ+JYnd7Z1g90sI7GOXOPR1PQvEIAGJb5MPgd0vISArsekA
	VL2kxMEVN1gmMErMQvLlLIQvZyH5cgEj8ypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkCjr
	3cF4+4D1IcZkoI0TmaVEk/OBUZpXEm9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6Yklqdmpq
	QWpRfFFpTmrxIUYmDk6pBsZo1Y6aZeWzlFvVV2UIKKTP4fmRftqEefK9B5crJDecdzFe+Gbr
	YzOt5m0ac2+tZTmZ47V0h8bU7COrzsz9r3pnpZSqxcOPR/9N3ZQmqyeQl8v5Z2Wm3urugzMj
	WY/9bmHZKxw069s1Pi3OFj/BPcwF12T0N2Yvt/2Tksd8ou3+1BmOvLEP/ukqsRRnJBpqMRcV
	JwIAlTjTwMgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd2rWm8DDb7NYLN43n6A2eLSIneL
	y7vmsDkwe/w/OInZY/eCz0wenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
	GlpamCsp5CXmptoqufgE6Lpl5gAtUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12Nk
	gAYS1jFmrP52ibngOnvF8pnT2BsYJ7N1MXJySAiYSPSuecoOYYtJXLi3HijOxSEksIhR4uvp
	A4wgCV4BQYkfk++xdDFycDALyEscuZQNEmYWUJeYNG8RM0T9a0aJR/vXs0LU60r8fdHCDGIL
	C6RKvH/byQjSyyagLbF5vwFIWEhAUeLt/rtg5SICahLP3l1igpiZIPHwfD9YnEVAVeL653Ng
	cU4BPYk/3V8YIXp1Jf4/mQ02nl9AVOLwwu3MEPcrSexu72SfwCg0C8nVsxCunoXk6gWMzKsY
	RVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgmP4mdQOxpUNFocYBTgYlXh4GwLeBAqxJpYVV+Ye
	YpTgYFYS4fVcBRTiTUmsrEotyo8vKs1JLT7EmAx0+ERmKdHkfGB6ySuJNzQ2MTOyNDKzMDIx
	NydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxjNLgh95i84/EWPMeDpp9YMqn/l7ZK+2
	rtr9d5PD1Yc9cdaLfz+Q2T/zqsEUXvmjdSF7XvnHGGt8SjWuLf9k8ZDRfnOKM8vu2rNrSyfJ
	cs/e/m7Hg18VKsLne3c/kTit8ZetoeDG/jXd3cL1pR0fvC/eqPizLcVh2UOdtm2mq0U+PbgS
	27PycZwSS3FGoqEWc1FxIgAX3UwSJQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-07-19 (금), 16:18 +0800, Gu Zheng:
> After writing orphan inode entry in jornal block, we need to delete each
> entry from the orphan entry list, and release them.
> 
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/checkpoint.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 66a6b85..290db04 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -337,6 +337,10 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
>  		memset(orphan_blk, 0, sizeof(*orphan_blk));
>  page_exist:
>  		orphan_blk->ino[nentries++] = cpu_to_le32(orphan->ino);
> +
> +		list_del(&orphan->list);
> +		kmem_cache_free(orphan_entry_slab, orphan);
> +		sbi->n_orphans--;

NAK.
We should not release them here.
Only f2fs_evict_inode can do it. 

>  	}
>  	if (!page)
>  		goto end;

-- 
Jaegeuk Kim
Samsung

