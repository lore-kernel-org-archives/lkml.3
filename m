Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbaCDOpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:45:14 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:58119 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbaCDOpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:45:11 -0500
Date: Tue, 4 Mar 2014 15:45:04 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] drm/i915/opregion: work around buggy firmware that
 provides 8+ output devices
Message-ID: <20140304144504.GE17001@phenom.ffwll.local>
Mail-Followup-To: Aaron Lu <aaron.lu@intel.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <52FAE504.8020001@intel.com>
 <20140212103156.GC5298@nuc-i3427.alporthouse.com>
 <52FC8C01.1040002@intel.com>
 <20140213100814.GM14909@nuc-i3427.alporthouse.com>
 <CAKMK7uGN3Of2VU6_LsSLh041kkx4TrhyH0H8zvE-PRvOtzJgfg@mail.gmail.com>
 <53045DD1.5010406@intel.com>
 <20140219073339.GA30685@srcf.ucam.org>
 <5304725A.3020909@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5304725A.3020909@intel.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 04:59:06PM +0800, Aaron Lu wrote:
> On 02/19/2014 03:33 PM, Matthew Garrett wrote:
> > On Wed, Feb 19, 2014 at 03:31:29PM +0800, Aaron Lu wrote:
> > 
> >> DID2 is in system memory region and has some assigned value like 0x400
> >> when we read it. For this case it is easy since there is only one output
> >> device that is of type LVDS so we can match it to connector of type eDP
> >> or LVDS, suppose there is only one such connector. But for output
> >> devices' whose _ADR has the value of 0x301, 0x302, etc. I have no idea
> >> how to match them up to the connectors of that type as we can't be sure
> >> the probe order we have used in i915 driver is the same as BIOS'.
> > 
> > Non-standard _ADR values are assigend by the GPU vendor, so Intel should 
> > be able to provide you with the correct interpretations.
> 
> It doesn't seem the _ADR value has to be the format defined by _DOD, as
> the example of the ACPI spec gives:
> Method (_ADR, 0) {
>     return(0x0100)
> }
> So that is not the problem here.
> 
> The problem is, we don't have any way of matching an ACPI output device
> node to a drm connector of the same type when there are more than 1 of
> those with the same type, i.e. we don't know how the index value are
> assigned by BIOS.

I've thought the OpRegion spec has some additional fields in there
indicating the port number, which we could match up at least on modern
platforms (where there's only ever port A-E). But that's very hazy
recollection from a really old OpRegion spec, i.e. I have no bloody clue
at all ;-)

If I misremember this then we need to start on a begging tour again and
ask the windows guys how this is all supposed to work ...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
