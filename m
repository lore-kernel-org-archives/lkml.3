Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3EFUzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:55:17 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:59966 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab3EFUzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <1367870518.18069.211@driftwood>
References: <CAPweEDwZrXQ4Wqw6_-YvmR7uNxWWNvE_c0-8UMuEhFzYW-BZWQ@mail.gmail.com>
	<1367870518.18069.211@driftwood>
Date: Mon, 6 May 2013 21:55:11 +0100
X-Google-Sender-Auth: ZFVrWuRRXPtP6jY9Kc1yLrICiHE
Message-ID: <CAPweEDw33eWGwkedvRHS3iCc2VRe7ho7SV-mjra-AgxNkC6REg@mail.gmail.com>
Subject: Re: device tree not the answer in the ARM world [was: Re: running
 Debian on a Cubieboard]
From: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
To: Rob Landley <rob@landley.net>
Cc: James Courtier-Dutton <james.dutton@gmail.com>,
        Robert Hancock <hancockrwd@gmail.com>,
        David Goodenough <david.goodenough@btconnect.com>,
        debian-arm@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 9:01 PM, Rob Landley <rob@landley.net> wrote:
> On 05/06/2013 07:08:44 AM, Luke Kenneth Casson Leighton wrote:
>>
>> > I suppose that ARM multi-platform will never cover all ARM CPUs, but
>> > the more it covers, the easier and cheaper it will be to work with new
>> > hardware and ARM.
>>
>>  no.  no, no no and wrong.  absolutely dead wrong.  you're completely
>> misunderstanding the economics of large and mass-volume product
>> development.  the hardware cost is
>> EEEEEEVVVEEERRRRRRYYYTTHHHHIIINNNNGGGG.
>
>
> And economies of scale are everything to hardware cost. Unit volume
> amortizes the development (and often licensing) costs down, in the long run
> who has the highest unit volume has the cheapest product. Being able to
> reuse off the shelf components is nice, but being able to repurpose existing
> high-volume smartphone packages semi-verbatim is nicer.

 yes.  ok, it's about time i mentioned the EOMA initiative, with the
first standard being EOMA-68 that will see mass-production.  the main
thrust of the argument is: if the main gubbins (CPU, NAND, RAM) is on
a user-removable hot-swappable CPU Card, and the interfaces are
*MANDATORY* and comprise (mostly) self-describing buses (USB, SATA,
Ethernet) and use device-tree for the remainder (24-pin RGB/TTL, I2C
and 8 pins of GPIO) then two things happen:

 1) the CPU Cards can be mass-produced for the [often very very short]
lifetime of the product, *BUT*, importantly, those CPU Cards can be
re-used across a seriously-large product range covering laptops,
tablets, MIDs, desktop PCs, SoHo servers, keyboard computers, LCD
monitors (yes - upgradeable LCD monitors that can be turned into
all-in-one PCs), LCD TVs - the list is almost endless and the only
things *not* covered are small smartphones [a market taken by samsung
and apple as you later point out rob], and high-end systems [a market
covered by intel and AMD anyway].

 2) the "products" [i won't list them again] can *LITERALLY* be made
*WITHOUT MODIFICATION* except cosmetic or replacing end-of-life
components until the cows come home.  i fully expect EOMA-68 laptops
for example to be made *literally* without a single modification for
at least five maybe even eight years [as long as its parts don't go
end-of-life].

 the relevance here for the linux kernel mailing list is that the
effort required to create a new product combination becomes an N
***PLUS*** M [plus tiny porting overhead to link into EOMA68]
development effort, where N is "number of CPUs" and M is "products".

in this scenario, device tree is actually critical to the success of
the EOMA initiatives, because every peripheral which is not
self-describing (the 8 GPIO pins and the LCD panel's timings, size
etc.) is to be stored in an on-board I2C EEPROM at a known location,
in device tree format.

 at boot time, the 9 [or so] device tree files will need to be read
from the product's EEPROM.  only then will the CPU Card know, for
example, what the size of the LCD is, or what GPIO 0 does.

 ... actually the device drivers are going to have to be capable of
reconfiguring even *after* boot time because a CPU Card could be
suspended, removed from one product, reinserted into another one and
told to wake up.... and find that its hardware is completely
different!! :)

 but that's another story.

> Also, your cheap little one-off product tends to have a lifespan measured in
> months. Especially since the most common southeast asian business model used
> to be something like "develop thing through shell company, fill inventory
> channel with product, launder profits through series of shell companies that
> patent infringement suits can't burrow through in a reasonable amount of
> time, dissolve company and shell companies before product ever winds up on
> store shelves leaving nobody to sue, re-hire the same set of engineers at
> new shell company, rinse, repeat.'

 yeah.  look up the zenithink ZT-180 tablet for a classic example.
you're _really_ helping to make the case for the EOMA initiatives, rob
:)

> (Has this changed recently? I haven't really been paying attention since
> smartphones started replacing the PC the way the PC replaced minicomputers
> and mainframes, so the billion seats of Android are more interesting than
> the rest of the embedded space combined. I did a talk about that at ELC if
> you're bored:
> http://www.youtube.com/watch?v=SGmtP5Lg_t0 )
>
>
>>  the software development cost because it is a one-off (non-recurring
>> expense) is completely and utterly irrelevant.  again, see reply to
>> oliver's message.
>
>
> Which is why this hardware tends to ship with crappy, unusable, unsupported
> software. Because actually programming the sucker is an afterthought, and
> the company that created it won't be _around_ long enough to support it,
> because if it did it would be around long enough to be sued for "we patented
> breathing, pay up".

 yes.  so this is why there is an open invitation to free software
developers to help out with the EOMA initiative, which is to do it
*right*, from the start.  put the cart before the horse.

> The reason we should care about this business model when the vendors don't
> is...?

 exactly.

>> > Say, if a manufacturer has 20 different models of mobile phone out
>> > there, all based on ARM.
>> > Currently, they need a different kernel for each one. If they could
>> > use the same kernel across all 20 models, that would reduce their
>> > development costs considerably.
>>
>>  let's do some maths.  let's say that the cost of re-using a DT-based
>> kernel is $50k, but the custom development (not using DT) is $250,000.
>
>
> If you use a DT-based kernel you can upgrade to new vanilla releases for 5
> years, and if you don't you probably never upgrade to a new version ever.

 i'm not sure i follow the relevance here.

> Except the type of company you're describing won't be around long enough to
> provide an upgrade.

 true! :)

> They'll just tell you to buy a new one next year, from
> the same engineers working at new shell company du jour (which has already
> dissolved by the time product hits the shelves; this stuff can get
> outsourced and rebadged with other people's branding to disguise the churn
> but the short-term thinking is there for a _reason_).

 most people would call you a cynic for saying this, but unfortunately
i've actually encountered exactly the situation you describe, as well
as meeting several people who have, *after* paying a deposit based on
a promise that they would receive the GPL Source Code if only they
paid cash up-front for 1k to 20k units, learned that the fucking
fucking fuckers didn't actually *have* the source code in the fucking
first place: they bought a GPL-violating binary-only deal from some
fucker-of-an-ODM who pulled the wool over the eyes of the factory.  i
_did_ try to warn a couple of people who actually paid up...

>
>>  let's say that you have to use a freescale $20 processor (iMX6 Dual)
>> with that, because linaro is being paid $1m per year to help freescale
>> to make devicetree work, and it gets them in on that
>> one-kernel-across-20-models thing.
>>
>>  so they work out the BOM, against the projected expenditure over say
>> 2 years they expect to sell say 100 million phones.
>
>
> You realize that nobody except Samsung and Apple is currently making money
> in the smartphone space, right?

 ok, ok - substitute "tablet" or "laptop" or "media centre" for
"smartphone" . actually it doesn't matter what the product is, really.
 the economics are the same: by the time you get to over 100 million
units, the software development costs are somewhere around the 4th
decimal place.


> Yes, you can install Linux on cheap plastic pieces of nonstandard crap that
> have already ceased production before you can buy one. It's about as
> interesting as hollowing out a Furby and making it run Linux.

 tell me about it.  now you know what drove me to come up with the
Rhombus Tech initiative.  been there, rob, and decided i didn't like
being fucked about, and decided to do something about it.

>
>>  do you see the point, james?  the cost of the software development is
>> utterly, utterly, utterly irrelevant.
>
>
> Which means that nothing we do matters to them anyway, they will never
> listen to us, we have no reason to listen to them, and they can basically
> piss off and stop bothering us?

 well, i'm listening.  through some _really_ random and extremely
lucky - very very jammy - coincidences, i have access to some very
very large factories in china.  we've been talking to them for some
time, and because of the sheer overwhelming scales that they're
dealing with, they reaaaaally like the advantages that 1) and 2) bring
to them [above, right at the top of this message].

 mind you, it took us 18 months to explain it to them, but when we
finally managed, they were really fired up.

 and this is the opportunity that i'm acting as the gateway for *you*
- free software developers - to gain access to, to make a difference
and finally stop having to fuck around cleaning up after the mess made
by the pathological profit-maximising corporations who get up our
noses year on year.

> Meanwhile, we pay attention to the companies that have a future, and not the
> modern gold rush iteration. (Before the smartphone we had the digital watch
> boom, the calculator boom, the incomptible 8-bit microcomputer boom, the
> dot-com pets.com/drkoop.com era... this is not a new thing, and unix has
> lived through all of it.)

 i'll be sticking around and keeping an eye on the EOMA initiative for
the next decade, see how far it gets.  that kind of long-term
commitment

> Don't get me wrong: I'm happy to provide them with good tools. But making
> their needs a primary design consideration when it comes to sustainability
> and upgrade paths is wrong.

 indeed.

>A company that lives or dies based on half a
> cent in component selection is NOT worried about an upgrade path. It's
> making something disposable, and the company itself is disposable.

 whereas the EOMA initiative is at the complete opposite end of the
spectrum.  and products based around the EOMA standards, although
there is a cost overhead of e.g. around $6 in parts for EOMA-68, there
is a whopping great saving of 30 to 40% to the customer when compared
to other products *if* your end-user is prepared to swap / share CPU
Cards between two products.  if they share the CPU Card between three
products then the saving to them is even greater.

 not only that but rather than throw away an entire product just
because a CPU Card is obsolete [to them] the end-user can either
re-purpose the CPU Card in a slower product, or sell it on e-bay, or
re-use it in a freedombox.... whatever they like.

 what they *don't* have to do is put the entire product in landfill.

 etc. etc. i could go on about this at some length but i've already
done so lots of times.

>>  but the amount of time taken on software development is *not* the
>> same as the *cost* of the software development.
>
>
> And neither is the same as the quality or sustainability of the resulting
> software. But if the product line will be be discontinued three months after
> its introduction, who cares about being able to maintain anything?

 exactly.  so in this case, with EOMA-68, even if a CPU has a 3 month
lifecycle, it's a 3 month lifecycle on *only* the CPU Card (not the
entire product range), and in that 3 months that CPU Card sold 10
times more than if it was used in only one single-board product.

 so to a factory making EOMA-68 CPU Cards with that 3-month-lifecycle
CPU, it's still worth doing, and still worth doing well.

 so.  to summarise: have i made it clear, rob, that only by doing
things like EOMA - which is basically about creating mandatory
standards with device-tree in each product's EEPROM - does device-tree
actually become *truly* useful?  if not, please do say so, because
this is really important to get the message over to people.

l.
