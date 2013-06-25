Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab3FYQKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:10:38 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36515 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3FYQKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:10:36 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130625160848.GA27123@srcf.ucam.org>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	<1371937599.17761.19.camel@scapa>
	<20130625160848.GA27123@srcf.ucam.org>
Date: Tue, 25 Jun 2013 18:10:35 +0200
Message-ID: <CAKMK7uEtF9XnPem+rTQuBgAef6RDhRuj-=SdvufTa4zBs80Ssw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fix backlight issues on some Windows 8 systems
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Yves-Alexis Perez <corsac@debian.org>, linux-acpi@vger.kernel.org,
        seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Henrique de Moraes Holschuh <hmh@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 6:08 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sat, Jun 22, 2013 at 11:46:39PM +0200, Yves-Alexis Perez wrote:
>
>> Before Linux support for acpi_osi("Windows 2012") (and when booting with
>> acpi_osi="!Windows 2012"), brightness keys were handled by the kernel
>> just fine, whether in console, in the display manager or in my desktop
>> environment (Xfce). xfce4-power-manager just needs to be told that the
>> brightness keys are already handled and it doesn't need to do anything.
>
> Right, the kernel has special-casing to hook the backlight keys up to
> the ACPI backlight control. This is an awful thing, because there's no
> way to detect this case other than parsing a single driver-specific
> module parameter.
>
> Could this functionality be duplicated across other backlight drivers?
> Not easily. The ACPI driver receives keypresses and performs backlight
> control. The i915 driver doesn't receive keypresses. We could easily tie
> certain keycodes into backlight events, but which backlight should they
> control? You're really starting to get into the kind of complex policy
> decision that's best left to userspace, which is where it should have
> been to begin with.

Do we have any chances to amend this mistake by (gradually) phasing
out support for the direct keypress forwarding in ACPI? Or at least
some plans?
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
