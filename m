Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3IYIxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:53:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38329 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3IYIxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:53:17 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7fe86d0000077a5-3c-5242a47bac8d
Content-transfer-encoding: 8BIT
Message-id: <1380099177.4529.38.camel@kjgkr>
Subject: Re: [RFC 1/1] f2fs: don't GC or take an fs_lock from f2fs_initxattrs()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Russ Knize <Russ.Knize@motorola.com>
Cc: Russ Knize <rknize@gmail.com>,
        "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 17:52:57 +0900
In-reply-to: <CAGfvh62J=rkvAw_nxEt1CSE9EhDQqnow+waQJ_gNt1YmkrD9wg@mail.gmail.com>
References: <CAGfvh62J=rkvAw_nxEt1CSE9EhDQqnow+waQJ_gNt1YmkrD9wg@mail.gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zY93qJU5BBr/+6FhcWuRusWfvSRaL
	y7vmsFmsnV9rsXDyBxYHVo+ds+6ye+xe8JnJo+fUW2aPz5vkAliiuGxSUnMyy1KL9O0SuDKu
	f5nGWPBVo2L6z+mMDYz/ZboYOTkkBEwktvQ9YIWwxSQu3FvP1sXIxSEksIxRYvGjY6wwRXtX
	vWSESExnlHj1/gAzSIJXQFDix+R7LF2MHBzMAvISRy5lg4SZBdQlJs1bBFYiJPCKUWLmQWuQ
	El4BHYm3/wRAwsIC/hI7zq9kAgmzCWhLbN5vAFGtKPF2/12wrSICGkCnNbFCTPzFKPFirzqI
	zSKgKjG39SHYUk6BYIn1k6pBTCGBAIn9NwJAKvgFRCUOL9zODHG7ksTu9k52kNslBK6xS1xs
	/cIMMUZA4tvkQ2BjJARkJTYdgKqXlDi44gbLBEaJWUg+nIXw4SwkHy5gZF7FKJpakFxQnJRe
	ZKhXnJhbXJqXrpecn7uJERJ5vTsYbx+wPsSYDLRxIrOUaHI+MHLzSuINjc2MLExNTI2NzC3N
	SBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBYKvhR3urlgSlLn1QGz7u9t/iu
	S3rl0hD9D1wuLTNf7MuZ0Wksu2eF1Gr/SUeWRag4NE6/n9cR1H4gSo9PQl1g95HvS8TLFGdI
	LFxhHOE9M6O0sGojdwNXSF6/V6zAGYe3oX+LXSsMXxoc4/p+IC7lscqCtpKpzVs+Hj9W+Uro
	2nxbY5Omrr9KLMUZiYZazEXFiQDl/I3M0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd3qJU5BBk1nNSwuLXK32LP3JIvF
	5V1z2CzWzq+1WDj5A4sDq8fOWXfZPXYv+Mzk0XPqLbPH501yASxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2mCaE
	hrjpWsA0Ruj6hgTB9RgZoIGEdYwZ179MYyz4qlEx/ed0xgbG/zJdjJwcEgImEntXvWSEsMUk
	Ltxbz9bFyMUhJDCdUeLV+wPMIAleAUGJH5PvsXQxcnAwC8hLHLmUDRJmFlCXmDRvEViJkMAr
	RomZB61BSngFdCTe/hMACQsL+EvsOL+SCSTMJqAtsXm/AUS1osTb/XdZQWwRAQ2JLX1NrBAT
	fzFKvNirDmKzCKhKzG19CLaUUyBYYv2kahBTSCBAYv+NAJAKfgFRicMLtzND3K4ksbu9k30C
	o9AsJBfPQrh4FpKLFzAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjutnUjsYVzZYHGIU
	4GBU4uEVOOoYJMSaWFZcmXuIUYKDWUmEN3yxU5AQb0piZVVqUX58UWlOavEhxmSgsycyS4km
	5wNTTl5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MO47VLZH
	/srqXzr36v+t+jjvkPujsoQwkZnT+A3L/1ulfxb4WbvPUG6nqXPLrY15L+fVbqq5ozv9fy3T
	e2PZL+J6b1WrPqQ6+TJPuveG7ZFdd96Rrd0vrs/x98vhF+M0K9Cbn/J76aLYTL9zZnOMuO99
	frrBt+E8D4uAyY8LlWfO/02oz/sc1qXEUpyRaKjFXFScCACT7sIyLwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russ,

That's what I wanted before.
Merged.
Thanks,

2013-09-24 (화), 15:53 -0500, Russ Knize:
> This is an alternate solution to the deadlock problem I mentioned in
> my previous patch.
> 
> On Tue, Sep 24, 2013 at 3:49 PM, Russ Knize <rknize@gmail.com> wrote:
> > From: Russ Knize <Russ.Knize@motorola.com>
> >
> > f2fs_initxattrs() is called internally from within F2FS and should
> > not call functions that are used by VFS handlers.  This avoids
> > certain deadlocks:
> >
> > - vfs_create()
> >  - f2fs_create() <-- takes an fs_lock
> >   - f2fs_add_link()
> >    - __f2fs_add_link()
> >     - init_inode_metadata()
> >      - f2fs_init_security()
> >       - security_inode_init_security()
> >        - f2fs_initxattrs()
> >         - f2fs_setxattr() <-- also takes an fs_lock
> >
> > If the caller happens to grab the same fs_lock from the pool in both
> > places, they will deadlock.  There are also deadlocks involving
> > multiple threads and mutexes:
> >
> > - f2fs_write_begin()
> >  - f2fs_balance_fs() <-- takes gc_mutex
> >   - f2fs_gc()
> >    - write_checkpoint()
> >     - block_operations()
> >      - mutex_lock_all() <-- blocks trying to grab all fs_locks
> >
> > - f2fs_mkdir() <-- takes an fs_lock
> >  - __f2fs_add_link()
> >   - f2fs_init_security()
> >    - security_inode_init_security()
> >     - f2fs_initxattrs()
> >      - f2fs_setxattr()
> >       - f2fs_balance_fs() <-- blocks trying to take gc_mutex
> >
> > Signed-off-by: Russ Knize <Russ.Knize@motorola.com>
> > ---
> >  fs/f2fs/xattr.c |   35 +++++++++++++++++++++++++----------
> >  1 file changed, 25 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
> > index 1ac8a5f..3d900ea 100644
> > --- a/fs/f2fs/xattr.c
> > +++ b/fs/f2fs/xattr.c
> > @@ -154,6 +154,9 @@ static int f2fs_xattr_advise_set(struct dentry *dentry, const char *name,
> >  }
> >
> >  #ifdef CONFIG_F2FS_FS_SECURITY
> > +static int __f2fs_setxattr(struct inode *inode, int name_index,
> > +                       const char *name, const void *value, size_t value_len,
> > +                       struct page *ipage);
> >  static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> >                 void *page)
> >  {
> > @@ -161,7 +164,7 @@ static int f2fs_initxattrs(struct inode *inode, const struct xattr *xattr_array,
> >         int err = 0;
> >
> >         for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> > -               err = f2fs_setxattr(inode, F2FS_XATTR_INDEX_SECURITY,
> > +               err = __f2fs_setxattr(inode, F2FS_XATTR_INDEX_SECURITY,
> >                                 xattr->name, xattr->value,
> >                                 xattr->value_len, (struct page *)page);
> >                 if (err < 0)
> > @@ -469,16 +472,15 @@ cleanup:
> >         return error;
> >  }
> >
> > -int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
> > -                       const void *value, size_t value_len, struct page *ipage)
> > +static int __f2fs_setxattr(struct inode *inode, int name_index,
> > +                       const char *name, const void *value, size_t value_len,
> > +                       struct page *ipage)
> >  {
> > -       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> >         struct f2fs_inode_info *fi = F2FS_I(inode);
> >         struct f2fs_xattr_entry *here, *last;
> >         void *base_addr;
> >         int found, newsize;
> >         size_t name_len;
> > -       int ilock;
> >         __u32 new_hsize;
> >         int error = -ENOMEM;
> >
> > @@ -493,10 +495,6 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
> >         if (name_len > F2FS_NAME_LEN || value_len > MAX_VALUE_LEN(inode))
> >                 return -ERANGE;
> >
> > -       f2fs_balance_fs(sbi);
> > -
> > -       ilock = mutex_lock_op(sbi);
> > -
> >         base_addr = read_all_xattrs(inode, ipage);
> >         if (!base_addr)
> >                 goto exit;
> > @@ -578,7 +576,24 @@ int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
> >         else
> >                 update_inode_page(inode);
> >  exit:
> > -       mutex_unlock_op(sbi, ilock);
> >         kzfree(base_addr);
> >         return error;
> >  }
> > +
> > +int f2fs_setxattr(struct inode *inode, int name_index, const char *name,
> > +                       const void *value, size_t value_len, struct page *ipage)
> > +{
> > +       struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> > +       int ilock;
> > +       int err;
> > +
> > +       f2fs_balance_fs(sbi);
> > +
> > +       ilock = mutex_lock_op(sbi);
> > +
> > +       err = __f2fs_setxattr(inode, name_index, name, value, value_len, ipage);
> > +
> > +       mutex_unlock_op(sbi, ilock);
> > +
> > +       return err;
> > +}
> > --
> > 1.7.10.4
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

