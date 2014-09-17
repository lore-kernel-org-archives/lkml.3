Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbaIQTu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 15:50:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62227 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756006AbaIQTu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 15:50:26 -0400
Date: Wed, 17 Sep 2014 20:50:22 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Olof Johansson <olof@lixom.net>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Documentation: dt-bindings: add dt binding info
 for rk3288-smp
Message-ID: <20140917195022.GF7983@leverpostej>
References: <1410864271-9277-1-git-send-email-kever.yang@rock-chips.com>
 <1410864271-9277-2-git-send-email-kever.yang@rock-chips.com>
 <20140916185439.GF14191@leverpostej>
 <5418DFFC.5030808@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5418DFFC.5030808@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 02:12:28AM +0100, Kever Yang wrote:
> Hi Mark,
> 
>      Thanks for your comment.
> On 09/17/2014 02:54 AM, Mark Rutland wrote:
> > On Tue, Sep 16, 2014 at 11:44:28AM +0100, Kever Yang wrote:
> >> This add documentation for rk3288 smp dt binding
> >>
> >> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> >> ---
> >>
> >> Changes in v2:
> >> - add documentation
> >>
> >>   Documentation/devicetree/bindings/arm/cpus.txt | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> >> index 298e2f6..4b46233 100644
> >> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> >> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> >> @@ -195,6 +195,7 @@ nodes to be present and contain the properties described below.
> >>   			    "qcom,kpss-acc-v1"
> >>   			    "qcom,kpss-acc-v2"
> >>   			    "rockchip,rk3066-smp"
> >> +			    "rockchip,rk3288-smp"
> > How do these differ?
> rk3066 and rk3288 smp bring up code is quite different, so I need a new 
> node "rockchip,rk3288-smp"
> other than "rockchip,rk3066-smp".

The code being different is a Linux detail. What is different in the HW
that necessitates the code being different?

> > What does "rockchip,rk3288-smp" mean exactly?
> The driver who using this node is in 2/3 of this patchset, it goes to 
> linux-arm-kernel list and linux-rockchip
> list, I'm not sure if you have get that, maybe I need a RESEND?

Documentaiton and drivers are different things. A binding is a contract,
and for that contract to be meaningful it needs to be described.

> > Presumably other nodes / properties are required?
> Base on linux-next, I think only "rockchip,rk3288-smp" is new node to my 
> driver.

But presumably there are other resources that you require (e.g. a system
controller, perhaps a specific portion of sram). I can't just put
"rockchip,rk3288-smp" into an otherwise empty DT and get SMP support, I
would assume.

Mark.
