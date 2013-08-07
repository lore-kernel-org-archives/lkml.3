Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab3HGLEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:04:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36080 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249Ab3HGLEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:04:08 -0400
Date: Wed, 7 Aug 2013 13:04:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: Backlight control only in the kernel?
Message-ID: <20130807110406.GD17920@pd.tnic>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
 <20130807074405.GA18272@pd.tnic>
 <1375871766.10292.7.camel@x230.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1375871766.10292.7.camel@x230.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 10:36:08AM +0000, Matthew Garrett wrote:
> Not really. The ACPI driver is able to do this because the events and
> the backlight are associated with the same device.

Well, it doesn't work at least in my case.

I need to echo stuff into /sys/class/backlight/intel_backlight :(

> We could potentially make something work with GPU backlight drivers
> since their PCI device should also be associated with the backlight
> device, but things get complicated quickly - once ddcci support
> is hooked up you'll also have kernel backlight devices for some
> external monitors, and now you need to make a policy decision about
> which display should be controlled in response to the keypress. One
> reasonable choice would be whichever display contains the currently
> focused window, which is obviously out of scope for the kernel.
>
> So if we're going to do this then we need a generalised mechanism
> in-kernel for connecting input devices to backlight devices, and we
> need a mechanism for disabling it when userspace knows better. This
> sounds like a lot of work for something that should really just be
> handled by userspace already.

That's easy: single-monitor setups have it enabled by default. So every
laptop out there will just work, without any userspace intervention.

More complicated situations are presented with the opportunity to
disable the kernel-side control and do it themselves.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
