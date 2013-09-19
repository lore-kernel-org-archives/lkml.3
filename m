Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab3ISMWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:22:54 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:34174 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3ISMWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:22:52 -0400
Date: Thu, 19 Sep 2013 13:22:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: core: introduce of_node_name for mfd sub devices
Message-ID: <20130919122240.GI22389@lee--X1>
References: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com>
 <20130919083050.GH16984@lee--X1>
 <20130919115501.GM21013@sirena.org.uk>
 <20130919120051.GG22389@lee--X1>
 <523AEE07.9090405@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <523AEE07.9090405@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>Do the sub-nodes have their own properties? If so, it would be worth
> >>>breaking them up as other OSes could reuse the specifics. If they do,
> >>>then you need so put them in the binding. If they don't, then you do
> >>>not require sub-nodes. The MFD core will ensure the sub-devices are
> >>>probed and there is no requirement for the of_node to be assigned.
> >>You do see some reusable IP blocks (like the regualtors on the wm831x
> >>PMICs for example, they're repeated blocks) which can be reused but
> >>generally they have a register base as part of the binding.  Personally
> >>if it's just a property or two I'd probably just put them on the root
> >>node for the device.
> >Agreed. Besides, there doesn't seem to be *any* sub-device properties
> >defined in the binding document. So what are you trying to achieve
> >with the child nodes?
> 
> I wanted to have the DT like:
> 
> as3722 {
>                 compatible = "ams,as3722";
>                 reg = <0x40>;
> 
>                 #interrupt-controller;
>                 .....
> 
> 
>                 regulators {
>                             ldo1-in-supply = <..>;
>                             ....
>                             sd0 {
>                                     regulator-name = "vdd-cpu";
>                                     .....
>                             };
>                             sd1 {
>                                     regulator-name = "vdd-ddr";
>                                     .....
>                             };
>                             ....
>             };
> };
> 
> And regulator driver should get the regulator node by their
> pdev->dev.of_node.
> Currently, in most of driver, we are having the code on regulator
> driver to get "regulators" node from parent node which I want to
> avoid.

Ah, I see. Yes, I believe the regulators should have their own node,
complete with a compatible string. To have each regulator listed
separately in the parent node seems a little messy. Just out of
interest, how many regulators are we talking about here?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
