Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3EFEPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:15:38 -0400
Received: from mail-ye0-f172.google.com ([209.85.213.172]:43876 "EHLO
	mail-ye0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3EFEPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:15:36 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 May 2013 00:15:36 EDT
Message-ID: <51872CF6.5070409@gmail.com>
Date: Sun, 05 May 2013 22:09:26 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
CC: David Goodenough <david.goodenough@btconnect.com>,
        debian-arm@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Subject: Re: device tree not the answer in the ARM world [was: Re: running
 Debian on a Cubieboard]
References: <CAPweEDym3TSEKWB1PsRWZ77irkTPF-Qdm9nRGfRBrv72CQ8zJA@mail.gmail.com>
In-Reply-To: <CAPweEDym3TSEKWB1PsRWZ77irkTPF-Qdm9nRGfRBrv72CQ8zJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2013 06:27 AM, Luke Kenneth Casson Leighton wrote:
> this message came up on debian-arm and i figured that it is worthwhile
> endeavouring to get across to people why device tree cannot and will
> not ever be the solution it was believed to be, in the ARM world.
>
> [just a quick note to david who asked this question on the debian-arm
> mailing list: any chance you could use replies with plaintext in
> future?  converting from HTML to text proved rather awkward and
> burdensome, requiring considerable editing.  the generally-accepted
> formatting rules for international technical mailing lists are
> plaintext only and 7-bit characters]
>
> On Sun, May 5, 2013 at 11:14 AM, David Goodenough
> <david.goodenough@btconnect.com> wrote:
>> On Sunday 05 May 2013, Luke Kenneth Casson Leighton wrote:
>
>>>> And I have a question: as the Debian installer takes the arch armhf in
>>>> charge, do you think a standard install' from a netboot image will work
>>>> ?
>>>
>>
>>> this has been on my list for a loooong time. as with *all* debian
>>> installer images however you are hampered by the fact that there is no
>>> BIOS - at all - on ARM devices - and therefore it is impossible to
>>> have a "one size fits all" debian installer.
>
>> I wonder if the device tree is the answer here. If the box comes with
>> a DT or one is available on the web then the installer could read it and
>> know what to install. That and the armmp kernel should solve the problem.
>
>   you'd think so, and it's a very good question, to which the answer
> could have been and was predicted to be "not a snowbal in hell's
> chance", even before work started on device tree, and turns out to
> *be* "not a snowball in hell's chance" which i believe people are now
> beginning to learn, based on the ultra-low adoption rate of device
> tree in the ARM world (side-note: [*0]).
>
>   in the past, i've written at some length as to why this is the case,
> however the weighting given to my opinions on linux kernel strategic
> decision-making is negligeable, so as one associate of mine once
> wisely said, "you just gotta let the train wreck happen".
>
>   device tree was designed to take the burden off of the linux kernel
> due to proliferation of platform-specific hard-coding of support for
> peripherals.  however it was designed ***WITHOUT*** its advocates
> having a full grasp of the sheer overwhelming diversity of the
> platforms.
>
>   specifically i am referring to linus torvald's complete lack of
> understanding of the ARM linux kernel world, as his primary experience
> is with x86.  in his mind, and the minds of those people who do not
> understand how ARM-based boxes are built and linux brought up on them,
> *surely* it cannot be all that complicated, *surely* it cannot be as
> bad as it is, right?
>
>   what they're completely missing is the following:
>
>   * the x86 world resolves around standards such as ACPI, BIOSes and
> general-purpose dynamic buses.
>   * ACPI normalises every single piece of hardware from the perspective
> of most low-level peripherals.
>   * the BIOS also helps in that normalisation.  DOS INT33 is the
> classic one i remember.
>   * the general-purpose dynamic buses include:
>     - USB and its speed variants (self-describing peripherals)
>     - PCI and its derivatives (self-describing peripherals)
>     - SATA and its speed variants (self-describing peripherals)
>
> exceptions to the above include i2c (unusual, and taken care of by
> i2c-sensors, which uses good heuristics to "probe" devices from
> userspace) and the ISA bus and its derivatives such as Compact Flash
> and IDE.  even PCMCIA got sufficient advances to auto-identify devices
> from userspace at runtime.
>
> so as a general rule, supporting a new x86-based piece of hardware is
> a piece of piss.  get datasheet or reverse-engineer, drop it in, it's
> got BIOS, ACPI, USB, PCIe, SATA, wow big deal, job done.  also as a
> general rule, hardware that conforms to x86-motherboard-like layouts
> such as the various powerpc architectures are along the same lines.
>
> so here, device tree is a real easy thing to add, and to some extent a
> "nice-to-have".  i.e. it's not really essential to have device tree on
> top of something where 99% of the peripherals can describe themselves
> dynamically over their bus architecture when they're plugged in!
>
> now let's look at the ARM world.
>
> * is there a BIOS?  no.  so all the boot-up procedures including
> ultra-low-level stuff like DDR3 RAM timings initialisation, which is
> normally the job of the BIOS - must be taken care of BY YOU (usually
> in u-boot) and it must be done SPECIFICALLY CUSTOMISED EACH AND EVERY
> SINGLE TIME FOR EVERY SINGLE SPECIFIC HARDWARE COMBINATION.
>
> * is there ACPI present?  no.  so anything related to power
> management, fans (if there are any), temperature detection (if there
> is any), all of that must be taken care of BY YOU.
>
>   * what about the devices?  here's where it becomes absolute hell on
> earth as far as attempting to "streamline" the linux kernel into a
> "one size fits all" monolithic package.
>
> the classic example i give here is the HTC Universal, which was a
> device that, after 3 years of dedicated reverse-engineering, finally
> had fully-working hardware with the exception of write to its on-board
> NAND.  the reason for the complexity is in the hardware design, where
> not even 110 GPIO pins of the PXA270 were enough to cover all of the
> peripherals, so they had to use a custom ASIC with an additional 64
> GPIO pins.  it turned out that *that* wasn't enough either, so in
> desperation the designers used the 16 GPIO pins of the Ericsson 3G
> Radio ROM, in order to do basic things like switch on the camera flash
> LED.
>
> the point is: each device that's designed using an ARM processor is
> COMPLETELY AND UTTERLY DIFFERENT from any other device in the world.
>
> when i say "completely and utterly different", i am not just talking
> about the processor, i am not just talking about the GPIO, or even the
> buses: i'm talking about the sensors, the power-up mechanisms, the
> startup procedures - everything.  one device uses GPIO pin 32 for
> powering up and resetting a USB hub peripheral, yet for another device
> that exact same GPIO pin is used not even as a GPIO but as an
> alternate multiplexed function e.g. as RS232 TX pin!
>
> additionally, there are complexities in the bring-up procedure for
> devices, where a hardware revision has made a mistake (or made too
> many cost savings), and by the skin of their teeth the kernel
> developers work out a bring-up procedure. the example i give here is
> the one of the HTC Blueangel, where the PXA processor's GPIO was used
> (directly) to power the device.  unfortunately, there simply wasn't
> enough current.  but that's ok!  why?  because what they did was:
>
> * bring up the 3.3v GPIO (power to the GSM chip)
> * bring up the 2nd 3.3v GPIO
> * pull the GPIO pin connected to the GSM "reset" chip
> * wait 5 milliseconds
> * **PULL EVERYTHING BACK DOWN AGAIN**
> * wait 1 millisecond
> * bring up the 1st 3.3v GPIO (again)
> * wait 10 milliseconds
> * bring up the 2nd 3.3v GPIO (again)
> * wait 5 milliseconds
> * pull up the "RESET" GPIO
> * wait 10 milliseconds
> * pull the "RESET" GPIO down
> * ***AGAIN*** do the reset GPIO.
>
> this procedure was clearly designed to put enough power into the
> capacitors of the on-board GSM chip so that it could start up (and
> crash) then try again (crash again), and finally have enough power to
> not drain itself beyond its capacity.
>
> ... the pointed question is: how the bloody hell are you going to
> represent *that* in "device tree"???  and why - even if it was
> possible to do - should you burden other platforms with such an insane
> boot-up procedure even if they *did* use the exact same chipset?
>
> ... but these devices, because they are in a huge market with
> ever-changing prices and are simply overwhelmed with choice for
> low-level I2C, I2S devices etc, each made in different countries, each
> with their NDAs, simply don't use the same peripheral chips.  and even
> if they did, they certainly don't use them in the same way!
>
> again, the example that i give here is of the Phillips UDA1381 which
> was quite a common sound IC used in Compaq iPAQ PDAs (designed by
> HTC).  so, of course, when HTC did the Himalaya, they used the same
> sound IC.
>
> .... did they power it up in the exact same way across both devices?
>
> no.
>
> did they even use the same *interfaces* across both devices?
>
> no.
>
> why not?
>
> because the UDA1381 can be used *either* in I2S mode *or* in SPI mode,
> and one [completely independent] team used one mode, and the other
> team used the other.
>
> so when it came to looking at the existing uda1381.c source code, and
> trying to share that code across both platforms, could i do that?
>
> no.
>
> then - as if that wasn't enough you also have the diversity amongst
> the ARM chips themselves.  if you look for example at the history of
> the development of the S3C6410, then the S5PC100 and the S5PC110, it
> just doesn't make any sense... *until* you are aware that my associate
> was the global director of R&D at samsung and he instigated the
> procedure of having two overlapping teams, one who does development
> and the other does testing; they swap every 8-9 months.
>
> basically what happened was that the S3C6410 used FIMD 3D GPU, and so
> did the 800mhz S5PC100.  by the time the S5PC110 came out (which was
> nothing more than a 1ghz jump) it had been flipped over to a
> *completely* different 3D engine!  changing the 3D GPU in mid-flow on
> a CPU series!
>
> and that's just within *one* of the fabless semiconductor companies,
> and you have to bear in mind that there are *several hundred* ARM
> licensees.  when this topic was last raised, someone mentioned that
> ARM attempted to standardise on dynamic peripheral publication on the
> internal AXI/AHB bus, so that things like device tree or udev could
> read it.  what happened?  some company failed to implement the
> standard properly, and it was game over right there.

Admittedly without knowing much background on the situation, that seems 
like a bit of a cop-out. In the PC world there are a bunch of devices 
that don't follow standards properly (ACPI, PCI, etc.) and we add quirks 
or workarounds and move on with life - people don't decide to abandon 
the standard because of it.

>
>
> are you beginning to see the sheer scope of the problem, here?  can
> you see now why russell is so completely overwhelmed? are you
> beginning to get a picture as to why device tree can never solve the
> problem?

I think part of the answer has to come from the source of all of these 
problems: there seems to be this culture in the ARM world (and, well, 
the embedded world generally) where the HW designers don't care what 
kind of mess they cause the people who have to write and maintain device 
drivers and kernels that run on the devices. In the PC world designers 
can't really do many crazy things as the people doing drivers will tell 
them "What is this crap? There's no way we can make this work properly 
in Windows". In the embedded world the attitude is more like "Hey, it's 
Linux, it's open, we know you can put in a bunch of crazy hacks to make 
this mess we created work reasonably". So the designers have no reason 
to make things behave in a standardized and/or sane manner.

Obviously this is a longer-term solution and won't help with existing 
devices, but in the long run device designers may need to realize the 
kind of mess they're creating for the poor software people and try to 
achieve some more standardization and device discoverability. Given the 
market dominance of Linux in many parts of the embedded world, one 
thinks this should be achievable.

>
> the best that device tree does in the ARM world is add an extra burden
> for device development, because there is so little that can actually
> be shared between disparate hardware platforms - so much so that it is
> utterly hopeless and pointless for a time-pressured product designer
> to even consider going down that route when they *know* it's not going
> to be of benefit for them.
>
> you also have to bear in mind that the SoC vendors don't really talk
> to each other.  you also have to bear in mind that they are usually
> overwhelmed by the ignorance of the factories and OEMs that use their
> SoCs - a situation that's not helped in many cases by their failure to
> provide adequate documentation [but if you're selling 50 million SoCs
> a year through android and the SoC is, at $7.50, a small part of the
> BOM, why would you care about or even answer requests for adequate
> documentation??] - so it's often the SoC vendors that have to write
> the linux kernel source code themselves.  MStar Semi take this to its
> logical GPL-violating extreme by even preventing and prohibiting
> *everyone* from gaining access to even the *product* designs.  if they
> like your idea, they will design it for you - in total secrecy - from
> start to finish.  and if not, you f*** off.
>
> so at worst, device tree becomes a burden on the product designers
> when using ARM processors, because of the sheer overwhelming
> diversity.  at best... no, there is no "best".  device tree just moves
> the problem from the linux kernel source code into the device tree
> specifications.
>
> possible solutions:
>
> * can a BIOS help?  no, because you will never get disparate ARM SoC
> licensees to agree to use it.  their SoCs are all highly-specialised.
> and, why would they add extra layers of complexity and function cals
> in a memory-constrained, CPU-constrained and power-constrained
> specialist environment?
>
> * can ACPI help?  no, because power management is done in a completely
> different way, and low-level peripherals are typically connected
> directly to the chip and managed directly.  ACPI is an x86 solution.
>
> * can splitting CPUs into northbridge architectural designs help?  no,
> because again that's an x86 solution.  and it usually adds 2 watts to
> the power budget to drive the 128-bit or 256-bit-wide bus between the
> two chips.  which is insane, considering that some ARM SoCs are 0.1 to
> 1 watts.  Not Gonna Happen.  plus, it doesn't help you with the
> existing mess.
>
> * can hardware standardisation help?  yes [*1] but that has its own
> challenges, as well as additional costs which need to have some sort
> of strategic benefit before companies will adopt it [or users].
>
> * can chip-level standardisation help?  no - ARM tried that already,
> one SoC vendor screwed it up (failed to implement the tables properly)
> and that was the end of the standard.  plus, it doesn't help with the
> existing SoCs nor the NDA situation wrt all the sensors and
> peripherals nor the proliferation and localisation and
> contact-relationships associated with these hard-wired sensors and
> peripherals.
>
> * what about splitting up the linux kernel into "core" and
> "peripheral"?  that might do it.  something along the lines of OSKit -
> except done right, and along lines that are acceptable to and
> initiated by the key linux kernel developers.  the "core" could be as
> little as 2% of the entire linux kernel code-base: lib/* arch/*,
> kernel/* and so on.  the rest (peripherals) done as a gitmodule.
> whilst it doesn't *actually* solve the problem, it reduces and
> clarifies the development scope on each side of the fence,
> so-to-speak, and, critically, separates out the discussions and focus
> for each part.  perhaps even go further and have forks of the "core"
> which deal *exclusively* with each architecture.
>
> i don't know.  i don't know - honestly - what the solution is here,
> and perhaps there really isn't one - certainly not at the software
> level, not with the sheer overwhelming hardware diversity.  linus
> "ordered" the ARM representatives at that 2007 conference to "go away,
> get themselves organised, come back with only one representative" and
> that really says it all, the level of naivete and lack of
> understanding of the scope, and the fact that each ARM processor
> *really is* a completely different processor: they might as well have
> completely different instruction sets and it's just damn lucky that
> they do.
>
> so i'm attempting to solve this from a different angle: the hardware
> level.  drastic and i mean *drastic* simplification of the permitted
> interfaces, thus allowing hardware to become a series of dynamic buses
> plus a series of about 10 device tree descriptions.
>
> so, in answer to your question, david: *yes* device-tree could help,
> if the hardware was simple enough and was standardised, and that's
> what i'm working towards, but the EOMA standards are the *only* ones
> which are simple enough and have taken this problem properly into
> consideration.  if you don't use hardware standards then the answer
> is, sadly i feel, that device tree has absolutely no place in the ARM
> world and will only cause harm rather than good [*2]
>
> thoughts on a postcard....
>
> l.
>
> [*0] allwinner use "script.fex".  it's an alternative to device-tree
> and it's a hell of a lot better.  INI config file format.
> standardised across *all* hardware that uses the A10.  it even allows
> setting of the pin mux functions.  _and_ there is a GUI application
> which helps ODMs to customise the linux kernel for their clients...
> WITHOUT RECOMPILING THE LINUX KERNEL AT ALL.  the designers of
> devicetree could learn a lot from what allwinner have achieved.
>
> [*1] http://elinux.org/Embedded_Open_Modular_Architecture/EOMA-68
>
> [*2] that's not quite true.  if there were multiple ARM-based systems
> that conformed to x86 hardware standards such as ITX motherboard
> layout, those ARM systems would actually work and benefit from
> device-tree.  if aarm64 starts to get put regularly into x86-style
> hardware form-factors, that would work.  but right now, and for the
> forseeable future, any ARM SoC that's used for "embedded" single-board
> purposes, flat-out forget it.  and even when aarm64 comes out, there
> will still be plenty of cheap 32-bit ARM systems out there.
>
>

