Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3FBKvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 06:51:10 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:59170 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab3FBKvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:51:03 -0400
MIME-Version: 1.0
In-Reply-To: <000501ce5e97$73e05f40$5ba11dc0$@samsung.com>
References: <000501ce5e97$73e05f40$5ba11dc0$@samsung.com>
Date: Sun, 2 Jun 2013 13:51:02 +0300
Message-ID: <CAHp75VeUzyURf=fpzW2nW-BYio06GE7C_9BXyxsrjEdQhzGQgg@mail.gmail.com>
Subject: Re: [PATCH] mfd: replace strict_strtoul() with kstrtoul()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 10:13 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> The usage of strict_strtoul() is not preferred, because
> strict_strtoul() is obsolete. Thus, kstrtoul() should be
> used.

> --- a/drivers/mfd/aat2870-core.c
> +++ b/drivers/mfd/aat2870-core.c
> @@ -312,7 +312,7 @@ static ssize_t aat2870_reg_write_file(struct file *file,
>         while (*start == ' ')
>                 start++;
>
> -       if (strict_strtoul(start, 16, &val))
> +       if (kstrtoul(start, 16, &val))
>                 return -EINVAL;

ret = kstrtoul(...);
if (ret)
 return ret;

> --- a/drivers/mfd/ab3100-core.c
> +++ b/drivers/mfd/ab3100-core.c
> @@ -514,13 +514,13 @@ static ssize_t ab3100_get_set_reg(struct file *file,
>         /*
>          * Advance pointer to end of string then terminate
>          * the register string. This is needed to satisfy
> -        * the strict_strtoul() function.
> +        * the kstrtoul() function.
>          */
>         while ((i < buf_size) && (buf[i] != ' '))
>                 i++;
>         buf[i] = '\0';
>
> -       err = strict_strtoul(&buf[regp], 16, &user_reg);
> +       err = kstrtoul(&buf[regp], 16, &user_reg);
>         if (err)
>                 return err;
>         if (user_reg > 0xff)

user_reg couldn't be more than byte.
So, you may change its definition to u8 and use here kstrtou8() and
remove later check.

But on first glance on that function it could be optimized a lot
(there are so many custom stuff like skip_space() and like that).

> @@ -557,7 +557,7 @@ static ssize_t ab3100_get_set_reg(struct file *file,
>                         i++;
>                 buf[i] = '\0';
>
> -               err = strict_strtoul(&buf[valp], 16, &user_value);
> +               err = kstrtoul(&buf[valp], 16, &user_value);
>                 if (err)
>                         return err;
>                 if (user_reg > 0xff)

Same idea here.

--
With Best Regards,
Andy Shevchenko
