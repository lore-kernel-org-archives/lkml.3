Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbaJVTRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:17:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242AbaJVTRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:17:10 -0400
Date: Wed, 22 Oct 2014 15:16:43 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Paris <eparis@redhat.com>, Paulo Zanoni <przanoni@gmail.com>,
        linux-audit@redhat.com,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression: audit: x86: drop arch from __audit_syscall_entry()
 interface
Message-ID: <20141022191643.GU15532@madcap2.tricolour.ca>
References: <CA+gsUGSiXf2gpB8QQOQOmgxFc8mx31V6qeRqow6aXO1195jWEA@mail.gmail.com>
 <1414002190.30946.95.camel@localhost>
 <5447FF10.3060506@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5447FF10.3060506@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/22, Andy Lutomirski wrote:
> On 10/22/2014 11:23 AM, Eric Paris wrote:
> > That's really serious.  Looking now.
> > 
> > On Wed, 2014-10-22 at 16:08 -0200, Paulo Zanoni wrote:
> >> Hi
> >>
> >> (Cc'ing everybody mentioned in the original patch)
> >>
> >> I work for Intel, on our Linux Graphics driver - aka i915.ko - and our
> >> QA team recently reported a regression on:
> >>
> >> commit b4f0d3755c5e9cc86292d5fd78261903b4f23d4a
> >> Author: Richard Guy Briggs
> >> Date:   Tue Mar 4 10:38:06 2014 -0500
> >>     audit: x86: drop arch from __audit_syscall_entry() interface
> >>
> >> According to our QA, their i386 machine doesn't boot anymore. I tried
> >> to write my own revert for the patch, asked QA to test, and they
> >> confirmed it "solves" the problem.
> >>
> >> Here are the details of QA' s bug report:
> >> https://bugs.freedesktop.org/show_bug.cgi?id=85277 .
> >>
> >> The trees our QA tests are the development trees from i915.ko:
> >> http://cgit.freedesktop.org/drm-intel?h=drm-intel-fixes .
> >>
> >> I tried searching for other bug reports on the same patch, but
> >> couldn't find any. Forgive me if this bug was already reported.
> >>
> >> Feel free to continue this discussion on the bugzilla report if you want.
> 
> This piece:
> 
> 	movl %esi,4(%esp)		/* 5th arg: 4th syscall arg */
> 	movl %edx,(%esp)		/* 4th arg: 3rd syscall arg */
> 
> looks like it's overwriting syscall arguments.
> 
> This is clearly fixable, but an even better fix would be to drop the asm
> entirely and switch to two-phase tracing.  Want to do it?  I can test
> the seccomp bits if you switch over the asm :)

Like what you did for x86_64.  That sounds worth investigating.

I'll have a look at the asm, but I'm being distracted by a gunman loose
2km from me and my wife and kids under lockdown in two different
locations on the other side of the shooting site.  Had to cancel lunch
today with two work colleagues 1/2km away from that site.  ...not been a
productive day.

> --Andy

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
