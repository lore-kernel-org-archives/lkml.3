Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaAPJ3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:29:50 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:53167 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaAPJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:29:45 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzcHCg1Azf0t4KrYx0N1z0xaeT8fNHJEW5og3VBd+UPOA@mail.gmail.com>
References: <CA+55aFzcHCg1Azf0t4KrYx0N1z0xaeT8fNHJEW5og3VBd+UPOA@mail.gmail.com>
Date: Thu, 16 Jan 2014 10:29:45 +0100
Message-ID: <CACRpkdZqdaq7qqwhvfufa9BNUAeO4CFAr6g4uqXvbe5wsAYaQQ@mail.gmail.com>
Subject: Re: Baytrail problems (was Re: Linux 3.13-rc8)
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Paul Drews <paul.drews@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 2:49 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Adding in the appropriate people...
>
> On Tue, Jan 14, 2014 at 7:01 PM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
>>
>> It seems to hate Baytrail/T
>>
>> My ASUS T100TA has gone from 3.11 'needs video=VGA-1:blah' to get the mode
>> right but otherwise running nicely and playing 3D games to 3.13-rc8
>>
>> - crashes and burns during boot if the Baytrail pinctrl driver is compiled
>>   in
>
> Andy, Paul? The changes to the pinctrl driver since 3.11 look trivial,
> but I guess the GPIO and ACPI ID addition ends up also enabling all
> the old code that Alan probably never ran in 3.11 because the driver
> didn't trigger on his machine.

So that is commit f6308b36c411dc5
"ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs"?

This seems to have been selected for -stable as well so the
problem will be spreading as distros start pushing stable kernel
updates :-(

That came in through the ACPI tree, Rafael do you want to
revert it if there is no better quickfix?

This adds an interesting twist to the general statement that
new PCI/ACPI IDs should go into stable BTW, maybe they
should not always do that.

Yours,
Linus Walleij
