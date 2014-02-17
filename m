Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaBQJLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:11:22 -0500
Received: from [207.46.163.208] ([207.46.163.208]:50903 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751448AbaBQJLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:11:18 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: "vinod.koul@intel.com" <vinod.koul@intel.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv11 2/2] dma: Add Freescale eDMA engine driver support
Thread-Topic: [PATCHv11 2/2] dma: Add Freescale eDMA engine driver support
Thread-Index: AQHPFcl/DqoJuHRuCEGLFAeiA59sf5qX5zRggCFpSkA=
Date: Mon, 17 Feb 2014 09:08:00 +0000
Message-ID: <de84e857254848fb86dfcffa65617f47@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1390209831-15679-1-git-send-email-b35083@freescale.com>
 <ca19105670be4af882ed72d3e004a6c7@BLUPR03MB472.namprd03.prod.outlook.com>
In-Reply-To: <ca19105670be4af882ed72d3e004a6c7@BLUPR03MB472.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 012570D5A0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(377454003)(66654002)(13464003)(189002)(41574002)(199002)(80022001)(85306002)(87936001)(49866001)(80976001)(65816001)(81816001)(95666001)(81686001)(4396001)(95416001)(47446002)(76786001)(76796001)(77982001)(19580395003)(56776001)(33646001)(79102001)(59766001)(47736001)(87266001)(2656002)(19580405001)(50986001)(83322001)(47976001)(74502001)(54356001)(53806001)(54316002)(74366001)(81542001)(83072002)(46102001)(66066001)(74662001)(74876001)(90146001)(81342001)(56816005)(86362001)(93516002)(94946001)(85852003)(51856001)(94316002)(74706001)(76576001)(31966008)(76482001)(92566001)(63696002)(93136001)(69226001)(74316001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB466;H:BL2PR03MB467.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1H9BVP1015881

Hi, Vinod,

    Could you please help merge this patch? We are having some other upstreaming
patches using the dma functionality pending the acceptance of the eDMA driver.
    Many thanks!

Best Regards,
Jingchang

> -----Original Message-----
> From: Lu Jingchang-B35083
> Sent: Monday, January 27, 2014 1:20 PM
> To: Lu Jingchang-B35083; vinod.koul@intel.com
> Cc: dan.j.williams@intel.com; arnd@arndb.de; shawn.guo@linaro.org;
> pawel.moll@arm.com; mark.rutland@arm.com; swarren@wwwdotorg.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> devicetree@vger.kernel.org; Wang Huan-B18965
> Subject: RE: [PATCHv11 2/2] dma: Add Freescale eDMA engine driver support
> 
> Hi, Vinod,
> 
>   Let me give some more explanation on the eDMA engine pause and
> termination here:
> The eDMA engine is a request-driven controller, it manage all channels in
> one engine and schedule them to perform each one's transfer when one's
> dma request arrive.
> When a dma request of a specific channel is received, the channel's
> appropriate TCD Parameter contents are loaded into the eDMA engine, and
> the appropriate reads and writes Perform until the minor byte transfer
> count has transferred, the number of bytes to transfer per request is
> determined by the salve's characteristics, such as the FIFO size, and the
> dma request condition is also determined by specific slave, such as FIFO
> empty.
> And to the transfer a bunch of data need many dma requests.
>   So if the dma request enable bit of a channel is cleared, there will be
> no further dma Request received by the eDMA engine, thus the channel will
> never be scheduled to run by the eDMA engine, the channel is paused,
> halted, also as stopped. If the channel need to transfer the remained
> data with the previous setting, just set the dma request enable bit, the
> transfer will complete with slave's dma request.(resume) If the
> parameters need be changed, corresponding register parameters can be
> reprogrammed, after all is ok, the dma request enable bit can be set to
> enable a new dma transfer.(terminate)
>   So is this ok and could it be merged, thanks!
> 
> 
> Best Regards,
> Jingchang
> 
> 
> > -----Original Message-----
> > From: Jingchang Lu [mailto:b35083@freescale.com]
> > Sent: Monday, January 20, 2014 5:24 PM
> > To: vinod.koul@intel.com
> > Cc: dan.j.williams@intel.com; arnd@arndb.de; shawn.guo@linaro.org;
> > pawel.moll@arm.com; mark.rutland@arm.com; swarren@wwwdotorg.org; linux-
> > kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> > devicetree@vger.kernel.org; Lu Jingchang-B35083; Wang Huan-B18965
> > Subject: [PATCHv11 2/2] dma: Add Freescale eDMA engine driver support
> >
> > Add Freescale enhanced direct memory(eDMA) controller support.
> > This module can be found on Vybrid and LS-1 SoCs.
> >
> > Signed-off-by: Alison Wang <b18965@freescale.com>
> > Signed-off-by: Jingchang Lu <b35083@freescale.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > changes in v11:
> >  Add dma device_slave_caps definition.
> >
> > changes in v10:
> >  define fsl_edma_mutex in fsl_edma_engine instead of global.
> >  minor changes of binding description.
> >
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
> >  Documentation/devicetree/bindings/dma/fsl-edma.txt |  76 ++
> >  drivers/dma/Kconfig                                |  10 +
> >  drivers/dma/Makefile                               |   1 +
> >  drivers/dma/fsl-edma.c                             | 975
> > +++++++++++++++++++++
> >  4 files changed, 1062 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/dma/fsl-edma.txt
> >  create mode 100644 drivers/dma/fsl-edma.c

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
