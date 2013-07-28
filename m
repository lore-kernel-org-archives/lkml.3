Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab3G1OKC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 10:10:02 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:50329 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab3G1OKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 10:10:00 -0400
MIME-Version: 1.0
In-Reply-To: <2529481.u8xHuXumcd@flatron>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	<1416484.XDfk5G56BI@flatron>
	<20130728131901.GA8864@netboy>
	<2529481.u8xHuXumcd@flatron>
Date: Sun, 28 Jul 2013 10:09:57 -0400
Message-ID: <CAKON4OzReTRb5JnJE+07vNJ-uDndLfqq8ha04J7K3x=WtsZEWw@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Arend van Spriel <arend@broadcom.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 9:39 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Sunday 28 of July 2013 15:19:03 Richard Cochran wrote:
>> On Sun, Jul 28, 2013 at 11:12:53AM +0200, Tomasz Figa wrote:
>> > I'm not really sure what effect on users this has. Maybe you should
>> > define "users".
>>
>> ...
>>
>> > Care to explain this reasoning?
>>
>> Use Case
>> ~~~~~~~~
>>
>> User acquires a machine running ARM Linux version 3.x, with u-boot
>> and dtb in a read only flash partition. The board boots and works just
>> fine. However, for his application, the user requires a new kernel
>> feature that appeared in version 3.y where y > x. He compiles the new
>> kernel, and it also works.
>
> Generally the user does not care where the dtb is stored. He just want to
> upgrade the kernel without thinking about internals.
>
> There are many possible options:
>
> a) The BSP packaging script he received from board vendor, or even kernel
> build system, builds dtb from kernel sources and appends it to built
> zImage. He just flashes the zImage and everything is working correctly.
>
>   This is pretty common case today, as many boards still use legacy
>   bootloaders without native support for DT. See the analogy to board
>   files, being compiled as a part of kernel sources.
>
> b) The user always compiles the kernel and dtb and flashes both at the
> same time.
>
>   This does not differ at all to flashing the kernel alone, except two
>   files, not one, need to be flashed.

c) Use a quirk system to map ROM based DTB's.

3.x kernel was matched to dtb that is flashed into boot rom.
Everything was initially ok.

The 3.y kernel is built with init time quirks that map the dtb from
3.x format  into the 3.y format. These quirks can be easily built
since we know the generic schema from both 3.x and 3.y. Mapping ten
year old power PC dtbs may involve more code.

These quirks aren't going to be large, it's not like the entire schema
is going to change on each kernel release.  They are just going to
make a best effort to map the dtb in ROM into something the 3.y kernel
can understand. Owners of these ROMs will complain loudly if the
quirks aren't right.

3.z kernel is free to alter the schema. But it will have to supply the
necessary quirks needed to keep those old dtb's functioning.

>
> By the way, in use case you are describing, changes that dtb wouldn't have
> to be updated are very low, unless the one present in read only memory of
> the board is complete, i.e. fully describes all the available hardware,
> which is unlikely for a dtb built at time of 3.x availability, whenever
> the feature showed up in 3.y (y > x). The user will most likely have to
> update the dtb anyway.
>
> Please note, though, I'm _not_ trying to convince you that this kind of
> solutions is good, as I'm not convinced either. That's why we are
> discussing this.
>
> Best regards,
> Tomasz
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Jon Smirl
jonsmirl@gmail.com
