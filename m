Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3ITKIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 06:08:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43395 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754494Ab3ITKIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 06:08:18 -0400
Date: Fri, 20 Sep 2013 11:08:07 +0100
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Waiman Long <Waiman.Long@hp.com>
Subject: Re: [PATCH] lockref: use cmpxchg64 explicitly for lockless updates
Message-ID: <20130920100806.GA5015@mudshark.cambridge.arm.com>
References: <1379614006-3844-1-git-send-email-will.deacon@arm.com>
 <CA+55aFxuc3yD5pH2w5uEr_VDsEANvEiGCWA6tu1cSFrAiaU4Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxuc3yD5pH2w5uEr_VDsEANvEiGCWA6tu1cSFrAiaU4Ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 07:11:32PM +0100, Linus Torvalds wrote:
> On Thu, Sep 19, 2013 at 1:06 PM, Will Deacon <will.deacon@arm.com> wrote:
> > The cmpxchg() function tends not to support 64-bit arguments on 32-bit
> > architectures. This could be either due to use of unsigned long arguments
> > (like on ARM) or lack of instruction support (cmpxchgq on x86). However,
> > these architectures may implement a specific cmpxchg64() function to
> > provide 64-bit cmpxchg support instead
> 
> I'm certainly ok with this, but I wonder how much point there is to
> use the cmpxchg alternatives for 32-bit architectures at all...
> 
> From a performance standpoint, lockref really is expected to mainly
> help with big machines. Only insane people would do big machines with
> 32-bit kernels these days.

Our definitions of "big" machines probably differ significantly, but it
would be interesting to see if this *does* make a difference on some of the
multi-cluster ARMv7 hardware. Unfortunately, my development boards are all
I/O bound, so I'll need to leave a strategically placed crate of
non-poisoned beer next to the server guys' office...

> Of course, it may be that cmpxchg is actually faster on some
> architectures, but at least on x86-32, cmpxchg8b is traditionally
> quite slow.

On ARMv7, our double-word exclusives shouldn't be slower than the word
exclusives (hell, everything apart from the machine registers will be >=
64-bit).

> In other words, I'd actually like to see some numbers if there are
> loads where this actually helps and matters...

That's fair enough; I just saw the new lockref stuff, thought "that's a cool
hack" then looked at playing with it on ARM. I'll go see what this AIM7
thing is all about...

Cheers,

Will
