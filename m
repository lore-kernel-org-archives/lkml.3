Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3IOEfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 00:35:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3IOEff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 00:35:35 -0400
Date: Sat, 14 Sep 2013 21:35:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Andre Naujoks <nautsch2@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Jason Baron <jbaron@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux list <linux-kernel@vger.kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/3] lib: introduce upper case hex ascii helpers
Message-Id: <20130914213546.ae435cdd.akpm@linux-foundation.org>
In-Reply-To: <CACnwZYdBocYEjASpKCNZ6cfLNpzxeLxaVjLCHwxwsYO+P14tAQ@mail.gmail.com>
References: <1379093833-4949-1-git-send-email-nautsch2@gmail.com>
	<1379093833-4949-3-git-send-email-nautsch2@gmail.com>
	<CACnwZYdBocYEjASpKCNZ6cfLNpzxeLxaVjLCHwxwsYO+P14tAQ@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Sep 2013 01:27:03 -0300 Thiago Farina <tfransosi@gmail.com> wrote:

> On Fri, Sep 13, 2013 at 2:37 PM, Andre Naujoks <nautsch2@gmail.com> wrote:
> > To be able to use the hex ascii functions in case sensitive environments
> > the array hex_asc_upper[] and the needed functions for hex_byte_pack_upper()
> > are introduced.
> >
> > Signed-off-by: Andre Naujoks <nautsch2@gmail.com>
> > ---
> >  include/linux/kernel.h | 11 +++++++++++
> >  lib/hexdump.c          |  2 ++
> >  2 files changed, 13 insertions(+)
> >
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index 482ad2d..672ddc4 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -439,6 +439,17 @@ static inline char *hex_byte_pack(char *buf, u8 byte)
> >         return buf;
> >  }
> >
> > +extern const char hex_asc_upper[];
> > +#define hex_asc_upper_lo(x)    hex_asc_upper[((x) & 0x0f)]
> > +#define hex_asc_upper_hi(x)    hex_asc_upper[((x) & 0xf0) >> 4]
> Does using a macro instead of a real function (static inline)
> generates a better code?

Yes, a static inline would be nicer, but these are derived from
hex_asc_lo/hex_asc_hi.  If we change one we should change the other
and that becomes a separate cleanup.  So I think this patch is
OK as-is.

Also, it would make sense to get all the *hex* stuff out of kernel.h
and into a new header file (hexchar.h?).  They're a clean
self-contained thing and kernel.h is rather a dumping ground.

