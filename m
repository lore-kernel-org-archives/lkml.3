Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaDWNAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:00:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54818 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbaDWNAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:00:16 -0400
Date: Wed, 23 Apr 2014 14:00:12 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Byungho An'" <bh74.an@samsung.com>,
        "ilho215.lee@samsung.com" <ilho215.lee@samsung.com>
Subject: Re: [RFC PATCH 2/2] PCI: exynos: Add PCIe support for Samsung GH7 SoC
Message-ID: <20140423130012.GL865@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Kukjin Kim <kgene.kim@samsung.com>,
	'Arnd Bergmann' <arnd@arndb.de>, 'Jingoo Han' <jg1.han@samsung.com>,
	'linux-pci' <linux-pci@vger.kernel.org>,
	'Bjorn Helgaas' <bhelgaas@google.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	'Byungho An' <bh74.an@samsung.com>,
	"ilho215.lee@samsung.com" <ilho215.lee@samsung.com>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com>
 <000a01cf592e$67e592e0$37b0b8a0$%han@samsung.com>
 <201404221611.40087.arnd@arndb.de>
 <031b01cf5ed5$21d536a0$657fa3e0$@samsung.com>
MIME-Version: 1.0
In-Reply-To: <031b01cf5ed5$21d536a0$657fa3e0$@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 23 Apr 2014 13:00:28.0828 (UTC) FILETIME=[005ED5C0:01CF5EF4]
X-MC-Unique: 114042314001404801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 10:19:30AM +0100, Kukjin Kim wrote:
> Arnd Bergmann wrote:
> > 
> > On Wednesday 16 April 2014, Jingoo Han wrote:
> > > Samsung GH7 has four PCIe controllers which can be used as root
> > > complex for PCIe interface.
> > >
> > > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > > ---
> > >  drivers/pci/host/Kconfig      |    2 +-
> > >  drivers/pci/host/pci-exynos.c |  135
> > ++++++++++++++++++++++++++++++++++++++---
> > >  2 files changed, 126 insertions(+), 11 deletions(-)
> > 
> + Byungho An, Ilho Lee
> 
> Hi Arnd,
> 
> > Can you explain how much the GH7 and Exynos front-ends actually have in
> > common? Would it make sense to have a separate driver for gh7?
> > 
> Basically, ARMv8 based GH7 has same PCIe hardware IP with previous ARMv7
> based exynos5440, several features in PCIe are different though. In other
> words, basic functionalities for PCIe are same. So I think, would be nice if
> we could use one PCIe device driver for both SoCs.
> 
> However, if we need to support the PCIe with each own device driver because
> of difference of 32bit and 64bit, please kindly let us know. Honestly, I'm
> not sure about that right now.

Hi Kukjin,

I will let Arnd offer his view as a maintainer of DT enabled platforms for 
arch/arm, but in my understanding the goal is to convert individual host
bridge drivers to use my patch series directly, as they intentionally don't
depend on any arch specific code and then leave the existing bios32 code
for the non-DT platforms and the ones that do not see the need to convert
to the framework.

Rob Herring has posted an example on how he can add support for a host
bridge running under arm32 that uses my framework, so it is not an impossible
task and can be used as an example for future conversions.

Does that make sense?

Best regards,
Liviu

> 
> > Also, if gh7 is expected to run a full firmware, I think you should
> > do all the setup in the firmware before booting Linux, and just
> > do the required run-time operations in the driver itself.
> > 
> Well, we're expecting that all the setup should be done by the device driver
> in kernel not firmware.
> 
> Thanks,
> Kukjin
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

