Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbaIQLo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:44:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbaIQLo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:44:27 -0400
Date: Wed, 17 Sep 2014 07:44:14 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] framebuffer: fix screen corruption when copying
In-Reply-To: <CAMuHMdXVwUrK1dscSAX7mFbG9nquF5mYC=xbOKmV5ZXC-T7fLA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1409170736370.15277@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1409161236550.3150@file01.intranet.prod.int.rdu2.redhat.com> <CAMuHMdXVwUrK1dscSAX7mFbG9nquF5mYC=xbOKmV5ZXC-T7fLA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Sep 2014, Geert Uytterhoeven wrote:

> Hi Mikulas,
> 
> On Tue, Sep 16, 2014 at 6:38 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > The patch also removes the references to fb_memmove in the code that is
> > commented out because fb_memmove was removed from framebuffer subsystem.
> 
> I'd leave it as-is. Using plain memmove() is not correct, as it should operate
> on MMIO space, not RAM. On x86 it works with memmove(), though, but
> not on all architectures.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert

That code is disabled with #if 0. So it doesn't matter if it's incorrect 
in some specific situation.

The purpose of that disabled code is to be able to verify that the bug is 
in bitcpy_rev. I get screen corruption - so I enable that "memmove" 
statement - the screen corruption goes away - so I know that the bug is in 
bitcpy_rev.

Mikulas
