Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaKQKf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:35:28 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:57721 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaKQKf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:35:26 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1415906662-4576-6-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
	<1415906662-4576-6-git-send-email-bobby.prani@gmail.com>
Date: Mon, 17 Nov 2014 11:35:26 +0100
Message-ID: <CAJfpegtL9=YjB34kqYgGV7FRnR75uPP6LjnHBmaABK-ixZKsrw@mail.gmail.com>
Subject: Re: [PATCH 05/16] overlayfs: Replace smp_read_barrier_depends() with lockless_dereference()
From: Miklos Szeredi <miklos@szeredi.hu>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "open list:OVERLAYFS FILESYSTEM" <linux-fsdevel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 8:24 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> Recently lockless_dereference() was added which can be used in place of
> hard-coding smp_read_barrier_depends(). The following PATCH makes the change.
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  fs/overlayfs/super.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 08b704c..b0f050e 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -84,12 +84,10 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
>
>  static struct dentry *ovl_upperdentry_dereference(struct ovl_entry *oe)
>  {
> -       struct dentry *upperdentry = ACCESS_ONCE(oe->__upperdentry);
>         /*
>          * Make sure to order reads to upperdentry wrt ovl_dentry_update()
>          */
> -       smp_read_barrier_depends();
> -       return upperdentry;
> +       return lockless_dereference(oe->__upperdentry);
>  }
>
>  void ovl_path_upper(struct dentry *dentry, struct path *path)
> --
> 1.9.1
>

Thanks, already in overlayfs-next branch of

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

Thanks,
Miklos
