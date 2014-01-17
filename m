Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaAQC6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 21:58:53 -0500
Received: from mail-bn1lp0154.outbound.protection.outlook.com ([207.46.163.154]:16143
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbaAQC6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 21:58:50 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCHv9 2/2] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCHv9 2/2] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHPEmrvyxjbmA0a8EaGX9qH7zMJ1pqHMr4AgAD+e4A=
Date: Fri, 17 Jan 2014 02:58:47 +0000
Message-ID: <baf3ad72a9ea4f07bad56abcbb89bce4@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1389839400-29728-1-git-send-email-b35083@freescale.com>
 <1389839400-29728-3-git-send-email-b35083@freescale.com>
 <20140116111205.GB19578@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140116111205.GB19578@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(679001)(689001)(779001)(13464003)(51704005)(199002)(189002)(377454003)(24454002)(54316002)(53806001)(46102001)(49866001)(54356001)(76796001)(51856001)(19580395003)(63696002)(47976001)(50986001)(83322001)(79102001)(19580405001)(80976001)(47736001)(92566001)(74316001)(93136001)(81816001)(33646001)(56776001)(77982001)(59766001)(76786001)(76482001)(87266001)(76576001)(74876001)(74662001)(87936001)(31966008)(83072002)(81686001)(81342001)(47446002)(85306002)(90146001)(56816005)(2656002)(80022001)(65816001)(66066001)(69226001)(85852003)(4396001)(81542001)(74706001)(74502001)(74366001)(93516002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB467.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0H2wxPb021871



> -----Original Message-----
> From: Mark Rutland [mailto:mark.rutland@arm.com]
> Sent: Thursday, January 16, 2014 7:12 PM
> To: Lu Jingchang-B35083
> Cc: vinod.koul@intel.com; dan.j.williams@intel.com; arnd@arndb.de;
> shawn.guo@linaro.org; Pawel Moll; swarren@wwwdotorg.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> devicetree@vger.kernel.org; Wang Huan-B18965
> Subject: Re: [PATCHv9 2/2] dma: Add Freescale eDMA engine driver support
> 
> On Thu, Jan 16, 2014 at 02:30:00AM +0000, Jingchang Lu wrote:
> > Add Freescale enhanced direct memory(eDMA) controller support.
> > This module can be found on Vybrid and LS-1 SoCs.
> >
> > Signed-off-by: Alison Wang <b18965@freescale.com>
> > Signed-off-by: Jingchang Lu <b35083@freescale.com>
> > ---
> > changes in v9:
> >  define endian's operating functions instead of macro definition.
> >  remove the filter function, using dma_get_slave_channel instead.
> >
> > changes in v8:
> >  change the edma driver according eDMA dts change.
> >  add big-endian and little-endian handling.
> >
> >  no changes in v4 ~ v7.
> >
> >  changes in v3:
> >   add vf610 edma dt-bindings namespace with prefix VF610_*.
> >
> >  changes in v2:
> >   using generic dma-channels property instead of fsl,dma-channels.
> >
> >
> >  Documentation/devicetree/bindings/dma/fsl-edma.txt |  66 ++
> >  drivers/dma/Kconfig                                |  10 +
> >  drivers/dma/Makefile                               |   1 +
> >  drivers/dma/fsl-edma.c                             | 957
> +++++++++++++++++++++
> >  4 files changed, 1034 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/dma/fsl-edma.txt
> >  create mode 100644 drivers/dma/fsl-edma.c
> >
> > diff --git a/Documentation/devicetree/bindings/dma/fsl-edma.txt
> b/Documentation/devicetree/bindings/dma/fsl-edma.txt
> > new file mode 100644
> > index 0000000..5a5fb61
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/dma/fsl-edma.txt
> > @@ -0,0 +1,66 @@
> > +* Freescale enhanced Direct Memory Access(eDMA) Controller
> > +
> > +  The eDMA channels have multiplex capability by programmble memory-
> mapped
> > +registers. channels are split into two groups, called DMAMUX0 and
> DMAMUX1,
> > +specific DMA request source can only be multiplexed by any channel of
> certain
> > +group, DMAMUX0 or DMAMUX1, but not both.
> > +
> > +* eDMA Controller
> > +Required properties:
> > +- compatible :
> > +       - "fsl,vf610-edma" for eDMA used similar to that on Vybrid
> vf610 SoC
> > +- reg : Specifies base physical address(s) and size of the eDMA
> registers.
> > +       The 1st region is eDMA control register's address and size.
> > +       The 2nd and the 3rd regions are programmable channel
> multiplexing
> > +       control register's address and size.
> > +- interrupts : Should contain eDMA interrupt
> > +- interrupt-names : Should be "edma-tx" for transmission interrupt and
> > +       "edma-err" for error interrupt
> 
> The description of interrupts and interrupt-names is a bit odd. How
> about:
> 
> - interrupts: a list of interrupt-specifiers, one for each entry in
>   interrupt-names.
> 
> - interrupt names: should contain:
>   * "edma-tx" - the transmission interrupt.
>   * "edma-err" - the error interrupt.
> 
> > +- #dma-cells : Must be <2>.
> > +       The 1st cell specifies the DMAMUX(0 for DMAMUX0 and 1 for
> DMAMUX1).
> > +       Specific request source can only be multiplexed by specific
> channels
> > +       group called DMAMUX.
> > +       The 2nd cell specifies the request source(slot) ID.
> > +       See the SoC's reference manual for all the supported request
> sources.
> > +- dma-channels : Number of channels supported by the controller
> > +- clock-names : The channel group block clock names
> > +- clocks : eDMA module clock
> 
> The set of expected clock-names should be well defined, and the example
> has more than one clock..
> 
> This should be something like:
> 
> - clocks: a list of phandle + clock-specifier pairs, one for each entry
>   in clock-names.
> 
> - clock-names: a list of clock names. Should contain:
>   * "dmamux0" - <insert description here>
>   * "dmamux1" - <insert description here>
Your suggestion for the interrupt and clock binding is much clearer, I will take this, thanks.
> 
> > +
> > +
> > +Examples:
> > +
> > +edma0: dma-controller@40018000 {
> > +       #dma-cells = <2>;
> > +       compatible = "fsl,vf610-edma";
> > +       reg = <0x40018000 0x2000>,
> > +               <0x40024000 0x1000>,
> > +               <0x40025000 0x1000>;
> > +       interrupts = <0 8 IRQ_TYPE_LEVEL_HIGH>,
> > +               <0 9 IRQ_TYPE_LEVEL_HIGH>;
> > +       interrupt-names = "edma-tx", "edma-err";
> > +       dma-channels = <32>;
> > +       clock-names = "dmamux0", "dmamux1";
> > +       clocks = <&clks VF610_CLK_DMAMUX0>,
> > +               <&clks VF610_CLK_DMAMUX1>;
> > +};
> 
> [...]
> 
> > +       for (i = 0; i < DMAMUX_NR; i++) {
> > +               char clkname[32];
> > +
> > +               res = platform_get_resource(pdev, IORESOURCE_MEM, 1 +
> i);
> > +               fsl_edma->muxbase[i] = devm_ioremap_resource(&pdev->dev,
> res);
> > +               if (IS_ERR(fsl_edma->muxbase[i]))
> > +                       return PTR_ERR(fsl_edma->muxbase[i]);
> > +
> > +               sprintf(clkname, "dmamux%d", i);
> > +               fsl_edma->muxclk[i] = of_clk_get(np, i);
> > +               fsl_edma->muxclk[i] = devm_clk_get(&pdev->dev, clkname);
> 
> The of_clk_get should disappear. It's always overwritten and
> devm_clk_get will do what you want.
It's my mistake in substituting devm_clk_get() for of_clk_get(), I will remove it, thanks.

> 
> > +               if (IS_ERR(fsl_edma->muxclk[i])) {
> > +                       dev_err(&pdev->dev, "Missing DMAMUX block
> clock.\n");
> > +                       return PTR_ERR(fsl_edma->muxclk[i]);
> > +               }
> > +
> > +               ret = clk_prepare_enable(fsl_edma->muxclk[i]);
> > +               if (ret) {
> > +                       dev_err(&pdev->dev, "DMAMUX clk block
> failed.\n");
> > +                       return ret;
> > +               }
> > +
> > +       }
> > +
> > +       ret = fsl_edma_irq_init(pdev, fsl_edma);
> > +       if (ret)
> > +               return ret;
> > +
> > +       fsl_edma->big_endian = of_property_read_bool(np, "big-endian");
> 
> This isn't in the binding.
I will add its binding, thanks.


Best Regards,
Jingchang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
