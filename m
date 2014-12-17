Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaLQGQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 01:16:53 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62780 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLQGQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 01:16:50 -0500
MIME-Version: 1.0
In-Reply-To: <20141215133817.GD8264@leverpostej>
References: <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<20141205104009.GE11889@leverpostej>
	<CAAfSe-uz534FiZufojKa8MdBi=VFqhuoFLwof7K+FqXG--AGaw@mail.gmail.com>
	<20141215133817.GD8264@leverpostej>
Date: Wed, 17 Dec 2014 14:16:47 +0800
Message-ID: <CAAfSe-u1PXP1KS5qGRKboCyJ7k-eDRizC76Xs3uwCsNyk7XZ9g@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] Add Spreadtrum Sharkl64 Platform support
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "hytszk@gmail.com" <hytszk@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "allen.zhang@spreadtrum.com" <allen.zhang@spreadtrum.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark

On Mon, Dec 15, 2014 at 9:38 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Fri, Dec 05, 2014 at 12:27:23PM +0000, Lyra Zhang wrote:
>> On Fri, Dec 5, 2014 at 6:40 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > Hi,
>> >
>> > On Thu, Dec 04, 2014 at 11:34:15AM +0000, Chunyan Zhang wrote:
>> >> Spreadtrum is a rapid growing chip vendor providing smart phone total solutions.
>> >>
>> >> Sharkl64 Platform is nominated as a SoC infrastructure that supports 4G/3G/2G
>> >> standards based on ARMv8 multiple core architecture.Now we have only one
>> >> SoC(SC9836) based on this Platform in developing.
>> >>
>> >> This patchset adds Sharkl64 support in arm64 device tree and the serial driver
>> >> of SC9836-UART.
>> >>
>> >> This patchset also has patches which address "sprd" prefix and DT compatible
>> >> strings for nodes which appear un-documented.
>> >>
>> >> This version code was tesed both on Fast Mode and sc9836-fpga board.
>> >> We use the latest boot-wrapper-aarch64 as the bootloader.
>> >>
>> >> Changes from v3:
>> >> * Addressed review comments:
>> >>       - Added the description of clock property for sc9836-uart
>> >>       - Revised the size of GICC to be 8KiB
>> >>       - Added another compatible string for psci-0.1
>> >
>> > I had open questions on v3 regarding your PSCI imlpementation. You
>> > mentioned that you are using the aarch64 bootwrapper, but your DT
>> > describes PSCI 0.2, and the (upstream) bootwrapper does not implement
>> > PSCI 0.2. Adding the old PSCI compatible string is _not_ sufficient if
>> > you do not have a full PSCI 0.2 implementation.
>> >
>> > Given that PSCI 0.2 requires more functionality to be implemented, I'd
>> > like to know that your implementation is spec-compliant (implementing
>> > the mandatory functions, nters the kernel in the correct state, etc),
>> > and that it has been tested.
>> >
>> > Would you be able to look at my comments from the last posting please?
>> >
>> > Thanks,
>> > Mark.
>> > --
>>
>> Hi, Mark
>>
>> Ok, I'll check it again with our related engineers.
>>
>> Actually, I had read all of your comments carefully before sending
>> each version of patches, and I replied you a few days early, I guess
>> you may miss it :)
>>
>> If we just implemented psci-0.1 until now, can we submit this path
>> without "compatible = "arm,psci-0.2"", but only with " compatible =
>> "arm,psci" ".
>
> Elsewhere I've recommended such things are placed in the DTB by the
> bootloader (at least for those cases where the bootlaoder is tied to the
> firmware), as it can fill in the appropriate enable-method (and add any
> other nodes as required).
>
> Having compatible = "arm,psci", and a couple of other properties for now
> is certainly preferable to describing a not-yet-implemented PSCI 0.2.
>
> Thanks,
> Mark.
> --

Thank you for the replay.
I'll still ping my colleagues to implement PSCI 0.2, and test it.
But it perhaps would not be finished soon, because our internal
developing code right now is based on a little old version Linux
kernel which doesn't support  PSCI-0.2

Thanks again,
Chunyan
