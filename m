Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3JVIZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:25:55 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:56816 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3JVIZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:25:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAGbDTvqC0e0wZpEYHL2kg2wGYFfZt9gx7bQQ8cmbySWHqquWqw@mail.gmail.com>
References: <CAGbDTvqC0e0wZpEYHL2kg2wGYFfZt9gx7bQQ8cmbySWHqquWqw@mail.gmail.com>
Date: Tue, 22 Oct 2013 10:25:53 +0200
X-Google-Sender-Auth: Z6DQMkA5mLfTgaWJBuQyw0jvKZ4
Message-ID: <CAMuHMdWwWPST8AHUiThuFge9bVjuwVMEjb2yXbivMAE==W4NmQ@mail.gmail.com>
Subject: Re: Looking for configuration-dependent bugs in Linux
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Iago Abal <mail@iagoabal.eu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Iago Abal <iari@itu.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 12:49 PM, Iago Abal <mail@iagoabal.eu> wrote:
> We are currently looking for already-fixed configuration-dependent
> bugs in Linux ---the bugfix helps us to understand the underlying
> cause. A good example is [2], which fixes a bug that only shows up in
> PA-RISC architectures when DISCONTIGMEM is enabled. Any bug appearing
> in some configurations but not in others is interesting for us (e.g. a
> bug affecting PowerPC only), even though the more complex the
> interaction between configuration options the more interesting is the
> bug for our purpose.
>
> As a Linux kernel developer, could you:
>
> * remember any configuration-dependent bug?
> * identify any subset of configuration options that tend to interact badly?
> * spot any part of the kernel more prone to configuration-dependent bugs?

>From the top of my head and a little bit of git log:

  * Missing includes, due to indirect inclusion on some platforms.
    Typically one of:
        <linux/slab.h>
        <linux/prefetch.h>
        <linux/of.h>
        <linux/irqreturn.h>
        <linux/uaccess.h>
        <linux/err.h>
  * Missing/broken code/dependencies on platforms where some popular
    config options are not set.
    Typically one of:
        CONFIG_SMP
        CONFIG_PM
        CONFIG_PCI
        CONFIG_HAS_DMA

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
