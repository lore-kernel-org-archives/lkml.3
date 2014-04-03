Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162430AbaDCHF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:05:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:33924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162382AbaDCHFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:05:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,784,1389772800"; 
   d="scan'208";a="513904184"
From: Jani Nikula <jani.nikula@intel.com>
To: James Hogan <james@albanarts.com>, Imre Deak <imre.deak@intel.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: drm/i915: XPS13 backlight regression in v3.14
In-Reply-To: <2613018.1cXJgVWlHm@radagast>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <2613018.1cXJgVWlHm@radagast>
User-Agent: Notmuch/0.17+162~g34940eaa1d37 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 03 Apr 2014 10:02:58 +0300
Message-ID: <87zjk2lwt9.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Apr 2014, James Hogan <james@albanarts.com> wrote:
> Hi,
>
> I've noticed that v3.14 breaks the backlight on Dell XPS13. Reverting the 
> following commit fixes the issue for me (i.e. the GUI brightness controls work 
> again):
>
> bc0bb9fd1c78 drm/i915: remove QUIRK_NO_PCH_PWM_ENABLE
>
> It appears that in v3.14 (with the above patch):
> * intel_backlight/brightness=4882 (max & default) causes 
> acpi_video0/brightness to have no effect.
> * intel_backlight/brightness=0 causes acpi_video0/brightness to behave 
> corrrectly (the firmware (I assume) fades the brightness gradually when 
> acpi_video0/brightness is set)
> * intel_backlight/brightness=something else in between often causes 
> acpi_video0 and intel_backlight to apparently "fight" over the backlight, 
> resulting in brightness flickering up and down every second or so.
>
> Reverting the above patch on v3.14:
> * intel_backlight/brightness has no effect
> * acpi_video0/brightness works normally
>
> It doesn't seem quite as simple as them trying to use the same hardware since 
> when intel_backlight/brightness=4882, acpi_video0/brightness has no effect at 
> all, so I don't really get what's going on.
>
> Can anybody shed some light or suggest a proper fix for this recurring issue?

Tracked at https://bugs.freedesktop.org/show_bug.cgi?id=76276

BR,
Jani.


>
> Thanks
> James

-- 
Jani Nikula, Intel Open Source Technology Center
