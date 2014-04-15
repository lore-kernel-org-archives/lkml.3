Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaDOLsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:48:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39711 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750960AbaDOLsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:48:51 -0400
Date: Tue, 15 Apr 2014 13:48:49 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jisheng Zhang <jszhang@marvell.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: berlin: add GPIO nodes for the BG2Q
Message-ID: <20140415114848.GA2813@piout.net>
References: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397549245-3338-3-git-send-email-antoine.tenart@free-electrons.com>
 <534CFA77.9030108@gmail.com>
 <20140415180058.2fefca78@xhacker>
 <534D0943.2050100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <534D0943.2050100@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/04/2014 at 12:26:11 +0200, Sebastian Hesselbarth wrote :
> On 04/15/2014 12:00 PM, Jisheng Zhang wrote:
> >On Tue, 15 Apr 2014 02:23:03 -0700
> >Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
> >>On 04/15/2014 10:07 AM, Antoine Ténart wrote:
> >>>The Marvell Berlin BG2Q has 6 GPIO ports compatible with the
> >>>snps,dw-apb-gpio driver. This patch add the corresponding device tree
> >>>nodes.
> >>>
> >>>Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> >>>---
> >>>   arch/arm/boot/dts/berlin2q.dtsi | 102
> >>>++++++++++++++++++++++++++++++++++++++++ 1 file changed, 102 insertions(+)
> >>>
> >>>diff --git a/arch/arm/boot/dts/berlin2q.dtsi
> >>>b/arch/arm/boot/dts/berlin2q.dtsi index e6e556055dfc..b2625f896bc5 100644
> >>>--- a/arch/arm/boot/dts/berlin2q.dtsi
> >>>+++ b/arch/arm/boot/dts/berlin2q.dtsi
> [...]
> >>>+					compatible =
> >>>"snps,dw-apb-gpio-port";
> >>>+					gpio-controller;
> >>>+					#gpio-cells = <2>;
> >>>+					snps,nr-gpios = <32>;
> >>
> >>32 gpio pins for each of the 6 GPIO controllers? Either BG2Q is a GPIO
> >
> >Yes, BG2Q support 32 pins every port
> 
> Wow. Thanks for confirming this!
> 
> >>I am fine with using nr-gpios property now, but I guess BG2Q also
> >>has that CONFIG[1,2] registers to actually read out the features
> >>synthesized in? If I find some time, I'll prepare a patch for
> >>dw-apb-gpio to exploit that (optional) information instead of
> >>using nr-gpios.
> >
> >The problem is CONFIG1/2 registers don't exist on some versions.
> >For example, the version used in BG2/BG2CD. So nr-gpio is necessary
> >if we want to support these versions.
> 
> Hmm, are you sure about BG2? I remember reading it and it contains
> sane values. Anyway, a proper patch for dw-apb-gpio would include
> checking for sane (e.g. non-zero) values. And nr-gpios will always
> stay as fall-back just because e.g. sunxi does not have the CONFIG
> registers.
> 

Shouldn't that be use nr-gpios and if not available, read the CONFIG
registers? Else, what about bogus registers ?

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
