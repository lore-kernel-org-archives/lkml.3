Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaENDYW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:24:22 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:59316 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbaENDYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:24:18 -0400
Subject: Re: [PATCH v2] ARM: dts: am335x-bone-common: Add i2c2 definition
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@gmail.com>
In-Reply-To: <CABxcv=mWqENSzODJYAJRgDYNy46X6WkQ+0e4NSDt8qE-ob1KuQ@mail.gmail.com>
Date: Tue, 13 May 2014 20:24:14 -0700
Cc: Matt Porter <matt.porter@linaro.org>, Tom Rini <trini@ti.com>,
        Robert Nelson <robertcnelson@gmail.com>,
        Tony Lindgren <tony@atomide.com>, Matt Ranostay <mranostay@gmail.com>,
        robh+dt@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <47F0EEF7-3716-418B-9049-00BB2BD5BFC6@gmail.com>
References: <1399686184-1594-1-git-send-email-mranostay@gmail.com> <20140512195050.GB5668@atomide.com> <CAOCHtYiYwx_bEsyqkbUTTAbhBYESzvfBOOYeVuFXPS1dDy0ZKA@mail.gmail.com> <20140512201517.GC5668@atomide.com> <CAOCHtYg6XpF0Gbo4iFqsFvP=QSivQQvCzov8UfxeLXMzrRYEWw@mail.gmail.com> <20140512204213.GD5668@atomide.com> <CAOCHtYgg7jwxswH+mqF3RA7-0RP-nGuft+Ze-GRwu1fbA6+0Bw@mail.gmail.com> <537215D3.70306@ti.com> <CABxcv=nq9XvyN0aPOBFDm0UyoaW-Htyy0tyP3YhYaDnDUo3a5w@mail.gmail.com> <20140513142252.GG32082@beef> <CABxcv=mSs71pS1PAS-WdP0ru_Eb1XhXEm1qCCKW7=aL7EN4FgQ@mail.gmail.com> <4BCFCB24-9732-4B96-B814-5290CA2D0EE4@gmail.com> <CABxcv=mWqENSzODJYAJRgDYNy46X6WkQ+0e4NSDt8qE-ob1KuQ@mail.gmail.com>
To: Javier Martinez Canillas <javier@dowhile0.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On May 13, 2014, at 10:51 AM, Javier Martinez Canillas wrote:

> Hello Pantelis,
> 
> On Tue, May 13, 2014 at 7:07 PM, Pantelis Antoniou
> <pantelis.antoniou@gmail.com> wrote:
>> Hi Javier,
>> 
>> On May 13, 2014, at 7:39 AM, Javier Martinez Canillas wrote:
>> 
>>> On Tue, May 13, 2014 at 4:22 PM, Matt Porter <matt.porter@linaro.org> wrote:
>>>> On Tue, May 13, 2014 at 04:06:02PM +0200, Javier Martinez Canillas wrote:
>>>>> On Tue, May 13, 2014 at 2:53 PM, Tom Rini <trini@ti.com> wrote:
>>>>>> On 05/12/2014 04:57 PM, Robert Nelson wrote:
>>>>>>>>> Either case if fine with me.  As who knows when the dtc "overlay" will
>>>>>>>>> every truly make it mainline, as the capemgr was the only real kernel
>>>>>>>>> user of the i2c/at24 eeprom information.
>>>>>>>> 
>>>>>>>> Sounds like we should keep it disabled though so u-boot can be used
>>>>>>>> to toggle it while waiting for the capemgr. That's because the board
>>>>>>>> has a header for pins, so it's not exactly limited to just the capes.
>>>>>>>> 
>>>>>>>> Anybody working on enabling/disabling cape dtb configurations in u-boot?
>>>>>>> 
>>>>>>> Well,
>>>>>>> 
>>>>>>> Would Tom even approve of that in mainline u-boot? He didn't want my
>>>>>>> "invert" the gpio to enable the usb hub on the older beagle xm A/B..
>>>>>>> 
>>>>>>> http://lists.denx.de/pipermail/u-boot/2014-January/172154.html
>>>>>>> 
>>>>>>> http://lists.denx.de/pipermail/u-boot/2014-January/172274.html
>>>>> 
>>>>> Using fdt set from the bootloader to use the same FDT for similar
>>>>> boards (like the example with Beagle xM variants) is kind of trying to
>>>>> replicate what we used to do from boards files where it was possible
>>>>> to manage a set of boards using the same platform code.
>>>>> 
>>>>> But Device Trees are meant to describe hardware and thus should be
>>>>> static, if two board are almost identical but slightly different, then
>>>>> are two different hardware where each need its proper FDT that
>>>>> describes it.
>>>>> 
>>>>>> 
>>>>>> I would think that using the 'fdt' command in U-Boot to add all
>>>>>> properties of every cape found on a running system would drive someone
>>>>>> to madness quite quickly.  Moving all of Pantelis' work for dynamic
>>>>>> device trees from the kernel to N bootloaders (U-Boot, barebox, UEFI,
>>>>>> etc) sounds like a step in the wrong direction.
>>>>>> 
>>>>> 
>>>>> Agreed. I think that until the device tree overlay and the cape
>>>>> manager find their way into mainline we should treat capes as if they
>>>>> were expansion boards attached to a Computer-on-Module. That is, a
>>>>> static based board which its own DTS including the BB{B,W} as an dtsi
>>>>> and not something that can be added on runtime.
>>>> 
>>>> It's far more complicated than a SOM plus carrier board. Consider that
>>>> you can have any 4 of these capes stacked on the BBB/BBW in any
>>>> combination (assuming no resource conflicts). Capturing all possible
>>>> combinations in static dtsis is not practical.
>>>> 
>>> 
>> 
>> Since this appears to be all coming back to DT overlays, let me try to
>> address some points.
>> 
> 
> It seems that you misunderstood my comments. I do think that DT
> overlays and the cape manager are a great solution for any hardware
> that could be expanded on runtime and I really hope that they can
> eventually land into mainline.
> 
> In fact if you look on my previous mail you will see that I said:
> "until device tree overlay and the cape manager find their way into
> mainline..."
> 
>>> Right, I forgot that the capes were stackable so is indeed not
>>> practical to model every single combination as DTS in mainline. Even
>>> if stacking was not possible there are just too many capes out there
>>> to have a DTS for every single cape.
>>> 
>> 
>> Each cape does have a DTS as dynamically loaded fragment; it works absolutely fine.
>> 
>> Trying to come up with a base DTS for all the capes you've stacked up
>> is an exponential problem.
>> 
>>> My point was that someone who wants to use a BBB + a set of capes can
>>> today write a DTS for its own stacked setup.
>>> 
>> 
>> No, the guy that designs a cape (or learns how to) can not write a DTS for
>> the base board and the cape in question. Doing that he essentially cuts
>> himself off from the community.
>> 
>> Let me explain, the point is for people to easily design capes, open-source their
>> design as well as their software, and share them to the community.
>> 
>> This requires that things are easily shareable.
>> 
>> Requiring a relative newbie in kernel development not only generate his own
>> base DT, but also to merge all of the other capes DT into his own is a
>> nightmare.
>> 
>> BTW, on another tangent, it's not just the BB people that care about dynamic
>> hardware configuration. There are a number of FPGA people that seem interested
>> as well.
>> 
>> The notion of hardware as something static that never changes is obsolete IMHO.
>> 
>>> Unfortunately I don't have a solution but what I'm pretty sure is that
>>> mangling the DTS from the bootloader is not the right one :-)
>>> 
>> 
>> No, it is not. And this is what we're trying to solve here.
>> 
> 
> What I said that I'm against is modifying a FDT using U-Boot scripts
> commands that is something that mentioned in this thread. That is not
> a robust way to do it and also is not something that a newbie could do
> it neither.
> 
> Also, doing these FDT changes in the bootloader has several
> disadvantages, besides having to implement on each bootloaders like
> Tom said, you need to upgrade your bootloader which is something that
> just can't be done on many boards and also is still a static
> configuration since you need to reboot in order to use a different
> FDT. So the hardware can't really be expanded on runtime unlike with
> DT overlays where the overlays are loaded from regular files.
> 
> But I guess you agree with me on all those points and you just
> misunderstood my comments. So DT overlays is definitely the way to go
> (or something similar) but my point is that until we have that
> solution merged, you can use a static DT in mainline for your stacked
> cape or use a vendor kernel that already has DT overlays support.
> 
> I hope I explained myself better this time ;-)
> 

Heh, no worries :)

I guess I'm a little jumpy since this discussion feels like a glitch in the matrix for me :)

> Best regards,
> Javier

Regards

-- Pantelis

> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

