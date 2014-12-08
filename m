Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbaLHKzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:55:54 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:42511 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaLHKzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:55:52 -0500
MIME-Version: 1.0
In-Reply-To: <1418009702.19126.14.camel@rzhang1-toshiba>
References: <CA+r1ZhhoskOXaRSmcrnbdgapi-FsaKf+dnPHTXGkDvkYbvwQ8Q@mail.gmail.com>
	<543F88BE.4090307@intel.com>
	<20141017070620.GA1538@aaronlu.sh.intel.com>
	<20141017072236.GA12504@aaronlu.sh.intel.com>
	<544F33AF.1000704@intel.com>
	<20141107191127.GB27438@developer>
	<1417350176.27484.10.camel@rzhang1-toshiba>
	<547D59D2.8010906@intel.com>
	<1418009702.19126.14.camel@rzhang1-toshiba>
Date: Mon, 8 Dec 2014 11:55:49 +0100
X-Google-Sender-Auth: NdywWETlyx3cwddwsjEqnWf9SZI
Message-ID: <CAMuHMdWHn+BcpPjr7x+Y1aRwUgBP54mH=4XpjB1VOd7T76-kjw@mail.gmail.com>
Subject: Re: [PATCH] Thermal: introduce INT3406 thermal driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Eduardo Valentin <edubezval@gmail.com>,
        Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 4:35 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> On Tue, 2014-12-02 at 14:18 +0800, Aaron Lu wrote:
>> On 11/30/2014 08:22 PM, Zhang Rui wrote:
>> > On Fri, 2014-11-07 at 15:11 -0400, Eduardo Valentin wrote:
>> >> Hi,
>> >>
>> >> On Tue, Oct 28, 2014 at 02:11:59PM +0800, Aaron Lu wrote:
>> >>> Jim found that the current kernel may trigger a build error with some
>> >>> config: drivers/built-in.o: In function `int3406_thermal_probe':
>> >>> int3406_thermal.c:(.text+0x1d10b8): undefined reference to
>> >>> `acpi_video_get_levels'. The problem happens when CONFIG_THERMAL=y and
>> >>> CONFIG_ACPI_VIDEO=m. Solve the problem by separating a kernel config for
>> >>> int3406 thermal driver and add dependency on ACPI video for it.
>> >>>
>> >>> Reported-by: Jim Davis <jim.epost@gmail.com>
>> >>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> >>
>> > Aaron, this is an incremental patch on top of the INT3406 driver patch.
>> > As, both patches have not been shipped in Linus' tree, please merge
>> > these two patches altogether and resend.
>>
>> OK, here it is:
>>
>> From 02d7abdcfe138e6cdee7572b10addce4f56d89eb Mon Sep 17 00:00:00 2001
>> From: Aaron Lu <aaron.lu@intel.com>
>> Date: Wed, 3 Sep 2014 15:15:02 +0800
>> Subject: [PATCH] Thermal: introduce INT3406 thermal driver
>>
>> INT3406 ACPI device object resembles an ACPI video output device, but its
>> _BCM is said to be deprecated and should not be used. So we will make
>> use of the raw interface to do the actual cooling. Due to this, the
>> backlight core has some modifications. Also, to re-use some of the ACPI
>> video module's code, one function has been exported.
>>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>
> applied.

Unfortunately drivers/thermal/int340x_thermal/Kconfig was missing
from the patch, hence "make oldconfig" now fails miserably with

drivers/thermal/Kconfig:265: can't open file
"drivers/thermal/int340x_thermal/Kconfig"

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
