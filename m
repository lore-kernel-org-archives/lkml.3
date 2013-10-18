Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab3JRJXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:23:06 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48315 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3JRJXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:23:04 -0400
MIME-Version: 1.0
In-Reply-To: <1382086049-14386-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382086049-14386-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Fri, 18 Oct 2013 11:23:03 +0200
X-Google-Sender-Auth: 6qnDbVMTVZhW9d6ytOyhBOQ9Ddg
Message-ID: <CAMuHMdWXWfGqw041pkOYKzLjQ05GfCcz9jOFQaPa=d_RwhOUcg@mail.gmail.com>
Subject: Re: [PATCH] init: make init failures more explicit
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 10:47 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> +       if (ret && ret != -ENOENT) {
> +               pr_err("Starting init: %s exists but couldn't execute it\n",

I think it makes sense to also print the value of ret here.
Apart from your -ENOEXEC case, peeking a bit around, it can be also be
-EINVAL, -ENOMEM (debug binary too big for small embedded system?),
-EACCES, -E2BIG, ...

> +                      init_filename);
> +       }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
