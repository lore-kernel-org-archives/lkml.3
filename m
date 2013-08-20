Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3HTRBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:01:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46451 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3HTRBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:01:36 -0400
Message-ID: <1377018092.31445.42.camel@hornet>
Subject: Re: [PATCH v4 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DWC3 core
From: Pawel Moll <pawel.moll@arm.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "idos@codeaurora.org" <idos@codeaurora.org>,
        "mgautam@codeaurora.org" <mgautam@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Paul Zimmerman <paul.zimmerman@synopsys.com>
Date: Tue, 20 Aug 2013 18:01:32 +0100
In-Reply-To: <1377011163.31445.30.camel@hornet>
References: <1376992565-22292-1-git-send-email-iivanov@mm-sol.com>
	 <1376992565-22292-3-git-send-email-iivanov@mm-sol.com>
	 <20130820122907.GU26587@radagast>
	 <1377005543.26268.22.camel@iivanov-dev.int.mm-sol.com>
	 <20130820133712.GC26587@radagast>
	 <1377007751.26268.27.camel@iivanov-dev.int.mm-sol.com>
	 <20130820143319.GG26587@radagast>
	 <1377010458.26268.30.camel@iivanov-dev.int.mm-sol.com>
	 <8691FDFE-326E-4198-838A-202D9EC988E1@codeaurora.org>
	 <1377011163.31445.30.camel@hornet>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 20 Aug 2013 17:01:32.0363 (UTC) FILETIME=[EBB0A1B0:01CE9DC6]
X-MC-Unique: 113082018013304801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 16:06 +0100, Pawel Moll wrote:
> On Tue, 2013-08-20 at 16:01 +0100, Kumar Gala wrote:
> > On Aug 20, 2013, at 9:54 AM, Ivan T. Ivanov wrote:
> > 
> > > 
> > > Hi, 
> > > 
> > > On Tue, 2013-08-20 at 09:33 -0500, Felipe Balbi wrote: 
> > >> On Tue, Aug 20, 2013 at 05:09:11PM +0300, Ivan T. Ivanov wrote:
> > >>> Hi,
> > >>> 
> > >>> On Tue, 2013-08-20 at 08:37 -0500, Felipe Balbi wrote: 
> > >>>> Hi,
> > >>>> 
> > >>>> On Tue, Aug 20, 2013 at 04:32:23PM +0300, Ivan T. Ivanov wrote:
> > >>>>>> On Tue, Aug 20, 2013 at 12:56:04PM +0300, Ivan T. Ivanov wrote:
> > >>>>>>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > >>>>>>> 
> > >>>>>>> These drivers handles control and configuration of the HS
> > >>>>>>> and SS USB PHY transceivers. They are part of the driver
> > >>>>>>> which manage Synopsys DesignWare USB3 controller stack
> > >>>>>>> inside Qualcomm SoC's.
> > >>>>>>> 
> > >>>>>>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > >>>>>>> ---
> > >>>>>>> drivers/usb/phy/Kconfig           |   11 ++
> > >>>>>>> drivers/usb/phy/Makefile          |    2 +
> > >>>>>>> drivers/usb/phy/phy-msm-dwc3-hs.c |  327 ++++++++++++++++++++++++++++++++
> > >>>>>>> drivers/usb/phy/phy-msm-dwc3-ss.c |  374 +++++++++++++++++++++++++++++++++++++
> > >>>>>> 
> > >>>>>> please rename these PHY drivers, they have nothing to do with DWC3. PHYs
> > >>>>>> don't care about the USB controller.
> > >>>>> 
> > >>>>> I think they are SNPS DesignWare PHY's, additionally
> > >>>>> wrapped with Qualcomm logic. I could substitute "dwc3"
> > >>>>> with just "dw", which will be more correct.
> > >>>> 
> > >>>> alright, thank you. Let's add Paul to the loop since he might have very
> > >>>> good insight in the synopsys PHYs.
> > >>>> 
> > >>>> mental note: if any other platform shows up with Synopsys PHY, ask them
> > >>>> to use this driver instead :-)
> > >>> 
> > >>> I really doubt that this will bi possible. Control of the PHY's is
> > >>> not directly trough ULPI, UTMI or PIPE3 interfaces, but trough
> > >>> QSCRATCH registers, which of course is highly Qualcomm specific.
> > >> 
> > >> isn't it a memory mapped IP ? doesn't synopsys provide their own set of
> > >> registers ?
> > > 
> > > From what I see it is not directly mapped. How QSCRATCH write and
> > > reads transactions are translated to DW IP is unclear to me.
> > 
> > 
> > I think the question is how does SW access them?
> 
> I afraid the answer may be: "it depends on the SOC". In my past I had to
> initialize a (SATA) PHY by implementing a software JTAG state machine,
> as the PHY's registers were not memory mapped *at all*. And the IP
> itself came from Synopsys, Cadence or yet another EDA company...

Having said all that... If the PHY's spec at least defined layout of the
registers in question and driver was using regmap API to talk to the
device (initially regmap-mmio), it has some chances to become universal.
The SOCs designed like "my" one would have to provide a custom regmap
implementation.

Paweł


