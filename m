Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030558Ab3HIIEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 04:04:41 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:61254 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030543Ab3HIIEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 04:04:13 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 06/16] ARM: dts: Add description of System MMU of Exynos SoCs
Date: Fri, 09 Aug 2013 10:04:03 +0200
Message-ID: <1448938.yRCOxA3Anc@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.4-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130809151557.018b1a95a55460525884e97d@samsung.com>
References: <002a01ce941b$0d9a31c0$28ce9540$@samsung.com> <2797229.pk5f2Qniai@flatron> <20130809151557.018b1a95a55460525884e97d@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 of August 2013 15:15:57 Cho KyongHo wrote:
> On Fri, 09 Aug 2013 00:26:51 +0200, Tomasz Figa wrote:
> > Hi KyongHo,
> > 
> > On Thursday 08 of August 2013 18:38:35 Cho KyongHo wrote:
> > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > > ---
> > > 
> > >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
> > >  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
> > >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
> > >  arch/arm/boot/dts/exynos4x12.dtsi                  |   82 ++++++
> > >  arch/arm/boot/dts/exynos5250.dtsi                  |  290
> > > 
> > > ++++++++++++++++++++ 5 files changed, 622 insertions(+), 0
> > > deletions(-)
> > > 
> > >  create mode 100644
> > > 
> > > Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.tx
> > > t
> > > 
> > > diff --git
> > > a/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.
> > > txt
> > > b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.
> > > txt
> > > new file mode 100644
> > > index 0000000..92f0a33
> > > --- /dev/null
> > > +++
> > > b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.
> > > txt
> > > @@ -0,0 +1,103 @@
> > > +Samsung Exynos4210 IOMMU H/W, System MMU (System Memory Management
> > > Unit) +
> > > +Samsung's Exynos architecture contains System MMU that enables
> > > scattered +physical memory chunks visible as a contiguous region to
> > > DMA-capable peripheral +devices like MFC, FIMC, FIMD, GScaler,
> > > FIMC-IS
> > > and so forth.
> > > +
> > > +System MMU is a sort of IOMMU and support identical translation
> > > table
> > > format to +ARMv7 translation tables with minimum set of page
> > > properties
> > > including access +permissions, shareability and security protection.
> > > In
> > > addition, System MMU has +another capabilities like L2 TLB or
> > > block-fetch buffers to minimize translation +latency.
> > > +
> > > +A System MMU is dedicated to a single master peripheral device. 
> > > Thus,
> > > it is +important to specify the correct System MMU in the device
> > > node
> > > of its master +device. Whereas a System MMU is dedicated to a master
> > > device, the master device +may have more than one System MMU.
> > 
> > This paragraph is still not clear. What about something among these 
lines:
> Yes. It is my fault.
> It is still unchanged... even though Grant sugessted clear and simple
> sentence. It must be changed :)
> 
> > System MMUs are in many to one relation with peripheral devices, i.e.
> > single peripheral device might have multiple System MMUs (usually one
> > for each bus master), but one System MMU can handle only one
> > peripheral device. The relation between a System MMU and the
> > peripheral device it handles needs to be defined in device node of
> > this peripheral device.
> That looks good to me.
> Please let me use your sentences.

OK.

> > > +Required properties:
> > > +- compatible: Should be "samsung,exynos4210-sysmmu"
> > > +- reg: A tuple of base address and size of System MMU registers.
> > > +- interrupt-parent: The phandle of the interrupt controller of
> > > System
> > > MMU +- interrupts: A tuple of numbers that indicates the interrupt
> > > source.
> > 
> > interrupts: An interrupt specifier for interrupt signal of System MMU,
> > according to format defined for particular interrupt parent.
> 
> Yes.. it is not changed..
> 
> > > +- clock-names: Should be "sysmmu" if the System MMU is needed
> > > to gate its clock. +               Please refer to the following
> > > documents:
> > > +	       Documentation/devicetree/bindings/clock/clock-bindings.txt
> > > +	       Documentation/devicetree/bindings/clock/exynos4-clock.txt
> > > +	       Documentation/devicetree/bindings/clock/exynos5250-
> > 
> > clock.txt
> > 
> > > +	       Optional "master" if the clock to the System MMU is gated
> > 
> > by
> > 
> > > +	       another gate clock other than "sysmmu". The System MMU
> > 
> > driver
> > 
> > > +	       sets "master" the parent of "sysmmu".
> > > +	       Exynos4 SoCs, there needs no "master" clocks.
> > > +	       Exynos5 SoCs, some System MMUs must have "master" clocks.
> > > +- clocks: Required if the System MMU is needed to gate its clock.
> > > +	  Please refer to the documents listed above.
> > > +- samsung,power-domain: Required if the System MMU is needed to
> > > gate
> > > its power. +	  Please refer to the following document:
> > > +	  Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> > > +
> > > +Required properties for the master peripheral devices:
> > > +- iommu: phandles to the System MMUs of the device
> > > +
> > > +Examples:
> > > +A System MMU is dedicated to a single master device.
> > > +	gsc_0:  gsc@0x13e00000 {
> > 
> > nit: duplicated space after gsc_0: and incorrect 0x prefix in node
> > unit- address.
> 
> Ok.
> 
> > > +		compatible = "samsung,exynos5-gsc";
> > > +		reg = <0x13e00000 0x1000>;
> > > +		interrupts = <0 85 0>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		clocks = <&clock 256>;
> > > +		clock-names = "gscl";
> > > +		iommu = <&sysmmu_gsc1>;
> > > +	};
> > > +
> > > +	sysmmu_gsc0: sysmmu@13E80000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13E80000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-gsc0";
> > 
> > Hmm? interrupt-names property is not defined in your binding
> > documentation and also the value here looks wrong. This should be a
> > generic interrupt signal name that the SysMMU driver can understand,
> > e.g. "sysmmu", without the "-gsc0" suffix.
> 
> Oh. I didn't know that. Thank you.
> As I replied in your previous mail about v8 patch, I thought it may be
> useful for printing debugging information.
> 
> > > +		interrupts = <2 0>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 262>, <&clock 256>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		status = "ok";
> > 
> > "ok" is not a valid value of status property, "okay" is. Still, I
> > don't
> > think this is a relevant property in this example, so maybe it could
> > be
> > omitted (status is "okay" by default anyway)?
> 
> Actually "ok" is valid value.
> Please see the description of of_device_is_available().

The handling of "ok" looks like a quirk for some broken device trees that 
somehow got out of the spec. The ePAPR specification[1], chapter 2.3.4 
defines a set of values for the "status" property and there is no "ok" 
there.

By the way, the ePAPR specification[1] is a good thing to read on device 
tree bindings, so you might want to look at it if you want to get more 
information on this.

[1] - https://www.power.org/wp-content/uploads/2012/06/Power_ePAPR_APPROVED_v1.1.pdf

> However, I agree with you that it can be omitted.
> 
> Since status property is not an important information in the
> description, I will remove it from the binding document.
> 
> How about dtsi files?
> should it be removed from dtsi files as you addressed below?

Yes, I think so.

Best regards,
Tomasz

> > > +	};
> > > +
> > > +MFC has 2 System MMUs for each port that MFC is attached. Thus it
> > > seems natural +to define 2 System MMUs for each port of the MFC:
> > > +
> > > +	mfc: codec@13400000 {
> > > +		compatible = "samsung,mfc-v5";
> > > +		reg = <0x13400000 0x10000>;
> > > +		interrupts = <0 94 0>;
> > > +		samsung,power-domain = <&pd_mfc>;
> > > +		clocks = <&clock 170>, <&clock 273>;
> > > +		clock-names = "sclk_mfc", "mfc";
> > > +		status = "ok";
> > 
> > Ditto.
> > 
> > > +		iommu = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
> > > +	};
> > > +
> > > +	sysmmu_mfc_l: sysmmu@13620000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13620000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-mfc-l";
> > > +		interrupts = <5 5>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 274>;
> > > +		samsung,power-domain = <&pd_mfc>;
> > > +		status = "ok";
> > 
> > Ditto.
> > 
> > > +	};
> > > +
> > > +	sysmmu_mfc_r: sysmmu@13630000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13630000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-mfc-r";
> > 
> > Ditto.
> > 
> > > +		interrupts = <5 6>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 275>;
> > > +		samsung,power-domain = <&pd_mfc>;
> > > +		status = "ok";
> > 
> > Ditto.
> > 
> > > +	};
> > > +
> > > diff --git a/arch/arm/boot/dts/exynos4.dtsi
> > > b/arch/arm/boot/dts/exynos4.dtsi index 597cfcf..6265984 100644
> > > --- a/arch/arm/boot/dts/exynos4.dtsi
> > > +++ b/arch/arm/boot/dts/exynos4.dtsi
> > > @@ -251,6 +251,7 @@
> > > 
> > >  		clocks = <&clock 170>, <&clock 273>;
> > >  		clock-names = "sclk_mfc", "mfc";
> > >  		status = "disabled";
> > > 
> > > +		iommu = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
> > > 
> > >  	};
> > >  	
> > >  	serial@13800000 {
> > > 
> > > @@ -485,5 +486,126 @@
> > > 
> > >  		clock-names = "sclk_fimd", "fimd";
> > >  		samsung,power-domain = <&pd_lcd0>;
> > >  		status = "disabled";
> > > 
> > > +		iommu = <&sysmmu_fimd0>;
> > > +	};
> > > +
> > > +	sysmmu_mfc_l: sysmmu@13620000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13620000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-mfc-l";
> > 
> > Ditto.
> > 
> > > +		interrupts = <5 5>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 274>;
> > > +		samsung,power-domain = <&pd_mfc>;
> > > +		status = "ok";
> > 
> > Ditto.
> > 
> > > +	};
> > > +
> > > +	sysmmu_mfc_r: sysmmu@13630000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13630000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-mfc-r";
> > 
> > Ditto.
> > 
> > > +		interrupts = <5 6>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 275>;
> > > +		samsung,power-domain = <&pd_mfc>;
> > > +		status = "ok";
> > 
> > Ditto.
> > 
> > > +	};
> > > +
> > > +	sysmmu_tv: sysmmu@12E20000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x12E20000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-tv";
> > 
> > Ditto.
> > 
> > > +		interrupts = <5 4>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 272>;
> > > +		samsung,power-domain = <&pd_tv>;
> > > +		status = "ok";
> > 
> > Ditto.
> > 
> > > +	};
> > > +
> > > +	sysmmu_fimc0: sysmmu@11A20000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x11A20000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc0";
> > 
> > Ditto.
> > 
> > > +		interrupts = <4 2>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 263>;
> > > +		samsung,power-domain = <&pd_cam>;
> > > +		status = "ok";
> > 
> > Ditto.
> > 
> > > +	};
> > > +
> > > +	sysmmu_fimc1: sysmmu@11A30000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x11A30000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc1";
> > 
> > Ditto.
> > 
> > > +		interrupts = <4 3>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 264>;
> > > +		samsung,power-domain = <&pd_cam>;
> > > +		status = "ok";
> > 
> > Ditto.
> > 
> > > +	};
> > > +
> > > +	sysmmu_fimc2: sysmmu@11A40000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x11A40000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc2";
> > 
> > Ditto.
> > 
> > > +		interrupts = <4 4>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 265>;
> > > +		samsung,power-domain = <&pd_cam>;
> > > +		status = "ok";
> > 
> > Ditto.
> > 
> > > +	};
> > > +
> > > +	sysmmu_fimc3: sysmmu@11A50000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x11A50000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc3";
> > 
> > Ditto.
> > 
> > > +		interrupts = <4 5>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 266>;
> > > +		samsung,power-domain = <&pd_cam>;
> > > +		status = "ok";
> > 
> > Ditto.
> > 
> > > +	};
> > > +
> > > +	sysmmu_jpeg: sysmmu@11A60000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x11A60000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-jpeg";
> > 
> > Ditto.
> > 
> > > +		interrupts = <4 6>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 267>;
> > > +		samsung,power-domain = <&pd_cam>;
> > > +		status = "ok";
> > 
> > Ditto... and so on in all further sysmmu nodes.
> > 
> > Best regards,
> > Tomasz
> > 
> > > +	};
> > > +
> > > +	sysmmu_rotator: sysmmu@12A30000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x12A30000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-rotator";
> > > +		interrupts = <5 0>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 281>;
> > > +		samsung,power-domain = <&pd_lcd0>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimd0: sysmmu@11E20000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x11E20000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimd0";
> > > +		interrupts = <5 2>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 287>;
> > > +		samsung,power-domain = <&pd_lcd0>;
> > > +		status = "ok";
> > > 
> > >  	};
> > >  
> > >  };
> > > 
> > > diff --git a/arch/arm/boot/dts/exynos4210.dtsi
> > > b/arch/arm/boot/dts/exynos4210.dtsi index 057d682..6b0012b 100644
> > > --- a/arch/arm/boot/dts/exynos4210.dtsi
> > > +++ b/arch/arm/boot/dts/exynos4210.dtsi
> > > @@ -124,6 +124,31 @@
> > > 
> > >  		clocks = <&clock 177>, <&clock 277>;
> > >  		clock-names = "sclk_fimg2d", "fimg2d";
> > >  		status = "disabled";
> > > 
> > > +		iommu = <&sysmmu_g2d>;
> > > +	};
> > > +
> > > +	sysmmu_g2d: sysmmu@12A20000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x12A20000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-g2d";
> > > +		interrupts = <4 7>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 280>;
> > > +		samsung,power-domain = <&pd_lcd0>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimd1: sysmmu@12220000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimd1";
> > > +		reg = <0x12220000 0x1000>;
> > > +		interrupts = <5 3>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 291>;
> > > +		samsung,power-domain = <&pd_lcd1>;
> > > +		status = "ok";
> > > 
> > >  	};
> > >  	
> > >  	camera {
> > > 
> > > diff --git a/arch/arm/boot/dts/exynos4x12.dtsi
> > > b/arch/arm/boot/dts/exynos4x12.dtsi index ad531fe..fcfe118 100644
> > > --- a/arch/arm/boot/dts/exynos4x12.dtsi
> > > +++ b/arch/arm/boot/dts/exynos4x12.dtsi
> > > @@ -176,4 +176,86 @@
> > > 
> > >  			};
> > >  		
> > >  		};
> > >  	
> > >  	};
> > > 
> > > +
> > > +	sysmmu_g2d: sysmmu@10A40000{
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x10A40000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-g2d";
> > > +		interrupts = <4 7>;
> > > +		clock-names = "sysmmu";
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_isp: sysmmu@12260000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x12260000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_isp";
> > > +		interrupts = <16 2>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 362>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_drc: sysmmu@12270000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x12270000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_drc";
> > > +		interrupts = <16 3>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 363>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_fd: sysmmu@122A0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x122A0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_fd";
> > > +		interrupts = <16 4>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 364>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_mcuctl: sysmmu@122B0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x122B0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_mcuctl";
> > > +		interrupts = <16 5>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 376>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_lite0: sysmmu@123B0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x123B0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_lite0";
> > > +		interrupts = <16 0>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 366>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_lite1: sysmmu@123C0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x123C0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_lite1";
> > > +		interrupts = <16 1>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 365>;
> > > +		status = "ok";
> > > +	};
> > > 
> > >  };
> > > 
> > > diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> > > b/arch/arm/boot/dts/exynos5250.dtsi index 88589b7..c91c9d3 100644
> > > --- a/arch/arm/boot/dts/exynos5250.dtsi
> > > +++ b/arch/arm/boot/dts/exynos5250.dtsi
> > > @@ -78,6 +78,16 @@
> > > 
> > >  		reg = <0x10044040 0x20>;
> > >  	
> > >  	};
> > > 
> > > +	pd_isp: isp-power-domain@0x10044020 {
> > > +		compatible = "samsung,exynos4210-pd";
> > > +		reg = <0x10044020 0x20>;
> > > +	};
> > > +
> > > +	pd_disp1: disp1-power-domain@0x100440A0 {
> > > +		compatible = "samsung,exynos4210-pd";
> > > +		reg = <0x100440A0 0x20>;
> > > +	};
> > > +
> > > 
> > >  	clock: clock-controller@10010000 {
> > >  	
> > >  		compatible = "samsung,exynos5250-clock";
> > >  		reg = <0x10010000 0x30000>;
> > > 
> > > @@ -577,6 +587,7 @@
> > > 
> > >  		samsung,power-domain = <&pd_gsc>;
> > >  		clocks = <&clock 256>;
> > >  		clock-names = "gscl";
> > > 
> > > +		iommu = <&sysmmu_gsc1>;
> > > 
> > >  	};
> > >  	
> > >  	gsc_1:  gsc@13e10000 {
> > > 
> > > @@ -586,6 +597,7 @@
> > > 
> > >  		samsung,power-domain = <&pd_gsc>;
> > >  		clocks = <&clock 257>;
> > >  		clock-names = "gscl";
> > > 
> > > +		iommu = <&sysmmu_gsc1>;
> > > 
> > >  	};
> > >  	
> > >  	gsc_2:  gsc@13e20000 {
> > > 
> > > @@ -595,6 +607,7 @@
> > > 
> > >  		samsung,power-domain = <&pd_gsc>;
> > >  		clocks = <&clock 258>;
> > >  		clock-names = "gscl";
> > > 
> > > +		iommu = <&sysmmu_gsc2>;
> > > 
> > >  	};
> > >  	
> > >  	gsc_3:  gsc@13e30000 {
> > > 
> > > @@ -604,6 +617,7 @@
> > > 
> > >  		samsung,power-domain = <&pd_gsc>;
> > >  		clocks = <&clock 259>;
> > >  		clock-names = "gscl";
> > > 
> > > +		iommu = <&sysmmu_gsc3>;
> > > 
> > >  	};
> > >  	
> > >  	hdmi {
> > > 
> > > @@ -620,6 +634,7 @@
> > > 
> > >  		compatible = "samsung,exynos5250-mixer";
> > >  		reg = <0x14450000 0x10000>;
> > >  		interrupts = <0 94 0>;
> > > 
> > > +		iommu = <&sysmmu_tv>;
> > > 
> > >  	};
> > >  	
> > >  	dp-controller {
> > > 
> > > @@ -646,5 +661,280 @@
> > > 
> > >  		interrupts = <18 4>, <18 5>, <18 6>;
> > >  		clocks = <&clock 133>, <&clock 339>;
> > >  		clock-names = "sclk_fimd", "fimd";
> > > 
> > > +		iommu = <&sysmmu_fimd1>;
> > > +	};
> > > +
> > > +	sysmmu_mfc_l: sysmmu@11210000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x11210000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-mfc_l";
> > > +		interrupts = <8 5>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 267>, <&clock 266>;
> > > +		samsung,power-domain = <&pd_mfc>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_mfc_r: sysmmu@11200000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x11200000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-mfc_r";
> > > +		interrupts = <6 2>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 268>, <&clock 266>;
> > > +		samsung,power-domain = <&pd_mfc>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_tv: sysmmu@14650000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x14650000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-tv";
> > > +		interrupts = <7 4>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 349>;
> > > +		samsung,power-domain = <&pd_disp1>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_gsc0: sysmmu@13E80000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13E80000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-gsc0";
> > > +		interrupts = <2 0>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 262>, <&clock 256>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_gsc1: sysmmu@13E90000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13E90000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-gsc1";
> > > +		interrupts = <2 2>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 263>, <&clock 257>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_gsc2: sysmmu@13EA0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13EA0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-gsc2";
> > > +		interrupts = <2 4>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 264>, <&clock 258>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_gsc3: sysmmu@13EB0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13EB0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-gsc3";
> > > +		interrupts = <2 6>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 265>, <&clock 259>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimd1: sysmmu@14640000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x14640000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimd1";
> > > +		interrupts = <3 2>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 350>;
> > > +		samsung,power-domain = <&pd_disp1>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_rotator: sysmmu@11D40000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x11D40000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-rotator";
> > > +		interrupts = <4 0>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 272>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_isp: sysmmu@13260000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13260000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_isp";
> > > +		interrupts = <10 6>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 361>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_drc: sysmmu@13270000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13270000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_drc";
> > > +		interrupts = <11 6>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 362>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_fd: sysmmu@132A0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x132A0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_fd";
> > > +		interrupts = <5 0>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 363>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_scc: sysmmu@13280000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13280000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_scalerc";
> > > +		interrupts = <5 2>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 364>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_scp: sysmmu@13290000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13290000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_scalerp";
> > > +		interrupts = <3 6>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 365>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_mcuctl: sysmmu@132B0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x132B0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_mcuctl";
> > > +		interrupts = <5 4>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 366>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_odc: sysmmu@132C0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x132C0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_odc";
> > > +		interrupts = <11 0>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 367>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_dis0: sysmmu@132D0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x132D0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_dis0";
> > > +		interrupts = <10 4>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 368>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_dis1: sysmmu@132E0000{
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x132E0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_dis1";
> > > +		interrupts = <9 4>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 369>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_3dnr: sysmmu@132F0000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x132F0000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_3dnr";
> > > +		interrupts = <5 6>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 370>;
> > > +		samsung,power-domain = <&pd_isp>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_lite0: sysmmu@13C40000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13C40000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_lite0";
> > > +		interrupts = <3 4>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 346>, <&clock 345>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_lite1: sysmmu@13C50000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13C50000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-fimc_lite1";
> > > +		interrupts = <24 1>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 347>, <&clock 345>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_jpeg: sysmmu@11F20000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x11F20000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-jpeg";
> > > +		interrupts = <4 2>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 273>, <&clock 270>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +	sysmmu_fimc_2d: sysmmu@10A60000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x10A60000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-2d";
> > > +		interrupts = <24 5>;
> > > +		clock-names = "sysmmu";
> > > +		clocks = <&clock 361>;
> > > +		status = "ok";
> > > 
> > >  	};
> > >  
> > >  };
