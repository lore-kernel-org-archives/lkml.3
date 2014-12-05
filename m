Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaLEKlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:41:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50243 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbaLEKlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:41:06 -0500
Date: Fri, 5 Dec 2014 10:40:09 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/5] Add Spreadtrum Sharkl64 Platform support
Message-ID: <20141205104009.GE11889@leverpostej>
References: <sc9836v4>
 <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
Thread-Topic: [PATCH v4 0/5] Add Spreadtrum Sharkl64 Platform support
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 04, 2014 at 11:34:15AM +0000, Chunyan Zhang wrote:
> Spreadtrum is a rapid growing chip vendor providing smart phone total solutions.
> 
> Sharkl64 Platform is nominated as a SoC infrastructure that supports 4G/3G/2G
> standards based on ARMv8 multiple core architecture.Now we have only one
> SoC(SC9836) based on this Platform in developing.
> 
> This patchset adds Sharkl64 support in arm64 device tree and the serial driver
> of SC9836-UART.
> 
> This patchset also has patches which address "sprd" prefix and DT compatible
> strings for nodes which appear un-documented.
> 
> This version code was tesed both on Fast Mode and sc9836-fpga board.
> We use the latest boot-wrapper-aarch64 as the bootloader.
> 
> Changes from v3:
> * Addressed review comments:
> 	- Added the description of clock property for sc9836-uart
> 	- Revised the size of GICC to be 8KiB
> 	- Added another compatible string for psci-0.1

I had open questions on v3 regarding your PSCI imlpementation. You
mentioned that you are using the aarch64 bootwrapper, but your DT
describes PSCI 0.2, and the (upstream) bootwrapper does not implement
PSCI 0.2. Adding the old PSCI compatible string is _not_ sufficient if
you do not have a full PSCI 0.2 implementation.

Given that PSCI 0.2 requires more functionality to be implemented, I'd
like to know that your implementation is spec-compliant (implementing
the mandatory functions, nters the kernel in the correct state, etc),
and that it has been tested.

Would you be able to look at my comments from the last posting please?

Thanks,
Mark.
