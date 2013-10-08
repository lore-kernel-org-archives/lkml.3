Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3JHDfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 23:35:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:47458 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab3JHDfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 23:35:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1054,1371106800"; 
   d="scan'208";a="406978746"
Date: Tue, 8 Oct 2013 11:35:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131008033518.GA9401@localhost>
References: <20131007051038.GA9764@localhost>
 <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
 <20131007083505.GA22585@localhost>
 <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
 <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
 <20131008020918.GA1220@localhost>
 <20131008021452.GA6456@localhost>
 <CA+55aFwrovZf-LYa=_SyMNvqQkTfxREm0YuzDk8wJy+Krs0xzw@mail.gmail.com>
 <20131008031152.GA8218@localhost>
 <CA+55aFwBVx0D=7b4+-PgnZ+uEBW9suNF8e-QCegme375N5yyYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwBVx0D=7b4+-PgnZ+uEBW9suNF8e-QCegme375N5yyYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 08:29:26PM -0700, Linus Torvalds wrote:
> On Mon, Oct 7, 2013 at 8:11 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >
> > Yeah, I see no timer usage in parport_pc driver, so it's still questionable.
> 
> The timer itself comes simply from the delayed_work that is used to
> delay the freeing of the kobject.
> 
> So that is not the surprising part.

OK.

> The surprising part is that I don't see parport_pc doing anything
> odd/bad with its kobject embedded in the 'struct dev'. It seems to
> just do a platform_device_register_simple() followed by a
> platform_device_unregister().
> 
> At least that's true for the normal parport_pc_probe_port() case that
> just passes in a NULL dev... But I only glanced at the driver, so I
> might have missed something.
> 
> > with some manual bisects, I find a good config (attached) that can
> > reliably boot the kernel up.
> >
> > Based on that config, I tried adding parport_pc and see that it still
> > boots fine.
> >
> > Adding drm, however will bring back the oops. Will try a kernel based
> > on the original kconfig with drm disabled only.

FYI I just confirmed that the original bad kconfig can be made
bootable by simply disabling CONFIG_DRM.

> Ok. The list corruption (which also pointed at parport_pc) might well
> be corrupted by removing the entries before or after the parport_pc,
> and moving the corruption to parport_pc that way (through the
> "prev->next = next" thing in list handling). So maybe it was something
> else all along. You could enable CONFIG_DEBUG_LIST to see if that
> triggers some dump earlier..

OK, I'll try enabling CONFIG_DEBUG_LIST.

Thanks,
Fengguang
