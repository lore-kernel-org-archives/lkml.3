Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3IJVPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:15:01 -0400
Received: from imap.thunk.org ([74.207.234.97]:57868 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab3IJVO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:14:59 -0400
Date: Tue, 10 Sep 2013 17:14:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130910211454.GJ29237@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net
References: <10005394.BRCyBMYWy3@tauon>
 <20130910150419.GA29237@thunk.org>
 <CAMuHMdXcXGpgE5ArcjNU-RgAr52qB8ih_b48jwR=+OqK4RDhFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXcXGpgE5ArcjNU-RgAr52qB8ih_b48jwR=+OqK4RDhFA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:48:00PM +0200, Geert Uytterhoeven wrote:
> 
> So the first importance for random_get_fast_cycles() is that it needs to
> be fast. What's most important next: number of bits or high-frequency?

High-frequency.  For example MIPS has a register which is bumped at
every clock tick, modulo the number of lines in the TLB.  That's what
we're probably going to end up using for MIPS, on the assumption that
the time between interrupts is not likely going to be related to the
number of lines in the TLB.  :-)

Something like jiffies has lots of bits, but since it's updated at a
much slower rate, it's not as useful if we are trying to measure
uncertainity based on the interrupt time.  (Worse yet, depending on
how the architecture handles the clock, there mgiht be a very high
correlation between when the jiffies counter gets incremented and the
timer interrupt....)

And yes, we will need to make sure this gets well documented in the
sources when we introduce random_get_fast_cycles()....

Cheers,

						- Ted
