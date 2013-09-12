Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab3ILKSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:18:25 -0400
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:37825 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751182Ab3ILKSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:18:22 -0400
Date: Thu, 12 Sep 2013 15:48:03 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
Message-ID: <20130912101803.GB5995@pratyush-vbox>
References: <51ED49D6.9050209@ti.com>
 <000701ce8741$fe47deb0$fad79c10$@samsung.com>
 <51EE22DF.6090902@ti.com>
 <001301ce8772$522dfc50$f689f4f0$@samsung.com>
 <5231607C.10702@ti.com>
 <003501ceaf87$cda45db0$68ed1910$%han@samsung.com>
 <20130912093018.GA2124@pratyush-vbox>
 <52318CCC.4040604@ti.com>
 <20130912095213.GA5995@pratyush-vbox>
 <5231925B.3030104@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5231925B.3030104@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 06:07:23PM +0800, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Thursday 12 September 2013 03:22 PM, Pratyush Anand wrote:
> > Hi Kishon,
> > 
> > On Thu, Sep 12, 2013 at 05:43:40PM +0800, Kishon Vijay Abraham I wrote:
> >> Hi,
> >>
> >> On Thursday 12 September 2013 03:00 PM, Pratyush Anand wrote:
> >>> Hi Jingoo,
> >>>
> >>>
> >>> On Thu, Sep 12, 2013 at 03:15:04PM +0800, Jingoo Han wrote:
> >>>> On Tuesday 23 July 2013 12:30 PM, Kishon Vijay Abraham I wrote:
> >>>>>>> .
> >>>>>>> .

[...]

> >> when I do ifconfig eth0 up, I get *r8169 0000:01:00.0 eth0: link up.*
> >> But I dont receive any packets and ping also fails and the tx and rx packet
> >> count is also 0. Could it be related to inbound translation?
> > 
> > A PCIe analyser log would tell a definite cause. Most likely either
> > inbound translation is not working or INTx/MSI is not working.
> 
> I have enabled only legacy interrupts. Whenever I connect or disconnect
> ethernet cable I get link up/link down message and also the interrupt count for
> eth0 increases. So I'm not doubting INTx interrupts as such.
> 
> btw configuring inbound translation once in dw_pcie_host_init enough is it? I
> mean we use the same registers for configuring outbound translation also no? So
> doesn't the inbound configuration gets lost?

No, you write at the same register, but you program direction as
inbound. There are different resources for each viewport in inbound
and outbound direction.

Regards
Pratyush

> 
> Thanks
> Kishon
