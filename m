Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3ITTTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 15:19:01 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:48113 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab3ITTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 15:18:58 -0400
Date: Fri, 20 Sep 2013 12:18:50 -0700
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k <linux-m68k@vger.kernel.org>, kexec@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Preliminary kexec support for Linux/m68k
Message-ID: <20130920191850.GA23335@verge.net.au>
References: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
 <20130919210750.GH2918@verge.net.au>
 <CAMuHMdVx3KmL9cK-_g3qcrkHxxCAno+3z4O=kVTOGCYhD_WmWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVx3KmL9cK-_g3qcrkHxxCAno+3z4O=kVTOGCYhD_WmWw@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 09:15:02AM +0200, Geert Uytterhoeven wrote:
> Hi Simon,
> 
> Thanks for your comments!
> 
> On Thu, Sep 19, 2013 at 11:07 PM, Simon Horman <horms@verge.net.au> wrote:
> > Pasting two series in one was a bit confusing for me at first.
> > Perhaps you could consider posting two separate series in future.
> 
> Sorry, I wanted to have all information in one series for the first posting, to
> avoid people having to look around too much if they want to give it a try.
> 
> I'll post seperate series in the future.

Thanks.

> >> Patches:
> >>   - [PATCH 1/2] kexec: Let slurp_file_len() return the number of bytes
> >>   - [PATCH 2/2] kexec: Add preliminary m68k support
> >>
> >> Notes:
> >>   - Based on git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git
> >
> > A good choice.
> 
> Is it normal I don't see much activity there?

Yes, that is normal.

> 
> >>   - The ramdisk is loaded at the top of memory minus 4096, unlike with
> >>     m68boot (ataboot/amiboot), as locate_hole() seems to have a bug that it
> >>     cannot reserve a block at the real top of memory.
> >
> > Is this a bug that could be fixed?
> 
> Possibly. I suspect an off-by-one bug somewhere, but I haven't looked deeply
> into it.

My feeling is that if possible it would be better to fix the bug than add a
work-around.

> >>   - Do we want to check the struct bootversion at the start of the kernel,
> >>     like m68kboot does?
> >>     Kexec may be used to load ELF files that are not Linux kernel images,
> >>     and thus don't have a Linux-specific struct bootversion.
> >
> > If the check can sanely be skipped for non Linux kernel images then
> > this sounds like a reasonable idea to me. Otherwise I would lean towards
> > omitting it. Either way, I don't feel strongly about this.
> >
> >>   - Do we want to check the size of the kernel image + bootinfo, and warn the
> >>     user if it's larger than 4 MiB?
> >>     This is a limitation of the current Linux/m68k kernel only.
> >
> > I think that sounds like a good idea but I don't feel strongly about it.
> 
> Currently I'm leaning towards just printing a warning for both
> (missing/incompatible
> bootversion and image-too-large).

That sounds fine to me.
