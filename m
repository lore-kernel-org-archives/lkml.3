Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab3EVUsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:48:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3EVUsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:48:14 -0400
Date: Wed, 22 May 2013 13:48:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 01/14] do_mounts: constify name_to_dev_t parameter
Message-Id: <20130522134812.40924cb34eaea1588b756a14@linux-foundation.org>
In-Reply-To: <1368132193-25817-2-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
	<1368132193-25817-2-git-send-email-joern@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 16:42:57 -0400 Joern Engel <joern@logfs.org> wrote:

> --- a/include/linux/mount.h
> +++ b/include/linux/mount.h
> @@ -74,6 +74,6 @@ extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
>  extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
>  extern void mark_mounts_for_expiry(struct list_head *mounts);
>  
> -extern dev_t name_to_dev_t(char *name);
> +extern dev_t name_to_dev_t(const char *name);
>  
>  #endif /* _LINUX_MOUNT_H */
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index 1d1b634..da96f85 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -202,7 +202,7 @@ done:
>   *	bangs.
>   */
>  
> -dev_t name_to_dev_t(char *name)
> +dev_t name_to_dev_t(const char *name)
>  {
>  	char s[32];
>  	char *p;

A changelog would be nice.  There are 1.1 billion places in the kernel
where we could make such a change - why was this one made?

