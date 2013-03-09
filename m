Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196Ab3CIBWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 20:22:05 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54992 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3CIBWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 20:22:03 -0500
Date: Fri, 8 Mar 2013 17:18:10 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
Message-ID: <20130309011809.GA4028@lizard.sbx05280.losalca.wayport.net>
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com>
 <20130227231826.GA30154@lizard.fhda.edu>
 <CAP=VYLqg5Q_e4y6bD9x8idOvJx2n_knzujOY9Z0VyGDEQZTzag@mail.gmail.com>
 <20130228013514.GA7556@lizard.fhda.edu>
 <CAP=VYLoNV16xJtQGtmnC6TejaBRjBz5x=+Lhu7Yzm7q9UZ20AA@mail.gmail.com>
 <20130228025931.GA13764@lizard.gateway.2wire.net>
 <513A1411.7060403@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <513A1411.7060403@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Fri, Mar 08, 2013 at 11:38:41AM -0500, Paul Gortmaker wrote:
> > I see. In that case, please feel free to send the patch to akpm with my
> > Nack and pointing to this discussion. If Andrew agrees and I was wrong
> > (and I'm really curious whether I am right or wrong), I will start
> > applying such patches in future.
> 
> I didn't send the patch to akpm, but I did have a chance to ask akpm how
> dependencies should be used, and you can see his answer here:
> 
> 	https://lkml.org/lkml/2013/3/7/456

Thanks for asking! FWIW, I won't be against CONFIG_AKPM. ;-) Something
like that will work:

	depends on GENERIC_HARDIRQS
	depends on RESTRICT_PLATFORM && GOLDFISH

But not that I think we really need this option, though. Whoever wants to
(re)build the kernel is assumed to be knowledgeable enough to figure out
what needed/unneeded for the given HW. I, for example, use 'ARCH=foo
allnoconfig' for stripped kernels, and then enable specific options which
I know I will need. Distros, however, they are using kind of
'allmodconfig' anyways:

	~$ du -sh /lib/modules/3.8.0-28-desktop/
	148M    /lib/modules/3.8.0-28-desktop/

One module less, one module more does not matter, but maintaining
CONFIG_AKPM will cost devs' time and efforts (especially figuring out what
is platform dep and what is not... I think it is easier to just keep
things simple.

But again, I won't be against it -- at least it doesn't make my life
harder. :-)

Cheers,

Anton
