Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253Ab3BSUSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:18:47 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:39379 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab3BSUSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:18:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130219100849.72d2330b@jbarnes-desktop>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
	<20130219100849.72d2330b@jbarnes-desktop>
Date: Tue, 19 Feb 2013 12:18:45 -0800
X-Google-Sender-Auth: _YQSG90jfli7zBkOXeaQ0h2_Vw4
Message-ID: <CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
Subject: Re: i915 black screen introduced by ACPI changes
From: Chris Li <lkml@chrisli.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, robert.moore@intel.com, feng.tang@intel.com,
        len.brown@intel.com, daniel.vetter@ffwll.ch,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC Linus for suggestion of debugging.

Linus, it seems very hard to extract information from the dead kernel.
Black screen prevents seeing the kernel OOPS, if there is one.
The laptop has no serial port. Ethernet driver is not working on that
laptop. Only wifi works.

Any suggestion?

On Tue, Feb 19, 2013 at 10:08 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> The black screen happens about the time kernel switch to using VT console.
>> At the point of black screen, no response of cap locks key led no network
>> connection. The machine seems dead.
>
> Can you set up netconsole and see if you can get any output from the
> boot, if we're lucky maybe you'll see a panic...

The kernel does not support the Gigabit Ethernet on that laptop.
I am not sure netconsole through wifi will work or not in that early
stage of the boot up. There seems to be a out of kernel driver
to support that ethernet card, but I haven't able to get to compile
on FC18.

Last time I try the kernel crashdump it does not seem to produce
dump. I can give it more try and get back to you.

BTW, does any one know limiting the kernel memory via "mem=1024M"
will work with the kernel crashdump? The laptop has 8G of memory, it will take
a long time to dump all the memory.

>
>> The CPU is i7 and it has two video card. The Intel build-in video card
>> and Gtx 660M Nvidia card.
>>
>> This is very annoying. I did some poking around it:
>> - It was fine on the FC18 3.6.xxx kernel before the upgrade.
>> - The black screen exists with FC18 3.7.xxx kernel
>> - The black screen also exists in latest tip of linux-2.6.
>> - Switch to multi-user mode booting does not get rid of the black screen.
>> - Get rid of the "rhrb quit" does not help either.
>> - When the black screen happen, cap lock LED does not response to cap locks.
>> - No networking when black screen happen. The only thing to do is
>> reboot the system.
>> - Adding "i915.modeset=0" will allow the kernel to boot into GUI login. However,
>>   logout of X will cause the machine to hang similar to the black screen.
>> - Suspend and resume will get stuck at the black screen with"i915.modeset=0".
>> - Kernel console and X is using the Intel driver for display.
>
> I don't know about the ACPI change mentioned, but ACPI is involved in
> dual-GPU configurations.  Maybe the change affected the default
> behavior and pointed more functions at the nVidia device rather than
> the Intel?

I don't think so. First of all, I want to clarify that I did the experiment
without the Nvidia commercial driver. I even blacklist the nouveau
driver it does
not change the test result. In that case, I assume the functions at
the nVidia driver
does not come into play. No?

Secondly, the one clue is that, setting "i915.modeset=0" alone will allow
the kernel to boot into X GUI login. It seems that the mode switch alone in
i915 can trigger the black screen. It is consistent with kernel lockup when I
logout of X desktop, where X want to reset the screen.

Instead of guess which driver were at fault, can you suggest some experiment
to confirm or denial which driver is at fault?

Chris
