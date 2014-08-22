Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaHVXRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 19:17:32 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:46901 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbaHVXRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 19:17:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAL1qeaEaZx0KpMpTSGqZVMZZj1VrzGY3ffRbzEdy4Aks2yHciA@mail.gmail.com>
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org>
 <CAGVrzcZobuL4z0WNX+Sz4p_uwaPL-S5yvEmgRUwZPJi4+qq0tg@mail.gmail.com>
 <53F7AEAC.90303@gmail.com> <CAL1qeaEaZx0KpMpTSGqZVMZZj1VrzGY3ffRbzEdy4Aks2yHciA@mail.gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sat, 23 Aug 2014 01:16:37 +0200
Message-ID: <CAOiHx=kLfKLZA2Nv+dn87S50209DBXRj8OgZsywXQ0MoqTVA8A@mail.gmail.com>
Subject: Re: [PATCH 0/7] MIPS: Move device-tree files to a common location
To: Andrew Bresticker <abrestic@chromium.org>
Cc: David Daney <ddaney.cavm@gmail.com>,
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

On Sat, Aug 23, 2014 at 12:10 AM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> On Fri, Aug 22, 2014 at 1:57 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>> On 08/22/2014 01:42 PM, Florian Fainelli wrote:
>>>
>>> On Aug 21, 2014 3:05 PM, "Andrew Bresticker" <abrestic@chromium.org
>>> <mailto:abrestic@chromium.org>> wrote:
>>>  >
>>>  > To be consistent with other architectures and to avoid unnecessary
>>>  > makefile duplication, move all MIPS device-trees to arch/mips/boot/dts
>>>  > and build them with a common makefile.
>>>
>>> I recall reading that the ARM organization for DTS files was a bit
>>> unfortunate and should have been something like:
>>>
>>> arch/arm/boot/dts/<vendor>/
>>>
>>> Is this something we should do for the MIPS and update the other
>>> architectures to follow that scheme?
>>
>>
>> If we choose not to intermingle .dts files from all the vendors in a single
>> directory, why do anything at all?  Currently the .dts files for a vendor
>> are nicely segregated with the rest of the vendors code under a single
>> directory.
>>
>> Personally I think things are fine as they are.  Any common code remaining
>> in the Makefiles could be moved to the scripts directory for a smaller
>> change.
>
> Assuming we don't move them to a common location just to segregate
> them again, it makes MIPS consistent with every other architecture
> (not just ARM!) using DT.  It also makes it easier to introduce common
> changes later on, like the 'dtbs' or 'dtbs_install' make targets.

I think having dts files under a predictable location is a good idea,
especially if it allows common code/targets as "dtbs".

Maybe a totally insane idea, but how this for having the cake and eating it too:

arch/mips/boot/dts/*.dts => dts files to be built along side the kernel as .dtbs

arch/mips/<mach>/*.dts => dts files built into the kernel

(the ../*.dts isn't meant as they should be in the top directory, just
somewhere in that sub tree)

Because I can see a use case where you want both. For example octeon
uses generic device tree boards to use as a basis if the bootloader
did not provide one/is too old, but maybe also provide dts files for
known boards, which shouldn't be included in the kernel binary itself.

And I would like to do a similar thing when I want to convert bcm63xx
to device tree, i.e. have dts files for supported boards, but also
include a "standard"/"fall-back" dts for each of the supported SoCs to
load if there is no dtb passed and the old board registration code is
used.


Jonas
