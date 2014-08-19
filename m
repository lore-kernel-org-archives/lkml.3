Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaHSIN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:13:29 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:9415
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750768AbaHSIN0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:13:26 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
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
Thread-Index: AQHPur/l6X7Prx80DU+vzEIed2D12pvWlCwAgAD4M4CAAAeFgA==
Date: Tue, 19 Aug 2014 08:13:15 +0000
Message-ID: <d7b06608abcc4f098789f63cb9f36eef@BN1PR0301MB0609.namprd03.prod.outlook.com>
References: <cover.1408350626.git.shengjiu.wang@freescale.com>
 <f30ba4e2c4eb6702fa40bd255036e6e9ad6eb47d.1408350626.git.shengjiu.wang@freescale.com>
 <53F22F5E.2090601@metafoo.de> <20140819074103.GA5806@audiosh1>
In-Reply-To: <20140819074103.GA5806@audiosh1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0308EE423E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019006)(6009001)(199003)(24454002)(164054003)(51704005)(479174003)(377454003)(189002)(77096002)(50986999)(54356999)(21056001)(83322001)(15975445006)(107046002)(19580395003)(2656002)(76576001)(76176999)(99396002)(15202345003)(74502001)(64706001)(81342001)(86362001)(76482001)(93886004)(66066001)(92566001)(95666004)(106116001)(79102001)(74662001)(87936001)(81542001)(31966008)(101416001)(74316001)(77982001)(19580405001)(85852003)(80022001)(105586002)(108616004)(4396001)(83072002)(46102001)(99286002)(85306004)(106356001)(20776003)(33646002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB331;H:BN1PR0301MB0609.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove dependence
> of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
> 
> On Mon, Aug 18, 2014 at 06:52:46PM +0200, Lars-Peter Clausen wrote:
> > On 08/18/2014 10:38 AM, Shengjiu Wang wrote:
> > >Build kernel with SND_SOC_IMC_PCM_DMA=m && SND_IMX_SOC=n leads the
> following
> > >error:
> > >
> > >    sound/built-in.o: In function `fsl_sai_probe':
> > >>>fsl_sai.c:(.text+0x5f662): undefined reference to `imx_pcm_dma_init'
> > >    sound/built-in.o: In function `fsl_esai_probe':
> > >>>fsl_esai.c:(.text+0x6044b): undefined reference to `imx_pcm_dma_init'
> > >
> > >Most cpu driver in soc/fsl has use the function 'imx_pcm_dma_init' which is
> > >defined in imx-pcm-dma.c, so need to select SND_SOC_IMX_PCM_DMA, but it
> depends
> > >on SND_IMX_SOC, if SND_IMX_SOC=n, then SND_SOC_IMX_PCM_DMA will not be
> > >selected.
> > >So remove the dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA.
> > >
> > >Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > >Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> >
> > Those if conditions where just added[1] by Arnd to avoid other build
> > failures. So just removing them again makes little sense.
> >
> > As far as I can see imx_pcm_dma_init() should be stubbed out when
> > SND_SOC_IMX_PCM_DMA is not selected. So what's going on here?
> >
> > [1]
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ff40
> 260f79dc0436604452bccd449bffd25ebafb
> >
> Lars-Peter Clausen & Arnd
> 
> The purpose of Arnd's patch is same with me, which is to resolve the build
> error when SND_SOC_IMX_PCM_DMA=m & SND_SOC_FSL_SSI/SAI/ESAI/SPDIF=y, the
> error is "undefined reference to `imx_pcm_dma_init'".
> But Arnd's patch didn't involve this situation that SND_IMX_SOC=n &
> SND_SOC_IMX_PCM_DMA=m.
> 
> Currently I think out a solution for this issue is to change
> 
> select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
> 
> to
> 
> depends on SND_SOC_IMX_PCM_DMA != m
> 
> How do you think about this?
> 

What will happen if to build both SAI/ESAI and IMX_PCM_DMA as modules at the same
time ?

Thanks,

BRs
Xiubo


> best regards
> Wang shengjiu
