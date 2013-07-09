Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab3GIK0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:26:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab3GIK0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:26:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAMuHMdX0aP7jm=2vAO=Mg9b-RggynRq+BosvzGfqSRtnyue4+w@mail.gmail.com>
References: <CAMuHMdX0aP7jm=2vAO=Mg9b-RggynRq+BosvzGfqSRtnyue4+w@mail.gmail.com> <1368850897.18069.255@driftwood>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: dhowells@redhat.com, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>, linux-net@vger.kernel.org
Subject: Re: 3.10-rc1: commit ccdfcc398594 broke uClibc build.
Date: Tue, 09 Jul 2013 11:25:53 +0100
Message-ID: <6325.1373365553@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> The #include <linux/kernel.h> added to include/uapi/linux/netlink.h causes
> the uClibc build to go:
>
> In file included from include/linux/kernel.h:4,
>                  from include/linux/netlink.h:4,
>                  from include/linux/rtnetlink.h:5,
>                  from libc/inet/netlinkaccess.h:27,
>                  from libc/inet/if_index.c:37:
> > include/linux/sysinfo.h:8: error: expected specifier-qualifier-list before
> > '__kernel_long_t'
> > make: *** [libc/inet/if_index.o] Error 1
> >
> > If I comment out that line, it builds fine. The kernel builds (for my
> > config) either way.

Comment out which line?  Line 8 of include/linux/sysinfo.h or the new #include
line?

Also, what arch are you compiling for?

David
