Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaFXM1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:27:45 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:52581 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752186AbaFXM1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:27:42 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Tue, 24 Jun 2014 13:27:37 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
Message-ID: <20140624122737.GF17674@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Thomas Meyer <thomas@m3y3r.de>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFxdAhp-esuGiY4VEugiiwcMJgg1r6fPiR9Fb+HOz_5tLg@mail.gmail.com>
 <1403564870.3091.6.camel@localhost.localdomain>
 <871tuea7nz.fsf@intel.com>
 <20140624115753.GD17674@nuc-i3427.alporthouse.com>
 <1403612670.3091.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403612670.3091.10.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 02:24:30PM +0200, Thomas Meyer wrote:
> Am Dienstag, den 24.06.2014, 12:57 +0100 schrieb Chris Wilson:
> > On Tue, Jun 24, 2014 at 02:06:24PM +0300, Jani Nikula wrote:
> > > On Tue, 24 Jun 2014, Thomas Meyer <thomas@m3y3r.de> wrote:
> > > > the i915 driver is still broken in 3.16-rc2. Resume from ram crashes the
> > > > X server.
> > > 
> > > This is not new to 3.16-rc2; apparently we've had it since v3.15-rc4
> > > [1]. Also related [2].
> > > 
> > > Chris, any fresh ideas?
> > 
> > Nope. The bug is https://bugs.freedesktop.org/show_bug.cgi?id=76554
> > everything we know and have tried is there. Which is not much more than
> > at time of the original incarnation:
> > 
> > commit 50aa253d820ad4577e2231202f2c8fd89f9dc4e6
> > Author: Keith Packard <keithp@keithp.com>
> > Date:   Tue Oct 14 17:20:35 2008 -0700
> > 
> >     i915: Fix up ring initialization to cover G45 oddities
> >     
> >     G45 appears quite sensitive to ring initialization register writes,
> >     sometimes leaving the HEAD register with the START register contents. Check
> >     to make sure HEAD is reset correctly when START is written, and fix it up,
> >     screaming loudly.
> > -Chris
> > 
> 
> Hi,
> 
> so why not revert 78f2975eec9faff353a6194e854d3d39907bab68 (drm/i915:
> Move all ring resets before setting the HWS page) ?

Because that patch was in response to a boot time regression.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
