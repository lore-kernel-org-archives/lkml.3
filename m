Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaHDL2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:28:37 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40726 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDL2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <2717555.fiA6A86F65@avalon>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<53D68CC4.1010704@ti.com>
	<CACxGe6uMke5vgzcNC9xUqjr2bHJ4QFHD6YjocSZWq8Ccx8Mm6A@mail.gmail.com>
	<2717555.fiA6A86F65@avalon>
Date: Mon, 4 Aug 2014 13:28:32 +0200
X-Google-Sender-Auth: m79txu9w1K4Lyj0hQyjnfKkBTSs
Message-ID: <CAMuHMdVKDQz8q0b2UA7=1K8Qw4n3U0=M+mJyi5UQP7QZdC-JiQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] of/clk: use "clkops-clocks" to specify clocks
 handled by clock_ops domain
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Jul 30, 2014 at 2:06 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> The third option would require storing the clocks lists in device drivers. I
> believe this is our best option, as a trade-off between simplicity and
> versatility. Drivers that use runtime PM already need to enable it explicitly
> when probing devices. Passing a list of clock names to runtime PM at that
> point wouldn't complicate drivers much. When the clocks list isn't SoC-
> dependent it could be stored as static information. Otherwise it could be
> derived from DT (or any other source of hardware description) using C code,
> offering all the versatility we need.
>
> The only drawback of this solution I can think of right now is that the
> runtime PM core couldn't manage device clocks before probing the device.
> Specifically device clocks couldn't be managed if no driver is loaded for that
> device. I somehow recall that someone raised this as being a problem, but I
> can't remember why.

Perhaps you're thinking of clocks that were enabled (by the boot loader or
implicit reset state) before running Linux, and aren't disabled?

That was fixed by commit bb178da701382a230e26d90cf94e8a24b280e0d9
("clk: shmobile: mstp: Fix the is_enabled() operation").

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
