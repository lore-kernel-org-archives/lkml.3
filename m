Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab3J2RyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 13:54:02 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:62994 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab3J2RyA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 13:54:00 -0400
Date: Tue, 29 Oct 2013 18:53:54 +0100
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, mmarek@suse.cz,
        akpm@linux-foundation.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: Re: [PATCH] scripts/kconfig/menu.c: warning: jump may be used
 uninitialized in this function
Message-ID: <20131029175354.GB3411@free.fr>
References: <alpine.DEB.2.11.1310271822540.31521@trent.utfs.org>
 <alpine.DEB.2.11.1310271859320.31521@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.11.1310271859320.31521@trent.utfs.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian, All,

On 2013-10-27 19:02 -0700, Christian Kujau spake thusly:
> On Sun, 27 Oct 2013 at 18:28, Christian Kujau wrote:
> > While doing "make oldconfig" on 3.12-rc7 with gcc-4.7.2 (Debian), the 
> > following warning is printed:
> > 
> >   HOSTCC  scripts/kconfig/zconf.tab.o
> > In file included from scripts/kconfig/zconf.tab.c:2537:0:
> > /usr/local/src/linux-git/scripts/kconfig/menu.c: In function ‘get_symbol_str’:
> > /usr/local/src/linux-git/scripts/kconfig/menu.c:586:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> > /usr/local/src/linux-git/scripts/kconfig/menu.c:547:19: note: ‘jump’ was declared here
> 
> Grrr, only after I sent this message I found this was reported in 
> September already by Madhavan Srinivasan:  https://lkml.org/lkml/2013/9/19/24
> 
> Does anybody know the state of this fix?

The solution was to properly comment that this was a gcc issue, in that 
this is a spurious error, does not appear in previous gcc versions, and
has been fixed in later gcc versions.

Setting 'jump' to NULL may hide reall issues in case the code is changed
in the future, so it is not appropriate a fix. Hence why the previously-
submitted patches were not applied.

I'll take this on me to properly fix this. Thanks for the heads up.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
