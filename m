Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbaDVQ2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 12:28:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50347 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756130AbaDVQ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 12:28:24 -0400
Date: Tue, 22 Apr 2014 13:27:37 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Chung-Lin Tang <cltang@codesourcery.com>
Cc: Tobias Klauser <tklauser@distanz.ch>, Ley Foon Tan <lftan@altera.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com
Subject: Re: [PATCH 06/28] nios2: Memory management
Message-ID: <20140422162737.GA13859@arch.cereza>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-5-git-send-email-lftan@altera.com>
 <20140422142443.GB15745@arch.cereza>
 <20140422151458.GC1053@distanz.ch>
 <20140422153522.GF15745@arch.cereza>
 <5356924E.7020605@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5356924E.7020605@codesourcery.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 23, Chung-Lin Tang wrote:
> On 2014/4/22 下午 11:35, Ezequiel Garcia wrote:
> > On Apr 22, Tobias Klauser wrote:
> >> On 2014-04-22 at 16:24:43 +0200, Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:
> >>> Hi Ley Foon,
> >>>
> >>> On Apr 18, Ley Foon Tan wrote:
> >>>> +/*
> >>>> + * PAGE_SHIFT determines the page size
> >>>> + */
> >>>> +#define PAGE_SHIFT	12
> >>>> +#define PAGE_SIZE	4096
> >>>> +#define PAGE_MASK	(~(PAGE_SIZE - 1))
> >>>> +
> >>>
> >>> How about something like this:
> >>>
> >>> /* PAGE_SHIFT determines the page size */
> >>> #define PAGE_SHIFT              12
> >>> #define PAGE_SIZE               (_AC(1,UL) << PAGE_SHIFT)
> >>> #define PAGE_MASK               (~((1 << PAGE_SHIFT) - 1))
> >>>
> >>> Otherwise, the PAGE_SIZE macro above produces some warnings, IIRC.
> >>
> >> AFAIR old nios2 GCC versions (the 4.1 version from Windriver, IIRC)
> >> would complain about something like the above, that's the reason I added
> >> an explicit value for PAGE_SIZE back then.
> >>
> > 
> > Other than being "pretty" the above fix is to remove a mismatch type
> > warning. You can get rid of the warning in different ways:
> > 
> > ifdef __ASSEMBLY__
> > define PAGE_SIZE       4096
> > else
> > define PAGE_SIZE       4096UL
> > endif
> > 
> >> I assume with the new nios2 GCC this should no longer be necessary and
> >> Ezequiel's fix should be fine.
> > 
> > Speaking of GCC... is there a libc available to test this kernel port?
> > (which I assume uses the generic syscall ABI)
> 
> It's submitted to libc-alpha, also still review in progress.
> 

Do you plan to support uclibc?

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
