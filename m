Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbaGYGHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:07:36 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:39877
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752292AbaGYGHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:07:35 -0400
Date: Fri, 25 Jul 2014 13:54:48 +0800
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
Message-ID: <20140725055447.GC29136@MrMyself>
References: <cover.1406259578.git.nicoleotsuka@gmail.com>
 <f4ff79269a1680f9ce128e0e98fea926d3a41834.1406259578.git.nicoleotsuka@gmail.com>
 <53D1DC0B.1000905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53D1DC0B.1000905@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(189002)(199002)(24454002)(377454003)(479174003)(26826002)(31966008)(50466002)(106466001)(46102001)(81342001)(84676001)(92566001)(110136001)(99396002)(64706001)(76176999)(85306003)(105606002)(50986999)(46406003)(97736001)(107046002)(44976005)(102836001)(92726001)(1411001)(83072002)(95666004)(21056001)(97756001)(80022001)(47776003)(87936001)(86362001)(54356999)(6806004)(79102001)(33656002)(83322001)(4396001)(74502001)(74662001)(83506001)(76482001)(85852003)(77982001)(23726002)(81542001)(33716001)(68736004)(20776003)(104016003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB442;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka,

   Regarding a point you suggested.

On Fri, Jul 25, 2014 at 09:54:43AM +0530, Varka Bhadram wrote:
> On 07/25/2014 09:33 AM, Nicolin Chen wrote:
> (...)
> 
> >+
> >+static const struct platform_device_id fsl_asrc_devtype[] = {
> >+	{
> >+		.name = "imx35-asrc",
> >+		.driver_data = IMX35_ASRC,
> >+	}, {
> >+		.name = "imx53-asrc",
> >+		.driver_data = IMX53_ASRC,
> >+	}, {
> >+		/* sentinel */
> >+	}
> >+};
> >+MODULE_DEVICE_TABLE(platform, fsl_asrc_devtype);
> >+
> >+static const struct of_device_id fsl_asrc_ids[] = {
> >+	{
> >+		.compatible = "fsl,imx35-asrc",
> >+		.data = &fsl_asrc_devtype[IMX35_ASRC],
> >+	}, {
> >+		.compatible = "fsl,imx53-asrc",
> >+		.data = &fsl_asrc_devtype[IMX53_ASRC],
> >+	}, {
> >+		/* sentinel */
> >+	}
> >+};
> >+MODULE_DEVICE_TABLE(of, fsl_asrc_ids);
> >+
> 
> move these ids after probe/remove... every driver follows same thing...

Hmm.. fsl_asrc_ids is called in probe(), so it's probably not a good choice
to put them after probe/remove. And actually not every driver does so.
For example drivers/i2c/busses/i2c-s3c2410.c

I think it should be okay to put here if it contains data.

Thank you,
Nicolin
