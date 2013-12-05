Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3LEKnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:43:07 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40988 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658Ab3LEKnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:43:04 -0500
Date: Thu, 5 Dec 2013 10:42:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "davidb@codeaurora.org" <davidb@codeaurora.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manu Gautam <mgautam@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 12/15] usb: phy: msm: Add support for secondary PHY
 control
Message-ID: <20131205104252.GK29200@e106331-lin.cambridge.arm.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
 <1384267910-32066-13-git-send-email-iivanov@mm-sol.com>
 <20131115164212.GI24831@e106331-lin.cambridge.arm.com>
 <1384779462.13631.16.camel@iivanov-dev.int.mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384779462.13631.16.camel@iivanov-dev.int.mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 12:57:42PM +0000, Ivan T. Ivanov wrote:
> 
> Hi Mark,
> 
> On Fri, 2013-11-15 at 16:42 +0000, Mark Rutland wrote: 
> > On Tue, Nov 12, 2013 at 02:51:47PM +0000, Ivan T. Ivanov wrote:
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > 
> > > Allow support to use 2nd HSPHY with USB2 Core.
> > > Some platforms may have configuration to allow USB controller
> > > work with any of the two HSPHYs present. By default driver
> > > configures USB core to use primary HSPHY. Add support to allow
> > > user select 2nd HSPHY using DT parameter.
> > > 
> > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > Cc: Manu Gautam <mgautam@codeaurora.org>
> > > Cc: devicetree@vger.kernel.org
> > > ---
> > >  .../devicetree/bindings/usb/msm-hsusb.txt          |    6 +++++
> > >  drivers/usb/phy/phy-msm-usb.c                      |   24 ++++++++++++++++++--
> > >  include/linux/usb/msm_hsusb.h                      |    1 +
> > >  include/linux/usb/msm_hsusb_hw.h                   |    1 +
> > >  4 files changed, 30 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> > > index 3f21204..d105ba9 100644
> > > --- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> > > +++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> > > @@ -72,6 +72,12 @@ Optional properties:
> > >  - qcom,phy-init-sequence: PHY configuration sequence. val, reg pairs
> > >  				terminate with -1
> > >  
> > > +- qcom,phy-num:	Select number of pyco-phy to use, can be one of
> > > +				0 - PHY one, default
> > > +				1 - Second PHY
> > > +				Some platforms may have configuration to allow USB
> > > +				controller work with any of the two HSPHYs present.
> > > +
> > 
> > Only one can be used at a time?
> 
> Yes only one of them. Selected at driver init time. 

Ok. For a given platform, is it likely that both are wired up and
_possibly_ usable?

Thanks
Mark.
