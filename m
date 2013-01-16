Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab3APOAL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:00:11 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:44642 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab3APOAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:00:06 -0500
MIME-Version: 1.0
In-Reply-To: <87obgpcmqs.fsf@tucsk.piliscsaba.szeredi.hu>
References: <87obgpcmqs.fsf@tucsk.piliscsaba.szeredi.hu>
From: Feng Shuo <steve.shuo.feng@gmail.com>
Date: Wed, 16 Jan 2013 21:59:32 +0800
Message-ID: <CALmpHybZ4ziLB1V10frctYrO3buHfMoekXxrHMLML3fRMy+Hnw@mail.gmail.com>
Subject: Re: [GIT PULL] fuse updates for 3.8
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Maxim Patlasov <mpatlasov@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

Would you consider the adaptive readdir_plus patch?

On Wed, Jan 16, 2013 at 8:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Hi Linus,
>
> Sorry for the late submission.  Most of this was bound for 3.7, which I
> missed due to moving house.  I think it makes sense to merge it now
> instead of next cycle as there are quite of few other fuse updates
> pending.
>
> Please consider pulling
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus
>
> The large part of this pull request is a patch series from Maxim
> Patlasov to optimize scatter-gather direct IO.  The rest is small fixes
> and cleanups.
>
> There's a one line change outside of fs/fuse to mm/filemap.c which makes
> the argument of iov_iter_single_seg_count() const, required by Maxim's
> patches.
>
> Thanks,
> Miklos
>
> ----
> Anand V. Avati (1):
>       fuse: implement NFS-like readdirplus support
>
> David Herrmann (2):
>       cuse: use mutex as registration lock instead of spinlocks
>       cuse: do not register multiple devices with identical names
>
> Maxim Patlasov (12):
>       fuse: general infrastructure for pages[] of variable size
>       fuse: categorize fuse_get_req()
>       fuse: rework fuse_retrieve()
>       fuse: rework fuse_readpages()
>       fuse: rework fuse_perform_write()
>       fuse: rework fuse_do_ioctl()
>       fuse: add per-page descriptor <offset, length> to fuse_req
>       fuse: use req->page_descs[] for argpages cases
>       mm: minor cleanup of iov_iter_single_seg_count()
>       fuse: pass iov[] to fuse_get_user_pages()
>       fuse: optimize fuse_get_user_pages()
>       fuse: optimize __fuse_direct_io()
>
> Miklos Szeredi (3):
>       fuse: cleanup fuse_direct_io()
>       fuse: make fuse_file_fallocate() static
>       cuse: fix uninitialized variable warnings
>
> Robert P. J. Day (1):
>       fuse: Move CUSE Kconfig entry from fs/Kconfig into fs/fuse/Kconfig
>
> Wei Yongjun (1):
>       fuse: remove unused variable in fuse_try_move_page()
>
> ---
>  fs/Kconfig                |   10 --
>  fs/fuse/Kconfig           |   16 ++-
>  fs/fuse/cuse.c            |   46 +++++----
>  fs/fuse/dev.c             |  122 ++++++++++++++++-------
>  fs/fuse/dir.c             |  199 ++++++++++++++++++++++++++++++++-----
>  fs/fuse/file.c            |  240 +++++++++++++++++++++++++++++----------------
>  fs/fuse/fuse_i.h          |   58 ++++++++---
>  fs/fuse/inode.c           |   11 ++-
>  include/linux/fs.h        |    2 +-
>  include/uapi/linux/fuse.h |   12 +++
>  mm/filemap.c              |    2 +-
>  11 files changed, 528 insertions(+), 190 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Feng Shuo
Tel: (86)10-59851155-2116
Fax: (86)10-59851155-2008
Tianjin Zhongke Blue Whale Information Technologies Co., Ltd
10th Floor, Tower A, The GATE building, No. 19 Zhong-guan-cun Avenue
Haidian District, Beijing, China
Postcode 100080
