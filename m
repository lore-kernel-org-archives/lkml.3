Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab3FEWU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:20:26 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58461 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679Ab3FEWUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:20:24 -0400
MIME-Version: 1.0
In-Reply-To: <1370468873.18839.22.camel@localhost>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
	<CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
	<CAPweEDzDC87KmOQ=0hyPcjPtPsRuXHxNTs97vbEqVNNnix69rA@mail.gmail.com>
	<1370468873.18839.22.camel@localhost>
Date: Wed, 5 Jun 2013 23:20:23 +0100
Message-ID: <CAPweEDwrpoYCFuWJvF99Yua_TBoONeEH8UkTZvC7dTev6FAYfw@mail.gmail.com>
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
From: "luke.leighton" <luke.leighton@gmail.com>
To: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
Cc: devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 10:47 PM, Henrik Nordström
<henrik@henriknordstrom.net> wrote:
> ons 2013-06-05 klockan 22:15 +0100 skrev Luke Kenneth Casson Leighton:
>
>> what we do not want to happen is that they see upstream patches being
>> submitted, they merge them into their internal tree (which to date has
>> had zero upstream changes: they're currently only just getting round
>> to doing 3.4 as we speak), and they *completely* ignore *absolutely
>> everything* that's being done by the community, duplicating yet
>> another set of device drivers (named drivers/*/sun8i_* and so on).
>
> Well, that will obviously happen one or two more rounds, a bit depending
> on which kernel releases Android will use. But I hope the Allwinner
> kernel team will rethink when they hit more current kernels.

 yyyeahhh..... that's the whole point, henrik: i'd like to give
allwinner a heads-up *before* that happens, and to also give the linux
and sunxi kernel developer teams an opportunity to hear what allwinner
would like to see happen (if anything).

 what i *really* don't want to happen is for them to get a nasty
surprise some time around 3.9 or above, along with a hell of a lot of
kernel conflicts that cause them to completely abandon the entire
current linux directory conventions.

 or worse, do "find . -name "*sunxi* | xargs git rm" on linux 3.9 [or
above] prior to perging in *their* versions.


>>  this proposal is a start: however what you have to bear in mind is
>> that you now have to convince a very busy company that it is in their
>> best interests to disrupt their schedule, to drop their existing
>> working practices, to tell all their customers "please stop using the
>> existing tools and please use these ones instead".
>
> Why?

 taking this as a rhetorical question (kinda), what i believe jon
proposed would have a knock-on effect of requiring that boot0 and
boot1 be converted *away* from script.fex and onto DT.  therefore,
automatically, all tools must now be converted to understand DT not
fex.  that includes the (proprietary) equivalents of fex2bin and
bin2fex [*1]

 but, i could be wrong.

>>  you also need to convince the creators of the proprietary
>> firmware-flashing tools "livesuite" and "phoenix" to *also* convert
>> their tools over to the new proposed idea.
>
> Why?
>
>>  can you provide such a supporting argument which would convince
>> allwinner to accept the modifications to their working practices that
>> you propose?
>
> It does not really need to be such big modifications to their working
> practices. Their configuration working practices is all built around the
> fex file, and the new practices can be
>
> 0. Assuming kernel drivers gets ported over to using device tree.
>
> 1. Do configuration as you have always done in the .fex
>
> 2. Modify the build script to build a device tree from the fex +
> template, in addition to script.bin.
>
> 3. Tell u-boot to load the device tree for the kernel.
>
> That's it really.
>
> livesuit do not modify script.bin. script.bin is compiled from the .fex
> at image creation time. A couple more lines in the build script (and a
> suitable translation tool) and there is also a device tree built and
> installed and you get a nice and smoot transition.

 ok: great.  so we have something that i can potentially propose to
them.   now: what reason can i give that they should accept this?
what's the biggest incentive for them, here, to make these changes?
what would they gain?


>> > Device tree on ARM's goal is to achieve a single kernel across vendors, not
>> > just a single kernel for a single vendor.
>>
>>  you'll be aware that i've mentioned a number of times and have
>> discussed at some length why this is a goal that is completely
>> impossible to achieve [*1].  sadly.
>
> Here I disagree. It is possible. Not across all vendors but a
> significant share.

time will tell, henrik [i mean that sincerely, not in a trite way].

fortunately as you know (but many people on these various lists may
not), with the eoma initiatives [*2], we bypass that possibility, and
through hardware standardisation turn an N*M work problem into an
N+M+2 work problem (where N is number-of-SoCs and M is number of
product types).

l.

[*1] https://github.com/linux-sunxi/sunxi-tools
[*2] http://elinux.org/Embedded_Open_Modular_Architecture
