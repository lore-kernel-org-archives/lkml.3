Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab3JAHEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 03:04:15 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64673 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3JAHEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 03:04:14 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
References: <20130912133855.GA23780@gmail.com>
	<CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
	<CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
	<20130912184341.GA11400@ghostprotocols.net>
	<52321CE4.1080804@gmail.com>
	<20130912200236.GC11400@ghostprotocols.net>
	<20130912203116.GD32644@gmail.com>
	<20130912204313.GA3259@gmail.com>
	<20130915091029.GA21465@gmail.com>
	<20130930164210.GA22342@gmail.com>
	<20130930171220.GC10293@ghostprotocols.net>
	<CA+55aFyjtFo2GVAvvUD_BQBN-F6QzOVWzcFo5v_MLhEwpGa03w@mail.gmail.com>
Date: Tue, 1 Oct 2013 09:04:13 +0200
X-Google-Sender-Auth: 3Caeycw3y-jlf2t9jzCeJdRnnRw
Message-ID: <CAMuHMdUe3nLFcsZL+soHC7hsjURT+3uO-PMuboSV_eGEO=XPxQ@mail.gmail.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them in parallel
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 7:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Sep 30, 2013 at 10:12 AM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
>>
>> Checking why that strlcpy failed...
>
> I don't think glibc does strlcpy. It's not a standard C function, and
> it's somewhat controversial (although I dislike strncpy more with the
> crazy zero-padding, ugh).

Indeed, e.g. on Ubuntu it's in libbsd, so you also need to #include
<bsd/string.h> and link with -lbsd.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
