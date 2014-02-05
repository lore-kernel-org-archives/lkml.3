Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbaBEIYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 03:24:25 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:55906 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaBEIYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 03:24:24 -0500
Date: Wed, 5 Feb 2014 09:24:04 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [3.14-rc1] cirrus driver problem (qemu)
Message-ID: <20140205082404.GC12991@kria>
References: <20140203153413.GA12991@kria>
 <CAPM=9twWniCmKNb1vxjS_PbsTqimX6EWVusA_+GZ7H9fdhQj3A@mail.gmail.com>
 <20140204225340.GB12991@kria>
 <CAPM=9txmSVnCVDZ6ni8GfqGSQqJkyuVb3PLf4dtYB0b4FdpraQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPM=9txmSVnCVDZ6ni8GfqGSQqJkyuVb3PLf4dtYB0b4FdpraQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-05, 14:50:18 +1000, Dave Airlie wrote:
> On Wed, Feb 5, 2014 at 8:53 AM, Sabrina Dubroca <sd@queasysnail.net> wrote:
> > 2014-02-04, 13:20:54 +1000, Dave Airlie wrote:
> >> On Tue, Feb 4, 2014 at 1:34 AM, Sabrina Dubroca <sd@queasysnail.net> wrote:
> >> > When I boot 3.14-rc1 in qemu, I get the trace below. The console stops
> >> > updating and I don't get a login prompt. I can login, but I can't see
> >> > what I'm doing. I can login normally via SSH.
> >> >
> >> > If I revert the last commit in drivers/gpu/drm/cirrus:
> >> >
> >> > f4b4718b61d1d5a7442a4fd6863ea80c3a10e508 drm: ast,cirrus,mgag200: use drm_can_sleep
> >> >
> >> > the problem is solved.
> >> >
> >>
> >> Hi does the attach patch fix it?
> >>
> >> Dave.
> >
> >
> > Same problem. Didn't you reverse the logic on in_interrupt, compared
> > to the old "if (!in_interrupt())" ? It looks like drm_can_sleep() is
> > false when in_interrupt() is true.
> >
> > I modified your patch as below. Display doesn't freeze, but I still
> > get the warning.
> 
> Oh wow I totally screwed up there, you are right, logic inversion.
> 
> Can you try the attached?
> 
> without the in_interrupt addition.
> 
> Dave.

It works, thanks!
No freeze, no warning.

Sabrina
