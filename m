Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab3IBUvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 16:51:02 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56629 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994Ab3IBUvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 16:51:00 -0400
MIME-Version: 1.0
In-Reply-To: <1378138904.1953.72.camel@joe-AO722>
References: <9606.1378129893@warthog.procyon.org.uk>
	<1378138904.1953.72.camel@joe-AO722>
Date: Mon, 2 Sep 2013 22:51:00 +0200
X-Google-Sender-Auth: WWGV8QuBX7Hjw1gWSQokZnddbNM
Message-ID: <CAMuHMdXMwnBqAM64yvhFNsbcnwOHRyN9c02GRyxATMwuMOKnUw@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Make extern in .h prototypes quieter.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, hannes@stressinduktion.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 6:21 PM, Joe Perches <joe@perches.com> wrote:
> The use of extern in .h files is a bit contentious.
>
> Make it emitted only when --strict is used on the
> command-line.

IIRC, the original intention was to always use "extern" in external function or
data declarations, and then complain if any "extern" keyword was found
in *.c files. Always using the "extern" keyword makes it easier to flag those.

> -                       if (WARN("AVOID_EXTERNS",
> -                                "extern prototypes should be avoided in .h files\n" . $herecurr) &&
> +                       if (CHK("AVOID_EXTERNS",
> +                               "extern prototypes should be avoided in .h files\n" . $herecurr) &&

I know it's not the subject of this patch, but shouldn't "extern prototypes"
be "extern keywords"?

>                             $fix) {
>                                 $fixed[$linenr - 1] =~ s/(.*)\bextern\s+(.*)/$1$2/;
>                         }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
