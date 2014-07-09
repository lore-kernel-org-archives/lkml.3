Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbaGIR6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:58:07 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:44384 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbaGIR6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:58:03 -0400
MIME-Version: 1.0
In-Reply-To: <1404911056-29064-4-git-send-email-elder@linaro.org>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
	<1404911056-29064-4-git-send-email-elder@linaro.org>
Date: Wed, 9 Jul 2014 19:58:01 +0200
X-Google-Sender-Auth: aEkCskZRxPtwRT6FXwS4BO0R5pk
Message-ID: <CAMuHMdV9=0ZUYvvK5eZsN-fFuCHNKTW6Ab2rKvS5XsfVOhBh6Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] printk: use a clever macro
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alex Elder <elder@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        bp@suse.de, Jan Kara <jack@suse.cz>,
        John Stultz <john.stultz@linaro.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Wed, Jul 9, 2014 at 3:04 PM, Alex Elder <elder@linaro.org> wrote:
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -453,11 +453,7 @@ static int log_store(int facility, int level,
>         return msg->text_len;
>  }
>
> -#ifdef CONFIG_SECURITY_DMESG_RESTRICT
> -int dmesg_restrict = 1;
> -#else
> -int dmesg_restrict;
> -#endif
> +int dmesg_restrict = IS_ENABLED(CONFIG_SECURITY_DMESG_RESTRICT);

Doesn't this move dmesg_restrict from the bss to the data section
in case CONFIG_SECURITY_DMESG_RESTRICT is not enabled, due
to the explicit initialization to zero?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
