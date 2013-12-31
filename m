Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3LaMbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 07:31:18 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:33933 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3LaMbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 07:31:17 -0500
MIME-Version: 1.0
In-Reply-To: <1388490199-26517-1-git-send-email-saumyakuanr@gmail.com>
References: <1388490199-26517-1-git-send-email-saumyakuanr@gmail.com>
Date: Tue, 31 Dec 2013 13:31:16 +0100
Message-ID: <CAFLxGvxD+6mBH-d00bR=8A_t=onE8Kbc7VYmH6z-93=0+K2Szw@mail.gmail.com>
Subject: Re: [PATCH] mtd: fixed few coding style and indentation issues
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Saumya Ranjan Kuanr <saumyakuanr@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Saumya Ranjan Kuanr <skuanr@asu.edu>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 12:43 PM, Saumya Ranjan Kuanr
<saumyakuanr@gmail.com> wrote:
> From: Saumya Ranjan Kuanr <skuanr@asu.edu>
>
> fixed few coding style and indentatiuon issues

Please fix real issues instead of polluting the git history with
whitespace cleanups.

> signed-off-by: Saumya Ranjan Kuanr <saumyakuanr@gmail.com>
> ---
>  drivers/mtd/mtdchar.c |   42 ++++++++++++++++++++----------------------
>  1 file changed, 20 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 684bfa3..b008744 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -32,6 +32,7 @@
>  #include <linux/mount.h>
>  #include <linux/blkpg.h>
>  #include <linux/magic.h>
> +#include <linux/major.h>
>  #include <linux/mtd/mtd.h>
>  #include <linux/mtd/partitions.h>
>  #include <linux/mtd/map.h>
> @@ -181,8 +182,8 @@ static ssize_t mtdchar_read(struct file *file, char __user *buf, size_t count,
>         struct mtd_file_info *mfi = file->private_data;
>         struct mtd_info *mtd = mfi->mtd;
>         size_t retlen;
> -       size_t total_retlen=0;
> -       int ret=0;
> +       size_t total_retlen = 0;
> +       int ret = 0;
>         int len;
>         size_t size = count;
>         char *kbuf;
> @@ -241,16 +242,14 @@ static ssize_t mtdchar_read(struct file *file, char __user *buf, size_t count,
>                         if (copy_to_user(buf, kbuf, retlen)) {
>                                 kfree(kbuf);
>                                 return -EFAULT;
> -                       }
> -                       else
> +                       } else
>                                 total_retlen += retlen;
>
>                         count -= retlen;
>                         buf += retlen;
>                         if (retlen == 0)
>                                 count = 0;
> -               }
> -               else {
> +               } else {
>                         kfree(kbuf);
>                         return ret;
>                 }
> @@ -269,8 +268,8 @@ static ssize_t mtdchar_write(struct file *file, const char __user *buf, size_t c
>         size_t size = count;
>         char *kbuf;
>         size_t retlen;
> -       size_t total_retlen=0;
> -       int ret=0;
> +       size_t total_retlen = 0;
> +       int ret = 0;
>         int len;
>
>         pr_debug("MTD_write\n");
> @@ -328,8 +327,7 @@ static ssize_t mtdchar_write(struct file *file, const char __user *buf, size_t c
>                         total_retlen += retlen;
>                         count -= retlen;
>                         buf += retlen;
> -               }
> -               else {
> +               } else {
>                         kfree(kbuf);
>                         return ret;
>                 }
> @@ -344,7 +342,7 @@ static ssize_t mtdchar_write(struct file *file, const char __user *buf, size_t c
>      IOCTL calls for getting device parameters.
>
>  ======================================================================*/
> -static void mtdchar_erase_callback (struct erase_info *instr)
> +static void mtdchar_erase_callback(struct erase_info *instr)
>  {
>         wake_up((wait_queue_head_t *)instr->priv);
>  }
> @@ -670,10 +668,10 @@ static int mtdchar_ioctl(struct file *file, u_int cmd, u_long arg)
>         {
>                 struct erase_info *erase;
>
> -               if(!(file->f_mode & FMODE_WRITE))
> +               if (!(file->f_mode & FMODE_WRITE))
>                         return -EPERM;
>
> -               erase=kzalloc(sizeof(struct erase_info),GFP_KERNEL);
> +               erase = kzalloc(sizeof(struct erase_info), GFP_KERNEL);
>                 if (!erase)
>                         ret = -ENOMEM;
>                 else {
> @@ -726,7 +724,7 @@ static int mtdchar_ioctl(struct file *file, u_int cmd, u_long arg)
>                                 remove_wait_queue(&waitq, &wait);
>                                 set_current_state(TASK_RUNNING);
>
> -                               ret = (erase->state == MTD_ERASE_FAILED)?-EIO:0;
> +                               ret = (erase->state == MTD_ERASE_FAILED) ? -EIO : 0;
>                         }
>                         kfree(erase);
>                 }
> @@ -958,7 +956,7 @@ static int mtdchar_ioctl(struct file *file, u_int cmd, u_long arg)
>         {
>                 mfi->mode = 0;
>
> -               switch(arg) {
> +               switch (arg) {
>                 case MTD_FILE_MODE_OTP_FACTORY:
>                 case MTD_FILE_MODE_OTP_USER:
>                         ret = otp_select_filemode(mfi, arg);
> @@ -1099,7 +1097,7 @@ static unsigned long mtdchar_get_unmapped_area(struct file *file,
>                 return (unsigned long) -EINVAL;
>
>         ret = mtd_get_unmapped_area(mtd, len, offset, flags);
> -       return ret == -EOPNOTSUPP ? -ENOSYS : ret;
> +       return ret == -EOPNOTSUPP ? -ENODEV : ret;
>  }
>  #endif
>
> @@ -1113,7 +1111,7 @@ static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
>         struct mtd_info *mtd = mfi->mtd;
>         struct map_info *map = mtd->priv;
>
> -        /* This is broken because it assumes the MTD device is map-based
> +       /* This is broken because it assumes the MTD device is map-based
>            and that mtd->priv is a valid struct map_info.  It should be
>            replaced with something that uses the mtd_get_unmapped_area()
>            operation properly. */
> @@ -1124,9 +1122,9 @@ static int mtdchar_mmap(struct file *file, struct vm_area_struct *vma)
>  #endif
>                 return vm_iomap_memory(vma, map->phys, map->size);
>         }
> -       return -ENOSYS;
> +       return -ENODEV;

Huh?

>  #else
> -       return vma->vm_flags & VM_SHARED ? 0 : -ENOSYS;
> +       return vma->vm_flags & VM_SHARED ? 0 : -EACCES;
>  #endif
>  }
>
> @@ -1159,9 +1157,9 @@ static struct dentry *mtd_inodefs_mount(struct file_system_type *fs_type,
>  }
>
>  static struct file_system_type mtd_inodefs_type = {
> -       .name = "mtd_inodefs",
> -       .mount = mtd_inodefs_mount,
> -       .kill_sb = kill_anon_super,
> +       .name = "mtd_inodefs",
> +       .mount = mtd_inodefs_mount,
> +       .kill_sb = kill_anon_super,
>  };
>  MODULE_ALIAS_FS("mtd_inodefs");
>
> --
> 1.7.9.5
>
>
> ---
> This email is free from viruses and malware because avast! Antivirus protection is active.
> http://www.avast.com
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/



-- 
Thanks,
//richard
