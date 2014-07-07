Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaGGUGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:06:53 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60281 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaGGUGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:06:51 -0400
Date: Mon, 7 Jul 2014 22:06:59 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Vetter <daniel@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Imre Deak <imre.deak@intel.com>
Subject: Re: linux-next: Tree for Jun 19 (drm/i915)
Message-ID: <20140707200659.GL5821@phenom.ffwll.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	"Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
	linux-kernel@vger.kernel.org,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	Imre Deak <imre.deak@intel.com>
References: <20140619161632.58b442e4@canb.auug.org.au>
 <9626816.NOau5dZfmB@vostro.rjw.lan>
 <20140707145423.GB5821@phenom.ffwll.local>
 <16952236.GFHaOHoKy4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16952236.GFHaOHoKy4@vostro.rjw.lan>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 10:01:27PM +0200, Rafael J. Wysocki wrote:
> On Monday, July 07, 2014 04:54:23 PM Daniel Vetter wrote:
> > On Wed, Jun 25, 2014 at 01:01:36AM +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, June 24, 2014 02:43:02 PM Jani Nikula wrote:
> > > > On Thu, 19 Jun 2014, Randy Dunlap <rdunlap@infradead.org> wrote:
> > > > > On 06/18/14 23:16, Stephen Rothwell wrote:
> > > > >> Hi all,
> > > > >> 
> > > > >> The powerpc allyesconfig is again broken more than usual.
> > > > >> 
> > > > >> Changes since 20140618:
> > > > >> 
> > > > >
> > > > > on i386:
> > > > >
> > > > > CONFIG_ACPI is not enabled.
> > > > >
> > > > >   CC      drivers/gpu/drm/i915/i915_drv.o
> > > > > ../drivers/gpu/drm/i915/i915_drv.c: In function 'i915_drm_freeze':
> > > > > ../drivers/gpu/drm/i915/i915_drv.c:547:2: error: implicit declaration of function 'acpi_target_system_state' [-Werror=implicit-function-declaration]
> > > > > ../drivers/gpu/drm/i915/i915_drv.c:547:36: error: 'ACPI_STATE_S3' undeclared (first use in this function)
> > > > > ../drivers/gpu/drm/i915/i915_drv.c:547:36: note: each undeclared identifier is reported only once for each function it appears in
> > > > >   CC      net/dccp/qpolicy.o
> > > > > cc1: some warnings being treated as errors
> > > > > make[5]: *** [drivers/gpu/drm/i915/i915_drv.o] Error 1
> > > > 
> > > > Thanks for the report, we'll fix it.
> > > > 
> > > > Can anyone explain why include/linux/acpi_bus.h has #ifdef
> > > > CONFIG_ACPI_SLEEP and conditional build for a dummy inline version of
> > > > acpi_target_system_state(), *but* that does not get included or used if
> > > > CONFIG_ACPI=n? Additionally, the combination of CONFIG_ACPI=y and
> > > > CONFIG_ACPI_SLEEP=n does not seem to work at all.
> > > 
> > > These two things look like bugs to me.  Most likely not tested thoruoughly
> > > enough.
> > > 
> > > > So we'll really have to sprinkle #ifdef CONFIG_ACPI all over, instead of
> > > > neatly using the dummy versions that someone has gone through the
> > > > trouble of adding?
> > > 
> > > No, we don't have to.
> > 
> > Back from my vacation and I didn't see a conclusion to this issue here.
> > Rafael, have you fixed this in your acpi tree or do I need to do something
> > in drm-intel?
> 
> I was on vacation too. :-)
> 
> Please have a look if i915 includes acpi/acpi_bus.h directly anywhere.  If so,
> it should include linux/acpi.h instead.  I'll fix up the rest in the ACPI tree.

We seem to only use linux/acpi.h and acpi/(video|button).h, at least
according to a grep include.*acpi. So I think we're good in i915 land.
Thanks for taking care of this.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
