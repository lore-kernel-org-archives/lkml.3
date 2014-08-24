Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaHXXn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 19:43:58 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:39382 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaHXXn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 19:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140823161456.GA2758@localhost>
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org>
 <CAL1qeaGb-o0P7x4nZPJ+dGfoSKz+2ANrB0gGrBi19TtPxVTAZQ@mail.gmail.com>
 <20140823063113.GC23715@localhost> <201408231556.42571.arnd@arndb.de> <20140823161456.GA2758@localhost>
From: Rob Herring <robherring2@gmail.com>
Date: Sun, 24 Aug 2014 18:43:35 -0500
Message-ID: <CAL_JsqLGdZRFXni0Y5Loij3FVfw8RzaizNaRA+_hccXz0opkKw@mail.gmail.com>
Subject: Re: [PATCH 0/7] MIPS: Move device-tree files to a common location
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Bresticker <abrestic@chromium.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, John Crispin <blogic@openwrt.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jayachandran C <jchandra@broadcom.com>,
        Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 11:14 AM, Olof Johansson <olof@lixom.net> wrote:
> On Sat, Aug 23, 2014 at 03:56:42PM +0200, Arnd Bergmann wrote:
>> On Saturday 23 August 2014, Olof Johansson wrote:
>> > On Fri, Aug 22, 2014 at 02:10:23PM -0700, Andrew Bresticker wrote:
>> > > On Fri, Aug 22, 2014 at 1:42 PM, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> > > >
>> > > > On Aug 21, 2014 3:05 PM, "Andrew Bresticker" <abrestic@chromium.org> wrote:
>> > > > >
>> > > > > To be consistent with other architectures and to avoid unnecessary
>> > > > > makefile duplication, move all MIPS device-trees to arch/mips/boot/dts
>> > > > > and build them with a common makefile.
>> > > >
>> > > > I recall reading that the ARM organization for DTS files was a bit unfortunate
>> > > > and should have been something like:
>> > > >
>> > > > arch/arm/boot/dts/<vendor>/
>> > > >
>> > > > Is this something we should do for the MIPS and update the other architectures
>> > > > to follow that scheme?
>> > >
>> > > I recall reading that as well and that it would be adopted for ARM64,
>> > > but that hasn't seemed to have happened.  Perhaps Olof (CC'ed) will no
>> > > more.
>> >
>> > Yeah, I highly recommend having a directory per vendor. We didn't on ARM,
>> > and the amount of files in that directory is becoming pretty
>> > insane. Moving to a subdirectory structure later gets messy which is
>> > why we've been holding off on it.
>>
>> Another argument is that we plan to actually move all the dts files out of
>> the kernel into a separate project in the future. We really don't want to
>> have the churn of moving all the files now when they get deleted in one
>> of the next merge windows.
>
> To be honest, I don't see that happening within the forseeable
> future. Some of us maintainers like talking about this, but everyone who
> actually develops have nightmares about this scenario. Nobody knows how
> it'll be done without causing some real serious impact on productivity.
>
>> I don't know if we talked about whether that move should be done for
>> all architectures at the same time. If that is the plan, I think it
>> would be best to not move the MIPS files at all but also wait until
>> they can get removed from the kernel tree.
>
> If MIPS can restructure now before things start growing, then I'd really
> recommend that they do so and not hold off waiting on some event that
> might never happen. :)

Yes, I agree on both points.

Rob
