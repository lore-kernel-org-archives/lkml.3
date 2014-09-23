Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaIWKXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:23:06 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:55409 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbaIWKXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:23:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140923051000.60355643@as>
References: <1411461080-4061-1-git-send-email-geert@linux-m68k.org>
	<20140923051000.60355643@as>
Date: Tue, 23 Sep 2014 12:23:01 +0200
X-Google-Sender-Auth: EriYFXenKU-PFtTC8N9g72djlaM
Message-ID: <CAMuHMdVQn=_0Xbwox9dvaG6zxr8eBy9SSZ5p1UMaSzT+wQr2NA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.17-rc6 (take two)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 12:09 PM, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> On Tue, 23 Sep 2014 10:31:20 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>> + /scratch/kisskb/src/mm/memcontrol.c: warning: control reaches end of non-void function [-Wreturn-type]:  => 4164:1
>
> Well, this one was educational. It was caused by:
>
> commit 05b8430123359886ef6a4146fba384e30d771b3f
> Author: Johannes Weiner <hannes@cmpxchg.org>
> Date:   Wed Aug 6 16:05:59 2014 -0700
>
>     mm: memcontrol: use root_mem_cgroup res_counter
>
> This removed the return statement from mem_cgroup_read_u64(). I think
> Johannes was assuming that BUG() never returns, but it looks like that
> is not true on some archs, especially with CONFIG_BUG disabled. (On x86
> it never returns in any case.) The bug was always there - it would have
> just returned an uninitialized variable before. Now it returns some
> different random value.
>
> I'm not sure what to do here. I really think BUG() should never return
> no matter what options are configured. In this case it's no big deal
> and I'd just return zero to silence the warning, but a bigger problem
> is that there are probably other places assuming BUG() never
> returns?

Just ignore it for now.

Fixing BUG() to avoid this has been an ongoing project for several years.
I don't remember what the latest status is...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
