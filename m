Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbaGYGXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:23:21 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:48357
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751913AbaGYGXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:23:19 -0400
Date: Fri, 25 Jul 2014 14:09:23 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Varka Bhadram <varkabhadram@gmail.com>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <timur@tabi.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <shawn.guo@linaro.org>, <b02247@freescale.com>, <b42378@freescale.com>,
        <tklauser@distanz.ch>
Subject: Re: [PATCH v3 2/2] ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and
 platform drivers
Message-ID: <20140725060920.GA29433@MrMyself>
References: <cover.1406259578.git.nicoleotsuka@gmail.com>
 <f4ff79269a1680f9ce128e0e98fea926d3a41834.1406259578.git.nicoleotsuka@gmail.com>
 <53D1DC0B.1000905@gmail.com> <20140725055447.GC29136@MrMyself>
 <53D1F686.30600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53D1F686.30600@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(479174003)(377454003)(189002)(199002)(51704005)(84676001)(81156004)(46102001)(81342001)(44976005)(31966008)(83506001)(104016003)(93886003)(64706001)(20776003)(97736001)(4396001)(102836001)(80022001)(83072002)(33656002)(79102001)(6806004)(76482001)(74662001)(26826002)(95666004)(74502001)(105606002)(77982001)(106466001)(85306003)(33716001)(1411001)(86362001)(107046002)(87936001)(97756001)(92726001)(47776003)(23726002)(110136001)(50466002)(21056001)(69596002)(76176999)(83322001)(54356999)(85852003)(99396002)(81542001)(92566001)(50986999)(68736004)(46406003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB336;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:47:42AM +0530, Varka Bhadram wrote:
> Hi Nicolin,
> 
> On 07/25/2014 11:24 AM, Nicolin Chen wrote:
> >Hi Varka,
> >
> >    Regarding a point you suggested.
> >
> >On Fri, Jul 25, 2014 at 09:54:43AM +0530, Varka Bhadram wrote:
> >>On 07/25/2014 09:33 AM, Nicolin Chen wrote:
> >>(...)
> >>
> >>>+
> >>>+static const struct platform_device_id fsl_asrc_devtype[] = {
> >>>+	{
> >>>+		.name = "imx35-asrc",
> >>>+		.driver_data = IMX35_ASRC,
> >>>+	}, {
> >>>+		.name = "imx53-asrc",
> >>>+		.driver_data = IMX53_ASRC,
> >>>+	}, {
> >>>+		/* sentinel */
> >>>+	}
> >>>+};
> >>>+MODULE_DEVICE_TABLE(platform, fsl_asrc_devtype);
> >>>+
> >>>+static const struct of_device_id fsl_asrc_ids[] = {
> >>>+	{
> >>>+		.compatible = "fsl,imx35-asrc",
> >>>+		.data = &fsl_asrc_devtype[IMX35_ASRC],
> >>>+	}, {
> >>>+		.compatible = "fsl,imx53-asrc",
> >>>+		.data = &fsl_asrc_devtype[IMX53_ASRC],
> >>>+	}, {
> >>>+		/* sentinel */
> >>>+	}
> >>>+};
> >>>+MODULE_DEVICE_TABLE(of, fsl_asrc_ids);
> >>>+
> >>move these ids after probe/remove... every driver follows same thing...
> >Hmm.. fsl_asrc_ids is called in probe(), so it's probably not a good choice
> >to put them after probe/remove. And actually not every driver does so.
> >For example drivers/i2c/busses/i2c-s3c2410.c
> >
> >I think it should be okay to put here if it contains data.
> 
> You are using these ids in the probe .Tt should be above the probe() so
> we can see of_match_device() directly...
> and also one more thing that the interrupt handler also would be immediately
> above the probe()
> 
> ex:
> static irqreturn_t fsl_asrc_isr(int irq, void *dev_id)
> {
> ...
> }
> 
> device ids..
> 
> your_probe()
> {
> ...
> }
> 
> your_remove()
> {
> ...
> }
> 
> Now every driver that is coming following this style...

I see....

Will follow this style.

Thank you!
Nicolin

---
> 
> If your not using device ids in probe then it would be like
> 
> static irqreturn_t fsl_asrc_isr(int irq, void *dev_id)
> {
> ...
> }
> 
> your_probe()
> {
> ...
> }
> 
> your_remove()
> {
> ...
> }
> 
> device ids..
> 
> Thanks...
> 
> -- 
> Regards,
> Varka Bhadram.
> 
