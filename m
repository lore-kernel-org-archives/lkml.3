Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3IXBLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:11:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36238 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab3IXBLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:11:16 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-0a-5240e6b27513
From: Chao Yu <chao2.yu@samsung.com>
To: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>
Cc: "'Kim Jaegeuk'" <jaegeuk.kim@gmail.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?gb2312?B?J8y35q0n?= <shu.tan@samsung.com>
References: <000101ceb768$a8b43ff0$fa1cbfd0$@samsung.com>
 <523F9F2D.1080501@cn.fujitsu.com>
In-reply-to: <523F9F2D.1080501@cn.fujitsu.com>
Subject: RE: [f2fs-dev] [PATCH] f2fs: remove unneeded write checkpoint in
 recover_fsync_data
Date: Tue, 24 Sep 2013 09:10:04 +0800
Message-id: <000101ceb8c2$f47270f0$dd5752d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK45DfZauXAgnI68Ijn2dmZNiucwwHZRIp0l/DxqzA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jAd1NzxyCDN7e0LF43n6A2eL2lUks
	FpcWuVvs2XuSxeLyrjlsFq0LzzM7sHn8PziJ2WPnrLvsHrsXfGby6NuyitHj8ya5ANYoLpuU
	1JzMstQifbsErow/36ayFkwRquib9Za1gXEPXxcjJ4eEgInE3fZWFghbTOLCvfVsXYxcHEIC
	ixglOp7tYYRwfjBKvJj0lx2kik1ARWJ5x38mEFtEQENi2tT9TCBFzAL7GSUW3HsIViQkECvx
	9N5SNhCbU0BP4njDdLC4sECcRP+CS2BxFgFViY2vu8HivAKWEqsOzGGGsAUlfky+B3YSM9CC
	/kUb2CBsbYkn7y6wQpyqILHj7Gug6ziAjrCSmHq0BqJEXGLjkVssExiFZiGZNAvJpFlIJs1C
	0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCMPJPewbiqweIQowAHoxIP74UEhyAh
	1sSy4srcQ4wSHMxKIrxHo4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YW
	pBbBZJk4OKUaGDPVy/wkNXz4vZ699O5qXq4xQWVPSNSeJzLvDZN2vwhLtdjr2ivtKyLfXipY
	LV3ZqXZtWsnMV21+075McTe4ESmeYLRkaYt/+NKtC3/cWuT/M3XSFfun50wM1FdGF14Ot9pw
	Xj5+rzD3q65Lj58wMGQnvuBjetk8IcrBSeEVz3HZFoG/BaqxSizFGYmGWsxFxYkA7+AXsI0C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu

> -----Original Message-----
> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> Sent: Monday, September 23, 2013 9:54 AM
> To: Chao Yu
> Cc: Kim Jaegeuk; linux-f2fs-devel@lists.sourceforge.net;
> linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; Ì·æ­
> Subject: Re: [f2fs-dev] [PATCH] f2fs: remove unneeded write checkpoint in
> recover_fsync_data
> 
> On 09/22/2013 03:51 PM, Chao Yu wrote:
> 
> > Previously, recover_fsync_data still to write checkpoint when there is
> > nothing to recover with normal umount image.
> > It may reduce mount performance and flash memory lifetime, so let's
> > remove it.
> >
> > Signed-off-by: Tan Shu <shu.tan@samsung.com>
> > Signed-off-by: Yu Chao <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/recovery.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c index
> > 51ef5ee..6988e1b 100644
> > --- a/fs/f2fs/recovery.c
> > +++ b/fs/f2fs/recovery.c
> > @@ -419,6 +419,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
> > {
> >  	struct list_head inode_list;
> >  	int err;
> > +	int is_writecp = 0;
> 
> "need_writecp" may be more suitable.

Okay, it increase readability. I will change it.

Thanks.
> 
> Thanks,
> Gu
> 
> >
> >  	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
> >  			sizeof(struct fsync_inode_entry), NULL); @@ -436,6
+437,8
> @@ int
> > recover_fsync_data(struct f2fs_sb_info *sbi)
> >  	if (list_empty(&inode_list))
> >  		goto out;
> >
> > +	is_writecp = 1;
> > +
> >  	/* step #2: recover data */
> >  	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
> >  	BUG_ON(!list_empty(&inode_list));
> > @@ -443,7 +446,7 @@ out:
> >  	destroy_fsync_dnodes(&inode_list);
> >  	kmem_cache_destroy(fsync_entry_slab);
> >  	sbi->por_doing = 0;
> > -	if (!err)
> > +	if (!err && is_writecp)
> >  		write_checkpoint(sbi, false);
> >  	return err;
> >  }
> > ---
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >


