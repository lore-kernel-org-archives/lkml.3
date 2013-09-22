Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3IVUWB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 16:22:01 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51356 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3IVUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 16:22:00 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.03.1309201946430.8379@linux-mips.org>
References: <c94f3e342947923f20d4c12932f382aa5200511b.1379641901.git.joe@perches.com>
	<6f500d88eb23fd9a4cfc5583f5ca17bc5f58fe24.1379641901.git.joe@perches.com>
	<CAMuHMdW6R5qTJ0uvsUUaYBZAqFcNshPsXeMbz5hwqq5UOkJr-g@mail.gmail.com>
	<alpine.LFD.2.03.1309201907380.8379@linux-mips.org>
	<1379702587.2301.12.camel@joe-AO722>
	<alpine.LFD.2.03.1309201946430.8379@linux-mips.org>
Date: Sun, 22 Sep 2013 22:21:59 +0200
X-Google-Sender-Auth: ieO-E5hC-Bs7I5-UphDRdWXimyc
Message-ID: <CAMuHMdXCTo4keP6vcXzxS1OQcdPC48eMu3H=D7mW-bWgrSsN6w@mail.gmail.com>
Subject: Re: [PATCH 2/2] framebuffer: Remove pmag-aa-fb
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Joe Perches <joe@perches.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 10:09 PM, Maciej W. Rozycki
<macro@linux-mips.org> wrote:
>  Thanks, but the changes required are actually much more than that -- the
> driver has never been converted to the modern TURBOchannel API.  I have
> now dug out an old patch I was working on back in 2006 to convert this
> driver as well as drivers/video/maxinefb.c.  I'll try to complete the two
> drivers as soon as possible (unfortunately I can't test the latter at all;
> it's for an onboard graphics adapter of another DECstation model),
> although I now remember the main reason I didn't complete them back then
> was they used an old internal API that was removed and no suitable
> replacement provided.  I need to investigate again what that actually was
> though (hw cursor probably).

pmag-aa-fb.c still has struct display_switch (for the old drawing API) and the
old fb_ops (with get_var()/get_fix()), instead of the new fb_ops (rectangular
drawing API and var/fix as member data).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
