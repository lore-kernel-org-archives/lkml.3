Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbaDVPPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:15:07 -0400
Received: from sym2.noone.org ([178.63.92.236]:43148 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932893AbaDVPPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:15:01 -0400
Date: Tue, 22 Apr 2014 17:14:58 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com, cltang@codesourcery.com
Subject: Re: [PATCH 06/28] nios2: Memory management
Message-ID: <20140422151458.GC1053@distanz.ch>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-5-git-send-email-lftan@altera.com>
 <20140422142443.GB15745@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422142443.GB15745@arch.cereza>
X-Editor: Vi IMproved 7.2
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-22 at 16:24:43 +0200, Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:
> Hi Ley Foon,
> 
> On Apr 18, Ley Foon Tan wrote:
> > +/*
> > + * PAGE_SHIFT determines the page size
> > + */
> > +#define PAGE_SHIFT	12
> > +#define PAGE_SIZE	4096
> > +#define PAGE_MASK	(~(PAGE_SIZE - 1))
> > +
> 
> How about something like this:
> 
> /* PAGE_SHIFT determines the page size */
> #define PAGE_SHIFT              12
> #define PAGE_SIZE               (_AC(1,UL) << PAGE_SHIFT)
> #define PAGE_MASK               (~((1 << PAGE_SHIFT) - 1))
> 
> Otherwise, the PAGE_SIZE macro above produces some warnings, IIRC.

AFAIR old nios2 GCC versions (the 4.1 version from Windriver, IIRC)
would complain about something like the above, that's the reason I added
an explicit value for PAGE_SIZE back then.

I assume with the new nios2 GCC this should no longer be necessary and
Ezequiel's fix should be fine.
