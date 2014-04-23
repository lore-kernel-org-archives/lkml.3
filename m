Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaDWOXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:23:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50046 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbaDWOXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:23:20 -0400
Date: Wed, 23 Apr 2014 15:23:16 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Byungho An'" <bh74.an@samsung.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilho215.lee@samsung.com" <ilho215.lee@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/2] PCI: exynos: Add PCIe support for Samsung GH7 SoC
Message-ID: <20140423142315.GO865@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	"linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
	Kukjin Kim <kgene.kim@samsung.com>,
	'Jingoo Han' <jg1.han@samsung.com>,
	'Byungho An' <bh74.an@samsung.com>,
	'linux-pci' <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ilho215.lee@samsung.com" <ilho215.lee@samsung.com>,
	'Bjorn Helgaas' <bhelgaas@google.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
 <201404221611.40087.arnd@arndb.de>
 <031b01cf5ed5$21d536a0$657fa3e0$@samsung.com>
 <4565008.ZECF3eWqge@wuerfel>
MIME-Version: 1.0
In-Reply-To: <4565008.ZECF3eWqge@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 23 Apr 2014 14:23:31.0811 (UTC) FILETIME=[9A75B330:01CF5EFF]
X-MC-Unique: 114042315231806701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 12:03:47PM +0100, Arnd Bergmann wrote:
> On Wednesday 23 April 2014 18:19:30 Kukjin Kim wrote:
> > 
> 
> > Basically, ARMv8 based GH7 has same PCIe hardware IP with previous ARMv7
> > based exynos5440, several features in PCIe are different though. In other
> > words, basic functionalities for PCIe are same. So I think, would be nice if
> > we could use one PCIe device driver for both SoCs.
> 
> Ok, I see. I was just trying to get a feeling for how much is shared
> or SoC specific between your variants. If they are different enough,
> it may be easier to have two drivers.
> 
> > However, if we need to support the PCIe with each own device driver because
> > of difference of 32bit and 64bit, please kindly let us know. Honestly, I'm
> > not sure about that right now.
> 
> We are working already on ideas to minimize the differences between
> arm32 and arm64 PCI support, it will just take more work.
> 
> > > Also, if gh7 is expected to run a full firmware, I think you should
> > > do all the setup in the firmware before booting Linux, and just
> > > do the required run-time operations in the driver itself.
> > > 
> > Well, we're expecting that all the setup should be done by the device driver
> > in kernel not firmware.
> 
> Ok, just make sure this hardware never shows up in servers then.

Not necessarily, as long as the setup will always happen in the kernel?

> 
> Unfortunately we are in a tricky situation on arm64 because we have
> to support both server-type SoCs and embedded-type SoCs. In an
> embedded system, you can't trust the boot loader to do a proper
> setup of all the hardware, so the kernel needs full control over
> all the initialization. In a server, the initialization is the
> responsibility of the firmware, and we don't want the kernel to
> even know about those registers.
> 
> My hope is that all server chips use an SBSA compliant PCIe
> implementation, but we already have X-Gene, which is doing server
> workloads with a nonstandard PCIe, and it's possible that there
> will also be server-like systems with a DesignWare PCIe block
> instead of an SBSA compliant one. We can still support those, but
> I don't want to see more than one implementation of dw-pcie
> on servers. Just like we have the generic PCIe support that Will
> is doing for virtual machines and SBSA compliant systems, we
> would do one dw-pcie variant for all systems that come with a
> host firmware and rely on it being set up already.

There is nothing in the SBSA that mandates firmware setup. All it requires
is that hardware is setup in a way that is not specific to a board
or a particular OEM. Surely if the setup being done for GH7 is always
the same it should fit the bill?

Kind regards,
Liviu


> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

