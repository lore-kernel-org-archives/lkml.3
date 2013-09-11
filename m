Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab3IKUVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:21:18 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48918 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3IKUVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbLVC2==zpNV1zV3OoiSQoKfptAGqF1EQNtrhFUCn=0h7A@mail.gmail.com>
References: <CACxGe6v8hO4sRX_KGcH=YBAMrF8mQHqWdxXEvVwoC2pVS5Yv9Q@mail.gmail.com>
	<CA+bK7J5cAWFPLTBR2afNLm2JaKFH4_dJO_NpVL5gom0iX+L2dQ@mail.gmail.com>
	<CA+55aFzBbKXJnaG_6X8Fff_APGJ3EkbG0thsbithDXtiEJjdHA@mail.gmail.com>
	<CA+8MBbLVC2==zpNV1zV3OoiSQoKfptAGqF1EQNtrhFUCn=0h7A@mail.gmail.com>
Date: Wed, 11 Sep 2013 13:21:15 -0700
Message-ID: <CA+bK7J4s1y5-CfwmNB3gN5Ed800AnuH6vHe8+jRmq+pyPu9o0A@mail.gmail.com>
Subject: Re: [GIT PULL] Device tree updates for v3.12
From: Tim Bird <tbird20d@gmail.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.  This gives me an order-of-magnitude measurement for this sort of thing.
I'll measure it directly myself on our hardware as soon as I can.

I've heard an ugly rumor that the device tree from our silicon vendor
may grow to be
as big as 130K in the near future. I'm still following up to see if
there's any truth
to this (so don't quote me on it), but if it does get that big it
might be an issue.  As
stated previously, the vast majority of our device tree files consists
of values that
are not device-specific.

I'll keep an eye on it and propose something if it turns out to be a real issue.


On Wed, Sep 11, 2013 at 10:02 AM, Tony Luck <tony.luck@gmail.com> wrote:
> On Tue, Sep 10, 2013 at 1:50 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Of course, maybe even the stupid add_device_randomness() is fast
>> enough. I just wanted to point out that it definitely isn't some
>> optimized thing.
>
> When I posted the patch that mixes in the whole SMBIOS table:
>
> commit d114a33387472555188f142ed8e98acdb8181c6d
> Author: Tony Luck <tony.luck@intel.com>
> Date:   Fri Jul 20 13:15:20 2012 -0700
>
>     dmi: Feed DMI table to /dev/random driver
>
> I asked whether there was any size issue - as it tends to be a few
> kilobytes on laptops and desktops, and tens of kilobytes on servers.
> The answer I got back then was not to worry - digesting a few kilobytes
> wouldn't be a problem.  I just threw in a debug message to check and saw:
>
> dmi_walk_early: added 10342 bytes in 339968 cycles
>
> So a couple of hundred microseconds for me.
>
> There are plenty of machine specific values buried in there (e.g. serial
> numbers for all the DIMMs) ... so this looks like a good use of this
> much boot time.
>
> -Tony



-- 
 -- Tim Bird
Senior Software Engineer, Sony Mobile
Architecture Group Chair, CE Workgroup, Linux Foundation
