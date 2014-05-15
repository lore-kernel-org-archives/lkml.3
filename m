Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaEOJPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:15:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43591 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaEOJPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:15:48 -0400
Message-ID: <5374859F.5080902@ti.com>
Date: Thu, 15 May 2014 14:45:11 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: Roger Quadros <rogerq@ti.com>, dt list <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Rajendra Nayak <rnayak@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Subject: Re: [PATCH 03/17] phy: ti-pipe3: add external clock support for PCIe
 PHY
References: <1399383244-14556-1-git-send-email-kishon@ti.com>	<1399383244-14556-4-git-send-email-kishon@ti.com>	<53736CBC.2060702@ti.com>	<5373897C.6080504@ti.com> <CAGo_u6qw1OomEw_ueb3x+xT+qZLAfGv7Se1K=o725aOoD3ankQ@mail.gmail.com>
In-Reply-To: <CAGo_u6qw1OomEw_ueb3x+xT+qZLAfGv7Se1K=o725aOoD3ankQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,

On Wednesday 14 May 2014 09:04 PM, Nishanth Menon wrote:
> On Wed, May 14, 2014 at 10:19 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Hi Roger,
>>
>> On Wednesday 14 May 2014 06:46 PM, Roger Quadros wrote:
>>> Hi Kishon,
>>>
>>> On 05/06/2014 04:33 PM, Kishon Vijay Abraham I wrote:
>>>> APLL used by PCIE phy can either use external clock as input or the clock
>>>> from DPLL. Added support for the APLL to use external clock as input here.
>>>>
>>>> Cc: Rajendra Nayak <rnayak@ti.com>
>>>> Cc: Tero Kristo <t-kristo@ti.com>
>>>> Cc: Paul Walmsley <paul@pwsan.com>
>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>> ---
>>>>  Documentation/devicetree/bindings/phy/ti-phy.txt |    4 ++
>>>>  drivers/phy/phy-ti-pipe3.c                       |   75 ++++++++++++++--------
>>>>  2 files changed, 52 insertions(+), 27 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
>>>> index bc9afb5..d50f8ee 100644
>>>> --- a/Documentation/devicetree/bindings/phy/ti-phy.txt
>>>> +++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
>>>> @@ -76,6 +76,10 @@ Required properties:
>>>>     * "dpll_ref_m2" - external dpll ref clk
>>>>     * "phy-div" - divider for apll
>>>>     * "div-clk" - apll clock
>>>> +   * "apll_mux" - mux for pcie apll
>>>> +   * "refclk_ext" - external reference clock for pcie apll
>>>> + - ti,ext-clk: To specifiy if PCIE apll should use external clock. Applicable
>>>> +   only to PCIE PHY.
>>>
>>> Instead of specifying both clock sources "dpll_ref_clock", "refclk_ext" and then specifying a 3rd control option "ti,ext-clk" to select one of the 2 sources, why can't the DT just supply one clock source, i.e. the one that is being used in the board instance? The driver should then just configure the clock rate that is needed at that node. Shouldn't the clock framework automatically take care of muxing and parent rates?
>>
>> Want the dt to have all the clocks used by the controller. "ti,ext-clk" should
>> go in the board dt file (suggested by Nishanth).
>> The point is at some point later if some one wants to change the clock source,
>> it should be a simple enabling "ti,ext-clk" flag instead of finding the clock
>> phandle etc..
> 
> Wonder if that is implicit by the presence of  "refclk_ext" in the
> clocks provided?

IMO the presence of "refclk_ext" is useless unless the board indicates it
provides the clock source.

refclk_ext holds phandle for *fixed-clock*, so irrespective of whether the
board provides a clock or not, it can have that handle for configuring in PRCM.
However if the board does not provide the clock source, configuring refclk_ext
in PRCM is useless.

Thanks
Kishon
