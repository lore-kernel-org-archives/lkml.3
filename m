Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3HAIMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:12:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50051 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab3HAIMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:12:17 -0400
Date: Thu, 1 Aug 2013 10:12:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aaron Lu <aaron.lu@intel.com>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: i915 backlight
Message-ID: <20130801081215.GB3448@nazgul.tnic>
References: <20130731162252.GC4724@pd.tnic>
 <20130731163623.GD4724@pd.tnic>
 <51F9B63F.7060509@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51F9B63F.7060509@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 09:13:35AM +0800, Aaron Lu wrote:
> Can you please run acpi_listen and then press the Fn-Fx key, see if the
> events are correctly sent out?

Like this?

# acpi_listen
video/brightnessdown BRTDN 00000087 00000000
video/brightnessup BRTUP 00000086 00000000
video/brightnessdown BRTDN 00000087 00000000
video/brightnessup BRTUP 00000086 00000000
video/brightnessdown BRTDN 00000087 00000000
video/brightnessup BRTUP 00000086 00000000
video/brightnessdown BRTDN 00000087 00000000
video/brightnessup BRTUP 00000086 00000000
video/brightnessdown BRTDN 00000087 00000000
^C

> From the bug page:
> https://bugzilla.kernel.org/show_bug.cgi?id=51231#c80
> I got the impression that both the acpi_video interface and the vendor
> interface thinkpad_screen are broken. So adding this cmdline here works
> suggests that either thinkpad_screen works or thinkpad vendor driver
> doesn't get loaded or doesn't create that interface for some reason.
> 
> Alternatively, if the intel_backlight interface works(highly possible),
> you can use xorg.conf to specify the that backlight interface for X.
> 
> Section "Device"
>         Option     "Backlight"	"intel_backlight"
> 	Identifier  "Card0"
> 	Driver      "intel"
> 	BusID       "PCI:0:2:0"
> EndSection

Yeah, that didn't work *but* manually writing to both:

/sys/class/backlight/acpi_video0/brightness

and

/sys/class/backlight/intel_backlight/brightness

works.

The ranges are different, though:

intel_backlight/actual_brightness:1000
intel_backlight/bl_power:0
intel_backlight/brightness:1000
intel_backlight/max_brightness:4437
intel_backlight/type:raw

acpi_video0/actual_brightness:41
acpi_video0/bl_power:0
acpi_video0/brightness:41
acpi_video0/max_brightness:100
acpi_video0/type:firmware

I guess I need to write me a dirty script for now ... :-)

Thanks guys.
