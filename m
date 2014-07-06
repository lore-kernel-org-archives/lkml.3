Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaGFJIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 05:08:31 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:52997 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaGFJI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 05:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <1404637557.24853.12.camel@x220>
References: <20140706080234.19520.96704.stgit@zurg>
	<1404637557.24853.12.camel@x220>
Date: Sun, 6 Jul 2014 11:08:27 +0200
X-Google-Sender-Auth: C7WXp8sf9_GQm1mVF1TrVJReQr4
Message-ID: <CAMuHMdWUpqz0W_znrrm2Qp+QjKExQ5Gcv0OsuA4gJa1Wvjv06A@mail.gmail.com>
Subject: Re: [PATCH] kconfig: store default ARCH in .config
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2014 at 11:05 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sun, 2014-07-06 at 12:02 +0400, Konstantin Khlebnikov wrote:
>> This patch makes cross-compilation configuration fully statefull.
>> Default ARCH is stored in .config as CONFIG_DEFAULT_ARCH.
>> After initial configuration specifying ARCH= is no longer required.
>>
>> To avoid recursion it is read directly from .config using scritps/config
>> because include/config/auto.conf is not yet included at this point.
>>
>> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
>> ---
>
> It this needed because the Kconfig symbol ARCH is set only if ARCH is
> set in the environment?
>
> Could the same result be had by saving CONFIG_ARCH in .config (I suppose
> it actually already is) and then use its value on builds with

No, currently it's not saved in .config, so I guess that's why this convoluted
approach is needed.

> that .config unless ARCH is specified in the environment again? Ie,
> change the "option env=[...]" semantics a bit, perhaps by special casing
> CONFIG_ARCH.

Indeed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
