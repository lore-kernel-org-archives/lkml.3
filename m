Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaHSIbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:31:55 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:7196
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750721AbaHSIbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:31:51 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "xobs@kosagi.com" <xobs@kosagi.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "timur@tabi.org" <timur@tabi.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove dependence
 of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
Thread-Topic: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove
 dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
Thread-Index: AQHPur/l6X7Prx80DU+vzEIed2D12pvWlCwAgAD4M4CAAAeFgIAAA6uAgAAAW8A=
Date: Tue, 19 Aug 2014 08:31:47 +0000
Message-ID: <fb8086a68ed74e0794d34f66c2396b30@BN1PR0301MB0609.namprd03.prod.outlook.com>
References: <cover.1408350626.git.shengjiu.wang@freescale.com>
 <f30ba4e2c4eb6702fa40bd255036e6e9ad6eb47d.1408350626.git.shengjiu.wang@freescale.com>
 <53F22F5E.2090601@metafoo.de> <20140819074103.GA5806@audiosh1>
 <d7b06608abcc4f098789f63cb9f36eef@BN1PR0301MB0609.namprd03.prod.outlook.com>
 <20140819082108.GB5806@audiosh1>
In-Reply-To: <20140819082108.GB5806@audiosh1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0308EE423E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019006)(6009001)(51704005)(189002)(199003)(164054003)(46102001)(76482001)(33646002)(81342001)(21056001)(107046002)(31966008)(74316001)(80022001)(76576001)(66066001)(85852003)(83072002)(87936001)(110136001)(74662001)(86362001)(20776003)(54356999)(85306004)(108616004)(95666004)(93886004)(79102001)(77982001)(106116001)(4396001)(77096002)(99286002)(50986999)(2656002)(99396002)(83322001)(92566001)(81542001)(64706001)(74502001)(106356001)(76176999)(101416001)(105586002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB332;H:BN1PR0301MB0609.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Lars-Peter Clausen & Arnd
> > >
> > > The purpose of Arnd's patch is same with me, which is to resolve the build
> > > error when SND_SOC_IMX_PCM_DMA=m & SND_SOC_FSL_SSI/SAI/ESAI/SPDIF=y, the
> > > error is "undefined reference to `imx_pcm_dma_init'".
> > > But Arnd's patch didn't involve this situation that SND_IMX_SOC=n &
> > > SND_SOC_IMX_PCM_DMA=m.
> > >
> > > Currently I think out a solution for this issue is to change
> > >
> > > select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
> > >
> > > to
> > >
> > > depends on SND_SOC_IMX_PCM_DMA != m
> > >
> > > How do you think about this?
> > >
> >
> > What will happen if to build both SAI/ESAI and IMX_PCM_DMA as modules at the
> same
> > time ?
> >
> > Thanks,
> >
> > BRs
> > Xiubo
> 
> I didn't find error/warning when SAI/ESAI and IMX_PCM_DMA are as modules. The
> build is successful.
> 

Yes, but if IMX_PCM_DMA == m, the SAI/ESAI will be invisible in menuconfig....
Does it matter here ?

BRs
Xiubo


> >
> >
> > > best regards
> > > Wang shengjiu
