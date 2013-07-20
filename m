Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3GTNRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 09:17:01 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47512 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3GTNQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 09:16:59 -0400
MIME-Version: 1.0
In-Reply-To: <1448863.3slS729B6b@vostro.rjw.lan>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	<1448863.3slS729B6b@vostro.rjw.lan>
Date: Sat, 20 Jul 2013 08:16:56 -0500
Message-ID: <CAMP44s2fT8C=wfF-uadxTOSzqLLfjFTJMQ767qy6teJZh_SS6w@mail.gmail.com>
Subject: Re: [Update][PATCH 0/3] Fix backlight issues on some Windows 8 systems
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        lenb@kernel.org, Aaron Lu <aaron.lu@intel.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>, "Lee, Chun-Yi" <jlee@suse.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 7:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, June 09, 2013 07:01:36 PM Matthew Garrett wrote:
>> Windows 8 introduced new policy for backlight control by pushing it out to
>> graphics drivers. This appears to have coincided with a range of vendors
>> adding Windows 8 checks to their backlight control code which trigger either
>> awkward behaviour (Lenovo) or complete brokenness (some Dells). The simplest
>> thing to do would be to just disable ACPI backlight control entirely if the
>> firmware indicates Windows 8 support, but it's entirely possible that
>> individual graphics drivers might still make use of the ACPI functionality in
>> preference to native control.
>>
>> The first two patches in this series are picked from other patchesets aimed at
>> solving similar problems. The last simply unregisters ACPI backlight control
>> on Windows 8 systems when using an Intel GPU. Similar code could be added to
>> other drivers, but I'm reluctant to do so without further investigation as
>> to the behaviour of the vendor drivers under Windows.
>
> Well, after some more time spent on that, we now have a series of 3 patches
> (different from the $subject one) that we think may be used to address this
> issue.  As far as I can say, it has been tested by multiple people whose
> systems have those problems and they generally saw improvement.
>
> It is not my ideal approach, but it seems to be the least intrusive and/or
> with the least amount of possible side effects that we can do right now
> as a general measure (alternatively, we could create a possibly long
> blacklist table of affected systems with different workarounds for them,
> but let's just say that is not overwhelmingly attractive).
>
> [1/3] Make ACPICA export things that we need for checking OSI(Win8).
>
> [2/3] Make acpi_video_device_find_cap() call acpi_video_init_brightness() even
>       if it is not going to register the backlight interface (needed for
>       Thinkpads).
>
> [3/3] Avoid using ACPI backlight if i915 is in use and the firmware believes
>       we are Windows 8.
>
> Many thanks to everyone involved!

I tried this patch series and it's as I expected, it's the same as
acpi_backlight=vendor, and the intel backlight driver doesn't work
correctly in this machine. If you are actually serious about the
mantra of "no user-space regressions", then for this machine at least,
you need to use the ACPI backlight with Windows8 OSI disabled, until
the intel backlight driver is fixed. My patch does that:

http://article.gmane.org/gmane.linux.acpi.devel/60969

-- 
Felipe Contreras
