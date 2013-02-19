Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934204Ab3BSUvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:51:47 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:60777 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934167Ab3BSUvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:51:46 -0500
Date: Tue, 19 Feb 2013 12:52:17 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Li <lkml@chrisli.org>
Cc: linux-kernel@vger.kernel.org, robert.moore@intel.com, feng.tang@intel.com,
        len.brown@intel.com, daniel.vetter@ffwll.ch,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: i915 black screen introduced by ACPI changes
Message-ID: <20130219125217.6b6f55ff@jbarnes-desktop>
In-Reply-To: <CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
	<20130219100849.72d2330b@jbarnes-desktop>
	<CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013 12:18:45 -0800
Chris Li <lkml@chrisli.org> wrote:
> Secondly, the one clue is that, setting "i915.modeset=0" alone will allow
> the kernel to boot into X GUI login. It seems that the mode switch alone in
> i915 can trigger the black screen. It is consistent with kernel lockup when I
> logout of X desktop, where X want to reset the screen.
> 
> Instead of guess which driver were at fault, can you suggest some experiment
> to confirm or denial which driver is at fault?

Well it definitely sounds i915 related.  I was just thinking that if
certain bits were routed to the nvidia chip instead of the i915 one,
the i915 driver may get confused and panic.

For debugging, you could modify the modeset_init function in i915_dma.c
and make it return early with an error.  You could use that to narrow
down which part of init was failing.

-- 
Jesse Barnes, Intel Open Source Technology Center
