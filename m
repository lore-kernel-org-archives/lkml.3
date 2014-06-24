Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaFXMYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:24:34 -0400
Received: from www17.your-server.de ([213.133.104.17]:46347 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaFXMYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:24:33 -0400
Message-ID: <1403612670.3091.10.camel@localhost.localdomain>
Subject: Re: [Intel-gfx] Linux 3.16-rc2
From: Thomas Meyer <thomas@m3y3r.de>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jun 2014 14:24:30 +0200
In-Reply-To: <20140624115753.GD17674@nuc-i3427.alporthouse.com>
References: <CA+55aFxdAhp-esuGiY4VEugiiwcMJgg1r6fPiR9Fb+HOz_5tLg@mail.gmail.com>
	 <1403564870.3091.6.camel@localhost.localdomain> <871tuea7nz.fsf@intel.com>
	 <20140624115753.GD17674@nuc-i3427.alporthouse.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 24.06.2014, 12:57 +0100 schrieb Chris Wilson:
> On Tue, Jun 24, 2014 at 02:06:24PM +0300, Jani Nikula wrote:
> > On Tue, 24 Jun 2014, Thomas Meyer <thomas@m3y3r.de> wrote:
> > > the i915 driver is still broken in 3.16-rc2. Resume from ram crashes the
> > > X server.
> > 
> > This is not new to 3.16-rc2; apparently we've had it since v3.15-rc4
> > [1]. Also related [2].
> > 
> > Chris, any fresh ideas?
> 
> Nope. The bug is https://bugs.freedesktop.org/show_bug.cgi?id=76554
> everything we know and have tried is there. Which is not much more than
> at time of the original incarnation:
> 
> commit 50aa253d820ad4577e2231202f2c8fd89f9dc4e6
> Author: Keith Packard <keithp@keithp.com>
> Date:   Tue Oct 14 17:20:35 2008 -0700
> 
>     i915: Fix up ring initialization to cover G45 oddities
>     
>     G45 appears quite sensitive to ring initialization register writes,
>     sometimes leaving the HEAD register with the START register contents. Check
>     to make sure HEAD is reset correctly when START is written, and fix it up,
>     screaming loudly.
> -Chris
> 

Hi,

so why not revert 78f2975eec9faff353a6194e854d3d39907bab68 (drm/i915:
Move all ring resets before setting the HWS page) ?

Without this commit 3.15 is super stable for me. This seems to be also
true for others according to above bug report.

thomas

