Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab3CTMPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:15:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2597 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab3CTMPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:15:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Mar 2013 05:08:35 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: kishon <kishon@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Wed, 20 Mar 2013 17:45:43 +0530
Subject: RE: [PATCH 1/7] ARM: tegra: finalize USB EHCI and PHY bindings
Thread-Topic: [PATCH 1/7] ARM: tegra: finalize USB EHCI and PHY bindings
Thread-Index: Ac4lXNKA/fBxvH++QqOOrdw6NL3KsAAB3Vew
Message-ID: <D958900912E20642BCBC71664EFECE3E6E5092FFE5@BGMAIL02.nvidia.com>
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com>
 <1363609781-4045-2-git-send-email-vbyravarasu@nvidia.com>
 <51499B3E.3080602@ti.com>
In-Reply-To: <51499B3E.3080602@ti.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: kishon [mailto:kishon@ti.com]
> Sent: Wednesday, March 20, 2013 4:49 PM
> To: Venu Byravarasu
> Cc: gregkh@linuxfoundation.org; stern@rowland.harvard.edu;
> balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> swarren@wwwdotorg.org; linux-tegra@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org
> Subject: Re: [PATCH 1/7] ARM: tegra: finalize USB EHCI and PHY bindings
> 
> Hi,
> 
> On Monday 18 March 2013 05:59 PM, Venu Byravarasu wrote:
> > The existing Tegra USB bindings have a few issues:
> >
> > 1) Many properties are documented as being part of the EHCI controller
> > node, yet they apply more to the PHY device. They should be moved.
> >
> > 2) Some registers in PHY1 are shared with PHY3, and hence PHY3 needs a
> > reg entry to point at PHY1's register space. We can't assume the PHY1
> > driver is present, so the PHY3 driver will directly access those
> > registers.
> >
> > 3) The list of clocks required by the PHY was missing some required
> > entries.
> >
> > This patch fixes the binding definition to resolve these issues.
> >
> > Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> > ---
> >   .../bindings/usb/nvidia,tegra20-ehci.txt           |   27 +++----------------
> >   .../bindings/usb/nvidia,tegra20-usb-phy.txt        |   27
> +++++++++++++++++--
> >   2 files changed, 29 insertions(+), 25 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
> b/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
> > index 34c9528..df09330 100644
> > --- a/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
> > +++ b/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
> > @@ -6,27 +6,10 @@ Practice : Universal Serial Bus" with the following
> modifications
> >   and additions :
> >
> >   Required properties :
> > - - compatible : Should be "nvidia,tegra20-ehci" for USB controllers
> > -   used in host mode.
> > - - phy_type : Should be one of "ulpi" or "utmi".
> >
> >   Optional properties:
> > -  - dr_mode : dual role mode. Indicates the working mode for

> > index 6bdaba2..7ceccd3 100644
> > --- a/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
> > +++ b/Documentation/devicetree/bindings/usb/nvidia,tegra20-usb-phy.txt
> > @@ -4,8 +4,24 @@ The device node for Tegra SOC USB PHY:
> >
> >   Required properties :
> > + - phy_type : Should be one of "utmi", "ulpi" or "hsic".
> 
> dt property names generally dont have "_".

Thanks Kishon, for your comments.
Is it mandatory or optional?
If it is mandatory, then I might have to change dr_mode as well along with phy_type.
 
> 
> Thanks
> Kishon
