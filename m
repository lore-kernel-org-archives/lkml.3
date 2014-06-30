Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaF3Nef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:34:35 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39863 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaF3Nec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:34:32 -0400
MIME-Version: 1.0
In-Reply-To: <530fc2e19919f12996227b27645be7e8f911a7ba.1403999769.git.joe@perches.com>
References: <cover.1403999769.git.joe@perches.com>
	<530fc2e19919f12996227b27645be7e8f911a7ba.1403999769.git.joe@perches.com>
Date: Mon, 30 Jun 2014 14:34:31 +0100
Message-ID: <CAKPcRGpKuGsGvZ--3oVFGEpWwBg3RajAVzr3Hiz3bcmdbZR2=w@mail.gmail.com>
Subject: Re: [PATCH 4/4] fs: asus_atk0110: Fix DEFINE_SIMPLE_ATTRIBUTE
 semicolon definition and use
From: Luca Tettamanti <kronos.it@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2014 at 1:20 AM, Joe Perches <joe@perches.com> wrote:
> The DEFINE_SIMPLE_ATTRIBUTE macro should not end in a ;
> Fix the one use in the kernel tree that did not have a semicolon.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Luca Tettamanti <kronos.it@gmail.com>

For my driver only ;-)

Luca

> ---
>  drivers/hwmon/asus_atk0110.c | 2 +-
>  include/linux/fs.h           | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
> index ae208f6..cccef87 100644
> --- a/drivers/hwmon/asus_atk0110.c
> +++ b/drivers/hwmon/asus_atk0110.c
> @@ -688,7 +688,7 @@ static int atk_debugfs_gitm_get(void *p, u64 *val)
>  DEFINE_SIMPLE_ATTRIBUTE(atk_debugfs_gitm,
>                         atk_debugfs_gitm_get,
>                         NULL,
> -                       "0x%08llx\n")
> +                       "0x%08llx\n");
>
>  static int atk_acpi_print(char *buf, size_t sz, union acpi_object *obj)
>  {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8a9e7f8..e78e9ac 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2701,7 +2701,7 @@ static const struct file_operations __fops = {                            \
>         .read    = simple_attr_read,                                    \
>         .write   = simple_attr_write,                                   \
>         .llseek  = generic_file_llseek,                                 \
> -};
> +}
>
>  static inline __printf(1, 2)
>  void __simple_attr_check_format(const char *fmt, ...)
> --
> 1.8.1.2.459.gbcd45b4.dirty
>
