Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaDXM0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:26:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59513 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaDXM0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:26:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [RFC PATCH 2/2] PCI: exynos: Add PCIe support for Samsung GH7 SoC
Date: Thu, 24 Apr 2014 14:25:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kukjin Kim <kgene.kim@samsung.com>, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Byungho An'" <bh74.an@samsung.com>,
        "ilho215.lee@samsung.com" <ilho215.lee@samsung.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <000801cf592e$30b7bff0$92273fd0$%han@samsung.com> <031b01cf5ed5$21d536a0$657fa3e0$@samsung.com> <20140423130012.GL865@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140423130012.GL865@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404241425.31625.arnd@arndb.de>
X-Provags-ID: V02:K0:DsrG/oJ4zltZ7T3C/3RgE4rkkO+YJejrxRZ2jx8tE7T
 dPYFDOwLPkn7/DssMnLX9ElHQ2D4xogx8OX5DkfDoqafWHfRqm
 LWds30BnFa8h1rk2VSaB95r4aTm+emD8EIvBYeuJsROmw1au3a
 kAAfHoDAR/GXMsRoMVRqvw+w+k+pI+Om1rxTuQL9e++eMG8Vu3
 mDGTbCeZLlA45vgbhA3gNMWU/5xyBnbPhy16WihSI26bRQ0oYv
 Y4dccFEDoUEkwzsttMWqgjrHcIx57lgJsR434NAnS5xlwOq5mZ
 cCf7/i9Rp3BNqORwiC/WnNNXM1AIpzFpD/hzfi85FzyxndDAV0
 iZeLCJVuJZC7Np+OGdMo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2014, Liviu Dudau wrote:
> On Wed, Apr 23, 2014 at 10:19:30AM +0100, Kukjin Kim wrote:
> > Arnd Bergmann wrote:
> > > 
> > > Can you explain how much the GH7 and Exynos front-ends actually have in
> > > common? Would it make sense to have a separate driver for gh7?
> > > 
> > Basically, ARMv8 based GH7 has same PCIe hardware IP with previous ARMv7
> > based exynos5440, several features in PCIe are different though. In other
> > words, basic functionalities for PCIe are same. So I think, would be nice if
> > we could use one PCIe device driver for both SoCs.
> > 
> > However, if we need to support the PCIe with each own device driver because
> > of difference of 32bit and 64bit, please kindly let us know. Honestly, I'm
> > not sure about that right now.
> 
> Hi Kukjin,
> 
> I will let Arnd offer his view as a maintainer of DT enabled platforms for 
> arch/arm, but in my understanding the goal is to convert individual host
> bridge drivers to use my patch series directly, as they intentionally don't
> depend on any arch specific code and then leave the existing bios32 code
> for the non-DT platforms and the ones that do not see the need to convert
> to the framework.
>
> Rob Herring has posted an example on how he can add support for a host
> bridge running under arm32 that uses my framework, so it is not an impossible
> task and can be used as an example for future conversions.

Yes, I agree that would be the best approach. I'm not sure if it
makes sense to convert the various dw-pcie front-ends separately
or if we have to do them all at once though. Doing them together
may require some more coordination.

Let's also make sure to keep Russell in the loop regarding arm32
PCI support. He probably has some ideas as well on how we should
proceed with the existing code.

	Arnd
