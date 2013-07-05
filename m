Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab3GEHTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 03:19:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47641 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab3GEHTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 03:19:07 -0400
Date: Fri, 5 Jul 2013 09:19:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: scheduling while atomic & hang.
Message-ID: <20130705071901.GB24783@somewhere.redhat.com>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <51D5BA25.9060207@zytor.com>
 <20130705065113.GA6588@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130705065113.GA6588@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 08:51:13AM +0200, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 07/03/2013 07:49 PM, Linus Torvalds wrote:
> > >> [<ffffffff816f42bf>] __schedule+0x94f/0x9c0
> > >> [<ffffffff816f487e>] schedule_user+0x2e/0x70
> > >> [<ffffffff816f6de4>] retint_careful+0x12/0x2e
> > 
> > This call trace does indeed indicate that we took a hardware
> > interrupt which caused a reschedule.  It doesn't necessarily have to
> > be a quantum expiration interrupt, it could just as easily be an I/O
> > completion interrupt.
> 
> Too bad the kernel stack frame at this point is so small [we are just 
> before return to userspace], so we don't really get our usual trace of 
> recent activities via the '?' entries ...
> 
> It would be nice to have a full-kernel-stack backtrace printout as an 
> option, which prints entries 'above' the current RSP.
> 
> I've Cc:-ed Frederic, maybe he has interest in implementing that?

Yeah that sounds interesting. I may give it a try.

Thanks.
