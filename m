Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935687AbaH0Sa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:30:28 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:38638 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935147AbaH0Sa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:30:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAOiHx=mZPt=p_jw4fyEqgniJvqunQ86ro_Run5ZtD1zLYWzmqA@mail.gmail.com>
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org>
	<CAGVrzcZobuL4z0WNX+Sz4p_uwaPL-S5yvEmgRUwZPJi4+qq0tg@mail.gmail.com>
	<CAL1qeaGb-o0P7x4nZPJ+dGfoSKz+2ANrB0gGrBi19TtPxVTAZQ@mail.gmail.com>
	<20140823063113.GC23715@localhost>
	<CAMuHMdXudu0kuOkKN8JCrWZSrQ4awKHhHU0E2ss++ProP0rteQ@mail.gmail.com>
	<CAOiHx=mZPt=p_jw4fyEqgniJvqunQ86ro_Run5ZtD1zLYWzmqA@mail.gmail.com>
Date: Wed, 27 Aug 2014 11:30:25 -0700
X-Google-Sender-Auth: gSKCX90fjPFKKMmxN0pywTF2gKY
Message-ID: <CAL1qeaFTw=0XMEkag1Z8C4jKkWnwBeGJLYxHGiYfKXBk-9o0Yw@mail.gmail.com>
Subject: Re: [PATCH 0/7] MIPS: Move device-tree files to a common location
From: Andrew Bresticker <abrestic@chromium.org>
To: Jonas Gorski <jogo@openwrt.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Olof Johansson <olof@lixom.net>,
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

On Mon, Aug 25, 2014 at 8:17 AM, Jonas Gorski <jogo@openwrt.org> wrote:
> On Sat, Aug 23, 2014 at 9:50 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Sat, Aug 23, 2014 at 8:31 AM, Olof Johansson <olof@lixom.net> wrote:
>>>> > arch/arm/boot/dts/<vendor>/
>>>> >
>>>> > Is this something we should do for the MIPS and update the other architectures
>>>> > to follow that scheme?
>>>>
>>>> I recall reading that as well and that it would be adopted for ARM64,
>>>> but that hasn't seemed to have happened.  Perhaps Olof (CC'ed) will no
>>>> more.
>>>
>>> Yeah, I highly recommend having a directory per vendor. We didn't on ARM,
>>> and the amount of files in that directory is becoming pretty
>>> insane. Moving to a subdirectory structure later gets messy which is
>>> why we've been holding off on it.
>>
>> It would mean we can change our scripts to operate on "interesting"
>> DTS files from
>>
>>      do-something-with $(git grep -l $vendor, -- arch/arm/boot/dts)
>>
>> to
>>
>>     do-something-with arch/arm/boot/dts/$vendor/*
>>
>> which is easier to type...
>
> Btw, do you mean chip-vendor or device-vendor with vendor?
> Device-vendor could get a bit messy on the source part as the router
> manufacturers tend to switch them quite often. E.g. d-link used arm,
> mips and ubi32 chips from marvell, ubicom, broadcom, atheros, realtek
> and ralink for their dir-615 router, happily switching back and forth.
> There are 14 known different hardware revisions of it where the chip
> differed from the previous one.

I'm going to assume it means chip/SoC vendor.  That would result in
the following structure (I think):

Octeon -> cavium/
Lantiq -> lantiq/
Netlogic -> netlogic/ (or should this now be brcm/?)
SEAD-3 -> mti/
Ralink -> ralink/
