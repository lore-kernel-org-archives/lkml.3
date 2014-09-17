Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaIQGoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 02:44:15 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:61037 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaIQGoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 02:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1409161236550.3150@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1409161236550.3150@file01.intranet.prod.int.rdu2.redhat.com>
Date: Wed, 17 Sep 2014 08:44:11 +0200
X-Google-Sender-Auth: sG3pq9MNn3b6nlpamFO6lKKZpsE
Message-ID: <CAMuHMdXVwUrK1dscSAX7mFbG9nquF5mYC=xbOKmV5ZXC-T7fLA@mail.gmail.com>
Subject: Re: [PATCH] framebuffer: fix screen corruption when copying
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikulas,

On Tue, Sep 16, 2014 at 6:38 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> The patch also removes the references to fb_memmove in the code that is
> commented out because fb_memmove was removed from framebuffer subsystem.

I'd leave it as-is. Using plain memmove() is not correct, as it should operate
on MMIO space, not RAM. On x86 it works with memmove(), though, but
not on all architectures.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
