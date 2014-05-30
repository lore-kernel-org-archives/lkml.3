Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbaE3O60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 10:58:26 -0400
Received: from mout.gmx.net ([212.227.17.22]:61398 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699AbaE3O6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 10:58:25 -0400
Message-ID: <1401461863.4646.9.camel@schoellingm.dzne.de>
Subject: Re: [PATCH] console: Add persistent scrollback buffers for all VGA
 consoles
From: Manuel Schoelling <manuel.schoelling@gmx.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Mark Brown <broonie@linaro.org>, Randy Dunlap <rdunlap@infradead.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 30 May 2014 16:57:43 +0200
In-Reply-To: <CAMuHMdVrDB7Q+oZi_WJk07a7OF_VOJiOHxpYwRABymTKsPuMoA@mail.gmail.com>
References: <1401456425-15931-1-git-send-email-manuel.schoelling@gmx.de>
	 <CAMuHMdVrDB7Q+oZi_WJk07a7OF_VOJiOHxpYwRABymTKsPuMoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K0:mqHksVmcsKmYTWpdvOpQMhjx1QPOHoOJE4ad09zCULf93kOz2p4
 weEXUU3yCA0EWcI953oxszEp3Qv0Kq3vibZ8nltCr85jF1l/DkXyLOSEloyqgQaNPPmXlJ4
 ZUm8km4nd4v9g7ZzPgJPq85Ml+9MWFdxCIDe5S6YzbZM35Hg0hAQjKMiT2HPlq5w+fdcfGR
 8ART4OtpNJcRy6bfstisQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Fr, 2014-05-30 at 16:28 +0200, Geert Uytterhoeven wrote:
Hi Manuel,
> 
> On Fri, May 30, 2014 at 3:27 PM, Manuel Schölling
> <manuel.schoelling@gmx.de> wrote:
> > Add a scrollback buffers for each VGA console. The benefit is that
> > the scrollback history is not flushed when switching between
consoles
> > but is persistent.
> > The buffers are allocated on demand when a new console is opened.
> 
> Thanks for your patch!
> 
> I see two issues with this feature:
>   1. Before, the single (default 64 KiB) buffer was allocated at
startup.
>      Now you will allocate a buffer each time a new console is opened.
>      Depending on memory fragmentation, this may fail.
Indeed, if allocation fails, scrollbuffer[vc_num]->data will stay NULL
and scrolling will be disabled for that console. Is that ok or would you
prefer another behavior of the kernel?

>  2. People with RAM-constrained systems may not like this.
>      Can it be a config option?
Sure, I will add an option for that.

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a
hacker. But
> when I'm talking to journalists I just say "programmer" or something
like that.
>                                 -- Linus Torvalds
> 

