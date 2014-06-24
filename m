Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaFXWny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:43:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54755 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751211AbaFXWnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:43:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Imre Deak <imre.deak@intel.com>
Subject: Re: linux-next: Tree for Jun 19 (drm/i915)
Date: Wed, 25 Jun 2014 01:01:36 +0200
Message-ID: <9626816.NOau5dZfmB@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <87y4wm8reh.fsf@intel.com>
References: <20140619161632.58b442e4@canb.auug.org.au> <53A31CDA.20207@infradead.org> <87y4wm8reh.fsf@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 24, 2014 02:43:02 PM Jani Nikula wrote:
> On Thu, 19 Jun 2014, Randy Dunlap <rdunlap@infradead.org> wrote:
> > On 06/18/14 23:16, Stephen Rothwell wrote:
> >> Hi all,
> >> 
> >> The powerpc allyesconfig is again broken more than usual.
> >> 
> >> Changes since 20140618:
> >> 
> >
> > on i386:
> >
> > CONFIG_ACPI is not enabled.
> >
> >   CC      drivers/gpu/drm/i915/i915_drv.o
> > ../drivers/gpu/drm/i915/i915_drv.c: In function 'i915_drm_freeze':
> > ../drivers/gpu/drm/i915/i915_drv.c:547:2: error: implicit declaration of function 'acpi_target_system_state' [-Werror=implicit-function-declaration]
> > ../drivers/gpu/drm/i915/i915_drv.c:547:36: error: 'ACPI_STATE_S3' undeclared (first use in this function)
> > ../drivers/gpu/drm/i915/i915_drv.c:547:36: note: each undeclared identifier is reported only once for each function it appears in
> >   CC      net/dccp/qpolicy.o
> > cc1: some warnings being treated as errors
> > make[5]: *** [drivers/gpu/drm/i915/i915_drv.o] Error 1
> 
> Thanks for the report, we'll fix it.
> 
> Can anyone explain why include/linux/acpi_bus.h has #ifdef
> CONFIG_ACPI_SLEEP and conditional build for a dummy inline version of
> acpi_target_system_state(), *but* that does not get included or used if
> CONFIG_ACPI=n? Additionally, the combination of CONFIG_ACPI=y and
> CONFIG_ACPI_SLEEP=n does not seem to work at all.

These two things look like bugs to me.  Most likely not tested thoruoughly
enough.

> So we'll really have to sprinkle #ifdef CONFIG_ACPI all over, instead of
> neatly using the dummy versions that someone has gone through the
> trouble of adding?

No, we don't have to.

Rafael

