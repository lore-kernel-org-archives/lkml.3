Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaHSIVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:21:21 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:25912
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751423AbaHSIVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:21:18 -0400
Date: Tue, 19 Aug 2014 16:21:09 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Xiubo Li-B47053 <Li.Xiubo@freescale.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        Estevam Fabio-R49496 <Fabio.Estevam@freescale.com>,
        "xobs@kosagi.com" <xobs@kosagi.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "timur@tabi.org" <timur@tabi.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove
 dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
Message-ID: <20140819082108.GB5806@audiosh1>
References: <cover.1408350626.git.shengjiu.wang@freescale.com>
 <f30ba4e2c4eb6702fa40bd255036e6e9ad6eb47d.1408350626.git.shengjiu.wang@freescale.com>
 <53F22F5E.2090601@metafoo.de> <20140819074103.GA5806@audiosh1>
 <d7b06608abcc4f098789f63cb9f36eef@BN1PR0301MB0609.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d7b06608abcc4f098789f63cb9f36eef@BN1PR0301MB0609.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019006)(6009001)(164054003)(24454002)(479174003)(377454003)(199003)(189002)(51704005)(83506001)(21056001)(44976005)(74502001)(74662001)(84676001)(31966008)(95666004)(46406003)(76176999)(4396001)(26826002)(15202345003)(6806004)(87936001)(68736004)(110136001)(97756001)(107046002)(97736001)(69596002)(80022001)(46102001)(20776003)(15975445006)(104016003)(76482001)(92566001)(81342001)(83072002)(93886004)(92726001)(19580405001)(85306004)(85852003)(81542001)(23726002)(99396002)(86362001)(79102001)(54356999)(50466002)(102836001)(105606002)(77982001)(33656002)(19580395003)(106466001)(81156004)(64706001)(47776003)(50986999)(33716001)(83322001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB256;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 04:13:15PM +0800, Xiubo Li-B47053 wrote:
> > Subject: Re: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove dependence
> > of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
> > 
> > On Mon, Aug 18, 2014 at 06:52:46PM +0200, Lars-Peter Clausen wrote:
> > > On 08/18/2014 10:38 AM, Shengjiu Wang wrote:
> > > >Build kernel with SND_SOC_IMC_PCM_DMA=m && SND_IMX_SOC=n leads the
> > following
> > > >error:
> > > >
> > > >    sound/built-in.o: In function `fsl_sai_probe':
> > > >>>fsl_sai.c:(.text+0x5f662): undefined reference to `imx_pcm_dma_init'
> > > >    sound/built-in.o: In function `fsl_esai_probe':
> > > >>>fsl_esai.c:(.text+0x6044b): undefined reference to `imx_pcm_dma_init'
> > > >
> > > >Most cpu driver in soc/fsl has use the function 'imx_pcm_dma_init' which is
> > > >defined in imx-pcm-dma.c, so need to select SND_SOC_IMX_PCM_DMA, but it
> > depends
> > > >on SND_IMX_SOC, if SND_IMX_SOC=n, then SND_SOC_IMX_PCM_DMA will not be
> > > >selected.
> > > >So remove the dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA.
> > > >
> > > >Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > > >Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> > >
> > > Those if conditions where just added[1] by Arnd to avoid other build
> > > failures. So just removing them again makes little sense.
> > >
> > > As far as I can see imx_pcm_dma_init() should be stubbed out when
> > > SND_SOC_IMX_PCM_DMA is not selected. So what's going on here?
> > >
> > > [1]
> > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ff40
> > 260f79dc0436604452bccd449bffd25ebafb
> > >
> > Lars-Peter Clausen & Arnd
> > 
> > The purpose of Arnd's patch is same with me, which is to resolve the build
> > error when SND_SOC_IMX_PCM_DMA=m & SND_SOC_FSL_SSI/SAI/ESAI/SPDIF=y, the
> > error is "undefined reference to `imx_pcm_dma_init'".
> > But Arnd's patch didn't involve this situation that SND_IMX_SOC=n &
> > SND_SOC_IMX_PCM_DMA=m.
> > 
> > Currently I think out a solution for this issue is to change
> > 
> > select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n
> > 
> > to
> > 
> > depends on SND_SOC_IMX_PCM_DMA != m
> > 
> > How do you think about this?
> > 
> 
> What will happen if to build both SAI/ESAI and IMX_PCM_DMA as modules at the same
> time ?
> 
> Thanks,
> 
> BRs
> Xiubo

I didn't find error/warning when SAI/ESAI and IMX_PCM_DMA are as modules. The 
build is successful.

> 
> 
> > best regards
> > Wang shengjiu
