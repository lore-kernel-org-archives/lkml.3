Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab3CKNPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:15:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:59405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab3CKNPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:15:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,822,1355126400"; 
   d="scan'208";a="276378790"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Chris Li <lkml@chrisli.org>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: len.brown@intel.com, feng.tang@intel.com,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, robert.moore@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] i915 black screen introduced by ACPI changes
In-Reply-To: <CANeU7Q=_+qt5C3G2uKhQYq_hh9kOg5c8=uAvjQzRwvx_xOe2hA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com> <20130219100849.72d2330b@jbarnes-desktop> <CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com> <20130219125217.6b6f55ff@jbarnes-desktop> <CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com> <CAKMK7uG7TgiAn0ZQ=E_-QBPNAVhTSxpORkX3Z1mY=54mgTzM-g@mail.gmail.com> <CANeU7QnMzYuG6iiU3nLh4k0dGFMEDOyfUDQgxQSKj20_y-oL+Q@mail.gmail.com> <CAKMK7uGDpSKga9=2SrGQDxBGzY5B1cGJAchZvfKfQy1ivRONMg@mail.gmail.com> <CANeU7Q=K4Adu3yokT182ZaG3hW04bhDiXhyZgjngd7Nn+JD3aQ@mail.gmail.com> <CANeU7QmMYERbg9fCnyGuDcEdzwfErNT4B_7YbAD7w243hWdaQQ@mail.gmail.com> <CANeU7Q=hbU89zfcrP15ZAqMYaZPhQzM4f7i71txQDmESt0J36w@mail.gmail.com> <CANeU7Q=ge+z=uzpWdvXbfpZ0vaA0C0bnZcPBad5zKGyj1DmLAA@mail.gmail.com> <CAKMK7uGGN6ikKr4KvaJJ7iLPgK2KwE5RsgUn=WqTtvU-ryM5nQ@mail.gmail.com> <CAKMK7uEc5R8WrdDaQWQPG-0L+uEFc_5idkvwKm2vvLDeOGQ3tA@mail.gmail.com> <CANeU7Q=rbfDXULOsMqVkGCOny5aECwqNjEwyab37pPhHfVBa4w@mail.gmail.com> <CANeU7Q=_+qt5C3G2uKhQYq_hh9kOg5c8=uAvjQzRwvx_xOe2hA@mail.gmail.com>
User-Agent: Notmuch/0.15.1+22~g943ed44 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 11 Mar 2013 15:16:08 +0200
Message-ID: <87txoit6uf.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Mar 2013, Chris Li <lkml@chrisli.org> wrote:
> On Mon, Mar 4, 2013 at 3:16 PM, Chris Li <lkml@chrisli.org> wrote:
>>>> Two things to test:
>>>> - Can you please check whether any of the backlight drivers in
>>>> /sys/class/backlight does anything? You need to frob the brightness
>>>> file. Please also list all the drivers you have.
>
> This is the kernel with the ACPI change causing the black screen.
>
> lrwxrwxrwx. 1 root root 0 Mar  4 15:20 acpi_video0 ->
> ../../devices/pci0000:00/0000:00:01.0/0000:01:00.0/backlight/acpi_video0
> lrwxrwxrwx. 1 root root 0 Mar  4 15:20 acpi_video1 ->
> ../../devices/pci0000:00/0000:00:02.0/backlight/acpi_video1
> lrwxrwxrwx. 1 root root 0 Mar  4 15:20 intel_backlight ->
> ../../devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight
>
> Here is the interesting part. The brightness and max_brightness is all
> set to 4648,
> However, the actual brightness is 0. The bl_power is also 0. I think
> you are on to some thing.

Hi Chris -

Interesting snippets from your dmesgs:

1) good

[    0.000000] Linux version 3.6.0-rc6+ (chrisl@ideapad.lan) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #25 SMP Wed Feb 20 12:55:06 PST 2013
...
[    5.341431] [drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[    5.341442] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[    5.342572] [drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[    5.342578] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4648

2) bad

[    0.000000] Linux version 3.8.0-rc7+ (chrisl@ideapad.lan) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #23 SMP Tue Feb 19 19:24:57 PST 2013
...
[    5.692853] [drm:asle_set_backlight], bclp = 0x800000ff
[    5.692865] [drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[    5.692870] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
[    5.693401] [drm:asle_set_backlight], bclp = 0x80000000
[    5.693408] [drm:intel_panel_get_max_backlight], max backlight PWM = 4648
[    5.693413] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0

(We've added another debug print to asle_set_backlight.)

For some reason we get two asle requests in a row. In the good kernel
it's the same request twice, in the bad kernel the second requests is
for 0 backlight. The register dumps seem to confirm this.

Please try a recent kernel, with and without the the bisected bad commit

commit a57f7f9175b8ccbc9df83ac13860488913115de4
Author: Bob Moore <robert.moore@intel.com>
Date:   Fri Aug 17 10:55:02 2012 +0800

    ACPICA: Add Windows8/Server2012 string for _OSI method.

reverted. Is the difference the same? Check reg dumps and dmesgs with
drm.debug=0xe.


Thanks,
Jani.
