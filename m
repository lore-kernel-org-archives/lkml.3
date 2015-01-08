Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbbAHH3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 02:29:24 -0500
Received: from mail-by2on0065.outbound.protection.outlook.com ([207.46.100.65]:62000
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750886AbbAHH3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 02:29:22 -0500
X-Greylist: delayed 863 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 02:29:21 EST
From: "Wu, Aaron" <Aaron.Wu@analog.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] bfin_can: rewrite the blackfin CAN driver into arch
 independent style
Thread-Topic: [PATCH] bfin_can: rewrite the blackfin CAN driver into arch
 independent style
Thread-Index: AQHQHyrz+KLR1lu+50+QguQeoH97TZy1JBKAgADA2IA=
Date: Thu, 8 Jan 2015 07:13:53 +0000
Message-ID: <649EF91064D35D40B9C93A225BF41674612E3EDD@NWD2MBX7.ad.analog.com>
References: <1419391828-21105-1-git-send-email-Aaron.wu@analog.com>
 <54AD4461.1040203@pengutronix.de>
In-Reply-To: <54AD4461.1040203@pengutronix.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.26.212]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 137.71.25.55)
 smtp.mailfrom=Aaron.Wu@analog.com; 
X-Forefront-Antispam-Report: CIP:137.71.25.55;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(13464003)(51704005)(199003)(189002)(377454003)(479174004)(24454002)(16601075003)(99396003)(46102003)(50986999)(2201001)(120916001)(33656002)(23676002)(2920100001)(2950100001)(106116001)(2900100001)(76176999)(20776003)(64706001)(107886001)(50466002)(107046002)(106466001)(86362001)(31966008)(16796002)(87936001)(92566001)(2656002)(2501002)(15975445007)(19580405001)(19580395003)(6806004)(55846006)(47776003)(21056001)(54356999)(77156002)(4396001)(62966003)(102836002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB0861;H:nwd2mta1.analog.com;FPR:;SPF:Pass;MLV:sfv;PTR:nwd2mail10.analog.com;A:1;MX:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DM2PR0301MB0861;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0861;
X-Forefront-PRVS: 0450A714CB
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0861;
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2015 07:14:55.6213
 (UTC)
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t087TWHc029064

Hi Marc

Thanks for your comments. I've split it into two parts and submit patches of V2.
Do you mind if I fix potential bugs with future patches? 

Regards
Aaron

> -----Original Message-----
> From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
> Sent: 2015å¹´1æœˆ7æ—¥ 22:36
> To: Wu, Aaron; adi-buildroot-devel@lists.sourceforge.net;
> wg@grandegger.com; linux-can@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] bfin_can: rewrite the blackfin CAN driver into arch
> independent style
> 
> On 12/24/2014 04:30 AM, Aaron Wu wrote:
> > Rewrite the blackfin CAN driver into arch independent style
> >
> > Signed-off-by: Aaron Wu <Aaron.wu@analog.com>
> 
> [...]
> 
> > @@ -547,6 +543,11 @@ static int bfin_can_probe(struct platform_device
> *pdev)
> >  	}
> >
> >  	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (res_mem == NULL) {
> > +		dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
> > +		return -ENOENT;
> > +	}
> > +
> >  	rx_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >  	tx_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
> >  	err_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 2); @@ -
> 555,12
> > +556,6 @@ static int bfin_can_probe(struct platform_device *pdev)
> >  		goto exit;
> >  	}
> >
> > -	if (!request_mem_region(res_mem->start, resource_size(res_mem),
> > -				dev_name(&pdev->dev))) {
> > -		err = -EBUSY;
> > -		goto exit;
> > -	}
> 
> You should remove the corresponding release_mem_region() from the
> remove() function, too.
> 
> > -
> >  	/* request peripheral pins */
> >  	err = peripheral_request_list(pdata, dev_name(&pdev->dev));
> >  	if (err)
> > @@ -573,7 +568,13 @@ static int bfin_can_probe(struct platform_device
> *pdev)
> >  	}
> >
> >  	priv = netdev_priv(dev);
> > -	priv->membase = (void __iomem *)res_mem->start;
> > +
> > +	priv->membase = devm_ioremap_resource(&pdev->dev, res_mem);
> > +	if (IS_ERR((void *)priv->membase)) {
> > +		dev_err(&pdev->dev, "Cannot map IO\n");
> > +		return PTR_ERR((void *)priv->membase);
> 
> Is this cast still needed?
> 
> Can you move the devm_ conversion into a separate patch?
> 
> Marc
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
