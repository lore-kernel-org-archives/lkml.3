Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3GXVCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:02:07 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:62767 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3GXVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:02:04 -0400
Date: Wed, 24 Jul 2013 23:02:00 +0200
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lu@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        * =?iso-8859-1?Q?SAM=CD?= * <miaousami@hotmail.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Subject: Re: [Intel-gfx] Linux 3.11-rc2 [backlight] [ASUS N56VZ]
Message-ID: <20130724210200.GY5939@phenom.ffwll.local>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lu@intel.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	* =?iso-8859-1?Q?SAM=CD?= * <miaousami@hotmail.com>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Igor Gnatenko <i.gnatenko.brain@gmail.com>
References: <BLU0-SMTP125E791F01E26C3D60D7353A6680@phx.gbl>
 <17420057.BAULu67LQ3@vostro.rjw.lan>
 <CA+55aFzDgAcrzkkq06Qe9CBbBv6xKMYwPqtwv+ACryRSTRDOSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzDgAcrzkkq06Qe9CBbBv6xKMYwPqtwv+ACryRSTRDOSQ@mail.gmail.com>
X-Originating-IP: [178.83.130.250]
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:39 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, Jul 24, 2013 at 12:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> Well, there seems to be a number of people who'll be equally unhappy if I don't
>> do that.  Unfortunately for you, things work for them without that patch.
>
> So I think we have to revert the behavior back, but I wonder if we
> could keep the logic and have a i915 kernel command line option to
> enable it.
>
> We did that for a long time with "drm.modeset" and the
> "i915.enable_rc6" mess. We still have the "i915.invert_brightness"
> thing, although I don't know who actually uses it. But that option is
> itself an indication that the i915 driver still has some backlight
> issues.

invert_brighntess seems to be real, at least we have a pile of quirk
entries for Acer and Packard Bell machines. Generally I'm not too happy
with module options since they tend to get stuck eternally in a limbo
state where everyone in the know sets them to their liking and no one
bothers to fix the underlying.

Otoh this is the backlight and I've essentially given up and opted for
quirk entries :(

> But if that kind of "revert behavior" isn't easy, we need to just
> revert the patches entirely.

I think a i915 module option should be doable, otoh people seem to have a
viable workaround by setting a different acpi os version already.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
