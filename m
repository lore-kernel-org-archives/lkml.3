Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbbAEMdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:33:06 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55292 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbbAEMdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:33:03 -0500
Date: Mon, 5 Jan 2015 12:32:52 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150105123252.GB10116@arm.com>
References: <20150104190123.GA20153@amd>
 <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <20150104201026.GA23427@amd>
 <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
 <20150104203724.GA16372@amd>
 <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
 <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
 <20150104212659.GC12302@n2100.arm.linux.org.uk>
 <20150105013436.GA23350@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150105013436.GA23350@thunk.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Mon, Jan 05, 2015 at 01:34:36AM +0000, Theodore Ts'o wrote:
> On Sun, Jan 04, 2015 at 09:26:59PM +0000, Russell King - ARM Linux wrote:
> > 
> > With the revert in place, we now have insanely small bogomips values
> > reported via /proc/cpuinfo when hardware timers are used.  That needs
> > fixing.
> 
> Why does it need to be fixed?
> 
> It's clear that there are applications that are working OK with the
> existing value,

I'm not sure it is that clear -- the reported regression was on a processor
that doesn't use the timer-backed delay loop, so the bogomips value will
essentially be restored by reverting the patch.

The issue comes on newer CPUs, where there will now be a very small bogomips
value reported and (to my knowledge) nobody has yet tried running some
affected applications there to see if they can cope.

> and if you change it to fix it for some new applications, but it breaks
> for others, then have you considered defining a new interface (perhaps
> exported via sysfs) that exports a "sane" value and document that new
> applications shoud use the new interface.
> 
> Or if the answer is that no one should be using the bogomips field at
> all, then just document *that*, and then leave it be, so that existing
> applications don't break.

It never hurts to document our assumptions or anticipated/preferred use-cases
but in this case I think bogomips is difficult enough to use on any
half-recent SoCs that most developers have either (a) found another way to
do what they want (perf counters, clock_gettime) or (b) stopped bothering to
guess the CPU frequency when it's not actually needed, so I don't *think*
that new applications are such an issue.

Cheers,

Will
