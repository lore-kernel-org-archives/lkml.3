Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3FYQI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:08:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54238 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3FYQI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:08:57 -0400
Date: Tue, 25 Jun 2013 17:08:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl,
        Henrique de Moraes Holschuh <hmh@debian.org>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
Message-ID: <20130625160848.GA27123@srcf.ucam.org>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
 <1371937599.17761.19.camel@scapa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371937599.17761.19.camel@scapa>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 11:46:39PM +0200, Yves-Alexis Perez wrote:

> Before Linux support for acpi_osi("Windows 2012") (and when booting with
> acpi_osi="!Windows 2012"), brightness keys were handled by the kernel
> just fine, whether in console, in the display manager or in my desktop
> environment (Xfce). xfce4-power-manager just needs to be told that the
> brightness keys are already handled and it doesn't need to do anything.

Right, the kernel has special-casing to hook the backlight keys up to 
the ACPI backlight control. This is an awful thing, because there's no 
way to detect this case other than parsing a single driver-specific 
module parameter.

Could this functionality be duplicated across other backlight drivers? 
Not easily. The ACPI driver receives keypresses and performs backlight 
control. The i915 driver doesn't receive keypresses. We could easily tie 
certain keycodes into backlight events, but which backlight should they 
control? You're really starting to get into the kind of complex policy 
decision that's best left to userspace, which is where it should have 
been to begin with.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
