Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaAILsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:48:08 -0500
Received: from [207.46.163.183] ([207.46.163.183]:44217 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750882AbaAILr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:47:58 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCHv8 2/2] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCHv8 2/2] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHPB47uPM111gOKuU2aAMy3AWNY85p6pw6ggAAJn4CAAXgr0IAAFwwAgAACFUA=
Date: Thu, 9 Jan 2014 11:44:46 +0000
Message-ID: <dde6cf78c07b40f29ac711fc27fe903c@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1388645544-5596-1-git-send-email-b35083@freescale.com>
 <5890639.zaOC7MRE09@wuerfel>
 <4efd24a1219547cbbf0ce8ec66d762e5@BL2PR03MB467.namprd03.prod.outlook.com>
 <201401091142.35226.arnd@arndb.de>
In-Reply-To: <201401091142.35226.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(24454002)(377454003)(41574002)(51704005)(13464003)(199002)(189002)(74366001)(46102001)(51856001)(2656002)(87936001)(65816001)(80022001)(66066001)(33646001)(85306002)(77982001)(59766001)(47976001)(50986001)(4396001)(47736001)(54316002)(49866001)(79102001)(53806001)(54356001)(87266001)(56776001)(63696002)(76482001)(74316001)(31966008)(74662001)(69226001)(76796001)(81342001)(81686001)(74502001)(47446002)(85852003)(19580395003)(80976001)(83072002)(83322001)(19580405001)(74706001)(74876001)(76576001)(76786001)(81542001)(81816001)(92566001)(56816005)(90146001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB467.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s09BmDuO001358


> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Thursday, January 09, 2014 6:43 PM
> To: Lu Jingchang-B35083
> Cc: vinod.koul@intel.com; dan.j.williams@intel.com; shawn.guo@linaro.org;
> pawel.moll@arm.com; mark.rutland@arm.com; swarren@wwwdotorg.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> devicetree@vger.kernel.org
> Subject: Re: [PATCHv8 2/2] dma: Add Freescale eDMA engine driver support
> 
> On Thursday 09 January 2014, Jingchang Lu wrote:
> > > > > +sai2: sai@40031000 {
> > > > > +	compatible = "fsl,vf610-sai";
> > > > > +	reg = <0x40031000 0x1000>;
> > > > > +	interrupts = <0 86 0x04>;
> > > > > +	clocks = <&clks VF610_CLK_SAI2>;
> > > > > +	clock-names = "sai";
> > > > > +	dma-names = "tx", "rx";
> > > > > +	dmas = <&edma0 VF610_EDMA_DMAMUX0 VF610_EDMA0_MUX0_SAI2_TX>,
> > > > > +		<&edma0 VF610_EDMA_DMAMUX0 VF610_EDMA0_MUX0_SAI2_RX>;
> > > > > +	status = "disabled";
> > > > > +};
> > >
> > > It seems wrong to have macros defined like VF610_EDMA0_MUX0_SAI2_TX,
> > > in particular in the example. These should just be literal numbers.
> > [Lu Jingchang-b35083]
> > This eDMA engineer requires two specifiers, one is a mux group id, the
> other is a request source id.
> > The VF610_EDMA0_MUX0_SAI2_TX is sai's tx dma request source id, it is
> defined as a literal number.
> > There are totally more than 100 request source id, I have them macros
> defined to make it referenced
> > easily and clearly, just like some clock binding done.
> > The macros are defined in include/dt-bindings/dma/vf610-edma.h.
> 
> The clock bindings are special because the macros there tend to be made
> up for controllers that just have a bunch of clocks at random register
> locations.
> 
> This is not the case for DMA bindings (or some of the more regular clock
> controllers), so there is absolutely no reason to define those macros
> in a header file, it just adds artificial dependencies between the
> driver, SoC support and the binding.
> 
> If the numbers are the same as the ones provided in the data sheet,
> just use the numbers and remove the macros.
Yes, the request source id is defined in the data sheet.
each eDMA controller has two muxes, some SoCs have two eDMA controllers
while others have only one. The 1st eDMA's muxes are named mux0 and mux1,
while the 2nd eDMA controller's muxes are named MUX2 and MUX3 in the datasheet,
and I index them in each eDMA controller from 0 in the driver to handle them commonly.
I defines the macro tending to give the info from the macro name, such as
for the VF610_EDMA0_MUX0_SAI2_TX request source, implying the eDMA engine id 0,
and the mux id should be 0. While VF610_EDMA1_MUX1_FTM0_CH0 implying eDMA engine id 1,
mux 1. The request sources are shared between the two eDMA controller but need the user
to select one manually when reference.
I think this could ease the dma reference for the eDMA controller, or I will remove them.
Thanks!
> 
> > > > > +/*
> > > > > + * copying of ARM read{b,w,l) and write{b,w,l) macro definations
> > > > > + * except for doing default swap of cpu_to_le32, the bytes swap
> > > > > + * is done depending on eDMA controller's endian defination,
> > > > > + * which may be big-endian or little-endian.
> > > > > + */
> > > > > +static inline u16 edma_readw(void __iomem *addr)
> > > > > +{
> > > > > +	u16 __v = (__force u16) __raw_readw(addr);
> > > > > +
> > > > > +	__iormb();
> > > > > +	return __v;
> > > > > +}
> > >
> > > The comment doesn't seem to match the implementation: You don't
> > > actually do swaps here at all, which means this will fail when
> > > your kernel is running in big-endian mode. Just use the regular
> > > readw() etc, or use ioread16/ioread16be depending on the flag,
> > > and get rid of your EDMA_SWAP macros.
> > >
> > > No need to come up with your own scheme when the problem has
> > > been solved already elsewhere.
> > The working scenario for this device is, the cpu running in little-
> endian mode,
> > While the eDMA module running in little- or big-endian mode. This
> device is currently
> > running on ARM architecture only, and I notice that ARM's little-endian
> readl/writel
> > treats all value as little-endian. This is not matching our scenario
> here. So I removed
> > the default cpu_to_le32() in the readl(), and put it in EDMA_SWAP32()
> to satisfy the
> > required.
> 
> You are right, your code is actually correct on all combinations
> of big-endian and little-endian ARM CPUs. However, I would argue that
> it's unusual style, and not portable to other architectures (e.g. arm64)
> because the definition of readl() is highly architecture dependent.
> It would also be problematic if the arm definition has to change
> in some form and this driver is overlooked.
[Lu Jingchang-b35083] 
Yes, these definitions are highly depending on the arm32 arch. This device is only
integrated in our arm32 SoCs currently, so I have only considered arm32.
In arm32, it seems that the ioread32 and readl are the same in arm32,
I will try your recommendation below to simplify the caller.
Thanks.
> 
> I would still recommend doing an implementation like
> 
> static inline u16 edma_readw(struct fsl_edma_engine *edma, u16 val,
> unsigned long offset)
> {
> 	if (edma->big_endian)
> 		iowrite16be(val, edma->membase + offset);
> 	else
> 		iowrite16(val, edma->membase + offset);
> }
> 
> 
> This would simplify the callers that now can replace
> 
>         cur_addr = EDMA_SWAP32(fsl_chan->edma, edma_readl(addr +
> EDMA_TCD_SADDR(ch)));
> 
> with
> 
> 	cur_addr = edma_readl(fsl_chan->edma, EDMA_TCD_SADDR(ch));
> 
> which IMHO is much easier to read. For accessing muxbase, you
> don't have to use your own version, because all accesses are
> single-byte.
> 
> BTW, I noticed that fsl_edma_set_tcd_params() is calling edma_writew()
> and edma_writel() without an endian-swap, so I assume it is still
> broken on big-endian CPUs, and likely also on big-endian eDMA engines.
The values written in fsl_edma_set_tcd_params() are pre-swapped in fill_tcd_params().
The eDMA support hardware SGs, but the eDMA engine's sg format is required the same as
the eDMA Controller's endian, so the SGs in memory to be loaded automatically by the eDMA 
engine also required swapped properly. So they should be swapped specifically here.
Thanks.

> > > > > +static bool fsl_edma_filter_fn(struct dma_chan *chan, void *mux)
> > > > > +{
> > > > > +	 return (chan->chan_id / DMAMUX_NR) == (u32)mux;
> > > > > +}
> > > > > +
> > > > > +static struct dma_chan *fsl_edma_xlate(struct of_phandle_args
> > > *dma_spec,
> > > > > +		struct of_dma *ofdma)
> > > > > +{
> > > > > +	struct dma_chan *chan;
> > > > > +	dma_cap_mask_t mask;
> > > > > +
> > > > > +	if (dma_spec->args_count != 2)
> > > > > +		return NULL;
> > > > > +
> > > > > +	dma_cap_zero(mask);
> > > > > +	dma_cap_set(DMA_SLAVE, mask);
> > > > > +	dma_cap_set(DMA_CYCLIC, mask);
> > > > > +	chan = dma_request_channel(mask, fsl_edma_filter_fn, (void
> > > > > *)dma_spec->args[0]);
> > > > > +	if (chan)
> > > > > +		fsl_edma_chan_mux(to_fsl_edma_chan(chan), dma_spec-
> >args[1],
> > > > > true);
> > > > > +	return chan;
> > > > > +}
> > >
> > > Please remove the filter function now and use dma_get_slave_chan
> > > with the correct channel as an argument. No need to walk all
> > > available channels in the system and introduce bugs by not
> > > ignoring other dma engines.
> >
> > The dma slave request can only be allocated to channel of particular
> channels group indicated by
> > the mux group id specifier. and the second specifier is the request id,
> not the channel number,
> > so to use the dma_get_slave_chan, I would find the channel for this
> request by walking all the
> > available channels manually.
> 
> Ah, I missed that you only check the mux number, not the channel number.
> 
> The current version however is buggy because you don't check that you
> are actually looking at the right eDMA instance, or an eDMA at all,
> rather
> than some other random dma engine that may be connected to an external
> bus.
> 
> It is possible to fix that, but I suspect that would involve more
> complex code than finding an appropriate channel first and then
> calling dma_get_slave_chan() on that.
> I would suggest keeping a list of channels per dmamux and walking that
> list until you find one that succeeds in dma_get_slave_chan().
The binding in DTS is to the eDMA engine, and the binding indicates the eDMA node
(by <&edma0 ...>), the dma engine framework would find the proper eDMA engine device
referenced in dts. This driver only supports dts reference, so I think the dma engine
framework could guarantee the eDMA instance properly in of_dma_find_controller().
Thanks.


Best regards,
Jingchang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
