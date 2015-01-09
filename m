Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbbAIDNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:13:35 -0500
Received: from mail-bn1on0137.outbound.protection.outlook.com ([157.56.110.137]:3072
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752782AbbAIDNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:13:33 -0500
Date: Fri, 9 Jan 2015 09:49:17 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
CC: Baruch Siach <baruch@tkos.co.il>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH RFC] usb: chipidea: add support for usb_phy in generic
 usb2
Message-ID: <20150109014916.GB433@shlinux2>
References: <1f6e0195fcb215d8378db66bdd67900e57b9d290.1420351491.git.baruch@tkos.co.il>
 <54AA2397.5000708@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54AA2397.5000708@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(51704005)(189002)(164054003)(377454003)(199003)(24454002)(77096005)(68736005)(69596002)(19580405001)(2950100001)(21056001)(4396001)(104016003)(84676001)(6806004)(83506001)(23726002)(31966008)(19580395003)(64706001)(47776003)(97756001)(20776003)(87936001)(92566001)(105606002)(62966003)(77156002)(54356999)(97736003)(46102003)(76176999)(50986999)(33656002)(120916001)(50466002)(86362001)(46406003)(107046002)(85426001)(33716001)(81156004)(99396003)(106466001)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0639;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DM2PR0301MB0639;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0639;
X-Forefront-PRVS: 04519BA941
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 02:58:58.4626
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0639
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 11:09:35AM +0530, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Sunday 04 January 2015 11:58 AM, Baruch Siach wrote:
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  drivers/usb/chipidea/ci_hdrc_usb2.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > I'm sending this as RFC as I'm not sure this is the right thing to do. There
> > seems to be a move away from USB specific PHY drivers towards the generic PHY
> > framework (drivers/phy). The trouble is that my PHY is similar to the mxs PHY
> > (phy-mxs-usb.c), and like mxs I need the notify_connect/notify_disconnect
> > callbacks. This functionality is not available is the generic PHY
> > framework. Having support for both 'usb-phy' and 'phy' properties (as dwc3
> > seems to do) is particularly bad, since the distinction between the two is a
> > Linux implementation detail that has nothing to do with hardware description.
> > 
> > So my questions are:
> > 
> >    1. Is there a plan to add notifications support to the generic PHY?
> > 
> >    2. If not, what are my options?
> 
> extcon framework has notification support. I feel your driver should use the
> extcon framework along with phy framework.
> 
> Adding extcon support in the generic PHY framework is something I have not
> thought through in detail.
> 

Hi Kishon & Felipe

This is also my concern, we will not accept the new usb phy driver using
current usb_phy interface any more, how usb phy specific interfaces are
existed at generic phy, any plans?

> > 
> > Thanks,
> > baruch
> > 
> > diff --git a/drivers/usb/chipidea/ci_hdrc_usb2.c b/drivers/usb/chipidea/ci_hdrc_usb2.c
> > index 45844c951788..cc3aeb781a57 100644
> > --- a/drivers/usb/chipidea/ci_hdrc_usb2.c
> > +++ b/drivers/usb/chipidea/ci_hdrc_usb2.c
> > @@ -35,11 +35,16 @@ static int ci_hdrc_usb2_probe(struct platform_device *pdev)
> >  	struct device *dev = &pdev->dev;
> >  	struct ci_hdrc_usb2_priv *priv;
> >  	struct ci_hdrc_platform_data *ci_pdata = dev_get_platdata(dev);
> > +	struct usb_phy *usb_phy;
> >  	int ret;
> >  
> >  	if (!ci_pdata)
> >  		ci_pdata = &ci_default_pdata;
> >  
> > +	usb_phy = devm_usb_get_phy_by_phandle(&pdev->dev, "usb-phy", 0);
> > +	if (!IS_ERR(usb_phy))
> > +		ci_pdata->usb_phy = usb_phy;
> > +
> >  	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> >  	if (!priv)
> >  		return -ENOMEM;
> > 

-- 

Best Regards,
Peter Chen
