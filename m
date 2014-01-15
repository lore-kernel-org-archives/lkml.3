Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaAOIq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:46:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbaAOIqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:46:25 -0500
Date: Wed, 15 Jan 2014 10:46:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH stable-only] virtio-net: fix build on m68k and sparc64
Message-ID: <20140115084605.GF29177@redhat.com>
References: <1389774152-1526-1-git-send-email-mst@redhat.com>
 <CAMuHMdV=qzDApabSiQj9up_RUW=PoVJA8oWaiWY7d2iQ22AfeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV=qzDApabSiQj9up_RUW=PoVJA8oWaiWY7d2iQ22AfeQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 09:36:13AM +0100, Geert Uytterhoeven wrote:
> On Wed, Jan 15, 2014 at 9:26 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > As a result of backporting a bugfix, virtio_net started passing void *
> > to page_address, assuming that it will get silently converted to struct
> > page *. But this does not happen on architectures where page_address is
> > a macro, the result is build failure as the macro tries to dereference
> > void*.
> >
> > Fix by reordering code slightly, so we always pass
> > struct page * to page_address.
> 
> Thanks for the clue! I was just investigating a similar failure in -next.
> 
> Gr{oetje,eeting}s,
> 
>                         Geert

You don't mean linux-next? And not in virtio-net? I don't see page_address
being used on void * anywhere there.

> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
