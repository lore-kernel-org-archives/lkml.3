Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3KKLfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:35:14 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:45145 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3KKLfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:35:06 -0500
Date: Mon, 11 Nov 2013 12:35:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Corrupted low memory in v3.9+
Message-ID: <20131111113503.GA16090@gmail.com>
References: <CAOesGMgV2UsBffPveaE+j1s-mDZ+cQvvQGLGAXjWSAv+a_56Fw@mail.gmail.com>
 <52603CD6.6080507@linux.intel.com>
 <CAOesGMjgvPWpZssrepDszTr0EexHtDXznWA4XYoZ6O_U=XJGAg@mail.gmail.com>
 <CAOesGMgiUbJF01+BPBDgJT3J-Sn6ewE04aMyCTYrwjKwY4S2SQ@mail.gmail.com>
 <527BEA91.6050603@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527BEA91.6050603@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> On 11/07/2013 11:02 AM, Olof Johansson wrote:
> >> [    0.000000] reserving inaccessible SNB gfx pages
> >> [    0.000000] memblock_reserve: [0x00000000000000-0x00000000100000]
> 
> This is on a Sandy Bridge system, which I guess I managed to miss the 
> first time.  Unfortunately low memory corruption is expected with SNB 
> graphics... this is why we unconditionally reserve all low memory on 
> SNB.
> 
> >> setup_arch+0xa2d/0xa41
> >> [...]
> >>
> >> Unfortunately x86 doesn't keep the memblock structures around, so 
> >> there's no way to verify after booting in debugfs, but based on the 
> >> above it should have been reserved properly.
> > 
> > *prod*
> > 
> > So, got a preference on solution for this? The warning seems harmless 
> > but still annoying to get used to ignoring false positives, etc.
> > 
> > Disable the low memory checker by default? Hide it behind a debug 
> > option (runtime or build time)?
> 
> I'm inclined to say disable it by default, but I'll let Ingo comment. 
> These days we default to reserving all of low memory other than the 
> trampoline (which we really can't avoid); leaving it in as a debug 
> option seems reasonable, but it is really questionable to me how much it 
> is useful to a general user.

If we reserve everything in low memory, all the time (which I very much 
argue we should do) then the checker becomes a no-op and can be removed.

Thanks,

	Ingo
