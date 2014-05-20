Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaETHiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:38:52 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:52013 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaETHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140520055026.E3A98C412DA@trevor.secretlab.ca>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com>
	<20140514100856.5198DC4153D@trevor.secretlab.ca>
	<E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com>
	<CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com>
	<20140516105814.3EA3FC403C2@trevor.secretlab.ca>
	<CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com>
	<20140520055026.E3A98C412DA@trevor.secretlab.ca>
Date: Tue, 20 May 2014 09:38:49 +0200
X-Google-Sender-Auth: s5Y_1t_tFsgjBLmOHM6bUHwV1Lw
Message-ID: <CAMuHMdXjWENrq0MW-DU2x7WnaCsWyipN4DO=y0ZTL+3G_fPYGg@mail.gmail.com>
Subject: Re: [PATCH v4 2/8] OF: Introduce DT overlay support.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Tue, May 20, 2014 at 7:50 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> Why has the overlay system been designed for plugging and unpluging whole
>> overlays?
>> That means the kernel has to remember the full stack, causing issues with
>> e.g. kexec.
>
> Mostly so that drivers don't see any difference in the livetree data
> structure. It also means that userspace sees a single representation of
> the hardware at any given time.

Sorry, I don't follow the argument about the "single representation of the
hardware".

>> Why not allowing the addition of removal of subtrees of the full device
>> tree?
>
> Overlays is more than just a subtree. A single overlay can make
> manipulations of multiple subtrees that should be handled as logically
> atomic.

Sure, it's more complicated due to the atomicity of multiple changes.

>> This is similar to other hotpluggable subsystems (which are not necessarily
>> DT-based), like PCI Express. That way the kernel can pass a
>> DT-representation of the actual current device tree to a kexec'ed kernel.
>
> I'm not following you argument. Hardware hotplug systems like PCIe don't
> manipulate the firmware data. The kernel detects the new device and
> populates the Linux device model directly. Firmware provided data (ACPI
> or FDT) isn't involved.

I mean the kernel doesn't remember the exact order in a stack, to reverse
operations. E.g. I can add hotplug a PCIe bridge with multiple devices
behind it, and unplug a single device later. It's still one subtree, though.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
