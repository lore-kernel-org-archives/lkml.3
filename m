Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbaCTKWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:22:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56989 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaCTKWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:22:41 -0400
X-AuditID: cbfee68f-b7f156d00000276c-5f-532ac16c87ee
Date: Thu, 20 Mar 2014 19:22:35 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 20/27] iommu/exynos: allow having multiple System MMUs
 for a master H/W
Message-id: <20140320192235.69386eba6ea04b7745b5fcca@samsung.com>
In-reply-to: <5329B471.7030703@samsung.com>
References: <20140314141050.c8bedcb66532d277c496796d@samsung.com>
 <53232A53.4040708@samsung.com>
 <20140318220128.564740c88d06b86c9c5c10e3@samsung.com>
 <532857A8.5060000@samsung.com>
 <20140319093929.d3a7cea131c626cf978e0ff1@samsung.com>
 <532999A2.6030107@samsung.com> <5329B471.7030703@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zQ92cg1rBBov2i1ncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJWx/PcTxoIv5hXnr61lbGDs1Oli5OSQEDCRmLztKTOE
	LSZx4d56ti5GLg4hgWWMEi/71zHCFM2ce5URIjGdUeLgtJcsEM5kJokdK2cBZTg4WARUJWac
	tAFpYBPQklg99zhYs4iAisTlU9PBmpkFGlklHt1fxg6SEBZIlHj4aRITiM0r4Cix++JzFhCb
	U0Bb4njfNqgzNjNJ7H3cwgRxhoXEhaYOdogGQYkfk++BNTADbdu8rYkVwpaX2LzmLdQ/Szkk
	DpwGu4hFQEDi2+RDLCCHSgjISmw6AFUiKXFwxQ2WCYxis5BMnYVk6iwkUxcwMq9iFE0tSC4o
	TkovMtYrTswtLs1L10vOz93ECIn2/h2Mdw9YH2JMBlo5kVlKNDkfmCzySuINjc2MLExNTI2N
	zC3NSBNWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjoeHxY3P1VPyfZ+05eEbO
	mV19bZdr6t3s1mLLZdbiP98z6895FldwmXmhqpH3hHfm3bO81MoULX8oFfaoSj+cHZPyp+tB
	9AS1X1sPfpQxviN+yOP+oYvz9bQ5DGISHbIZRC6b/73ywH6v1fHnn2/cZ1ATi7GItD6mNCmI
	79RDwRfmG6X2F3orsRRnJBpqMRcVJwIA4kR53QwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jQd2cg1rBBlNf81vcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY/nvJ4wFX8wr
	zl9by9jA2KnTxcjJISFgIjFz7lVGCFtM4sK99WxdjFwcQgLTGSUOTnvJAuFMZpLYsXIWUBUH
	B4uAqsSMkzYgDWwCWhKr5x4HaxYRUJG4fGo6I0g9s0Ajq8Sj+8vYQRLCAokSDz9NYgKxeQUc
	JXZffM4CYnMKaEsc79sGtW0zk8Texy1MEGdYSFxo6mCHaBCU+DH5HlgDM9C2zduaWCFseYnN
	a94yT2AUmIWkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4mz6R2MK5s
	sDjEKMDBqMTDu2KPZrAQa2JZcWXuIUYJDmYlEV5rd61gId6UxMqq1KL8+KLSnNTiQ4zJwOCY
	yCwlmpwPTHR5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cCo
	4r8pSF9tZlsyS4r4x7sHN1YmW6yvXfL7mcSGs8mL7xk3F6vZGUxav8X93M2FluK5vV+3PE1I
	sF24fuei4hq7Yz4uTaVl//8YhB1m4jpzOS8uZve9Iyo+Qm0sM/7IP/F6Es98bLaQdcd6k+Mu
	PCfVJE3y49IiV7t1POzd9cNhwfH2zVU7p5opsRRnJBpqMRcVJwIAhrbNHWoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 16:14:57 +0100, Tomasz Figa wrote:
> On 19.03.2014 14:20, Tomasz Figa wrote:
> > On 19.03.2014 01:39, Cho KyongHo wrote:
> >> On Tue, 18 Mar 2014 15:26:48 +0100, Tomasz Figa wrote:
> >>>
> >>>
> >>> On 18.03.2014 14:01, Cho KyongHo wrote:
> >>>> On Fri, 14 Mar 2014 17:12:03 +0100, Tomasz Figa wrote:
> >>>>> Hi KyongHo,
> >>>>>
> >>>>> On 14.03.2014 06:10, Cho KyongHo wrote:
> >>>>>> Some master device descriptor like fimc-is which is an abstraction
> >>>>>> of very complex H/W may have multiple System MMUs. For those devices,
> >>>>>> the design of the link between System MMU and its master H/W is
> >>>>>> needed
> >>>>>> to be reconsidered.
> >>>>>>
> >>>>>> A link structure, sysmmu_list_data is introduced that provides a link
> >>>>>> to master H/W and that has a pointer to the device descriptor of a
> >>>>>> System MMU. Given a device descriptor of a master H/W, it is possible
> >>>>>> to traverse all System MMUs that must be controlled along with the
> >>>>>> master H/W.
> >>>>>
> >>>>> NAK.
> >>>>>
> >>>>> A device driver should handle particular hardware instances
> >>>>> separately,
> >>>>> without abstracting a virtual hardware instance consisting of multiple
> >>>>> physical ones.
> >>>>>
> >>>>> If such abstraction is needed, it should be done above the
> >>>>> exynos-iommu
> >>>>> driver, e.g. by something like iommu-composite driver that would
> >>>>> aggregate several IOMMUs. Keep in mind that such IOMMUs in a group
> >>>>> could
> >>>>> be different, e.g. different Exynos SysMMU versions or even completely
> >>>>> different IPs handled by different drivers.
> >>>>>
> >>>>> Still, I don't think there is a real need for such abstraction.
> >>>>> Instead,
> >>>>> related drivers shall be fixed to properly handle multiple memory
> >>>>> masters and their IOMMUs.
> >>>>>
> >>>>
> >>>> G2D, Scalers and FIMD of Exynos5420 has 2 System MMUs while aother
> >>>> SoC like
> >>>> Exynos5250 does not.
> >>>>
> >>>> I don't understand why you are negative to this approach.
> >>>> This is the simplest than the others.
> >>>>
> >>>> Let me show you an example.
> >>>> FIMC-IS driver just controls MCU in FIMC-IS subsystem and the
> >>>> firmware of
> >>>> the MCU controls all other peripherals in the subsystem. Each
> >>>> peripherals
> >>>> have their own System MMU. Moreover, the configuration of the
> >>>> peripherals
> >>>> varies according to the SoCs.
> >>>>
> >>>> If System MMU driver accepts multiple masters, everything is done in
> >>>> DT.
> >>>> But I worry that it is not easy if System MMU driver does not support
> >>>> multiple masters.
> >>>
> >>> I believe I have stated enough reasons why this kind of implementation
> >>> is bad. I'm not going to waste time repeating myself.
> >>>
> >>> Your concerns presented above are valid, however they are not related to
> >>> what is wrong with this patch. I have given you two proper ways to
> >>> handle this, none should be forced upon particular IOMMU master drivers
> >>> - their authors should have the chance to select the method that works
> >>> best for them.
> >>>
> >>
> >> I don't still understand why you think this patch is wrong.
> >> I think this is the best way not to think for all the driver developers
> >> about other things than their business logic.
> >
> > I agree, but one of the ways I proposed (an iommu-composite layer above
> > the IOMMU low level drivers) doesn't add any extra responsibility of
> > driver developers.
> >
> > Moreover, it's this kind of business logic in low level drivers that is
> > adding more responsibility, because it introduces additional complexity
> > and makes the driver harder to read, maintain and extend in future.
> >
> >>
> >> This does not hurt anyone and I think this is good enough.
> >>
> >
> > Well, it is barely good enough. It is a good practice to make a low
> > level driver handle a single device instance and this is how Linux
> > driver model is designed.
> >
> > Moreover, a single device tree node _must_ represent a single hardware
> > block, so you can't group multiple SysMMUs into a single device tree node.
> >
> 
> OK, you add nodes for single SysMMUs devices which is fine, sorry. I was 
> under impression that one kernel device (struct device) corresponds to 
> multiple SysMMUs, but this was before your patches, sorry. So one issue 
> less, but it's still not good.
> 

Ok. Understood why you have mentioned such.

> > Furthermore, if you force grouping of SysMMUs into a single virtual one,
> > you enforce using the same address space for all masters of some
> > particular hardware blocks, while potentially driver developers would
> > like to separate them.
> 
> Probably some clarification is needed. Your other patch adds:
> 
> 	sysmmu_fimd0w04: sysmmu@14640000 {
> 		compatible = "samsung,sysmmu-v3.3";
> 		reg = <0x14640000 0x1000>;
> 		interrupt-parent = <&combiner>;
> 		interrupts = <3 2>;
> 		clock-names = "sysmmu", "master";
> 		clocks = <&clock 422>, <&clock 421>;
> 		samsung,power-domain = <&disp_pd>;
> 		mmu-masters = <&fimd>;
> 	};
> 
> 	sysmmu_fimd0w123: sysmmu@14680000 {
> 		compatible = "samsung,sysmmu-v3.3";
> 		reg = <0x14680000 0x1000>;
> 		interrupt-parent = <&combiner>;
> 		interrupts = <3 0>;
> 		clock-names = "sysmmu", "master";
> 		clocks = <&clock 423>, <&clock 421>;
> 		samsung,power-domain = <&disp_pd>;
> 		mmu-masters = <&fimd>;
> 	};
> 
>  From such description, in future FIMD driver won't be able to determine 
> which SysMMU is used for windows 0 and 4 and which for windows 1, 2 and 
> 3. However it would be desirable to handle both SysMMUs separately, 
> allowing each SysMMU to have only mappings for frame buffers needed by 
> respective FIMD windows.
> 

If it is required to map frame buffers for the System MMU of a specific window,
you can specify different phandles to mmu-masters of sysmmu_fimd0w04 and
sysmmu_0w123.

However, I think it is more convenient that all windows of a FIMD share the
same virtual address space because
 - Exynos5250: FIMD has one System MMU
 - Exynos5420: FIMD has 2 System MMUs for Window 0,4 and 1,2,3
 - Another SoC which is not ready for upstreaming: FIMD has 2 System MMUs for window 0,1 and 2,3,4
(I also discouraged when I found a new Soc has different H/W bus topology :)

For this reason, I prefer allowing a single master to have multiple System MMU.

> > A good interface design should not enforce any particular implementation
> > and this is what we should stick to in this case as well.
> >
> >> If you want to provide another layer between master device and system mmu
> >> as you mentioned, you do that. This patch does not restrict it.
> >
> > It does, as mentioned above. With a device tree listing multiple SysMMUs
> > as one, you can't separate them.
> 
> What I mean is that based on DT description, drivers should be able to 
> control SysMMUs separately if they want to.
> 

As I mentioned above, drivers can control every System MMU separately.

Thank you.

KyongHo
