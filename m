Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbbA0TNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:13:24 -0500
Received: from mail-bl2on0088.outbound.protection.outlook.com ([65.55.169.88]:19776
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758210AbbA0TNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:13:21 -0500
Date: Tue, 27 Jan 2015 11:13:08 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Felipe Balbi <balbi@ti.com>
CC: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>, <devicetree@vger.kernel.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Ola Jeppson <ola@adapteva.com>,
        <linux-gpio@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: phy-generic: Don't fail on missing gpio reset
References: <1422323129-20969-1-git-send-email-soren.brinkmann@xilinx.com>
 <20150127152047.GA13776@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150127152047.GA13776@saruman.tx.rr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21288.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <19e48726b36942cfb0430fc625b41e1b@BY2FFO11FD043.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; vger.kernel.org; dkim=none (message
 not signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(164054003)(51704005)(24454002)(377424004)(47776003)(106466001)(2950100001)(87936001)(77156002)(85182001)(76176999)(110136001)(50986999)(54356999)(104016003)(85202003)(92726002)(6806004)(46102003)(19580405001)(19580395003)(575784001)(50466002)(108616004)(86362001)(62966003)(23676002)(53416004)(92566002)(74316001)(83506001)(41533002)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB053;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB053;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB053;
X-Forefront-PRVS: 046985391D
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB053;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 19:13:18.3572
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB053
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 09:20AM -0600, Felipe Balbi wrote:
> On Mon, Jan 26, 2015 at 05:45:29PM -0800, Soren Brinkmann wrote:
> > A reset through a GPIO is optional. Don't fail probing when it is
> > missing.
> > 
> > Reported-by: Andreas Färber <afaerber@suse.de>
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > Hi Andreas,
> > 
> > does this do the trick?
> > 
> > 	Thanks,
> > 	Sören
> > 
> >  drivers/usb/phy/phy-generic.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
> > index dd05254241fb..a73d4c738f0b 100644
> > --- a/drivers/usb/phy/phy-generic.c
> > +++ b/drivers/usb/phy/phy-generic.c
> > @@ -241,10 +241,8 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop,
> >  
> >  	if (err == -EPROBE_DEFER)
> >  		return -EPROBE_DEFER;
> > -	if (err) {
> > -		dev_err(dev, "Error requesting RESET GPIO\n");
> > -		return err;
> > -	}
> > +	if (err)
> > +		nop->gpiod_reset = NULL;
> 
> there's a better patch to use gpiod_get_optional(), instead.

Great, apparently that wasn't in linux-next yesterday. I'll give it a
shot once it arrives there.

	Sören
