Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaILAGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 20:06:00 -0400
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:19744
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751120AbaILAF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 20:05:58 -0400
X-Greylist: delayed 81825 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 20:05:57 EDT
From: Peter Chen <Peter.Chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Topic: [PATCH v4 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Index: AQHPx0uAsMVpf/rFTEKtVSbBVZb2Ypv7sPGAgABrVYCAAI7ywA==
Date: Fri, 12 Sep 2014 00:05:55 +0000
Message-ID: <600c4437f5d14520931aabc242fd69f4@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1409730511-16101-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409730511-16101-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140911010709.GE3609@peterchendt> <20140911153119.GA11275@kwain>
In-Reply-To: <20140911153119.GA11275@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0332AACBC3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(199003)(51704005)(74502001)(76482001)(87936001)(108616004)(83072002)(92566001)(93886004)(77982001)(85306004)(90102001)(74662001)(99396002)(79102001)(46102001)(86362001)(97736003)(50986999)(85852003)(77096002)(31966008)(74316001)(4396001)(54356999)(76176999)(76576001)(101416001)(105586002)(106356001)(110136001)(2656002)(106116001)(83322001)(80022001)(33646002)(20776003)(21056001)(99286002)(81542001)(107046002)(64706001)(81342001)(66066001)(95666004)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0771;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
> On Thu, Sep 11, 2014 at 09:07:10AM +0800, Peter Chen wrote:
> > On Wed, Sep 03, 2014 at 09:48:26AM +0200, Antoine Tenart wrote:
> > > +
> > > +static int ci_hdrc_usb2_dt_probe(struct device *dev,
> > > +				 struct ci_hdrc_platform_data *ci_pdata) {
> > > +	ci_pdata->phy = of_phy_get(dev->of_node, 0);
> > > +	if (IS_ERR(ci_pdata->phy)) {
> > > +		if (PTR_ERR(ci_pdata->phy) == -EPROBE_DEFER)
> > > +			return -EPROBE_DEFER;
> > > +
> > > +		/* PHY is optional */
> > > +		ci_pdata->phy = NULL;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> >
> > You may also need to consider usb_phy case.
> 
> Don't we try using the generic PHY framework for new drivers?
> 
> Since there is no need for supporting an usb_phy case I don't think we have to
> consider this case yet. And no doing so could encourage people to add PHY
> drivers to the common PHY framework.
> 

If the common PHY framework is the only right way in future, you don't
need to change it.

> > > +
> > > +	if (dev->of_node) {
> > > +		ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
> > > +		if (ret)
> > > +			return ret;
> > > +	} else {
> > > +		ret = dma_set_mask_and_coherent(&pdev->dev,
> DMA_BIT_MASK(32));
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> >
> > You may need to do clk_disable_unprepare for above error cases.
> 
> Sure, I'll fix that.
> 
> > > +
> > > +	ci_pdata->name = dev_name(&pdev->dev);
> > > +
> > > +	priv->ci_pdev = ci_hdrc_add_device(dev, pdev->resource,
> > > +					   pdev->num_resources, ci_pdata);
> > > +	if (IS_ERR(priv->ci_pdev)) {
> > > +		ret = PTR_ERR(priv->ci_pdev);
> > > +		if (ret != -EPROBE_DEFER)
> > > +			dev_err(dev,
> > > +				"failed to register ci_hdrc platform
> device: %d\n",
> > > +				ret);
> >
> > Why you don't want the error message for deferral probe?
> 
> A driver can return an EPROBE_DEFER error and still probe successfully later.
> This would be confusing to have this kind of error message in this case. And
> when a driver returns -EPROBE_DEFER, there is an error message already.
> 

OK, agree.

Peter
