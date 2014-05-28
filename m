Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaE1Byt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 21:54:49 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40887 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaE1Byp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 21:54:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Nishanth Menon <nm@ti.com>, "Kishon Vijay Abraham I" <kishon@ti.com>,
        "Tero Kristo" <t-kristo@ti.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5374B409.3000607@ti.com>
Cc: "Roger Quadros" <rogerq@ti.com>, "dt list" <devicetree@vger.kernel.org>,
        "Paul Walmsley" <paul@pwsan.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-pci@vger.kernel.org, "Rajendra Nayak" <rnayak@ti.com>,
        "lkml" <linux-kernel@vger.kernel.org>, "Tero Kristo" <t-kristo@ti.com>,
        "linux-omap" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <5373897C.6080504@ti.com>
 <CAGo_u6qw1OomEw_ueb3x+xT+qZLAfGv7Se1K=o725aOoD3ankQ@mail.gmail.com>
 <5374859F.5080902@ti.com> <53748819.8060705@ti.com>
 <CAGo_u6qbbdAbdvrB3AFXSH1qD5MaBkJbi6oJJvvTWW4xfbmd_Q@mail.gmail.com>
 <5374AC0A.7070709@ti.com>
 <CAGo_u6r8XtGHOvsfJKQMZ2ghFRz8x8_UhzyKE9jnwO6mJ2HYpQ@mail.gmail.com>
 <5374B09F.2080803@ti.com> <5374B409.3000607@ti.com>
Message-ID: <20140528015441.7816.62452@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 03/17] phy: ti-pipe3: add external clock support for PCIe PHY
Date: Tue, 27 May 2014 18:54:41 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nishanth Menon (2014-05-15 05:33:13)
> On 05/15/2014 07:18 AM, Kishon Vijay Abraham I wrote:
> > Hi,
> > 
> > On Thursday 15 May 2014 05:42 PM, Nishanth Menon wrote:
> >> On Thu, May 15, 2014 at 6:59 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> >>> Hi Nishant,
> >>>
> >>> On Thursday 15 May 2014 05:16 PM, Nishanth Menon wrote:
> >>>> On Thu, May 15, 2014 at 4:25 AM, Roger Quadros <rogerq@ti.com> wrote:
> >>>>> On 05/15/2014 12:15 PM, Kishon Vijay Abraham I wrote:
> >>>>>> Hi Nishanth,
> >>>>>>
> >>>>>> On Wednesday 14 May 2014 09:04 PM, Nishanth Menon wrote:
> >>>>>>> On Wed, May 14, 2014 at 10:19 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> >>>>>>>> Hi Roger,
> >>>>>>>>
> >>>>>>>> On Wednesday 14 May 2014 06:46 PM, Roger Quadros wrote:
> >>>>>>>>> Hi Kishon,
> >>>>>>>>>
> >>>>>>>>> On 05/06/2014 04:33 PM, Kishon Vijay Abraham I wrote:
> >>>>>>>>>> APLL used by PCIE phy can either use external clock as input or the clock
> >>>>>>>>>> from DPLL. Added support for the APLL to use external clock as input here.
> >>>>>>>>>>
> >>>>>>>>>> Cc: Rajendra Nayak <rnayak@ti.com>
> >>>>>>>>>> Cc: Tero Kristo <t-kristo@ti.com>
> >>>>>>>>>> Cc: Paul Walmsley <paul@pwsan.com>
> >>>>>>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>>>>>>>>> ---
> >>>>>>>>>>  Documentation/devicetree/bindings/phy/ti-phy.txt |    4 ++
> >>>>>>>>>>  drivers/phy/phy-ti-pipe3.c                       |   75 ++++++++++++++--------
> >>>>>>>>>>  2 files changed, 52 insertions(+), 27 deletions(-)
> >>>>>>>>>>
> >>>>>>>>>> diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
> >>>>>>>>>> index bc9afb5..d50f8ee 100644
> >>>>>>>>>> --- a/Documentation/devicetree/bindings/phy/ti-phy.txt
> >>>>>>>>>> +++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
> >>>>>>>>>> @@ -76,6 +76,10 @@ Required properties:
> >>>>>>>>>>     * "dpll_ref_m2" - external dpll ref clk
> >>>>>>>>>>     * "phy-div" - divider for apll
> >>>>>>>>>>     * "div-clk" - apll clock
> >>>>>>>>>> +   * "apll_mux" - mux for pcie apll
> >>>>>>>>>> +   * "refclk_ext" - external reference clock for pcie apll
> >>>>>>>>>> + - ti,ext-clk: To specifiy if PCIE apll should use external clock. Applicable
> >>>>>>>>>> +   only to PCIE PHY.
> >>>>>>>>>
> >>>>>>>>> Instead of specifying both clock sources "dpll_ref_clock", "refclk_ext" and then specifying a 3rd control option "ti,ext-clk" to select one of the 2 sources, why can't the DT just supply one clock source, i.e. the one that is being used in the board instance? The driver should then just configure the clock rate that is needed at that node. Shouldn't the clock framework automatically take care of muxing and parent rates?
> >>>>>>>>
> >>>>>>>> Want the dt to have all the clocks used by the controller. "ti,ext-clk" should
> >>>>>>>> go in the board dt file (suggested by Nishanth).
> >>>>>>>> The point is at some point later if some one wants to change the clock source,
> >>>>>>>> it should be a simple enabling "ti,ext-clk" flag instead of finding the clock
> >>>>>>>> phandle etc..
> >>>>>>>
> >>>>>>> Wonder if that is implicit by the presence of  "refclk_ext" in the
> >>>>>>> clocks provided?
> >>>>>>
> >>>>>> IMO the presence of "refclk_ext" is useless unless the board indicates it
> >>>>>> provides the clock source.
> >>>>>>
> >>>>>> refclk_ext holds phandle for *fixed-clock*, so irrespective of whether the
> >>>>>> board provides a clock or not, it can have that handle for configuring in PRCM.
> >>>>>> However if the board does not provide the clock source, configuring refclk_ext
> >>>>>> in PRCM is useless.
> >>>>>
> >>>>> I think what Nishant meant is that if "refclk_ext" is provided it means that the driver
> >>>>> should use that over "dpll_ref_clock" so no need of a separate "ti,ext-clk" flag.
> >>>>
> >>>> yes, thank you for clarifying - it does indeed redundant to have
> >>>> "ti,ext-clk". and apologies on being a little obscure in the comment.
> >>>
> >>> Irrespective of whether external reference clock is used or not, all DRA7
> >>> (apll) has an input for external reference clock (and also a PRCM register for
> >>> programming it) and it has to be specified in dt no?
> >>
> >> Why is that a binding for ti-phy? that is a problem for the APLL clock
> >> driver (selecting it's own source). PHY properties should describe
> >> itself -> let the bindings of the APLL describe itself. please dont
> >> mix the two up.
> > 
> > The apll clock node is like this
> > 
> > apll_pcie_in_clk_mux: apll_pcie_in_clk_mux@4ae06118 {
> >         compatible = "mux-clock";
> >         clocks = <&dpll_pcie_ref_m2ldo_ck>, <&pciesref_acs_clk_ck>;
> >         #clock-cells = <0>;
> >         reg = <0x4a00821c 0x4>;
> >         bit-mask = <0x80>;
> > };
> > 
> > The external reference clock is denoted by *pciesref_acs_clk_ck*.
> > 
> > refclk_ext holds the phandle to *pciesref_acs_clk_ck* and is used in
> > "clk_set_parent" to set the parent of apll mux.
> 
> So, How about this: if refclk_ext is not defined, dont do setparent,
> if it is defined, do setparent.
> in short:
> Optional Properties:
> * "refclk_ext" - external reference clock for pcie apll - if defined,
> used as the parent to "apll_mux"
> 
> That said, my problem in general with this approach(which many folks
> have taken of describing parent of clock X in hardware block binding
> for Y) is the following:
> 
> The binding now has dependency on clock tree hierarchy. What if
> towmorrow, we have a tree where refclk_ext parent of muxZ parent of
> apll_mux? the binding breaks down. Lets not forget that we consider DT
> as an ABI - we dont want to change the binding in the future.
> 
> I had always preferred describing parent-child relationship of clocks
> by the approach Tero posted: https://patchwork.kernel.org/patch/3871551/
> 
> Maybe Mike and Tero could help here?

Hi all,

I didn't read all of this context, but it seems like
https://lkml.org/lkml/2014/5/19/539

might be a good fit here. Assuming that the PIPE3 PHY consumes the APLL
clock, then it reasonable for the dts phy node to specify
assigned-clock-parent.

Regards,
Mike

> 
> -- 
> Regards,
> Nishanth Menon
