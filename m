Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507Ab3GRAMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 20:12:41 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48001 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811Ab3GRAMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 20:12:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-acpi@vger.kernel.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        Aaron Lu <aaron.lu@intel.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Lee, Chun-Yi" <jlee@suse.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [Update][PATCH 0/3] Fix backlight issues on some Windows 8 systems
Date: Thu, 18 Jul 2013 02:16:09 +0200
Message-ID: <1448863.3slS729B6b@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 09, 2013 07:01:36 PM Matthew Garrett wrote:
> Windows 8 introduced new policy for backlight control by pushing it out to
> graphics drivers. This appears to have coincided with a range of vendors
> adding Windows 8 checks to their backlight control code which trigger either
> awkward behaviour (Lenovo) or complete brokenness (some Dells). The simplest
> thing to do would be to just disable ACPI backlight control entirely if the
> firmware indicates Windows 8 support, but it's entirely possible that
> individual graphics drivers might still make use of the ACPI functionality in
> preference to native control.
> 
> The first two patches in this series are picked from other patchesets aimed at
> solving similar problems. The last simply unregisters ACPI backlight control
> on Windows 8 systems when using an Intel GPU. Similar code could be added to
> other drivers, but I'm reluctant to do so without further investigation as
> to the behaviour of the vendor drivers under Windows.

Well, after some more time spent on that, we now have a series of 3 patches
(different from the $subject one) that we think may be used to address this
issue.  As far as I can say, it has been tested by multiple people whose
systems have those problems and they generally saw improvement.

It is not my ideal approach, but it seems to be the least intrusive and/or
with the least amount of possible side effects that we can do right now
as a general measure (alternatively, we could create a possibly long
blacklist table of affected systems with different workarounds for them,
but let's just say that is not overwhelmingly attractive).

[1/3] Make ACPICA export things that we need for checking OSI(Win8).

[2/3] Make acpi_video_device_find_cap() call acpi_video_init_brightness() even
      if it is not going to register the backlight interface (needed for
      Thinkpads).

[3/3] Avoid using ACPI backlight if i915 is in use and the firmware believes
      we are Windows 8.

Many thanks to everyone involved!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
