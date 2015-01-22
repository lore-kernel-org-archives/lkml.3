Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbbAVXrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:47:53 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:37453 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbAVXrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:47:47 -0500
MIME-Version: 1.0
In-Reply-To: <20150122210344.GE13072@google.com>
References: <1420857290-8373-1-git-send-email-robh@kernel.org> <20150122210344.GE13072@google.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 22 Jan 2015 17:47:25 -0600
X-Google-Sender-Auth: jxZxkq1ovtRf1Oubiyb5n6VzBE0
Message-ID: <CAL_Jsq+aw0y-1rrF=RMpYKMP4zGfmqzzG5BXYYoFABtKEUpX8Q@mail.gmail.com>
Subject: Re: [PATCH 00/16] PCI generic configuration space accessors
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Simek <michal.simek@xilinx.com>,
        Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Will Deacon <will.deacon@arm.com>, cbe-oss-dev@lists.ozlabs.org,
        linux-am33-list@redhat.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 3:03 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Jan 09, 2015 at 08:34:34PM -0600, Rob Herring wrote:
>> This series adds common accessor functions for PCI configuration space
>> accesses. This supports most PCI hosts with memory mapped configuration
>> space like ECAM or hosts with memory mapped address/data registers. ECAM
>> is not generically supported by this series, but could be added on top
>> of this. While some hosts have standard address decoding which could be
>> common as well, the various checks on bus numbers and device numbers are
>> quite varied. It is unclear how much of that is really necessary or
>> could be common.
>>
>> The first 4 patches are preparatory cleanup. Patch 5 introduces the
>> common accessors. The remaining patches convert several PCI host
>> controllers. This is in no way a complete list of host controllers. The
>> conversion of more hosts should be possible. The Designware controller
>> in particular should be able to be converted, but its config space
>> accessors are a mess of override-able functions that I've not gotten my
>> head around.

[...]

> Really nice cleanups.  I added these with the acks so far to a pci/config
> branch for v3.20.  I'll update it with more acks if they trickle in.

Thanks.

> You've structured it nicely so I can also just drop individual arch pieces
> if necessary.  The pieces that haven't been acked yet (hint, hint):
>
>     arch/arm/mach-cns3xxx/pcie.c
>     arch/arm/mach-sa1100/pci-nanoengine.c

Some ARM sub-arch maintainers tend to not respond on things. These are
platforms which aren't very active and aren't going to move to
drivers/pci/host/ anytime soon. Maybe Arnd wants to ack them.

>     arch/mn10300/unit-asb2305/pci.c
>     arch/powerpc
>
> In addition, nobody has acked the frv and mips parts, but they're trivial
> (they only add struct member names) that I can apply them without worrying.

You must pick-up the 4 clean-up ones or the build will break for those
platforms. Or perhaps that will encourage some acks.

I've also got some actual conversions for some MIPS platforms in my
tree I haven't sent out yet. MIPS is fun with all the variety of
endianness and h/w swapping capability or not.

Rob
