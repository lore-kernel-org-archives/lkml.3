Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaAXIdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:33:51 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42375 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaAXIdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:33:49 -0500
MIME-Version: 1.0
In-Reply-To: <871tzxg5d1.wl%kuninori.morimoto.gx@gmail.com>
References: <878uu6gle8.wl%kuninori.morimoto.gx@gmail.com>
	<CAMuHMdX14rktzRtV9bqHFHZV6bsmQ_k=vAZFaPeNjcJsWeX42w@mail.gmail.com>
	<871tzxg5d1.wl%kuninori.morimoto.gx@gmail.com>
Date: Fri, 24 Jan 2014 09:33:49 +0100
X-Google-Sender-Auth: -Pfb_v6rtrOB22XMtOE9iMVB8pE
Message-ID: <CAMuHMdWHSigAGx6EtFp_Em8Qw-jt2E-o79ORoTWe=MdwZmF5pw@mail.gmail.com>
Subject: Re: [PATCH] shdma: add R-Car Audio DMAC peri peri driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux-SH <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morimoto-san,

On Fri, Jan 24, 2014 at 9:18 AM, Kuninori Morimoto
<kuninori.morimoto.gx@gmail.com> wrote:
>> > +       if (slave_id >= AUDMAPP_SLAVE_NUMBER)
>>
>> So slave_id should be unsigned int, too, and AUDMAPP_SLAVE_NUMBER
>> too ("29U").
>
> Hmm...
> This driver is called from shdma-base.c.
> And shdmac.c/sudmac.c/rcar-hpbdmac.c are same style.
>
>  1) this "slave_id" came from shdma_ops::set_slave
>     and, it is using "int"
>  2) above drivers have same xxx_find_slave(),
>     they are using "int".
>     (this driver is based on that)
>
> What should I do ?

OK, then you should keep using int, and change the test to:

    if (slave_id < 0 || slave_id >= AUDMAPP_SLAVE_NUMBER)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
