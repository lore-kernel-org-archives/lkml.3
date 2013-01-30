Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3A3HfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:35:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49706 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab3A3He6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:34:58 -0500
Message-ID: <5108CD0F.3000404@ti.com>
Date: Wed, 30 Jan 2013 08:34:39 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 1/4] pwm_backlight: Fix PWM levels support in non DT case
References: <1358861996-27194-1-git-send-email-peter.ujfalusi@ti.com> <1358861996-27194-2-git-send-email-peter.ujfalusi@ti.com> <20130128210123.GA24673@avionic-0098.mockup.avionic-design.de> <51078580.2000808@ti.com> <20130129101709.GC16746@avionic-0098.mockup.avionic-design.de> <5107BC2B.5080400@ti.com> <20130129123025.GA20166@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130129123025.GA20166@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 01:30 PM, Thierry Reding wrote:
>> Right. Now I know the background.
>> However I do not agree with the conclusion. Probably it is fine in some cases
>> to limit the number of configurable duty cycles to have only distinct steps.
>> To not go too far, on my laptop I have:
>> # cat /sys/class/backlight/acpi_video0/max_brightness
>> 15
>> # cat /sys/class/backlight/intel_backlight/max_brightness
>> 93
> 
> FWIW, I have hardware with an Intel chipset that has max_brightness
> 13666. That doesn't mean all of these are necessarily valid or useful.

For sure this range is overkill, but if you reduce it to let's say 15 would it
be better? I don't think. It is up to the userspace to decide how to use it.
User should have full control over the HW in hand. In this particular case I
would expect userspace to give you around 20 steps to change brightness and
when you change it would step between those so you will have nice, smooth
changes and not big jumps.

> That's not true. The duty-cycle merely defines a percentage of how long
> the PWM signal will be high. You can choose an arbitrary number of
> subdivisions.

Sure all HW has limitation. The HW I have either have 127 or 255 time slots.
Probably the best thing way to deal with the backlight is to have a range of 0
- 100% Nothing else.
We should have an API to PWMs so user drivers could get the duty cycle from
the HW drivers. In this way backlight would only expose percentage and the
backlight driver would get the number of time slots from the PWM core to
calculate the actual value for the selected percentage.

> Since the brightness of a display isn't linearly proportional to the
> duty cycle of the PWM driving it, representing that brightness by a
> linear range is misleading. Furthermore some panels have regions where
> the backlight isn't lit at all or where changes in the PWM duty-cycle
> don't make any difference.

and all of this also depend on the surrounding light conditions as well. If
the same device is used in low light condition you care about the lower light
ranges more compared to when the same device is used in bright environment. In
these case the user space has to be adopted to the conditions and one should
not need to recompile the kernel/dtb just because the device is used in
different environment.

-- 
Péter
