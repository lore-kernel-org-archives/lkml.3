Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaAMIuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:50:23 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39611 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaAMIuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:50:20 -0500
MIME-Version: 1.0
In-Reply-To: <52D38787.5030505@codethink.co.uk>
References: <1389445540-21426-1-git-send-email-ben.dooks@codethink.co.uk>
	<2133074.4EFCIDJZXE@avalon>
	<52D38787.5030505@codethink.co.uk>
Date: Mon, 13 Jan 2014 09:50:19 +0100
X-Google-Sender-Auth: WDtkfd7tdgqnSsxCUyrK9rwtKf4
Message-ID: <CAMuHMdXek5YhKt9p-1LPXRuifqv6sazwzTZ+k6Ps=1-Myepirw@mail.gmail.com>
Subject: Re: [PATCH 1/3] power: clock_ops.c: fixup clk prepare/unprepare count
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@lists.codethink.co.uk,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 7:28 AM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>> I've never noticed this on Lager, probably because Lager multiplatform
>> doesn't
>> make use of clock_ops.c as drivers/sh/pm_runtime.c (which you addressed in
>> another patch that I've also replied to). I'm thus not sure we need to
>> apply
>> this as a fix and backport it to stable branches.
>
>
> Yes, it seems that a lot of the lager drivers assume that this support
> is there, and the work seems to have been sponsored by Renesas.

I can confirm that applying both this and "[PATCH] ARM: shmobile: compile
drivers/sh for CONFIG_ARCH_SHMOBILE_MULTI" makes

    rcar_thermal e61f0000.thermal: thermal sensor was broken

go away on Koelsch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
