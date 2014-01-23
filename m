Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaAWUol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:44:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbaAWUoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:44:39 -0500
Date: Thu, 23 Jan 2014 15:44:30 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/10] framebuffer: fix cfb_copyarea
In-Reply-To: <CAMuHMdWebQNKh4G8ZjpmZV15riHFpLiz5j1V4H+iSZ3VQp91gA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1401231539320.21686@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com> <CAMuHMdWebQNKh4G8ZjpmZV15riHFpLiz5j1V4H+iSZ3VQp91gA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Jan 2014, Geert Uytterhoeven wrote:

> On Thu, Jan 23, 2014 at 7:18 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > The cfb_copyarea code was very buggy and it looks like it was written
> > and never tried with non-8-pixel font.
> 
> My memory may suffer from bitrot, but I think I tested it with the Sun
> 12x22 font. That was on big endian (PPC), though.

The bug happens when the horizontal font size in bytes is not divisible by 
(sizeof(long) / 2).

Mikulas

> BTW, good to see you still have a working TGA. My PPC and Alpha gear
> died a decade ago.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
