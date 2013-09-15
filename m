Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3IOIPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 04:15:50 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44414 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3IOIPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 04:15:47 -0400
MIME-Version: 1.0
In-Reply-To: <1379219942-31545-1-git-send-email-linux@roeck-us.net>
References: <1379219942-31545-1-git-send-email-linux@roeck-us.net>
Date: Sun, 15 Sep 2013 10:15:47 +0200
X-Google-Sender-Auth: Hco7w8p7A7nWmRhOR0gp7_SYFrQ
Message-ID: <CAMuHMdWJ6w5WnY-80SQpYWiVkvaPNbU7w5-UAxqFxPfFVjB1+w@mail.gmail.com>
Subject: Re: [PATCH] modpost: Fix secondary errors seen if a single module
 build fails
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 6:39 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> -      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$/.o/' | $(modpost) -s -T -
> +      cmd_modpost = $(MODLISTCMD) | sed 's/\.ko$/.o/' | \
> +       while read a; do [ -f $a ] && echo $a; done | $(modpost) -s -T -

I'm wondering whether this can be filtered without using a shell while loop?
E.g. using "ls"?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
