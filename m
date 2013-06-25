Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3FYUyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:54:36 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59255 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3FYUye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:54:34 -0400
Date: Tue, 25 Jun 2013 21:54:30 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl,
        Henrique de Moraes Holschuh <hmh@debian.org>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
Message-ID: <20130625205430.GA2438@srcf.ucam.org>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
 <1371937599.17761.19.camel@scapa>
 <20130625160848.GA27123@srcf.ucam.org>
 <1372193037.8189.24.camel@scapa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372193037.8189.24.camel@scapa>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 10:43:57PM +0200, Yves-Alexis Perez wrote:
> On mar., 2013-06-25 at 17:08 +0100, Matthew Garrett wrote:
> > Right, the kernel has special-casing to hook the backlight keys up to 
> > the ACPI backlight control. This is an awful thing, because there's no 
> > way to detect this case other than parsing a single driver-specific 
> > module parameter.
> 
> I'm not sure what that means. To detect what case exactly? That the
> brightness is handled by video.ko?

That the kernel will automatically handle backlight key presses.

> > Could this functionality be duplicated across other backlight drivers? 
> > Not easily. The ACPI driver receives keypresses and performs backlight 
> > control. The i915 driver doesn't receive keypresses. We could easily tie 
> > certain keycodes into backlight events, but which backlight should they 
> > control? You're really starting to get into the kind of complex policy 
> > decision that's best left to userspace, which is where it should have 
> > been to begin with.
> > 
> Well, I get the reasoning, but I'm not sure I agree. That means
> userspace behavior is inconsistent depending on who does it
> (gnome-power-manager, gnome-setting-daemon, whatever), and it usually
> means there's nothing handling the brightness before those are running,
> not to mention people not running them because they don't run a full
> blown desktop environment (until someone starts thinking it's a good
> idea to handle brightness in systemd).

The behaviour is already inconsistent. If you have an ACPI backlight 
interface, hitting the keys makes your brightness change without any 
userspace help. If you don't, it doesn't.

> And in the end, the user just want the brightness keys to correctly
> handle the brightness, full stop. Having multiple brightness daemons
> using different policies on different hardware is a nightmare for the
> end user, imho. From a user point of view, having it handled all in the
> kernel works really pretty fine and is completely transparent (I have to
> admit that from that point of view, it was even better when it was
> handled by the EC but those times seem long gone).

I agree, we should standardise the behaviour. And the only way we can 
standardise the behaviour is to leave it up to userspace.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
