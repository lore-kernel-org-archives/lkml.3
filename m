Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaDVQYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:24:48 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:53065 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171AbaDVQYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:24:45 -0400
Date: Tue, 22 Apr 2014 18:24:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Tobias Klauser <tklauser@distanz.ch>, Ley Foon Tan <lftan@altera.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH 06/28] nios2: Memory management
Message-ID: <20140422162432.GA17674@ravnborg.org>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-5-git-send-email-lftan@altera.com>
 <20140422142443.GB15745@arch.cereza>
 <20140422151458.GC1053@distanz.ch>
 <20140422153522.GF15745@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422153522.GF15745@arch.cereza>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 12:35:22PM -0300, Ezequiel Garcia wrote:
> On Apr 22, Tobias Klauser wrote:
> > On 2014-04-22 at 16:24:43 +0200, Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:
> > > Hi Ley Foon,
> > > 
> > > On Apr 18, Ley Foon Tan wrote:
> > > > +/*
> > > > + * PAGE_SHIFT determines the page size
> > > > + */
> > > > +#define PAGE_SHIFT	12
> > > > +#define PAGE_SIZE	4096
> > > > +#define PAGE_MASK	(~(PAGE_SIZE - 1))
> > > > +
> > > 
> > > How about something like this:
> > > 
> > > /* PAGE_SHIFT determines the page size */
> > > #define PAGE_SHIFT              12
> > > #define PAGE_SIZE               (_AC(1,UL) << PAGE_SHIFT)
> > > #define PAGE_MASK               (~((1 << PAGE_SHIFT) - 1))
> > > 
> > > Otherwise, the PAGE_SIZE macro above produces some warnings, IIRC.
> > 
> > AFAIR old nios2 GCC versions (the 4.1 version from Windriver, IIRC)
> > would complain about something like the above, that's the reason I added
> > an explicit value for PAGE_SIZE back then.
> > 
> 
> Other than being "pretty" the above fix is to remove a mismatch type
> warning. You can get rid of the warning in different ways:
> 
> ifdef __ASSEMBLY__
> define PAGE_SIZE       4096
> else
> define PAGE_SIZE       4096UL
> endif

The usual way to do this is as follows:
#include <linux/const.h>

#define PAGE_SHIFT   12
#define PAGE_SIZE    (_AC(1, UL) << PAGE_SHIFT)
#define PAGE_MASK    (~(PAGE_SIZE-1))

_AC(1, UL) expands to 1 for assembler and 1UL for C code.

This is also what was suggested above.

Please follow this scheme for nios2 too.

	Sam
