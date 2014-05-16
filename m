Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbaEPLwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:52:45 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54609 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaEPLwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:52:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140516105814.3EA3FC403C2@trevor.secretlab.ca>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1396615441-29630-3-git-send-email-pantelis.antoniou@konsulko.com>
	<20140514100856.5198DC4153D@trevor.secretlab.ca>
	<E204285C-D6CD-4518-A94F-26BF0570C1B1@konsulko.com>
	<CAMuHMdUWfQ=2xPhNsS36mT6nv-CfR3_1exZ+5qYgdkjbBntrWg@mail.gmail.com>
	<20140516105814.3EA3FC403C2@trevor.secretlab.ca>
Date: Fri, 16 May 2014 13:52:42 +0200
X-Google-Sender-Auth: 6eVzT1mpK1ABib0NAyjq09AHMAs
Message-ID: <CAMuHMdWw39n8O0fFWECR6v6GaEJ3aB5S3ront4eDdXwxNO6Fgw@mail.gmail.com>
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

On Fri, May 16, 2014 at 12:58 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Thu, 15 May 2014 09:20:24 +0200, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Thu, May 15, 2014 at 9:12 AM, Pantelis Antoniou
>> <pantelis.antoniou@konsulko.com> wrote:
>> >> We also need to think about kexec. Kexec works by sucking the live tree
>> >> out of the kernel and creating a .dtb from it to pass to the new kernel.
>> >> What will the rules be when kexecing? Do all the overlays need to be
>> >> removed, or does the kernel get the tree with all the overlays applied
>> >> (in which case none of the overlays can be removed on the other side of
>> >> kexec).
>> >
>> > We can add a sysfs attribute that configures whether overlays are reverted before
>> > kexec or not. I can't really tell which is the correct option, so let's allow the
>> > policy up to user-space.
>>
>> Kexec'ing into a new kernel doesn't change the hardware, so IMHO the
>> in-kernel DT should not change.
>
> Conceptually though, if overlays are applied then the new kernel has a
> different tree from the old one. If the overlay is hotpluggable, then
> after the kexec, the new kernel would no longer be able to unplug the
> overlay if it uses the current state of the tree instead of pulling the
> overlays off first.

Which brings me to another question...

Why has the overlay system been designed for plugging and unpluging whole
overlays?
That means the kernel has to remember the full stack, causing issues with
e.g. kexec.

Why not allowing the addition of removal of subtrees of the full device
tree?
This is similar to other hotpluggable subsystems (which are not necessarily
DT-based), like PCI Express. That way the kernel can pass a
DT-representation of the actual current device tree to a kexec'ed kernel.

I missed the initial design discussions, so forgive me if this has been
beaten to death before.

Thanks for your answers!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
