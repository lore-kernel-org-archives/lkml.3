Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaHSHlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:41:18 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:5157
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752706AbaHSHlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:41:17 -0400
Date: Tue, 19 Aug 2014 15:41:07 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: <lgirdwood@gmail.com>, <broonie@kernel.org>, <perex@perex.cz>,
        <tiwai@suse.de>, <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>,
        <shc_work@mail.ru>, <fabio.estevam@freescale.com>, <xobs@kosagi.com>,
        <arnd@arndb.de>, <sfr@canb.auug.org.au>, <timur@tabi.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH V1 1/3] ASoC: fsl: Kconfig: remove
 dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA
Message-ID: <20140819074103.GA5806@audiosh1>
References: <cover.1408350626.git.shengjiu.wang@freescale.com>
 <f30ba4e2c4eb6702fa40bd255036e6e9ad6eb47d.1408350626.git.shengjiu.wang@freescale.com>
 <53F22F5E.2090601@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53F22F5E.2090601@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019006)(6009001)(51704005)(189002)(199003)(24454002)(377454003)(479174003)(81342001)(33716001)(83506001)(46102001)(83072002)(21056001)(104016003)(97756001)(50466002)(85852003)(31966008)(81542001)(80022001)(86362001)(87936001)(47776003)(15975445006)(92566001)(68736004)(105606002)(84676001)(110136001)(79102001)(15202345003)(99396002)(77982001)(4396001)(46406003)(6806004)(85306004)(107046002)(76176999)(50986999)(97736001)(83322001)(19580395003)(44976005)(23726002)(106466001)(74502001)(92726001)(19580405001)(74662001)(76482001)(102836001)(20776003)(95666004)(64706001)(54356999)(26826002)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB244;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 06:52:46PM +0200, Lars-Peter Clausen wrote:
> On 08/18/2014 10:38 AM, Shengjiu Wang wrote:
> >Build kernel with SND_SOC_IMC_PCM_DMA=m && SND_IMX_SOC=n leads the following
> >error:
> >
> >    sound/built-in.o: In function `fsl_sai_probe':
> >>>fsl_sai.c:(.text+0x5f662): undefined reference to `imx_pcm_dma_init'
> >    sound/built-in.o: In function `fsl_esai_probe':
> >>>fsl_esai.c:(.text+0x6044b): undefined reference to `imx_pcm_dma_init'
> >
> >Most cpu driver in soc/fsl has use the function 'imx_pcm_dma_init' which is
> >defined in imx-pcm-dma.c, so need to select SND_SOC_IMX_PCM_DMA, but it depends
> >on SND_IMX_SOC, if SND_IMX_SOC=n, then SND_SOC_IMX_PCM_DMA will not be
> >selected.
> >So remove the dependence of SND_IMX_SOC for SND_SOC_IMX_PCM_DMA.
> >
> >Reported-by: kbuild test robot <fengguang.wu@intel.com>
> >Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> 
> Those if conditions where just added[1] by Arnd to avoid other build
> failures. So just removing them again makes little sense.
> 
> As far as I can see imx_pcm_dma_init() should be stubbed out when
> SND_SOC_IMX_PCM_DMA is not selected. So what's going on here?
> 
> [1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ff40260f79dc0436604452bccd449bffd25ebafb
>
Lars-Peter Clausen & Arnd

The purpose of Arnd's patch is same with me, which is to resolve the build
error when SND_SOC_IMX_PCM_DMA=m & SND_SOC_FSL_SSI/SAI/ESAI/SPDIF=y, the
error is "undefined reference to `imx_pcm_dma_init'".
But Arnd's patch didn't involve this situation that SND_IMX_SOC=n &
SND_SOC_IMX_PCM_DMA=m. 

Currently I think out a solution for this issue is to change

select SND_SOC_IMX_PCM_DMA if SND_IMX_SOC != n 

to

depends on SND_SOC_IMX_PCM_DMA != m

How do you think about this?

best regards
Wang shengjiu
