Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaHFDLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 23:11:45 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56455 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaHFDLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 23:11:44 -0400
Date: Tue, 5 Aug 2014 23:11:41 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Kees Cook <keescook@chromium.org>
cc: Rob Herring <robherring2@gmail.com>, wangnan0@huawei.com,
        Laura Abbott <lauraa@codeaurora.org>, peifeiyue@huawei.com,
        Liu Hua <sdu.liu@huawei.com>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Andrianov <vitalya@ti.com>, Rabin Vincent <rabin@rab.in>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, liusdu@126.co,
        Cyril Chemparathy <cyril@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/2] ARM : change fixmap mapping region to support 32
 CPUs
In-Reply-To: <CAGXu5j+ga5Enrsd8LuYarGh1Ozakmi3MNw+b9fZ7ubGUJFZY=w@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1408052302460.6061@knanqh.ubzr>
References: <1397559967-26050-1-git-send-email-sdu.liu@huawei.com> <1397559967-26050-3-git-send-email-sdu.liu@huawei.com> <CAL_JsqKE-L2PN3mXHNdTPMEyTMR9ZtbgGB=O_V6nOXN0YC0a4A@mail.gmail.com> <alpine.LFD.2.11.1405301441210.17310@knanqh.ubzr>
 <CAGXu5j+ga5Enrsd8LuYarGh1Ozakmi3MNw+b9fZ7ubGUJFZY=w@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2014, Kees Cook wrote:

> On Fri, May 30, 2014 at 12:25 PM, Nicolas Pitre
> <nicolas.pitre@linaro.org> wrote:
> > On Fri, 30 May 2014, Rob Herring wrote:
> >
> >> There's work in flight to support early_ioremap, early console, and RO
> >> text patching which all use the fixmap region.
> >>
> >> There's a couple of options to solve this:
> >>
> >> - Only support up to 16 cpus. It could be anywhere between 17-31, but
> >> that seems somewhat unlikely. Are we really ever going to see 32-bit
> >> 32 core systems?
> >
> > I wouldn't rule that out.  I've seen 16-core ARM chips in 2008 (although
> > they didn't go into production).  Silly limitations like that always
> > come back to bite you.  And we have better alternatives.
> >
> >> - Reduce KM_TYPE_NR from 16 to 15. Based on the comment for it, we
> >> probably don't want to do that. Is increasing it to the default of 20
> >> worthwhile? Some of the options here would allow doing that.
> >> - Add 0xffe00000-0xfff00000 to the fixmap region. This would make
> >> fixmap span 2 PMDs with the top PMD having a mixture of uses like we
> >> had before.
> >
> > That would be my preferred approach.  Note here it could be
> > 0xffe00000-0xfffe0000 to include the whole of the previous fixmap area
> > curently unused.
> >
> >> - push the PCI i/o space down to 0xfec00000 and make fixmap 4MB. This
> >> is a cleaner solution as the 2 PMDs are only used for fixmap. This may
> >> require some static mapping adjustments on some platforms.
> >
> > No need.  With the latest changes, the fixmap area is between 0xffc00000
> > and 0xffe00000 (there is apparently a mistake in
> > Documentation/arm/memory.txt).  So currently 0xff000000-0xffc00000 is
> > free, which makes the fixmap area far away from the PCI i/o area with
> > plenti of space in between.
> 
> So, it seems there is something wrong with this patch series. I had to
> revert "ARM: 8031/2: change fixmap mapping region to support 32 CPUs"
> to make other fixmap changes work correctly. I think this is due to
> the non-highmem config case moving the fixmap to a location where
> there is to page table entry...

Could you elaborate please?  How can the non-highmem config move the 
fixmap area?  And what are those other fixmap changes?


Nicolas
