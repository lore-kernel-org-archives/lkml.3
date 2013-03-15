Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3COHaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 03:30:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:35388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab3COHay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 03:30:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="302623732"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Chris Li <lkml@chrisli.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, len.brown@intel.com,
        feng.tang@intel.com, intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, robert.moore@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [Intel-gfx] i915 black screen introduced by ACPI changes
In-Reply-To: <CANeU7QmJx=3m94ut0SYGEes4-C9khTMWbpee1u0rD4-esUpV=Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com> <20130219100849.72d2330b@jbarnes-desktop> <CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com> <20130219125217.6b6f55ff@jbarnes-desktop> <CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com> <CAKMK7uG7TgiAn0ZQ=E_-QBPNAVhTSxpORkX3Z1mY=54mgTzM-g@mail.gmail.com> <CANeU7QnMzYuG6iiU3nLh4k0dGFMEDOyfUDQgxQSKj20_y-oL+Q@mail.gmail.com> <CAKMK7uGDpSKga9=2SrGQDxBGzY5B1cGJAchZvfKfQy1ivRONMg@mail.gmail.com> <CANeU7Q=K4Adu3yokT182ZaG3hW04bhDiXhyZgjngd7Nn+JD3aQ@mail.gmail.com> <CANeU7QmMYERbg9fCnyGuDcEdzwfErNT4B_7YbAD7w243hWdaQQ@mail.gmail.com> <CANeU7Q=hbU89zfcrP15ZAqMYaZPhQzM4f7i71txQDmESt0J36w@mail.gmail.com> <CANeU7Q=ge+z=uzpWdvXbfpZ0vaA0C0bnZcPBad5zKGyj1DmLAA@mail.gmail.com> <CAKMK7uGGN6ikKr4KvaJJ7iLPgK2KwE5RsgUn=WqTtvU-ryM5nQ@mail.gmail.com> <CAKMK7uEc5R8WrdDaQWQPG-0L+uEFc_5idkvwKm2vvLDeOGQ3tA@mail.gmail.com> <CANeU7Q=rbfDXULOsMqVkGCOny5aECwqNjEwyab37pPhHfVBa4w@mail.gmail.com> <CANeU7Q=_+qt5C3G2uKhQYq_hh9kOg5c8=uAvjQzRwvx_xOe2hA@mail.gmail.com> <87txoit6uf.fsf@intel.com> <CANeU7QmoW7EcmfPgzFqvo6UVjZnaYGp6UiB_4HP238v2SGhMRg@mail.gmail.com> <CANeU7QmJx=3m94ut0SYGEes4-C9khTMWbpee1u0rD4-esUpV=Q@mail.gmail.com>
User-Agent: Notmuch/0.15.2+58~g805c484 (http://notmuchmail.org) Emacs/24.2.1 (x86_64-pc-linux-gnu)
Date: Fri, 15 Mar 2013 09:29:56 +0200
Message-ID: <87ip4tf7d7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Chris Li <lkml@chrisli.org> wrote:
> Hi, I attach the two demsg and with and without the bad commit
> on the intel nightly branch. Without the bad commit it actually works.
> However, on the tip of intel nightly. the moeset work around does not work
> there any more.

Hi Chris, thanks for the dmesgs.

So the diff in the dmesgs from intel nightly (bad) to the same with
a57f7f9175b8ccbc9df83ac13860488913115de4 reverted (good) wrt backlight
boils down to this, repeated a few times:

-[drm:asle_set_backlight], bclp = 0x80000000
+[drm:asle_set_backlight], bclp = 0x800000ff
 [drm:intel_panel_get_max_backlight], max backlight PWM = 4648
-[drm:intel_panel_actually_set_backlight], set backlight PWM = 0
-[drm:asle_set_backlight], bclp = 0x80000000
+[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
+[drm:asle_set_backlight], bclp = 0x800000ff
 [drm:intel_panel_get_max_backlight], max backlight PWM = 4648
-[drm:intel_panel_actually_set_backlight], set backlight PWM = 0
+[drm:intel_panel_actually_set_backlight], set backlight PWM = 4648

Fun. The BIOS seems to ask for zero backlight. Maybe it means something
else for Windows 8. White is the new black or something.

> Let me know if you need any thing else from me.

Just one idea, please attach hexdumps of
/sys/kernel/debug/dri/0/i915_opregion (with debugfs mounted there,
obviously) for both kernels. Maybe we're missing something there that
the BIOS thinks Windows 8 should handle.

I've never used the acpi_osi= kernel parameter, but it looks like you
could workaround this with acpi_osi="!Windows 2012". Please check that
running the "bad" kernel.


BR,
Jani.
