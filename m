Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3GYIIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:08:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:51692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab3GYIIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:08:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,742,1367996400"; 
   d="scan'208";a="375754984"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        * =?utf-8?Q?SAM=C3=8D?= * <miaousami@hotmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Subject: Re: [Intel-gfx] Linux 3.11-rc2 [backlight] [ASUS N56VZ]
In-Reply-To: <6051153.b6TE1dlrel@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <BLU0-SMTP125E791F01E26C3D60D7353A6680@phx.gbl> <20130724210200.GY5939@phenom.ffwll.local> <CA+55aFxvLox_iwPAg=iJx4F9M_FpMPY3ettFtAJOUk78d4+0pw@mail.gmail.com> <6051153.b6TE1dlrel@vostro.rjw.lan>
User-Agent: Notmuch/0.15.2+227~g0ff681e (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 25 Jul 2013 11:09:27 +0300
Message-ID: <87hafjxdqg.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> On Wednesday, July 24, 2013 02:05:15 PM Linus Torvalds wrote:
>> On Wed, Jul 24, 2013 at 2:02 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> >
>> > I think a i915 module option should be doable, otoh people seem to have a
>> > viable workaround by setting a different acpi os version already.
>> 
>> At least the original claim was that if you set a non-windows8 acpi os
>> version, you hit other bugs..
>> 
>> But yeah, if we just do a plain revert, that may be the only option
>> for the people for whom the current (to-be-reverted) patches made
>> things work.
>
> Well, I wonder what about the appended (untested) patch?

Rafael, before going there, I've been trying to wrap my (poor, rusty
after vacation) head around

commit 8c5bd7adb2ce47e6aa39d17b2375f69b0c0aa255
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu Jul 18 02:08:06 2013 +0200

    ACPI / video / i915: No ACPI backlight if firmware expects Windows 8

and I can't see how it could work.

First, the ACPI_VIDEO_SKIP_BACKLIGHT flag seems to be checked before
it's actually set anywhere. Buried deep in the calls from
acpi_video_bus_add(), acpi_video_verify_backlight_support() is used
before acpi_video_backlight_quirks() gets called. (Perhaps if i915 is
reloaded, this goes right as the flags are already set.)

Second, with i915 that has opregion support, __acpi_video_register()
should only ever get called once. Which means the acpi_walk_namespace()
with video_unregister_backlight() should never get called in register.

Please enlighten me.

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
