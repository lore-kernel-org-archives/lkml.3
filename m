Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3EFLrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 07:47:55 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:35800 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3EFLry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 07:47:54 -0400
MIME-Version: 1.0
In-Reply-To: <km7p8v$7jq$1@ger.gmane.org>
References: <CAPweEDym3TSEKWB1PsRWZ77irkTPF-Qdm9nRGfRBrv72CQ8zJA@mail.gmail.com>
	<51872CF6.5070409@gmail.com>
	<km7p8v$7jq$1@ger.gmane.org>
Date: Mon, 6 May 2013 12:47:53 +0100
Message-ID: <CAPweEDyeH_kKzNJJYdN2dhuMaa6S3x0-Yh4Vj2JiS+ftD9G9hw@mail.gmail.com>
Subject: Re: [Arm-netbook] device tree not the answer in the ARM world [was:
 Re: running Debian on a Cubieboard]
From: "luke.leighton" <luke.leighton@gmail.com>
To: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
Cc: debian-arm@lists.debian.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 9:22 AM, Oliver Schinagl <oliver+list@schinagl.nl> wrote:
> Note, I'm not qualified nor important or anything really to be part of
> this discussion or mud slinging this may turn into, but I do fine some
> flaws in the reasoning here that If not pointed out, may get grossly
> overlooked.

 allo oliver - did a quick read, didn't see anything remotely
resembling mud :)  which is a pity because i am looking forward to
making my next house out of compressed earth with a 3% concrete mix.

 but seriously: the only thing i'd say is it's a pity in some ways you
replied to this message rather than to the reply that robert wrote
[but i'd trimmed that], because i made a summary of the whole original
message based on robert's prompting and insights, and also invited
people to come up with some potential alternative solutions.

 .... and to do that, the problem has to be properly recognised, which
unnnfortunately takes quite a lot of thought/reading/observations to
take into account and express.  i don't necessarily have the best
experience to do that, which is why i asked people if they could help,
and in that regard your review is really really appreciated.

 ok, so let's have a look...

> On 06-05-13 06:09, Robert Hancock wrote:
>> On 05/05/2013 06:27 AM, Luke Kenneth Casson Leighton wrote:
> So yes, every single ARM SoC/platform will need its own dedicated
> SPL/U-boot. Kinda like a bios?

 kinda like a BIOS, yes.  except the differences are that a BIOS (and
ACPI) stay around (ROM, TSRs), whereas SPL and u-boot merely do the
board-bring-up and once done you're on your own [side-note: so there
is considerable code duplication between u-boot and the linux kernel,
and u-boot typically does bit-level direct manipulation of GPIO as
it's simpler]

 so, whereas a BIOS (and ACPI) ease the pain of bringing up a system
(actually multiple systems that conform to the same BIOS and ACPI
standards), and help normalise it (them) to a very large extent (bugs
in BIOSes and ACPI notwithstanding), in the ARM world the solutions
used actually *increase* the number of man-hours required to bring up
any one board!

> But if you want to boot from LAN (I think
> that's what this discussion was about?) you need U-boot loaded by SPL
> anyway. Can you boot a generic linux install (say from CD) on arm?

 if u-boot has cut across sufficient parts of the linux kernel device
driver infrastructure then yes!  we have a call on the arm-netbooks
and linux-sunxi mailing lists for example for addition of USB-OTG to
SPL.  that means going over to the linux kernel source code, *again*
duplicating that code, and adding it to the SPL in the u-boot sources.

> Usually no, the onboard boot loader only knows a very specific boot
> path, often flash, mmc etc etc.

 yes.  amazingly, the iMX6 supports a ton more boot options than i've
ever seen in any other ARM SoC: SATA boot, UEFI partitions and loads
more.

 it's yet another example unfortunately of the insane level of
diversity being faced by and imposed on the linux kernel
infrastructure.

>Those need to be able to bring up the
> memory too (SPL) so you'll need some specific glue for your platform
> anyhow.

 yes.  this is going to be interesting for when standard DIMMs become
commonplace in the aarm64 world, if companies consider making standard
ITX motherboards.

> I'm not sure if DT was supposed to solve that problem?

 mmm.... it would help, i feel, because the RAM timings would be part
of the DT.  however, it *wouldn't* help because this is incredibly
low-level, you'd have to have SPL (which is often extremely limited in
size, typically 32k i.e. the same size as the CPU's 1st level cache no
that's not a coincidence) understand DT.

so it *might* be good, but it might be a very poor match.  have to see.

in all other cases, where the RAM is hard-wired: DT is not much use.
the RAM timings have to be hard-wired, they're done by SPL, SPL is
often written with a disproportionately large amount of assembly code,
etc. etc. i'm waffling but you get the point?

> If that where the case, was DT to replace the BIOS too?

 i'm sure that was partly the intention, but ARM systems don't *have*
a standardised BIOS, because, i feel, there is too much diversity and
fragmentation - for very very good and sound business reasons as well
as pure good-old-fashioned FUBARness, for any kind of standardisation
to make a dent in that mess.

>>>
>>> * is there ACPI present?  no.  so anything related to power
>>> management, fans (if there are any), temperature detection (if there
>>> is any), all of that must be taken care of BY YOU.

> Again, I only know about 1 specific SoC, but for the A10, you have/need
> an external Power Manamgent IC, basically, a poor man's ACPI if you
> must.

 yes.  exactly!  this is a _great_ example.  if you've seen the
offerings from X-Powers and their competitors (MAXIM for example, and
then ingenic recommend another company), you'll know that the actual
PMIC is *customised* for a particular SoC!!!

 which is completely insane.

 so, for example, allwinner (whom i believe also own X-Powers) created
the AXP221 for their new SoC.  Samsung, back when the Odriod came out
(with the S5PC100), contacted MAXIM and asked them to create a special
custom PMIC.  MOQ for that customised PMIC: 50,000 units and special
privileges required before you could gain access to it.

 and for the MK802 they just used 3 LDOs [and as a result that little
USB-HDMI computer quite badly overheats]

 and the burden of power management is then placed onto the linux kernel.

 in the case of the iMX6, i don't know if you've read freescale's app
notes, but they go to some lengths to describe how to optimise power
consumption.  the Reference Board has some ODT (on-die termination)
resistors that can be electronically controlled with GPIO pins.  you
can adjust the DDR RAM speed (dynamically!!!) and when you do so, it's
best to change the ODT resistance, and if you do so you save 200mA (or
something - can't remember the details).

 normally these things are taken care of at the BIOS level... and the
burden of responsibility is placed onto the linux kernel +
device-tree.

 i'm pointing these things out because i don't believe people are
fully aware of the sheer overwhelming technical scope being faced, let
alone the business cases [or business FUBARs] surrounding ARM-based
product development.

> If you don't have this luxury, yes, you'll need a special driver.
> But how is that different from not having DT? You still need to write
> 'something' for this? A driver etc?

 yes.  exactly.  does DT help solve the above problem?  no not really,
because it's heavy customisation at quite a low level.  my point is
not that you won't need a special driver, my point is - the focus of
this discussion is - the question being asked is - "does the addition
of DT *actually* help solve these issues?"

 and the other [unfortunately pointed] question is, "were the people
who designed DT actually aware of these issues when they designed it?"
 because i certainly didn't see the public discussions which took
place, nor the online articles discussing it, nor see any draft or
preliminary documentation, nor any invitations to comment [RFCs].

 and this is a *major* piece of strategic decision-making we're talking.

>>> the classic example i give here is the HTC Universal, which was a
>>> device that, after 3 years of dedicated reverse-engineering, finally
> So, nofi, you have some shitty engineerd device,

 noo... beautifully engineered device.  a micro laptop with 5
speakers, 2 microphones, flip-over screen.  if you'd ever owned one
you would have gone "wow, why is this running wince??" and would have
immediately got onto #htc-linux to help :)

> that can't fit into this DT solution,

 you've misunderstood: it could.  there's nothing to stop anyone from
adding in DT, is there?  but the point is: in doing so, does it
*actually* help at all?

> and thus DT must be broken?

 DT *itself* is not broken.  it's a good solution.  but... what
problem does it actually solve, and what problem is *actually* being
faced?

 i'm going to emphasise this again and again until i get it through to
people, or until someone gives me a satisfactory answer.  device tree
solves *a* problem, but there is a logical disconnect - an assumption
- that it solves the much *larger* problem of helping with the massive
diversity of hardware in the ARM world.

 i mention the HTC universal as a kind of insane example (sample of
one) of the kind of thing that's faced, here.  i won't damage peoples'
brains including my own by listing every single bit of ARM kit out
there.

> Though with proper drivers
> and proper PINCTRL setup this may actually even work :p

 yes.  that chip was called the ASIC3 and it was used in half a dozen
products.  as such, those half-a-dozen-or-so products would have
benefitted from devicetree.  the userspace communication over RS232,
sending AT commands in order to activate any one of the extra 16 GPIO
pins on the other hand would not, not because it's userspace, but
because nobody else was faced with that kind of insane level of GPIO
(almost 200 pins) such that they actually *ran out* on the available
hardware and had to do that kind of desperate trick.

 so even if you _did_ write a device tree aware driver for that part,
how much code re-use would it see?  ABSOLUTELY NONE.

 and that's the key, key CRITICAL point that i'm making, here.  the
point of device-tree is to encourage code re-use.  but if the hardware
is massively diverse, there's NO OPPORTUNITY FOR REUSE.

 therefore, logically, device tree does not help!

 it's as simple as that!

 no - really, it's as simple as that.

 and it's something that i don't think people really thought about
before embarking on implementing device tree.


>>> this procedure was clearly designed to put enough power into the
>>> capacitors of the on-board GSM chip so that it could start up (and
>>> crash) then try again (crash again), and finally have enough power to
>>> not drain itself beyond its capacity.
> So again horribly shitty designed solution.

 no not at all. *iteratively-designed* solution, where they were told
"you can't have another go, you're out of time, MAKE it work".

 it's another example where the unique hardware-software solution will
never be repeated (hopefully...) and as such, device tree is
completely ineffective at solving the goal it was designed to solve,
because there is zero chance - ever - of any code re-use.


>>> because the UDA1381 can be used *either* in I2S mode *or* in SPI mode,
>>> and one [completely independent] team used one mode, and the other
>>> team used the other.
> Afaik, there's several IC's that work that way, and there's drivers for
> them in that way. I haven't seen this being applied in DT, but i'm sure
> this can reasonably easy be adapted into DT.

 yes it could.  but *will* it?  my point is slightly different here
from the other two examples.   unfortunately it's necessary to
speculate here (as DT wasn't around in 2004), but can you see that if
there were two independent teams even in the same company working on
drivers simultaneously, you'd end up with two *different*
implementations of the same driver?

 corporate companies work in secret.  they don't work together - they
don't collaborate - they *compete*.  HTC, kicking and screaming,
releases GPL source code *NINETY DAYS* after a product first hits the
shelf.  that means that the software was being done OVER A YEAR ago.
in secret.

 the amount of overlap time is enormous.

 will device tree help here, especially given that companies like HTC
are on the bleeding edge, and they use completely new ICs, and are
often literally the first to write the linux kenel device drivers for
that hardware?

 of course not.

 now multiply that up by samsung, motorola and every other
manufacturer, all working in secret, all competing, all not
communicating, throwing out code over the fence (often kicking and
screaming and *definitely* late), zero consultation with the linux
kernel developers who have to clean up their mess, work out the
duplications and so on.

 will device tree help in this circumstance?

 if there happens to be any common ground in the design of the
products - shared hardware - it'll help *after the fact*, to
rationalise things, but that's a burden that's now on the linux kernel
developers.  more fool them for being taken advantage of, as unpaid
slave labour by the large corporate organisations, i feel.

 ... you see what i'm getting at?

>> I think part of the answer has to come from the source of all of these
>> problems: there seems to be this culture in the ARM world (and, well,
>> the embedded world generally) where the HW designers don't care what
>> kind of mess they cause the people who have to write and maintain device
>> drivers and kernels that run on the devices.
>> [...]
>> this mess we created work reasonably". So the designers have no reason
>> to make things behave in a standardized and/or sane manner.

> This will level itself out in the end I suppose.

 naaahhh nah nah, oliver: you can't "suppose" :)

> Once a proper
> infrastructure is in place (working DT, reasonably well adopted etc,
> drivers rewritten/fixed etc). Once that all is in place, engineers will
> hopefully think twice. They have two options, either adapt their design
> (within reason and cost)

 yes.  exactly.  and cost *is* the driving factor.  i remember a
friend of mine saying that phillips used to argue over 0.001 pence
from suppliers of plastic keys.  that's 5 decimal places down on a GBP
(ok make it a dollar.  5 decimal places down on a dollar).

 in quantity five hundred million and above, that 0.001 pence shaved
off across say 100 keys on a keyboard represents £500,000.  that's
potentially the entire profit margin on a mass-volume product.

 in mass-volume, cost *is* the driving factor.  if there's a choice
between an insane low-cost solution which has the software engineers
tearing their hair out and wanting to take a bath every day for a
year, or a nice clean one that's even $0.10 more expensive, guess
which one they'll get *ORDERED* to implement?

 my associate when working for samsung as the head of R&D made it
clear that anyone who came up with a 4-layer board was told to go away
and to make it work as a 2-layer board.  the cost of the extra layers
would often mean the difference between profit and failure.

> to more closely match the 'one kernel to rule
> them all' approach, and reap its benefits, or apply hacks like the HTC
> example above and are then responsible for hacking around the code to
> get it to work. Their choice eventually.

 no.  you're not getting it oliver.  _really_ not getting it.  the
hardware cost is *everything*.  the software is a one-off expense that
can be amortised over the lifetime of the product, and becomes a
negligeable amount over time.  software is done *once*, hardware
production costs are on *every* unit.

> There we go, long term, I don't think DT is half as bad and In time,
> we'll see if it was really bad or not to bad at all.

 the question is not whether it's bad, the question is: does it solve
the problem for which it was designed?  or, more specifically, was the
problem even *discussed* in public prior to the solution being
enacted?

 the answer to both questions is definitely "no".

 ok - i believe i've repeated this point enough, and it's taken a
considerable chunk of my day, i don't know about anyone else -
apologies oliver i have to cut this short.

l.
