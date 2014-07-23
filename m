Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbaGWKD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:03:27 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:54282
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754112AbaGWKD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:03:26 -0400
Date: Wed, 23 Jul 2014 17:52:32 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <b02247@freescale.com>,
        <b42378@freescale.com>
Subject: Re: [PATCH 1/2] ASoC: fsl_sai: Reset FIFOs after disabling TE/RE
Message-ID: <20140723095229.GA25639@MrMyself>
References: <cover.1405603108.git.nicoleotsuka@gmail.com>
 <9ef07dc9cc98b19e3f81f8374617605bf0d9faeb.1405603108.git.nicoleotsuka@gmail.com>
 <20140718101810.GA15150@MrMyself>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140718101810.GA15150@MrMyself>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(189002)(199002)(43544003)(86362001)(575784001)(107046002)(2351001)(80022001)(83072002)(85852003)(33656002)(26826002)(20776003)(47776003)(4396001)(102836001)(23726002)(64706001)(81542001)(105606002)(110136001)(95666004)(83506001)(104016003)(46406003)(6806004)(81156004)(68736004)(106466001)(69596002)(85306003)(92566001)(92726001)(81342001)(84676001)(44976005)(97736001)(97756001)(99396002)(46102001)(83322001)(19580395003)(19580405001)(79102001)(33716001)(31966008)(74502001)(76482001)(50466002)(74662001)(77982001)(21056001)(54356999)(76176999)(50986999)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB435;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sir,

I found this two patches are merged into for-next branch, although I haven't
got the 'applied' email. 

Is that possible for you to drop this one? If not, I'll send another patch
to fix this.

Thank you,
Nicolin

On Fri, Jul 18, 2014 at 06:18:12PM +0800, Nicolin Chen wrote:
> Mark,
> 
> 	Please disregard this single patch. 
> 
> On Thu, Jul 17, 2014 at 09:21:37PM +0800, Nicolin Chen wrote:
> > SAI will not clear their FIFOs after disabling TE/RE. Therfore, the driver
> > should take care the task so as not to let useless data remain in the FIFO.
> > 
> > Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
> > ---
> >  sound/soc/fsl/fsl_sai.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> > index c5a0e8a..b10dbd8 100644
> > --- a/sound/soc/fsl/fsl_sai.c
> > +++ b/sound/soc/fsl/fsl_sai.c
> > @@ -371,10 +371,13 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
> >  
> >  		/* Check if the opposite FRDE is also disabled */
> >  		if (!(tx ? rcsr & FSL_SAI_CSR_FRDE : tcsr & FSL_SAI_CSR_FRDE)) {
> > +			/* Disable both directions and reset their FIFOs */
> >  			regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
> > -					   FSL_SAI_CSR_TERE, 0);
> > +					   FSL_SAI_CSR_TERE | FSL_SAI_CSR_FR,
> > +					   FSL_SAI_CSR_FR);
> >  			regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
> > -					   FSL_SAI_CSR_TERE, 0);
> > +					   FSL_SAI_CSR_TERE | FSL_SAI_CSR_FR,
> > +					   FSL_SAI_CSR_FR);
> 
> 
> The FR should be set _after_ clear TERE, not at the same time because it
> still may have tiny possibility to remain data.
> 
> I'll send another version later for this patch.
> 
> The other patch for isr() should be still fine.
> 
> Thank you,
> Nicolin
> 
> >  		}
> >  		break;
> >  	default:
> > -- 
> > 1.8.4
> > 
