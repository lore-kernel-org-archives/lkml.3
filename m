Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaC0CNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:13:53 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:2010
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752432AbaC0CNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:13:52 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Topic: [PATCH] ASoC: fsl_sai: Add isr to deal with error flag
Thread-Index: AQHPSOk07qbuL0Yc9E6K9N8Cg7O135r0MFsA
Date: Thu, 27 Mar 2014 02:13:48 +0000
Message-ID: <11a8271c31044515bd2657a93aefdaec@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
In-Reply-To: <1395834517-16426-1-git-send-email-Guangyu.Chen@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.212]
x-forefront-prvs: 01630974C0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(164054003)(199002)(189002)(85852003)(4396001)(81342001)(92566001)(76576001)(98676001)(56816005)(90146001)(50986001)(49866001)(74502001)(47446002)(80976001)(83072002)(47736001)(47976001)(97336001)(81542001)(33646001)(80022001)(95416001)(87266001)(87936001)(20776003)(65816001)(85306002)(2656002)(95666003)(79102001)(54356001)(97186001)(93516002)(46102001)(86362001)(94316002)(54316002)(56776001)(59766001)(77982001)(53806001)(74706001)(74366001)(74876001)(93136001)(31966008)(74662001)(69226001)(76796001)(74316001)(81816001)(94946001)(63696002)(81686001)(76482001)(76786001)(66066001)(83322001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB444;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:8222C6BE.6BF2B5BF.F46915F8.90FAE473.20106;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	regmap_read(sai->regmap, FSL_SAI_TCSR, &xcsr);
> +	regmap_write(sai->regmap, FSL_SAI_TCSR, xcsr);
> +
> +	if (xcsr & FSL_SAI_CSR_WSF)
> +		dev_dbg(dev, "isr: Start of Tx word detected\n");
> +
> +	if (xcsr & FSL_SAI_CSR_SEF)
> +		dev_dbg(dev, "isr: Tx Frame sync error detected\n");
> +
> +	if (xcsr & FSL_SAI_CSR_FEF)
> +		dev_dbg(dev, "isr: Transmit underrun detected\n");
> +

Actually, the above three isrs should to write a logic 1 to this field
to clear this flag.


> +	if (xcsr & FSL_SAI_CSR_FWF)
> +		dev_dbg(dev, "isr: Enabled transmit FIFO is empty\n");
> +
> +	if (xcsr & FSL_SAI_CSR_FRF)
> +		dev_dbg(dev, "isr: Transmit FIFO watermark has been reached\n");
> +

While are these ones really needed to clear manually ?


Thanks,
--

Best Regards,
Xiubo

