Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3CZRVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:21:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47776 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3CZRVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:21:07 -0400
Date: Tue, 26 Mar 2013 17:21:04 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Danny Baumann <dannybaumann@web.de>
Cc: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] drm/i915: Allow specifying a minimum brightness
 level for sysfs control.
Message-ID: <20130326172103.GA24566@srcf.ucam.org>
References: <1364298525-4337-1-git-send-email-dannybaumann@web.de>
 <20130326170203.GA23549@srcf.ucam.org>
 <5151D686.9070701@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5151D686.9070701@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 06:10:30PM +0100, Danny Baumann wrote:
> Am 26.03.2013 18:02, schrieb Matthew Garrett:
> >I'm not quite clear what you mean here. The behaviour of "0" isn't well
> >defined for the ACPI backlight driver - it's perfectly reasonable for it
> >to turn the backlight off entirely. Anything assuming that "0" is still
> >visible is broken.
> 
> Well, the ACPI spec says this (section B.5.2):
> 
> "
> The OEM may define the number 0 as "Zero brightness" that can mean
> to turn off the lighting (e.g. LCD panel backlight) in the device.
> This may be useful in the case of an output device that can still be
> viewed using only ambient light, for example, a transflective LCD.
> "
> 
> My interpretation of this is that the value 0 is supposed to still
> be visible. I'm pretty sure I saw a statement that 0 is supposed to
> mean "barely visible" somewhere, but can't find it at the moment.
> I'll search for the source of it.

I think that's a stretch - "This may be useful" isn't normative 
language, "The OEM may define" is. But even if we do assert it for the 
ACPI backlight, it's not true for other interfaces - zero backlight 
intensity is supposed to be screen off on Apple hardware, for instance.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
