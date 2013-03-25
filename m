Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab3CYSAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:00:15 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:53708
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932242Ab3CYSAN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:00:13 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(zzbb2dI98dI9371Ic89bh1102I1432I1414Jdb82h8580rzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dh8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Mon, 25 Mar 2013 10:59:53 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mike Turquette <mturquette@linaro.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <pcrost@xilinx.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <git@xilinx.com>,
        Jan =?utf-8?B?TMO8YmJl?= <jlu@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: RFC v2: Zynq Clock Controller
References: <27dae808-1d3a-4001-8eb2-b0a6e2a34b8f@AM1EHSMHS013.ehs.local>
 <514B5254.50101@metafoo.de>
 <128fc723-ace7-4f4c-95d9-971b42a52080@CH1EHSMHS028.ehs.local>
 <5150634B.9060601@metafoo.de>
 <e44aac14-ca51-446c-b564-00a7a440384a@TX2EHSMHS041.ehs.local>
 <5150870F.9030008@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5150870F.9030008@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <83871b9e-cbf1-48bc-8b05-2eba50923ba4@DB8EHSMHS015.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 25, 2013 at 06:19:11PM +0100, Lars-Peter Clausen wrote:
> On 03/25/2013 06:08 PM, Sören Brinkmann wrote:
> > Hi Lars,
> > 
> > On Mon, Mar 25, 2013 at 03:46:35PM +0100, Lars-Peter Clausen wrote:
> >> Hi,
> >>
> >> On 03/22/2013 11:41 PM, Sören Brinkmann wrote:
> >>> Hi Lars,
> >>>
> >>> On Thu, Mar 21, 2013 at 07:32:52PM +0100, Lars-Peter Clausen wrote:
> >>>> On 03/21/2013 12:56 AM, Sören Brinkmann wrote:
> >>>>> Hi,
> >>>>>
> >>>>> I spent some time working on this and incorporating feedback. Here's an updated proposal for a clock controller for Zynq:
> >>>>>
> >>>>> Required properties:
> >>>>>  - #clock-cells : Must be 1
> >>>>>  - compatible : "xlnx,ps7-clkc"  (this may become 'xlnx,zynq-clkc' terminology differs a bit between Xilinx internal and mainline)
> >>>>>  - ps-clk-frequency : Frequency of the oscillator providing ps_clk in HZ
> >>>>>                      (usually 33 MHz oscillators are used for Zynq platforms)
> >>>>>  - clock-output-names : List of strings used to name the clock outputs. Shall be a list of the outputs given below.
> >>>>>
> >>>>> Optional properties:
> >>>>>  - clocks : as described in the clock bindings
> >>>>>  - clock-names : as described in the clock bindings
> >>>>>
> >>>>> Clock inputs:
> >>>>> The following strings are optional parameters to the 'clock-names' property in
> >>>>> order to provide optional (E)MIO clock sources.
> >>>>>  - swdt_ext_clk
> >>>>>  - gem0_emio_clk
> >>>>>  - gem1_emio_clk
> >>>>>  - mio_clk_XX          # with XX = 00..53
> >>>>>
> >>>>> Example:
> >>>>>         clkc: clkc {
> >>>>>                 #clock-cells = <1>;
> >>>>>                 compatible = "xlnx,ps7-clkc";
> >>>>>                 ps-clk-frequency = <33333333>;
> >>>>
> >>>> The input frequency should be a clock as well.
> >>> Again, monolithic vs split. I don't see a reason not to just internally
> >>> call clk_register_fixed_rate(). That way its children do not have to
> >>> cope with a variable name for the xtal.
> >>> Also, with my proposal 'clocks' and 'clock-names' would be purely
> >>> optional properties, only required if optional external inputs are
> >>> present. Having the xtal defined externally would add mandatory entries for
> >>> those props.
> >>
> >>
> >>
> >>>
> >>>>
> >>>>>                 clock-output-names = "armpll", "ddrpll", "iopll", "cpu_6or4x", "cpu_3or2x", "cpu_2x", "cpu_1x", "ddr2x", "ddr3x", "dci", "lqspi", "smc", "pcap", "gem0", "gem1", "fclk0", "fclk1", "fclk2", "fclk3", "can0", "can1", "sdio0", "sdio1", "uart0", "uart1", "spi0", "spi1", "dma", "usb0_aper", "usb1_aper", "gem0_aper", "gem1_aper", "sdio0_aper", "sdio1_aper", "spi0_aper", "spi1_aper", "can0_aper", "can1_aper", "i2c0_aper", "i2c1_aper", "uart0_aper", "uart1_aper", "gpio_aper", "lqspi_aper", "smc_aper", "swdt", "dbg_trc", "dbg_apb";  /* long list... explanation below */
> >>>>>                 /* optional props */
> >>>>>                 clocks = <&clkc 16>, <&clk_foo>;
> >>>>>                 clock-names = "gem1_emio_clk", "can_mio_clk_23";
> >>>>>         };
> >>>>>
> >>>>> With this revised bindings arbitrary upstream and downstream clock providers should be supported and it's also possible to loop back an output as input. The downside of supporting this is, that I don't see a way around explicitly listing the clock output names in the DT.
> >>>>> The reason for this is, that a downstream clock provider should use of_clk_get_parent_name() to obtain its parent clock name. For a block with multiple outputs of_clk_get_parent_name() can return a valid clock name only when 'clock-output-names' is present.
> >>>>> Probably the fclks are the only realistic use case to become parent of downstream clock providers, but I could imagine that e.g. a device driver like UART wants to use the CCF to model its internal clocks, hence it would require its parent clock name. Even though a device driver could use clk_get_parent() and __clk_get_name(), of_clk_get_parent_name() should probably work as well. I simply have a bad feeling about breaking of_clk_get_parent_name() for any clock.
> >>>>> But after all, I'm open for finding a better solution for this.
> >>>>>
> >>>>>
> >>>>> Similar, inputs for optional clock sources through (E)MIO pins can be defined as described in the clock bindings using the 'clocks' and 'clock-names' properties, with 'clock-names' being an arbitrary subset of the documented names. The actual parent clock names are internally resolved using of_clk_get_parent_name().
> >>>>>
> >>>>>
> >>>>> Regarding this monolithic solution versus a finer granular split:
> >>>>>
> >>>>> On cost of more complex probing we would also have:
> >>>>>  - one clock driver covering the peripheral clocks
> >>>>>  - one for the CPU clock domain
> >>>>>  - one for the DDR clock domain
> >>>>>  - one for GEM
> >>>>>  - one for CAN
> >>>>>  - one for the APER clks
> >>>>>  - one for the PLLs
> >>>>>  - one for fclks
> >>>>
> >>>> fclks are the same as peripheral clocks except for the gate bit, as far as I
> >>>> can see.
> >>> And that makes them quite different, since they have to access multiple
> >>> registers instead of a single one. Also, the fclks have two dividers.
> >>> If you want to cover all of those with a single driver, you need a
> >>> plethora of arguments/properties to catch the small differences.
> >>>
> >>>>
> >>>>>  - probably one for the debug clocks (not sure whether we need those)
> >>>>>
> >>>>> Except for the peripheral one and probably the fclk, they would all be instantiated just once. So, there is not a lot of reuse going on.
> >>>>
> >>>> PLLs are going to be instantiated multiple times as well.
> >>> As mentioned in the very next sentence, I rather see a single driver
> >>> with multiple outputs. Take suspend: My plan is to have a few functions
> >>> like zynq_clk_(suspend|resume). That should take care of bypassing
> >>> shutting down the PLLs (and probably more). Therefore it's easier to
> >>> have them all in a single driver.
> >>> And if it turned out, that other clocks require special handling for
> >>> such system level functions, that could be addressed that way too with
> >>> the monolithic approach.
> >>>
> >>>>
> >>>>> Fclks I would probably also rather put into one driver with four outputs instead of instantiating a single output driver multiple times. Same for PLLs.
> >>>>>
> >>>>> And then there is e.g. a mux for the system watchdog input which doesn't really fit anywhere and it would be pretty much ridiculous to have another clock driver just for that one and it would also become "hidden" in one of the others.
> >>>>>
> >>>>> In my opinion that's just not necessary. We would create a bunch of clock drivers including DT bindings for them, probing would become more complex and it doesn't really help with the probe/naming issue. So, I don't think it's beneficial to go down that road.
> >>>>>
> >>>>> The monolithic solution would need one custom driver for the PLLs, DT bindings wouldn't be required for it though. Everything else should be internally described using the clock-primitives.
> >>>>>
> >>>>> Other than having a much simpler probe and init process, I still think it might be beneficial to have this monolithic block with a holistic view of the clock tree. For suspend e.g. I think the clock controller could export functions like zynq_clkc_(suspend|resume) and then the controller handles the PLL bypassing/shutdown.
> >>>>> Regarding full dynamic reparenting, I don't know how exactly that could work, but with the clock controller there is at least a block where that intelligence would be going and which has knowledge of all the 'struct clk *' required to reparent clocks.
> >>>>>
> >>>>> Regarding the DT description, it is probably controversial what is considered better. I, like the Tegra folks, think having one clock controller in there is fine and hides irrelevant implementation details.
> >>>>>
> >>>>
> >>>> I still don't like the monolithic solution. From my point of view it is
> >>>> architecturally inferior, it is a bad abstraction. You argue that for a
> >>>> non-monolithic version you'd have to implement a clock driver for each
> >>>> different type of clock. But you still have to do this for the monolithic
> >>>> version, they'd probably just end up in one huge messy file. Unless you are
> >>>> going to duplicate huge amounts of lines you'd probably have functions like
> >>>> add_gem_clk, add_peripheral_clk, add_pll_clk and so on in your monolithic drivers.
> >>> It probably makes sense to differ between having custom drivers and
> >>> describing the whole clock tree in DT.
> >>>
> >>> From reusability perspective, it may make sense to factor out some code
> >>> in drivers. IMHO, this does only apply to the peripheral clocks, since
> >>> everything else isn't reused and/or quite Zynq specific.
> >>> But a monolithic approach would not even prevent this. You could just
> >>> transparently change the implementation: Just add a clock driver,
> >>> replace the original code in the controller to use the new driver
> >>> instead and you're good. No need to touch DT bindings.
> >>>
> >>> In Zynq a peripheral clock is essentially described by:
> >>>         clk = clk_register_mux(NULL, mux_name, parents, 4, 0,                    
> >>>                         clk_ctrl, 4, 2, 0, lock);                                
> >>>                                                                                  
> >>>         clk = clk_register_divider(NULL, div_name, mux_name, 0, clk_ctrl, 8, 6,  
> >>>                         CLK_DIVIDER_ONE_BASED, lock);                            
> >>>                                                                                  
> >>>         clks[clk0] = clk_register_gate(NULL, clk_name0, div_name,                
> >>>                         CLK_SET_RATE_PARENT, clk_ctrl, 0, 0, lock);              
> >>>
> >>> If we wrapped this by a driver, any code outside of that driver couldn't
> >>> change the mux setting, since its struct clk* is not exposed outside.
> >>> To get around this we'd have to reimplement all the clock ops, to create a
> >>> clock which supports all possible operations.
> >>> In the monolithic approach we could simply remember that struct clk* and
> >>> work with it.
> >>>
> >>> Bottom line: Factoring out some parts of the monolithic driver might
> >>> make sense for some parts. But it can be done later in a transparent way,
> >>> especially w/o touching DT bindings.
> >>>
> >>>
> >>> The other thing is describing the whole clock tree in DT:
> >>> That would force us to not only describe clocks for which it might make
> >>> sense, but also all Zynq specific clocks in custom drivers and DT
> >>> bindings and we gain nothing from it.
> >>>
> >>>>
> >>>> The SLCR is a virtual construct, which groups the clock units together. But the
> >>>> clock units are the actual entities. E.g. imagine a Zync 2.0, it would probably
> >>>> reuse the same clock units, but there would quite likely be different clocks
> >>>> mapped at different addresses. If you choose a non-monolithic implementation
> >>>> you'd just have to update your devicetree to make this work, with a monolithic
> >>>> version you'd have to add a almost identical driver for the v2.
> >>> Either way you'll end up with a lot of lines describing the hierarchy.
> >>> Either in the dts or in the clock driver.
> >>>
> >>>
> >>> I think, my problem is, that I do not yet know how certain functionality
> >>> will be implemented later and what exact use-cases have to be supported.
> >>> With the monolithic approach I keep all options open. We hopefully will
> >>> never have to touch its DT bindings again. And refactoring the code and
> >>> migrating it to use dedicated clock drivers should be transparent
> >>> changes, if deemed beneficial.
> >>> Furthermore, I have a driver, which has references to all strucht clk*
> >>> in the system and can work with the whole clock tree leveraging a system
> >>> level view. Separating things in smaller blocks might complicate things
> >>> if a use case requires this.
> >>> And finally pushing the whole hierarchy description into the DT seems to
> >>> be the most restrictive approach, without offering big rewards.
> >>
> >> I don't see those restrictions you see with a dt binding which has nodes for
> >> each clock block. You seem to be under the impression, that each device tree
> >> node requires its own driver or device. This is not the case, have you looked
> >> at how the current upstream zynq clock support is implemented? This is still
> >> one monolithic driver, but there are multiple dt nodes, one for each clock
> >> block.
> > I thought the one "huge messy" file was one thing you wanted to avoid?
> 
> I want to avoid a messy one, yes.
> 
> > Also, how does it address my concern regarding inaccessible
> > 'struct clk *'? A clk_register_foo() will only return a single struct
> > clk *. So, wrapping several clk_register() calls within one
> > clk_register_foo() makes all but the actual output inaccessible.
> > And if we do not directly call clk_register_foo() but do the probing
> > through DT the clock init code does not even get hold of that struct clk
> > *.
> 
> That's what the composite clk driver is for.
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg4k04590.html
Is it merged by now? Last time I checked it wasn't and I was seeking a
solution w/o this driver. And I think it wouldn't fit all clocks. E.g. the
ones with multiple dividers or gates.

> 
> > 
> >> This leads to a very clean and well structured code and also nicely
> >> structured dt, which represents the tree as it is in hardware. If I understand
> >> you correctly what you suggest is that you basically want to copy 'n paste the
> >> same 10 lines to instantiate a peripheral clock, which you mentioned above,
> >> again and again. This will be quite messy.
> > For the peripheral clocks you're right, there is some reuse possible.
> > For those I have a helper, like zynq_clk_register_periph(). But for pretty much
> > everything else I don't.
> > 
> > In conclusion, I see the DT approach limiting my ability to modify the
> > clock tree when implementing system level functionality. 
> > Probably quite a stretch, but imagine some smart power management code,
> > which might try to reparent all and every clock in the system to certain
> > PLLs. How would such a power manager get hold of all the struct clk * it
> > needs. In a system probing fully through DT we cannot get hold of those
> > and even less if we wrap several clocks in one clock_foo. Unless, we add
> > a dummy device which has every clock in the system as its input. And
> > that sounds even wackier than having a clock controller which provides
> > all the clocks to consumers.
> 
> If you really really need a list of all the zynq clocks the easiest way to
> implement this is to add a global list and whenever a clock gets probed via
> dt add the clock to the list.
A simple list wouldn't do it. I need exact knowledge about which clock
is which. So, I pretty much copied the Tegra approach with a
'struct clk *clks[clk_max]' array. And filling such an array from a generic clock
driver seems wrong.
By separating clocks we take away their awareness of the bigger
hierarchy picture. The clock controller approach maintains this knowledge.

	Sören


