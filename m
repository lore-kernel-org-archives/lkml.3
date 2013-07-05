Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab3GEGvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:51:18 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:38210 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3GEGvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:51:17 -0400
Date: Fri, 5 Jul 2013 08:51:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: scheduling while atomic & hang.
Message-ID: <20130705065113.GA6588@gmail.com>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <51D5BA25.9060207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D5BA25.9060207@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 07/03/2013 07:49 PM, Linus Torvalds wrote:
> >> [<ffffffff816f42bf>] __schedule+0x94f/0x9c0
> >> [<ffffffff816f487e>] schedule_user+0x2e/0x70
> >> [<ffffffff816f6de4>] retint_careful+0x12/0x2e
> 
> This call trace does indeed indicate that we took a hardware
> interrupt which caused a reschedule.  It doesn't necessarily have to
> be a quantum expiration interrupt, it could just as easily be an I/O
> completion interrupt.

Too bad the kernel stack frame at this point is so small [we are just 
before return to userspace], so we don't really get our usual trace of 
recent activities via the '?' entries ...

It would be nice to have a full-kernel-stack backtrace printout as an 
option, which prints entries 'above' the current RSP.

I've Cc:-ed Frederic, maybe he has interest in implementing that?

Thanks,

	Ingo
