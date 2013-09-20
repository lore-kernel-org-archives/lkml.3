Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3ITLyC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:54:02 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33932 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3ITLx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:53:59 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <1378750707-1428-1-git-send-email-teg@jklm.no>
References: <1378750298-965-1-git-send-email-teg@jklm.no>
	<1378750707-1428-1-git-send-email-teg@jklm.no>
Date: Fri, 20 Sep 2013 13:53:58 +0200
Message-ID: <CAJfpegvExPSr6G8kq+eGRNkYCOiwctAyWPA9OiC7HC_RNyJ7Tg@mail.gmail.com>
Subject: Re: [PATCH v2] cuse: creat 'dead' device node for on-demand module loading
From: Miklos Szeredi <miklos@szeredi.hu>
To: Tom Gundersen <teg@jklm.no>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 8:18 PM, Tom Gundersen <teg@jklm.no> wrote:
> This allows udev (or more recently systemd-tmpfiles) to create /dev/cuse on
> boot, in the same way as /dev/fuse is currently created, and the corresponding
> module to be loaded on first access.

Committed to for-next.

Thanks,
Miklos

>
> The corresponding functionalty was introduced for fuse in commit 578454f.
>
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> ---
>
> v2: also update Documentation/devices.txt (and pick a minor that is not taken)
>
>  Documentation/devices.txt  | 1 +
>  fs/fuse/cuse.c             | 5 ++++-
>  include/linux/miscdevice.h | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> index 23721d3..80b7241 100644
> --- a/Documentation/devices.txt
> +++ b/Documentation/devices.txt
> @@ -414,6 +414,7 @@ Your cooperation is appreciated.
>                 200 = /dev/net/tun      TAP/TUN network device
>                 201 = /dev/button/gulpb Transmeta GULP-B buttons
>                 202 = /dev/emd/ctl      Enhanced Metadisk RAID (EMD) control
> +               203 = /dev/cuse         Cuse (character device in user-space)
>                 204 = /dev/video/em8300         EM8300 DVD decoder control
>                 205 = /dev/video/em8300_mv      EM8300 DVD decoder video
>                 206 = /dev/video/em8300_ma      EM8300 DVD decoder audio
> diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
> index adbfd66..24da581 100644
> --- a/fs/fuse/cuse.c
> +++ b/fs/fuse/cuse.c
> @@ -589,11 +589,14 @@ static struct attribute *cuse_class_dev_attrs[] = {
>  ATTRIBUTE_GROUPS(cuse_class_dev);
>
>  static struct miscdevice cuse_miscdev = {
> -       .minor          = MISC_DYNAMIC_MINOR,
> +       .minor          = CUSE_MINOR,
>         .name           = "cuse",
>         .fops           = &cuse_channel_fops,
>  };
>
> +MODULE_ALIAS_MISCDEV(CUSE_MINOR);
> +MODULE_ALIAS("devname:cuse");
> +
>  static int __init cuse_init(void)
>  {
>         int i, rc;
> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
> index cb35835..f7eaf2d 100644
> --- a/include/linux/miscdevice.h
> +++ b/include/linux/miscdevice.h
> @@ -31,6 +31,7 @@
>  #define I2O_MINOR              166
>  #define MICROCODE_MINOR                184
>  #define TUN_MINOR              200
> +#define CUSE_MINOR             203
>  #define MWAVE_MINOR            219     /* ACP/Mwave Modem */
>  #define MPT_MINOR              220
>  #define MPT2SAS_MINOR          221
> --
> 1.8.4
>
