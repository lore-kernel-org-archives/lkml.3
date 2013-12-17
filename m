Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3LQAKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:10:07 -0500
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:30926
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277Ab3LQAKD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:10:03 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(z579eh551biz98dI9371Ic89bh1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h906i1155h)
Date: Mon, 16 Dec 2013 16:09:52 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
CC: Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] ARM: mach-moxart: add MOXA ART SoC device tree
 files
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com>
 <1386945188-8316-3-git-send-email-jonas.jensen@gmail.com>
 <CAEgOgz7=xZ8N+vGuaQ6L3n5SYpS3bS+xN88WXDH+A7m7JNLrcw@mail.gmail.com>
 <CACmBeS1H96Scr+ycHa-Ar_t72Q2x=LH-2vrbQXiLiuYHyH3S-Q@mail.gmail.com>
 <CAEgOgz6qz8ES_rQX8+UE-Ukh=G=_kHnAWJLQ-sUm6vkz=Xa7pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAEgOgz6qz8ES_rQX8+UE-Ukh=G=_kHnAWJLQ-sUm6vkz=Xa7pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <c68889e4-99be-44df-833d-c290f4a0592b@DB8EHSMHS009.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 17, 2013 at 09:53:27AM +1000, Peter Crosthwaite wrote:
> On Tue, Dec 17, 2013 at 6:05 AM, Jonas Jensen <jonas.jensen@gmail.com> wrote:
> > On 15 December 2013 05:27, Peter Crosthwaite
> > <peter.crosthwaite@xilinx.com> wrote:
> >>> +       sdhci: sdhci@98e00000 {
> >>> +               compatible = "moxa,moxart-sdhci";
> >>> +               reg = <0x98e00000 0x5C>;
> >>> +               interrupts = <5 0>;
> >>> +               clocks = <&clk_apb>;
> >>> +               dmas =  <&dma 5>,
> >>> +                       <&dma 5>;
> >>> +               dma-names = "tx", "rx";
> >>> +       };
> >>
> >> Is your SDHCI really implemented on the board level? The fact that its
> >> reg property is within the same as the SoC range (for your dtsi)
> >> suggests the SDHCI is part of the SoC and should perhaps be in the
> >> dtsi?
> >
> >>> +       mac1: mac@92000000 {
> >>> +               compatible = "moxa,moxart-mac";
> >>> +               reg = <0x92000000 0x90>;
> >>> +               interrupts = <27 0>;
> >>> +               phy-handle = <&ethphy1>;
> >>> +               phy-mode = "mii";
> >>> +       };
> >>
> >> Same for MACs.
> >
> >>> +
> >>> +       uart0: uart@98200000 {
> >>> +               compatible = "ns16550a";
> >>> +               reg = <0x98200000 0x20>;
> >>> +               interrupts = <31 8>;
> >>> +               reg-shift = <2>;
> >>> +               reg-io-width = <4>;
> >>> +               clock-frequency = <14745600>;
> >>> +               status = "okay";
> >>> +       };
> >>> +
> >>
> >> And UARTs.
> >>
> >> Let me know if i'm misunderstanding dts/dtsi split but looking at some
> >> of the other SoCs this seems inconsistent to me.
> >
> >
> > It is likely to be true, that technically these are all part of the
> > SoC. By examining the hardware, there are no external chips (on either
> > base or main board) that looks capable of handling such functions:
> >
> > https://plus.google.com/photos/103371465418643926605/albums/5820634595801767953
> >
> > I made the split with some consideration to other MOXA ART machines,
> > that they can be added as a separate file including the same dtsi:
> >
> > MOXA ART hardware examples:
> >
> > UC-7112/UC-7110: "SD slot (UC-7112, and UC-7112 Plus only)":
> > http://www.moxa.com/product/UC-7112_UC-7110.htm
> >
> > IA241: "64 MB RAM":
> > http://www.moxa.com/product/IA241_IA240.htm
> >
> > UC-7101-LX: "One 10/100 Mbps Ethernet port":
> > http://www.moxa.com/product/UC-7101-LX.htm
> >
> >
> > UC-7112-LX has 32 MB RAM and two ethernet ports. This is why I think
> > MAC is good as is, RAM should move out from SoC?
> >
> > I don't know if they all have a debug UART (I only have access to
> > UC-7112-LX), and it's not obvious in specifications. UART can possibly
> > be moved into SoC as you say.
> >
> 
> I think its going to all be in the SoC. Having it board level would
> mean you have a system bus as copper which is not very SoC like (at
> least for UART anyway).
> 
> > In cases where SD slot is missing but the register remains in the SoC,
> > how is that normally handled?
> >
> 
> Soren Brinkmann's recent addition of ethernet to the Zynq SoC
> illustrates the concept for a MAC. The two MACs are added to the
> shared dtsi but disabled. The board level dts then enables it for the
> one which is board populated:
> 
> https://lkml.org/lkml/2013/12/11/434
> 
> I think its generally applicable to your SD MAC and UART cases. The
> tegra20 dtsi illustrates the status = "disabled" concept specifically
> for SDHCI.

I think it's less SoC vs. non-SoC parts. There are even platforms using
more than two levels of includes. IMHO, it's just to avoid duplication.
So, stuff that doesn't change ever goes into the lowest level dtsi and
then you work your way up. That way people bringing up a board with your
part just have to enable the correct set of peripherals and provide
board specific properties. You don't want everybody to repeat the same
memory map (reg properties), clock references, etc. over and over again
in all dtses that use a specific SoC, right?

Long story short: I separate by: Properties that are statically defined
by the SOC => dtsi. Properties that are defined by the PCB design =>
board level dts.

	Sören


