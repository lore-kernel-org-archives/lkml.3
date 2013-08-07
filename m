Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab3HGHoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:44:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51567 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab3HGHoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:44:08 -0400
Date: Wed, 7 Aug 2013 09:44:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl,
        Aaron Lu <aaron.lu@intel.com>
Subject: Backlight control only in the kernel?
Message-ID: <20130807074405.GA18272@pd.tnic>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 07:01:36PM -0400, Matthew Garrett wrote:
> Windows 8 introduced new policy for backlight control by pushing it out to
> graphics drivers. This appears to have coincided with a range of vendors
> adding Windows 8 checks to their backlight control code which trigger either
> awkward behaviour (Lenovo) or complete brokenness (some Dells). The simplest
> thing to do would be to just disable ACPI backlight control entirely if the
> firmware indicates Windows 8 support, but it's entirely possible that
> individual graphics drivers might still make use of the ACPI functionality in
> preference to native control.

Maybe tangential, so Aaron and I were wondering on
https://bugzilla.kernel.org/show_bug.cgi?id=60680 whether it would make
sense to handle the backlight control strictly in the kernel, without
going to userspace and back?

Background is that on my x230, I needed to connect the
Fn-Fx backlight hotkey presses to a script to write to
/sys/class/backlight/intel_backlight/brightness because Fluxbox doesn't
do that (and maybe doesn't have to).

So, without presuming any ACPI or backlight knowledge, can we make the
backlight control work only in the kernel by connecting the hotkey
presses to some backlight controlling interface which backlight-capable
devices implement so that it works regardless of userspace environment?
Even if the machine is not running X?

Hmmm.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
