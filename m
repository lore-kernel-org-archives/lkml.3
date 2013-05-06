Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3EFJEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:04:20 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:44856 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3EFJET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:04:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAPweEDz-Zp91zLG2H_bdj_Z5BSgKaXj6Hc8+OOp1_6Cm01xrFA@mail.gmail.com>
References: <CAPweEDym3TSEKWB1PsRWZ77irkTPF-Qdm9nRGfRBrv72CQ8zJA@mail.gmail.com>
	<51872CF6.5070409@gmail.com>
	<CAPweEDz-Zp91zLG2H_bdj_Z5BSgKaXj6Hc8+OOp1_6Cm01xrFA@mail.gmail.com>
Date: Mon, 6 May 2013 10:04:18 +0100
Message-ID: <CAAMvbhHy6iMweh1Pm_H1Oc2Z+TOypL-ACYnfsfQwzL2+0O3MFg@mail.gmail.com>
Subject: Re: device tree not the answer in the ARM world [was: Re: running
 Debian on a Cubieboard]
From: James Courtier-Dutton <james.dutton@gmail.com>
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        David Goodenough <david.goodenough@btconnect.com>,
        debian-arm@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The real problem with any new system, is the hardware is designed and
then it is a challenge for the software developer to get the software
to boot on the new hardware.
The nirvana here would be to take the original hardware circuit
diagram, and process it to automatically create a config file.
The config file would then be used by the software to configure itself
to boot the new hardware.
I think the device tree config file is going some way to help here.
X86 is lucky in that there are config standards out there, and people
are actually using them. PCI, USB, ACPI.
ARM is different and does not have this yet.
Also, so long as there is some way to uniquely identify the hardware
with, for example a model number, quirks can be written into the
software to handle special cases, and the config file identify which
quirks need to be used.
As more and more hardware manufactures report their quirks and device
drivers to the mainline kernel, the closer we will get to an automated
process to boot new hardware.
There are already efforts around the ARM multi-platform where a single
kernel can boot multiple ARM CPUs.
I suppose that ARM multi-platform will never cover all ARM CPUs, but
the more it covers, the easier and cheaper it will be to work with new
hardware and ARM.
Say, if a manufacturer has 20 different models of mobile phone out
there, all based on ARM.
Currently, they need a different kernel for each one. If they could
use the same kernel across all 20 models, that would reduce their
development costs considerably.



On 6 May 2013 07:53, Luke Kenneth Casson Leighton <lkcl@lkcl.net> wrote:
> On Mon, May 6, 2013 at 5:09 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
>
>>> and that's just within *one* of the fabless semiconductor companies,
>>> and you have to bear in mind that there are *several hundred* ARM
>>> licensees.  when this topic was last raised, someone mentioned that
>>> ARM attempted to standardise on dynamic peripheral publication on the
>>> internal AXI/AHB bus, so that things like device tree or udev could
>>> read it.  what happened?  some company failed to implement the
>>> standard properly, and it was game over right there.
>>
>>
>> Admittedly without knowing much background on the situation, that seems like
>> a bit of a cop-out.
>
>  i don't either - i may have the details / reasons wrong.  it's
> probably more along the lines of "as a general solution, because so
> few people adopted it plus because those who did adopt it got it wrong
> plus because it was too little too late everybody gave up"
>
>> In the PC world there are a bunch of devices that don't
>> follow standards properly (ACPI, PCI, etc.) and we add quirks or workarounds
>> and move on with life - people don't decide to abandon the standard because
>> of it.
>
>  in this case i believe it could be more to do with it being added
> some 15 years *after* there had been over 500+ ARM licensees who had
> already created huge numbers of CPUs, each of which is highly
> specialised but happens to share an instruction set.
>
>>
>>>
>>>
>>> are you beginning to see the sheer scope of the problem, here?  can
>>> you see now why russell is so completely overwhelmed? are you
>>> beginning to get a picture as to why device tree can never solve the
>>> problem?
>>
>>
>> I think part of the answer has to come from the source of all of these
>> problems: there seems to be this culture in the ARM world (and, well, the
>> embedded world generally) where the HW designers don't care what kind of
>> mess they cause the people who have to write and maintain device drivers and
>> kernels that run on the devices.
>
>  in a word... yes.  i think you summed it up nicely - that there's
> simply too much diversity for linux to take into account all on its
> own.  and u-boot.  and the pre-boot loaders [spl, part of u-boot].
>
>  but the question you have to ask is: why should the HW designers even
> care?  they're creating an embedded specialist system, they picked the
> most cost-effective and most available solution to them - why _should_
> they care?
>
>  and the answer is: they don't have to.  tough luck.  get over it, mr
> software engineer.  hardware cost reductions take priority.
>
>> In the PC world designers can't really do
>> many crazy things as the people doing drivers will tell them "What is this
>> crap? There's no way we can make this work properly in Windows". In the
>> embedded world the attitude is more like "Hey, it's Linux, it's open, we
>> know you can put in a bunch of crazy hacks to make this mess we created work
>> reasonably". So the designers have no reason to make things behave in a
>> standardized and/or sane manner.
>>
>> Obviously this is a longer-term solution
>
>  what is?  what solution?  you mean device tree? i'm still waiting for
> someone to put a comprehensive case together which says that device
> tree is a solution *at all*.
>
>  yes, sure, as someone on #arm-netbooks pointed out, device tree has
> helped them, personally, when it comes to understanding linux kernel
> source code and for porting of drivers to other hardware, because the
> GPIO to control the signals is separated out from the source code.
>
> but that only helps in cases where that one specific piece of hardware
> is re-used: we're talking THOUSANDS if not TENS of thousands of
> disparate pieces of hardware [small sensors with only 3 pins, all the
> way up to GPIO extender ICs with hundreds], where the majority of
> those device drivers never see the light of day due either to GPL
> violations, burdensome patch submission procedures and so on.
>
>  and in such cases, where the chances of code re-use are zero to none,
> what benefit does device tree offer wrt code re-use?  none!
>
>> and won't help with existing
>> devices, but in the long run device designers may need to realize the kind
>> of mess they're creating for the poor software people and try to achieve
>> some more standardization and device discoverability.
>
>  the economics of market forces don't work that way.
> profit-maximising companies are pathologically and *LEGALLY* bound to
> enact the articles of incorporation. so you'd need to show them that
> it would hurt their profits to continue the way that they are going.
>
>  fortunately, the linux kernel isn't bound by the same corporate
> rules, so if there *was* a solution, it would be possible to apply
> that solution and thus move everyone forward, kicking and screaming
> over a long period and turn things around.
>
>> Given the market
>> dominance of Linux in many parts of the embedded world, one thinks this
>> should be achievable.
>
>  working against that is the fact that there are only a few SoC
> companies with the expertise, they work in secret *without* consulting
> the linux kernel developers [as we well know], and the ODMs and
> factories simply run with whatever-the-SoC-vendors-put-their-way.
>
>  in fact, the factories usually have zero expertise: as far as they're
> concerned they might as well be making socks or jumpers rather than
> laptops or tablets and in some cases the owners of the factories
> really *do* have their staff making socks, jumpers or handbags as well
> as laptops or tablets [*1]
>
>  anyway, my point is that the problem which device tree set out to
> solve - that of the diversity in the ARM world - is an almost
> unsolvable problem in software.  i won't say "completely unsolvable".
>
>  device tree solves *some* problems, and generally makes things nice
> in certain cases, but it doesn't *actually* solve the problem it was
> originally designed to solve.
>
>  i'm still waiting to hear from someone - anyone - who recognises
> this, and i'm also still waiting to hear from people who may have an
> alternative solution or process which actually and truly helps solve
> the problem.  preferably on-list so that it can be discussed and
> properly reviewed.
>
> l.
>
> [*1] one day the factory owner woke up, probably around christmas five
> years ago when the UK's retail sector cartels Next, Top Shop etc.
> complained about Asda's George range of cheap clothing prices and
> demanded a monopolies review, causing huge shipping containers to sit
> outside of the UK in international waters for months] and went "my
> cash is all in clothing!  i must diversify!  i know, i'll buy some PCB
> printing equipment and some plastics moulding stamps, and make
> electronics appliances!".  this tells you everything you need to know
> about e.g. the problems that the KDE Plasma Vivaldi Spark Tablet has
> been having, as well as why there is a 98% GPL violations rate on
> low-cost tablet hardware.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
