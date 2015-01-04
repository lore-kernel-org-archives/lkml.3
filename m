Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbbADUp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:45:26 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:44098 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbADUpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:45:25 -0500
Date: Sun, 4 Jan 2015 15:45:22 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1501041526390.18844@knanqh.ubzr>
References: <20150104190123.GA20153@amd> <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr> <CA+55aFxMbicJZXzzHc8=vdwCzhz4kdrmZEKjLadZXr7aySZ4zg@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2015, Linus Torvalds wrote:

> On Sun, Jan 4, 2015 at 12:03 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> >
> > NAK.
> 
> To quote the standard response for people who ignore regressions:
> 
>   "SHUT THE FUCK UP"
> 
> you cannot NAK regression fixes. Seriously.
> 
> I don't understand how people can't get this simple thing.

OK, let's look at the issue more deeply then.

We're talking about exporting a bogomips entry via /proc/cpuinfo.

On ARM the calibration loop is no longer performed because udelay() is 
based on a hardware counter these days.  Why? because the calibration 
was completely unreliable in the presence of CPU frequency scaling, and 
other modern hardware niceties.  

Still, for a while, we did export the calibration loop value for 
/proc/cpuinfo's sake.  Yet people complained because the exported value 
was "wrong".  Of course it is wrong as it is just impossible to get 
"right", unless you have antique hardware that is.

> No regressions. If user mode breaks, it is absolutely *never*
> acceptable to blame user mode.
> 
> Occasionally there may be major overriding reasons (security issue,
> whatever), but even then we bend over *backwards* trying to make sure
> breakage is minimal.

I'm all for ensuring breakage is minimal.  That'd imply settling on a 
good phony bogomips value that is no more broken than the real one was 
when it was exported.

> Christ people. Why does this even have to be discussed any more?

Because we're discussing a choice between two evils.  The actual 
regression happened when people upgraded their antique hardware and 
expected the bogomips to still work with new hardware.  Even if the 
$subject commit is reverted, that won't solve the wrong bogomips problem 
and different people will start complaining again.

As I mentioned earlier, putting the entry back is not a problem if we 
may find the best phony number to go along with it.


Nicolas
