Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaBLKtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:49:15 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:54939 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323AbaBLKtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:49:11 -0500
X-Greylist: delayed 1024 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2014 05:49:10 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Wed, 12 Feb 2014 10:31:56 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] drm/i915/opregion: work around buggy firmware that
 provides 8+ output devices
Message-ID: <20140212103156.GC5298@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Aaron Lu <aaron.lu@intel.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Oleksij Rempel <linux@rempel-privat.de>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <52FAE504.8020001@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FAE504.8020001@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:05:40AM +0800, Aaron Lu wrote:
> The ACPI table on ASUS UX302LA has more than 8 output devices under the
> graphics controller device node. The problem is, the real active output
> device, the LCD panel, is listed the last. The result is, the LCD's
> device id doesn't get recorded in the active device list CADL array and
> when the _DCS control method for the LCD device is executed, it returns
> 0x1d, meaning it is not active. This affects the hotkey delivery ASL
> code that will not deliver a notification if the output device is not
> active on backlight hotkey press.
> 
> I don't see a clean way to solve this problem since the operation region
> spec doesn't allow more than 8 output devices so we have no way of
> storing all these output devices. The fact that output devices that have
> _BCM control method usually means they have a higher possibility of being
> used than those who don't made me choose a simple way to work around
> the buggy firmware by replacing the last entry in CADL array with the one
> that has _BCM control method. There is no specific reason why the last
> entry is picked instead of others.

Another possibility is that the connector list is in rough priority
order so might be useful for sorting the CADL array.

Since the CADL should only be a list of currently active devices, we
could just bite the bullet and repopulate it correctly after every
setcrtc.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
