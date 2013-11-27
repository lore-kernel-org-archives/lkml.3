Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab3K0F06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 00:26:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46143 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3K0F04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 00:26:56 -0500
X-AuditID: cbfee61b-b7f166d000007a34-96-5295829f1591
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>,
        fanofcode.li@samsung.com
References: <000201cee760$58df9f10$0a9edd30$@samsung.com>
 <1385529248.2417.19.camel@kjgkr>
In-reply-to: <1385529248.2417.19.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: remove unneeded code in punch_hole
Date: Wed, 27 Nov 2013 13:25:37 +0800
Message-id: <002e01ceeb31$44c21ce0$ce4656a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKAIwa0Uqo5iXM4vE5T3i3uoHv8ggNLhVy8mLu/UDA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jQd35TVODDF6sELD4vLWR3eL6rr9M
	FpcWuVvs2XuSxeLyrjlsFq0LzzM7sHnsXvCZyaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgy
	fp14yFqwjqdi/ZRLTA2MTzi7GDk5JARMJBr/TmSHsMUkLtxbz9bFyMUhJDCdUeL4ldXMEM4P
	Rol/E2awglSxCahILO/4zwRiiwhIS8z6NI8FpIhZYCujxN5/q8GKhARiJN7+XcAMYnMK6Erc
	udUMFhcW8JA4Mn0FWDOLgKpE09b9LCA2r4ClxLfXrxkhbEGJH5PvAcU5gIaqS0yZkgsSZhbQ
	lnjy7gIrxKUKEjvOQpSLCFhJ3L9ynQmiRlxi45FbLBMYhWYhmTQLYdIsJJNmIelYwMiyilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Gp5J72Bc1WBxiFGAg1GJh3fC5SlBQqyJZcWVuYcY
	JTiYlUR4wyunBgnxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLg
	lGpg1Fm4QH3FAs73Ez6xR33/b82Wz8ORwqPiz7dZSsZRfoe+4oWPef0n552LbK2/9qLV+nLP
	+r62p4dXRX8/xxabObFx5tmbBakX2ooYdIM4GL/v7uB2WR6jJTFXy9yZ18+uc/WVJZoSYb+e
	7lhma/xDyzm9m4f7WBGbxtekan2vmCfb3v6dHntGiaU4I9FQi7moOBEA2UwGgYICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Wednesday, November 27, 2013 1:14 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝; fanofcode.li@samsung.com
> Subject: Re: [f2fs-dev] [PATCH] f2fs: remove unneeded code in punch_hole
> 
> Got it.
> 
> But, with this patch, we can also remove the parameter, int mode, in
> punch_hole().
> If no objection, I'll fix that in your patch.
> Thanks,

Right, we should remove it.
Thanks!

> 
> 2013-11-22 (금), 16:52 +0800, Chao Yu:
> > Because FALLOC_FL_PUNCH_HOLE flag must be ORed with FALLOC_FL_KEEP_SIZE
> > in fallocate, so we could remove the useless 'keep size' branch code which
> > will never be excuted in punch_hole.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > Signed-off-by: Fan Li <fanofcode.li@samsung.com>
> > ---
> >  fs/f2fs/file.c |    6 ------
> >  1 file changed, 6 deletions(-)
> >
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index 7d714f4..0087d2a 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -499,12 +499,6 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len, int mode)
> >  		}
> >  	}
> >
> > -	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> > -		i_size_read(inode) <= (offset + len)) {
> > -		i_size_write(inode, offset);
> > -		mark_inode_dirty(inode);
> > -	}
> > -
> >  	return ret;
> >  }
> >
> 
> --
> Jaegeuk Kim
> Samsung

