Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506Ab3IDIhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:37:11 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:52068 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab3IDIhA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:37:00 -0400
Date: Wed, 04 Sep 2013 03:37:00 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Acceptance of proprietary kernel modules
To: Richard Weinberger <richard@nod.at>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5220ADA6.5050708@nod.at> (from richard@nod.at on Fri Aug 30
	09:35:18 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1378283820.2737.159@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 09:35:18 AM, Richard Weinberger wrote:
> Hi,
> 
> over the last  months I've reviewed lot's of Linux based products,  
> mostly networking related
> devices like firewalls, WiFi access points, DSL routers, IPMI, etc...
> The vast majority of them had proprietary kernel modules loaded.
> I'm not talking about single self contained device drivers. In the  
> wild you'll find whole kernel
> subsystems such as complete firewalling stacks, deep packet  
> inspection, IPsec implementations, anti virus scanners, network  
> introduction detection systems (yes, in kernel!),
> protocol implementations like MPLS, in-kernel VNC servers, and so on  
> as proprietary kernel modules.
> 
> Of course, all of them use EXPORT_SYMBOL() symbols only, but nobody  
> can tell me that
> these modules are self contained and not a derived work of the kernel.
> One vendor even applied a patch on the kernel which did a  
> s/EXPORT_SYMBOL_GPL/ EXPORT_SYMBOL/g on a few files, but that's a  
> different story.
> Reading the disassembly of said modules showed that most of them are  
> clearly designed to run only on Linux. (e.g. every single function  
> references a random Linux kernel symbol).
> It's not like NVIDIA's GPU driver which clearly is designed to work  
> on many operating systems and Linux is one of that.
> I have the feeling that such doubtful modules are no longer isolated  
> cases, they are the common case.
> 
> This leads me to one question.
> Have we reached a state where proprietary kernel modules are just  
> accepted and nobody cares?

I don't speak for the linux kernel, but:

1) I started the first GPL enforcement suits on behalf of the busybox  
project (both through the SFLC and another suit in europe suit along  
with gpl-violations.org and FSF europe against some french company),  
and I spent over a year pursuing them, resulting in exactly zero lines  
of code being added to busybox from any of the companies we sued.

2) I'm giving a talk about the rise and fall of the copyleft at Ohio  
LinuxFest later this month. (We have a "greying of fandom" problem  
where almost nobody under 30 really seems to care about copyleft, and  
the most common license on github is "no license specified".)

3) I touched on this topic in my ELC talk in February, maybe 5 minutes  
starting at:

   http://www.youtube.com/watch?v=SGmtP5Lg_t0#t=15m09s

(Google broke youtube's time link syntax recently, but that's 15  
minutes and 9 seconds into the talk. You'll probably have to advance by  
hand.)

The short version is: people who aren't in a position to do anything  
about it care very deeply in a fairly useless way. People with  
nontrivial standing are too busy with programming to spend time on  
lawsuits, pretty much by definition. After 20 years, don't expect  
sudden change unless somebody retires from programming to file lawsuits  
instead, and when they do expect them to burn out after about a year or  
two with nothing to show for it except maybe some money.

Sometimes "care in a deep but useless way" and "too busy to do anything  
about it" overlaps. Greg KH declared kernel modules flatly illegal in  
2006:

   http://www.kroah.com/log/linux/ols_2006_keynote.html

And you can see how many suits he's filed over the past 8 years to  
enforce that view...

What I found out experimentally is that when you _do_ pursue this  
stuff, the actual pragmatic payoff to the project, in engineering  
terms, is exactly zero.

Think about the fact that the guy who wrote Squashfs spent seven years  
trying to get the code in, had it in every major distro but not  
vanilla, and still had to take a YEAR off from work to volunteer full  
time to finally get it merged into Linus's tree. (And yet somehow, he  
still didn't qualify for the recent "call for hobbyists" at the private  
invitation-only kernel summit.) He wrote about that here:

   https://lwn.net/Articles/563578/

Think about Android too: an enormous chunk of divergent crap with  
source dropped along with each release, which spent years outside the  
kernel before the kernel guys even figured out what they wanted to _do_  
with it, and then they wound up rewriting most of it along different  
design lines, and _still_ dealing with the backlog. (Android was fully  
in compliance with the GPL every step of the way, even provided source  
repositories with history rather than "one big tarball, guess what to  
diff this against". And yet...)

If that's what it takes to get large chunks of widely used code  
upstream, with the active participation of the people who wrote it, the  
likelihood of any of the code you're talking about ever going into  
vanilla if it _was_ released (let alone as the result of a lawsuit) is  
essentially zero. And the companies behind it know it. And the kernel  
guys know it too. There's some posturing and chest beating, but a  
couple decades of precedent have made that pretty widely ignored, as  
you've noticed.

What the kernel being GPL really meant that Apple, Sun, Oracle, and IBM  
couldn't fork the whole thing to produce a large proprietary OS based  
on it. (That _would_ get a response from Red Hat and such, in the form  
of stop ship injunction with no questions about standing and what is  
and isn't a derived work. Of course it took IBM a decade to swat down a  
clearly insane SCO that had no actual case thanks to cash infusions  
from Sun and Microsoft to pay the lawyers, but "give us the code and  
clear title to use it" is a different bar from "yank your product off  
the shelves and keep it off indefinitely".) Thus MacOS X is FreeBSD  
instead, OpenSolaris... happened, and Oratroll bought its' corpse  
(while still doing their Red Hat fork), and IBM keeps AIX limping along  
while also doing Linux (and other systems). Meanwhile android gives us  
abandonware forks of stale versions after the vendors have preinstalled  
the locked down images, so 0.01% of the userbase has the option of  
doing cyanogenmod because nobody's ever done a jailbreak on an iPhone.

Another thing it meant is Apple couldn't hire Alan Cox away to work on  
a proprietary fork of Linux they way they hired Jordan Hubbard away to  
work on the proprietary fork of FreeBSD that became MacOS X. That said  
Gentoo's founder Daniel Robbins did spend a year at Microsoft to pay  
off some debts, and gentoo's never really recovered the momentum it had  
before that. (When Daniel got back they didn't like his smell and  
pushed him out of the nest.) Maybe somebody could have hired Philip  
Lougher away to work on a proprietary squashfs, but by the time it  
really came up the code was out there and in every major distro and  
there wasn't much proprietary advantage in having another one.

Cracking down on GPL enforcement is a lot like cracking down on  
software piracy: it works best as a cross between a threat and a guilt  
trip, but _actual_ enforcement tends to do more harm than good. So you  
have the "don't copy that floppy" crowd preaching fire and brimstone  
from the pulpit, with only occasional jackbooted thugs kicking down  
doors (usually as a sign of cluelessness [my response to the busybox  
"hall of shame" I inherited] or desperation [the FSF's ongoing struggle  
with irrelevance]; might be some wounded pride in there too at some  
point but so far that's just led to posturing, not action).

All this is specific to the kernel, by the way. In userspace the FSF  
mortally wounded copyleft by fragmenting it. There's no such thing as  
"The GPL" anymore: the kernel's cifs client driver and Samba's cifs  
server can't share code even though they implement two ends of the same  
protocol and both are licensed under versions of the GPL. QEMU is  
caught in the middle of this wanting to take driver code from linux for  
device emulation and from binutils/gdb for processor emulation and it  
literally _can't_ because they're incompatible GPL versions. (And  
saying "make your project GPLv2 or later" just makes it worse because  
then you can't accept code from _either_ source.)

For 17 years, "the GPL" was a terminal node in a directed graph of  
license convertibility that allowed developers to be lazy, we could all  
learn _one_ set of license terms in as much detail as we needed and  
treat everything GPL compatible as a single license and everything else  
as uninteresting. We didn't have to be lawyers, we could spend our time  
coding! But now it's split into incompatible camps even before you  
mention "affero" or trying to use creative commons for source code to  
get away from the problem. Once you figure out that naieve solutions  
like "make your project GPLv2 or later" mean you can't accept code from  
either one, and looking for alternate licenses just increases  
fragmentation in the copyleft space, the inescapable conclusion is that  
the practical effect of copyleft is now to PREVENT code reuse.

We all mocked Sun for introducing the CDDL for OpenSolaris (a non-GPL  
copyleft license, whose explicit goal was to prevent Linux and Solaris  
from being able to use each other's code), and then the FSF did CDDL2  
and switched all the projects they controlled, and split copyleft right  
down the middle. (Bravo, FSF. Bravo.)

In the absence of a universal receiver, the under-30 crowd has largely  
switched over to universal donor, mostly jumping _past_ BSD to outright  
public domain. That way they can give code to anybody, but can only  
_take_ code that's been very carefully vetted. (Which is about as much  
of a bother as Linux's signed-off-by chain of custody stuff; copyleft  
has no advantage here anymore.) Or just have an excuse for the natural  
"not invented here" to reinvent a lot of light bulbs until there's a  
public domain version of everything.

And explicitly _saying_ "public domain" (ala 7zip or libtomcrypt) is  
the _good_ outcome. The bad outcome is when they take a napster  
approach of civil disobedience lumping software copyrights and software  
patents together as "too broken to live" and just refusing to  
participate (here's the code, I refuse to specify a license; Dan  
Bernstein was ahead of his time it seems) until the whole diseased  
edifice collapses. Which is kinda annoying for those of us trying to  
cope in the meantime, but "no license specified" remains the most  
popular license on github...

So yeah, you'll find some people over the age of 40 who plan to enforce  
their faction of the GPL in court the same way they plan to write the  
great american novel someday. It's a thing they'll regret not having  
done on their deathbed, and don't expect much action before then unless  
it's a midlife crisis thing. You might also find some corporations who  
can gain a temporary strategic advantage by filing a hot coffee lawsuit  
against their neighbors (see "the ongoing smartphone patent  
hellscape"), but the recipient of said lawsuit can have two teams on  
two continents do a shim layer and a plugin for that shim layer with a  
clean room between 'em if they really want to, and fighting _that_  
means we're on the side of IBM vs Compaq back in 1984 saying the  
original PC should never have been cloned... Again, a threat followed  
through just often enough to keep it alive _as_ a threat, or maybe used  
punitively for unrelated strategic reasons.

But what you noticed at the start of this is 20 years of it basically  
not happening, with no immediate reason for that to change, and all the  
historical success stories from OpenWRT to the new exfat thing _not_  
involving lawsuits. (There were threats of using a stick, but it's the  
carrot that made 'em all move.)

Rob

(P.S. Reverse engineering hardware support isn't actually very hard.  
Noveau, forcedeth, various ATI drivers... The kernel guys actually  
don't _want_ code, they want hardware documentation so they can write  
their own darn drivers. The crap drivers most vendors produce are only  
interesting in that you can use it to reverse engineer a spec to write  
new code from, and it's not _that_ much harder to do that from the  
binary, especially now we've got kvm and can pass through individual  
devices and monitor the interaction with 'em...)

(P.P.S. Yeah, I blathered on at length. I _said_ I'm preparing a talk  
on all this stuff. Head full of random tangents from research, trying  
to edit it down to a coherent story that fits in 45 minutes...)