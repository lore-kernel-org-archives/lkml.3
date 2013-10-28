Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab3J1M24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 08:28:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23483 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3J1M2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:28:54 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f3d6d000001c4a-53-526e5884b2fd
Content-transfer-encoding: 8BIT
Message-id: <1382963296.992.108.camel@kjgkr>
Subject: Re: [f2fs-dev 3/5] f2fs: Add a new function: f2fs_reserve_block()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Date: Mon, 28 Oct 2013 21:28:16 +0900
In-reply-to: <1382962607.992.104.camel@kjgkr>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
 <1382716919-23345-4-git-send-email-huajun.li.lee@gmail.com>
 <1382962607.992.104.camel@kjgkr>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zY93WiLwggw/9jBYvD2lanHnWwWix
	ZUuMxdf+O2wWlxa5W+zZe5LF4vKuOWwWm07+YnXg8Ng56y67x+I9L5k85p0M9Ni94DOTR9+W
	VYwenzfJBbBFcdmkpOZklqUW6dslcGWsujGZsaCFu2Ldr10sDYxbOboYOTkkBEwknrcsYYWw
	xSQu3FvP1sXIxSEksIxR4sSFv4wwRdN7/7BAJKYzSpyasxQswSsgKPFj8j2gBAcHs4C8xJFL
	2SBhZgF1iUnzFjFD1L9ilLj7/BsLRL2OxJt355hAbGEBL4mHbxcwgfSyCWhLbN5vABIWElCU
	eLv/LthBIkBzXr+Yywoyh1ngFqPEw9YjYHNYBFQlGl4sB5vDKaArMeFrB9TVKxglpp89AFbE
	LyAqcXjhdmaID5Qkdrd3skPYP9kl7uzIhhgkIPFt8iGwByQEZCU2HYAql5Q4uOIGywRGiVlI
	3pyF8OYsJG8uYGRexSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iRESsRN2MN47YH2IMRlo40Rm
	KdHkfGDE55XEGxqbGVmYmpgaG5lbmpEmrCTOq/YoKUhIID2xJDU7NbUgtSi+qDQntfgQIxMH
	p1QD49yZy+5o7Y987SBh9yh/uregs1D9HduMPDWGVy8q1SsVvHYZV8ucWyIQe+DVj982GUyX
	7h2boc7z65nDlH3fa500vP8uOvXFlP/e8o9+vCuFZx66F9ZUrPstdsn9x6LHvt/8+HbClMLT
	dpclrS4Jm6zrYI/ZuXHi2nQzP46DPrJ1y2UVVp37xaHEUpyRaKjFXFScCADaQ29d7gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQd2WiLwgg8N7LC1eHtK0OPOsg9Fi
	y5YYi6/9d9gsLi1yt9iz9ySLxeVdc9gsNp38xerA4bFz1l12j8V7XjJ5zDsZ6LF7wWcmj74t
	qxg9Pm+SC2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAG6RkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYserGZMaCFu6K
	db92sTQwbuXoYuTkkBAwkZje+4cFwhaTuHBvPVsXIxeHkMB0RolTc5YygiR4BQQlfky+B1TE
	wcEsIC9x5FI2SJhZQF1i0rxFzBD1rxgl7j7/xgJRryPx5t05JhBbWMBL4uHbBUwgvWwC2hKb
	9xuAhIUEFCXe7r/LCmKLAM15/WIuK8gcZoFbjBIPW4+AzWERUJVoeLEcbA6ngK7EhK8dUMet
	YJSYfvYAWBG/gKjE4YXbmSE+UJLY3d7JPoFRaBaSu2ch3D0Lyd0LGJlXMYqmFiQXFCel5xrp
	FSfmFpfmpesl5+duYgQnhGfSOxhXNVgcYhTgYFTi4d2wNjdIiDWxrLgy9xCjBAezkgivh31e
	kBBvSmJlVWpRfnxRaU5q8SHGZKDLJzJLiSbnA5NVXkm8obGJmZGlkZmFkYm5OWnCSuK8B1ut
	A4UE0hNLUrNTUwtSi2C2MHFwSjUw8uYtb9hT/vvzs9dNoszhk5/2ikq/ns5o/o+rXM7j8tTW
	tuN3Diu/nMVcsuUQy7o7s/5V7jn5KfKwx6nXxheUbXJOz2vuYdtkk55TKNm+ID/mzLQWJ+O/
	t4+ErYl0+TIpwKmPN6NGw9p1SaOjA6fulk177rcpBhWWPlg4p3b6o2fRHWWtUxMnKbEUZyQa
	ajEXFScCAMw+9cBMAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-28 (월), 21:16 +0900, Jaegeuk Kim:
Hi,

> 
> 2013-10-26 (토), 00:01 +0800, Huajun Li:
> > From: Huajun Li <huajun.li@intel.com>
> > 
> > Add the function f2fs_reserve_block() to easily reserve new blocks.
> > 
> > Signed-off-by: Huajun Li <huajun.li@intel.com>
> > Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> > Signed-off-by: Weihong Xu <weihong.xu@intel.com>
> > ---
> >  fs/f2fs/data.c |   29 ++++++++++++++++++-----------
> >  fs/f2fs/f2fs.h |    1 +
> >  2 files changed, 19 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index c8887d8..7b31911 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -64,6 +64,23 @@ int reserve_new_block(struct dnode_of_data *dn)
> >  	return 0;
> >  }
> >  
> > +int f2fs_reserve_block(struct inode *inode,
> > +		       struct dnode_of_data *dn, pgoff_t index)
> 

We don't need to get dnode_of_data from parameters, since it is
used by this function only.

> 
> > +{
> > +	int err;

+        struct dnode_of_data dn;

> 
> > +
> > +	set_new_dnode(dn, inode, NULL, NULL, 0);
> > +	err = get_dnode_of_data(dn, index, ALLOC_NODE);
> > +	if (err)
> > +		return err;
> > +	if (dn->data_blkaddr == NULL_ADDR)
> > +		err = reserve_new_block(dn);
> > +
> > +	f2fs_put_dnode(dn);
> > +
> > +	return err;
> > +}
> > +
> 

-- 
Jaegeuk Kim
Samsung

