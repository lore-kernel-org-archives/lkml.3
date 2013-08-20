Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3HTP1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:27:38 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:37451 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab3HTP1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:27:36 -0400
Message-ID: <1377012381.26268.42.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v4 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DWC3 core
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: balbi@ti.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Paul Zimmerman <paul.zimmerman@synopsys.com>
Date: Tue, 20 Aug 2013 18:26:21 +0300
In-Reply-To: <8691FDFE-326E-4198-838A-202D9EC988E1@codeaurora.org>
References: <1376992565-22292-1-git-send-email-iivanov@mm-sol.com>
	 <1376992565-22292-3-git-send-email-iivanov@mm-sol.com>
	 <20130820122907.GU26587@radagast>
	 <1377005543.26268.22.camel@iivanov-dev.int.mm-sol.com>
	 <20130820133712.GC26587@radagast>
	 <1377007751.26268.27.camel@iivanov-dev.int.mm-sol.com>
	 <20130820143319.GG26587@radagast>
	 <1377010458.26268.30.camel@iivanov-dev.int.mm-sol.com>
	 <8691FDFE-326E-4198-838A-202D9EC988E1@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 10:01 -0500, Kumar Gala wrote: 
> On Aug 20, 2013, at 9:54 AM, Ivan T. Ivanov wrote:
> 
> > 
> > Hi, 
> > 
> > On Tue, 2013-08-20 at 09:33 -0500, Felipe Balbi wrote: 
> >> On Tue, Aug 20, 2013 at 05:09:11PM +0300, Ivan T. Ivanov wrote:
> >>> Hi,
> >>> 
> >>> On Tue, 2013-08-20 at 08:37 -0500, Felipe Balbi wrote: 
> >>>> Hi,
> >>>> 
> >>>> On Tue, Aug 20, 2013 at 04:32:23PM +0300, Ivan T. Ivanov wrote:
> >>>>>> On Tue, Aug 20, 2013 at 12:56:04PM +0300, Ivan T. Ivanov wrote:
> >>>>>>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> >>>>>>> 
> >>>>>>> These drivers handles control and configuration of the HS
> >>>>>>> and SS USB PHY transceivers. They are part of the driver
> >>>>>>> which manage Synopsys DesignWare USB3 controller stack
> >>>>>>> inside Qualcomm SoC's.
> >>>>>>> 
> >>>>>>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> >>>>>>> ---
> >>>>>>> drivers/usb/phy/Kconfig           |   11 ++
> >>>>>>> drivers/usb/phy/Makefile          |    2 +
> >>>>>>> drivers/usb/phy/phy-msm-dwc3-hs.c |  327 ++++++++++++++++++++++++++++++++
> >>>>>>> drivers/usb/phy/phy-msm-dwc3-ss.c |  374 +++++++++++++++++++++++++++++++++++++
> >>>>>> 
> >>>>>> please rename these PHY drivers, they have nothing to do with DWC3. PHYs
> >>>>>> don't care about the USB controller.
> >>>>> 
> >>>>> I think they are SNPS DesignWare PHY's, additionally
> >>>>> wrapped with Qualcomm logic. I could substitute "dwc3"
> >>>>> with just "dw", which will be more correct.
> >>>> 
> >>>> alright, thank you. Let's add Paul to the loop since he might have very
> >>>> good insight in the synopsys PHYs.
> >>>> 
> >>>> mental note: if any other platform shows up with Synopsys PHY, ask them
> >>>> to use this driver instead :-)
> >>> 
> >>> I really doubt that this will bi possible. Control of the PHY's is
> >>> not directly trough ULPI, UTMI or PIPE3 interfaces, but trough
> >>> QSCRATCH registers, which of course is highly Qualcomm specific.
> >> 
> >> isn't it a memory mapped IP ? doesn't synopsys provide their own set of
> >> registers ?
> > 
> > From what I see it is not directly mapped. How QSCRATCH write and
> > reads transactions are translated to DW IP is unclear to me.
> 
> 
> I think the question is how does SW access them?

"USB QSCRATCH Hardware registers" don't ask me what is this :-)
or like Pawel says: "it depends on the SOC" .

Ivan

> 
> - k
> 


