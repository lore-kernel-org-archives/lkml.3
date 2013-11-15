Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab3KOLL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 06:11:27 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59338 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3KOLLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 06:11:18 -0500
MIME-Version: 1.0
In-Reply-To: <E1VThRV-0002z6-Or@ZenIV.linux.org.uk>
References: <E1VThRV-0002z6-Or@ZenIV.linux.org.uk>
Date: Fri, 15 Nov 2013 12:11:18 +0100
X-Google-Sender-Auth: UGaq5SNA3RGjHstvpxLL7gwngTc
Message-ID: <CAMuHMdXQ6fKfy8UdsAnui+_40LYKSMBSLenNZ797RswHtYa9Xw@mail.gmail.com>
Subject: Re: [RFC][PATCH 11/13] dump_skip(): dump_seek() replacement taking coredump_params
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

On Wed, Oct 9, 2013 at 2:15 AM, Al Viro <viro@ftp.linux.org.uk> wrote:
> --- a/fs/coredump.c
> +++ b/fs/coredump.c

> @@ -714,32 +706,25 @@ int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
>  }
>  EXPORT_SYMBOL(dump_emit);
>
> -int dump_seek(struct file *file, loff_t off)
> +int dump_skip(struct coredump_params *cprm, size_t nr)
>  {
> -       int ret = 1;
> -
> +       static char zeroes[PAGE_SIZE];

Do we really need this to be static?

It's at the top of my v3.12.. bloat-o-meter report:

function                                     old     new   delta
static.zeroes                                  -    4096   +4096

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
