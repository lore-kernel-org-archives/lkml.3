Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3CNUKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:10:44 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:50843 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3CNUKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <87txoit6uf.fsf@intel.com>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
	<20130219100849.72d2330b@jbarnes-desktop>
	<CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
	<20130219125217.6b6f55ff@jbarnes-desktop>
	<CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com>
	<CAKMK7uG7TgiAn0ZQ=E_-QBPNAVhTSxpORkX3Z1mY=54mgTzM-g@mail.gmail.com>
	<CANeU7QnMzYuG6iiU3nLh4k0dGFMEDOyfUDQgxQSKj20_y-oL+Q@mail.gmail.com>
	<CAKMK7uGDpSKga9=2SrGQDxBGzY5B1cGJAchZvfKfQy1ivRONMg@mail.gmail.com>
	<CANeU7Q=K4Adu3yokT182ZaG3hW04bhDiXhyZgjngd7Nn+JD3aQ@mail.gmail.com>
	<CANeU7QmMYERbg9fCnyGuDcEdzwfErNT4B_7YbAD7w243hWdaQQ@mail.gmail.com>
	<CANeU7Q=hbU89zfcrP15ZAqMYaZPhQzM4f7i71txQDmESt0J36w@mail.gmail.com>
	<CANeU7Q=ge+z=uzpWdvXbfpZ0vaA0C0bnZcPBad5zKGyj1DmLAA@mail.gmail.com>
	<CAKMK7uGGN6ikKr4KvaJJ7iLPgK2KwE5RsgUn=WqTtvU-ryM5nQ@mail.gmail.com>
	<CAKMK7uEc5R8WrdDaQWQPG-0L+uEFc_5idkvwKm2vvLDeOGQ3tA@mail.gmail.com>
	<CANeU7Q=rbfDXULOsMqVkGCOny5aECwqNjEwyab37pPhHfVBa4w@mail.gmail.com>
	<CANeU7Q=_+qt5C3G2uKhQYq_hh9kOg5c8=uAvjQzRwvx_xOe2hA@mail.gmail.com>
	<87txoit6uf.fsf@intel.com>
Date: Thu, 14 Mar 2013 13:10:40 -0700
X-Google-Sender-Auth: UWX7nl9mv81-j_dWq7nu2D-c0Zg
Message-ID: <CANeU7QmoW7EcmfPgzFqvo6UVjZnaYGp6UiB_4HP238v2SGhMRg@mail.gmail.com>
Subject: Re: [Intel-gfx] i915 black screen introduced by ACPI changes
From: Chris Li <lkml@chrisli.org>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, len.brown@intel.com,
        feng.tang@intel.com, intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, robert.moore@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 6:16 AM, Jani Nikula
<jani.nikula@linux.intel.com> wrote:
> Interesting snippets from your dmesgs:
>
> 1) good
>
> [    0.000000] Linux version 3.6.0-rc6+ (chrisl@ideapad.lan) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #25 SMP Wed Feb 20 12:55:06 PST 2013
> ...
> [    5.341431] [drm:intel_panel_get_max_backlight], max backlight PWM = 4648
> [    5.341442] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
> [    5.342572] [drm:intel_panel_get_max_backlight], max backlight PWM = 4648
> [    5.342578] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
>
> 2) bad
>
> [    0.000000] Linux version 3.8.0-rc7+ (chrisl@ideapad.lan) (gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) ) #23 SMP Tue Feb 19 19:24:57 PST 2013
> ...
> [    5.692853] [drm:asle_set_backlight], bclp = 0x800000ff
> [    5.692865] [drm:intel_panel_get_max_backlight], max backlight PWM = 4648
> [    5.692870] [drm:intel_panel_actually_set_backlight], set backlight PWM = 4648
> [    5.693401] [drm:asle_set_backlight], bclp = 0x80000000
> [    5.693408] [drm:intel_panel_get_max_backlight], max backlight PWM = 4648
> [    5.693413] [drm:intel_panel_actually_set_backlight], set backlight PWM = 0
>
> (We've added another debug print to asle_set_backlight.)
>
> For some reason we get two asle requests in a row. In the good kernel
> it's the same request twice, in the bad kernel the second requests is
> for 0 backlight. The register dumps seem to confirm this.
>
> Please try a recent kernel, with and without the the bisected bad commit

Hi, I did try the tip of Linus git tree. However I can't make the kernel
boot regardless bad commit or not. The kernel just hang there after grub2
load the kernel and initram image. It looks like a different problem than the
intel black screen because it don't even get to the point show any console
print out.

I will try the intel branch instead.

Chris
