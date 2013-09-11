Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3IKInd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:43:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:62343 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab3IKInb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,883,1371106800"; 
   d="scan'208";a="293439595"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Aaron Lu <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Vetter <daniel@ffwll.ch>, Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx\@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Yves-Alexis Perez <corsac@debian.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel\@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee\, Chun-Yi" <joeyli.kernel@gmail.com>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Lee Chun-Yi <jlee@novell.com>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if firmware expects Windows 8
In-Reply-To: <20130911013206.GA556@mint-spring.sh.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <522D88C3.7000808@intel.com> <5155010.Y1gov7SKhP@vostro.rjw.lan> <87eh8wail7.fsf@intel.com> <1889567.vxI8heiC3B@vostro.rjw.lan> <20130911013206.GA556@mint-spring.sh.intel.com>
User-Agent: Notmuch/0.16+64~g94fe857 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 11 Sep 2013 11:45:19 +0300
Message-ID: <87hadrycf4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Aaron Lu <aaron.lu@intel.com> wrote:
> It is possible the i915 driver decides not to register a backlight
> interface for the graphics card for some reason(memory allocation failed
> or it knows the native control does not work on this card or whatever),
> so I would prefer let i915 tell ACPI video that it has registered a
> native backlight control interface as Jani has said.
>
> Then together with the video.use_native_backlight, we can register or
> not register ACPI video backlight interface accordingly. Or rather, we
> can simply not register ACPI video backlight interface for Win8 systems
> as long as i915 indicates that it has native backlight control(if the
> native control is broken, i915 should fix it or blacklist it so that
> i915 will not indicate it has native backlight control and ACPI video
> will continue to register its own).
>
> How does this sound?

Sounds good to me.

Before plunging forward, have you observed any difference between the
boot modes? We have reports [1] that the backlight behaviour is
different with UEFI vs. UEFI+CSM or legacy boot. So I'm wondering if the
acpi_gbl_osi_data >= ACPI_OSI_WIN_8 check in patch 2/2 is the whole
story.

Further, if we tell the BIOS we're Windows 8 to use the tested BIOS code
paths, what guarantees do we have of UEFI+CSM or legacy boots working?

BR,
Jani.


[1] https://bugzilla.kernel.org/show_bug.cgi?id=47941#c96


-- 
Jani Nikula, Intel Open Source Technology Center
