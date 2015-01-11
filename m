Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbbAKKmE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 05:42:04 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63164 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbbAKKmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 05:42:02 -0500
MIME-Version: 1.0
In-Reply-To: <1389910514-3802-1-git-send-email-paul.gortmaker@windriver.com>
References: <1389910514-3802-1-git-send-email-paul.gortmaker@windriver.com>
Date: Sun, 11 Jan 2015 11:42:00 +0100
X-Google-Sender-Auth: vQ7AKyFCw4dJJ2t1cKfcU_e2Pd4
Message-ID: <CAMuHMdWxEiBNas2S18fu9H8BK5aEdEmgazT0dpj1N0TFeDHiAg@mail.gmail.com>
Subject: Re: [PATCH] m68k: don't use module_init in non-modular mvme16x/rtc.c code
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 11:15 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> The rtc.o is built for obj-y, i.e. always built in.  It will
> never be modular, so using module_init as an alias for __initcall
> can be somewhat misleading.
>
> Fix this up now, so that we can relocate module_init from
> init.h into module.h in the future.  If we don't do this, we'd
> have to add module.h to obviously non-modular code, and that
> would be a worse thing.
>
> Note that direct use of __initcall is discouraged, vs. one
> of the priority categorized subgroups.  As __initcall gets
> mapped onto device_initcall, our use of device_initcall
> directly in this change means that the runtime impact is
> zero -- it will remain at level 6 in initcall ordering.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: linux-m68k@lists.linux-m68k.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Thanks, applied and queued for 3.20.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
