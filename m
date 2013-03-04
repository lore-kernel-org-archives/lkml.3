Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab3CDRuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:50:16 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50984 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab3CDRuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:50:14 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAKMK7uGGN6ikKr4KvaJJ7iLPgK2KwE5RsgUn=WqTtvU-ryM5nQ@mail.gmail.com>
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
Date: Mon, 4 Mar 2013 18:50:13 +0100
Message-ID: <CAKMK7uEc5R8WrdDaQWQPG-0L+uEFc_5idkvwKm2vvLDeOGQ3tA@mail.gmail.com>
Subject: Re: i915 black screen introduced by ACPI changes
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Li <lkml@chrisli.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        robert.moore@intel.com, feng.tang@intel.com, len.brown@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meh, forgotten to actually cc more lists ...
-Daniel

On Mon, Mar 4, 2013 at 6:49 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Mon, Mar 4, 2013 at 6:11 PM, Chris Li <lkml@chrisli.org> wrote:
>> To recap, the black screen first show up after the ACPI change to use widows 8
>> string. The i915_setmode function did not crash. The printk output
>> from that function seems the same as the one that is in 3.6 kernel.
>> I also include the 3.6 and 3.7 kernel dmesg. The black screen is 100%
>> reproducible.
>>
>> Any suggestion how to further debug this i9515 black screen problem?
>> I really want to get it fixed.
>
> Sorry for missing out on this one, I'll add a few more mailing lists to.
>
> Backlight issues themselves are usually a pain. I've looked through
> your debug dmesg and there doesn't seem to be anything bad going on.
>
> Two things to test:
> - Can you please check whether any of the backlight drivers in
> /sys/class/backlight does anything? You need to frob the brightness
> file. Please also list all the drivers you have.
> - Please grab the lates git of intel-gpu-tools and attach the output
> of intel_reg_dumper for both a working and a broken kernel. The git
> tree is at:
>
> http://cgit.freedesktop.org/xorg/app/intel-gpu-tools/
>
> Since backlight bugs usually take a lot of poking to figure out it
> might be good to keep things together in a bugzilla report.
> bugs.freedesktop.org, DRI -> DRM (Intel) is the preferred location,
> please file a report there and attach the dump files (and the debug
> dmesg logs we've gathered already).
>
> Thanks, Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
