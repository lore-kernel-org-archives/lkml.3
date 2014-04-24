Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbaDXPXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:23:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39770 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758125AbaDXPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:23:08 -0400
Date: Thu, 24 Apr 2014 12:22:32 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Subject: Re: [PATCH 08/28] nios2: MMU Fault handling
Message-ID: <20140424152232.GD1735@arch.cereza>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-6-git-send-email-lftan@altera.com>
 <20140422143036.GD15745@arch.cereza>
 <CAFiDJ59KHkh549PBezijr-UektFQtQaZ_5fP5qqRvsVC-e2uxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFiDJ59KHkh549PBezijr-UektFQtQaZ_5fP5qqRvsVC-e2uxw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 24, Ley Foon Tan wrote:
> On Tue, Apr 22, 2014 at 10:30 PM, Ezequiel Garcia
> <ezequiel.garcia@free-electrons.com> wrote:
> > Hello Ley Foon,
> >
> > On Apr 18, Ley Foon Tan wrote:
> >> +
> >> +bad_area_nosemaphore:
> >> +     /* User mode accesses just cause a SIGSEGV */
> >> +     if (user_mode(regs)) {
> >
> > I found that it's useful to add some printing here, just as ARM
> > does. I carry this patch on my kernel:
> >
> > +               printk(KERN_INFO "%s: unhandled page fault (%d) at 0x%08lx, cause %ld\n",
> > +                      current->comm, SIGSEGV, address, cause);
> > +               show_regs(regs);
> >
> > Do you think we could do something like it? Maybe with a compile time option?
> Yes, this is useful debug message. I can add this.
> Prefer not to add new compile time option, I think this shouldn't
> happen frequently.

No, it shouldn't happen frequently. You can take a look at what ARM does.
They use a DEBUG_USER compile-time option, much more complex than my silly
proposal.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
