Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab3ETDhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:37:12 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:33591
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755236Ab3ETDhK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:37:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI9371I936eI542I1432I4015I1447Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fhbe9i1155h)
From: Liu Shengzhou-B36685 <B36685@freescale.com>
To: Michael Braun <michael.braun@fem.tu-ilmenau.de>,
        Mehresh Ramneek-B31383 <B31383@freescale.com>
CC: "projekt-wlan@fem.tu-ilmenau.de" <projekt-wlan@fem.tu-ilmenau.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Regression in 3735ba8db8e6ea22ad3ff524328926d8d780a884 with
 Freescale P1020
Thread-Topic: Regression in 3735ba8db8e6ea22ad3ff524328926d8d780a884 with
 Freescale P1020
Thread-Index: AQHOVKTREHQoofHZBUeF6TcOpU8t05kNaRUQ
Date: Mon, 20 May 2013 03:37:06 +0000
Message-ID: <3F453DDFF675A64A89321A1F352810219ECBD5@039-SN1MPN1-004.039d.mgd.msft.net>
References: <20130417100809.GA8855@dynamic.fami-braun.de>
 <3F453DDFF675A64A89321A1F3528102199A20F@039-SN1MPN1-004.039d.mgd.msft.net>
 <751900163975fc8d055bd2414c76d59b@fami-braun.de>
 <20130519152230.GA2938@dynamic.fami-braun.de>
In-Reply-To: <20130519152230.GA2938@dynamic.fami-braun.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.68]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Braun,

At that time I had an P4080DS board which had the same issue and had been fixed with this patch.
I didn't test it on P1020 due to the absence of P1020. I think P1020 will need a new patch besides this one.
Later Ramneek took this issue on P1020 for more investigation.

Hello Ramneek, any update for the PHY_CLK_VALID issue?

Regards,
Shengzhou


> -----Original Message-----
> From: Michael Braun [mailto:michael.braun@fem.tu-ilmenau.de]
> Sent: Sunday, May 19, 2013 11:23 PM
> To: Liu Shengzhou-B36685
> Cc: projekt-wlan@fem.tu-ilmenau.de; Greg Kroah-Hartman; linux-
> usb@vger.kernel.org; Alan Stern; linux-kernel@vger.kernel.org
> Subject: Re: Regression in 3735ba8db8e6ea22ad3ff524328926d8d780a884 with
> Freescale P1020
> 
> Hi,
> 
> I've got hardware here to test with, so if there any changes to test, I'm
> willing to support.
> Meanwhile, might it be a good idea to make that check optional - i.e. add
> a module parameter or something like this around it?
> 
> Regards,
>  M. Braun
> 
> On Thu, Apr 18, 2013 at 05:13:39PM +0200, michael-dev wrote:
> > Hi,
> >
> > thanks for the quick reply.
> >
> > >Please review the patch http://patchwork.ozlabs.org/patch/237201/
> > I applied it, but it does not make any difference on my platform.
> >
> > Regards,
> >  M. Braun
> >
> > Am 17.04.2013 12:53, schrieb Liu Shengzhou-B36685:
> > >Hi Braun,
> > >
> > >It seems the duplicated tdi_reset caused the PHY_CLK_VALID bit
> > >unstable, introduced by patch "EHCI: centralize controller
> > >initialization".
> > >I submitted a patch to fix it.
> > >Please review the patch http://patchwork.ozlabs.org/patch/237201/
> > >
> > >Regards,
> > >Shengzhou
> > >
> > >
> > >>-----Original Message-----
> > >>From: Michael Braun [mailto:michael-dev@fami-braun.de]
> > >>Sent: Wednesday, April 17, 2013 6:08 PM
> > >>To: Liu Shengzhou-B36685
> > >>Cc: Alan Stern; projekt-wlan@fem.tu-ilmenau.de; Greg Kroah-Hartman;
> > >>linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > >>Subject: Regression in 3735ba8db8e6ea22ad3ff524328926d8d780a884 with
> > >>Freescale P1020
> > >>
> > >>Hi,
> > >>
> > >>I'm running OpenWRT Kernel 3.8.3 (which already has
> > >>f66dea709cd9309b2ee9f715697818001fb518de and
> > >>5ed338778f917a035f0f0a52327fc4f72e36f7a1 applied) on a P1020WLAN
> > >>(QorlQ,
> > >>PPC) device.
> > >>Before updating the kernel from 3.3.0, USB host support was working
> > >>fine.
> > >>Now I get "fsl-ehci: USB PHY clock invalid" messages in dmesg and
> > >>the lsusb output is empty, so USB host support is not working. When
> > >>I apply the following patch, USB host support starts working again,
> > >>so I guess
> > >>3735ba8db8e6ea22ad3ff524328926d8d780a884 is the cause.
> > >>Do you have an idea how to fix it more appropriately?
> > >>
> > >>Thanks,
> > >>  M. Braun
> > >>
> > >>--- a/drivers/usb/host/ehci-fsl.c       2013-04-15 21:13:52.924403077
> > >>+0200
> > >>+++ b/drivers/usb/host/ehci-fsl.c       2013-04-15 21:13:57.572410838
> > >>+0200
> > >>@@ -273,7 +273,6 @@ static int ehci_fsl_setup_phy(struct usb
> > >>                 if (!spin_event_timeout(in_be32(non_ehci +
> > >>FSL_SOC_USB_CTRL) &
> > >>                                 PHY_CLK_VALID,
> > >>FSL_USB_PHY_CLK_TIMEOUT,
> > >>0)) {
> > >>                         printk(KERN_WARNING "fsl-ehci: USB PHY
> > >>clock invalid\n");
> > >>-                       return -EINVAL;
> > >>                 }
> > >>         }
> > >>


