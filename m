Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaAGQhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:37:17 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53019 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751515AbaAGQhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:37:11 -0500
Date: Tue, 7 Jan 2014 16:36:29 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        sahara <keun-o.park@windriver.com>, Keun-O Park <kpark3469@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available
 for ARM_UNWIND
Message-ID: <20140107163629.GC3350@e103592.cambridge.arm.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <201401071533.35309.arnd@arndb.de>
 <20140107144130.GJ27432@n2100.arm.linux.org.uk>
 <4325142.7drL5ndxN9@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4325142.7drL5ndxN9@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 03:48:25PM +0000, Arnd Bergmann wrote:
> On Tuesday 07 January 2014 14:41:30 Russell King - ARM Linux wrote:
> > On Tue, Jan 07, 2014 at 03:33:34PM +0100, Arnd Bergmann wrote:
> > > 
> > > 
> > > It's been almost a year since we last discussed the patches that were
> > > posted by Dave and sahara, but nothing has changed in the mainline kernel.
> > > 
> > > Any chance that someone could be motivated to pick this work up again
> > > and finally fix return_address().
> > 
> > I thought that we had _actively_ decided that we would not use the
> > unwinder for these paths - that it was too expensive for these paths,
> > and you had to use frame pointers instead.
> 
> I don't remember that discussion, but it may well be. What does
> that mean for the #warning in return_address.c then? Can we
> just use the frame pointer version based on CONFIG_FRAME_POINTER
> and ignore whether CONFIG_ARM_UNWIND is set as the patch below,
> or did I misunderstand?

For an ARM kernel this may work, but I thought that for THUMB2_KERNEL
there just isn't usable a framepointer at all.

If so, the only choices are to use the unwinder and accept the cost, or
to decide that return_address() will never work without
CONFIG_FRAMEPOINTER and remove the build-time warning.


My other concern was that we might end up in a recursive trace due to
the use of non-notrace core functions in the unwinder.  But I seem to
remember Steve Rostedt saying the the tracer guards against recursive
invocation nowadays -- if so, that shouldn't be a problem.

Cheers
---Dave
