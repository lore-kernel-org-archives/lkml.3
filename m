Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaLYDjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 22:39:45 -0500
Received: from mail-by2on0138.outbound.protection.outlook.com ([207.46.100.138]:37208
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751637AbaLYDjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 22:39:43 -0500
Date: Thu, 25 Dec 2014 10:30:46 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: Sanchayan Maity <maitysanchayan@gmail.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] usb: chipidea: Add chipidea revision information
Message-ID: <20141225023044.GC5077@shlinux2>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
 <1da552d2284380f8606bd16d1d3c0cf51caa60ff.1418981438.git.maitysanchayan@gmail.com>
 <e7c92089fe1938c9f7f97bde12c6d8bc@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e7c92089fe1938c9f7f97bde12c6d8bc@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(51704005)(377424004)(199003)(189002)(24454002)(83506001)(6806004)(46102003)(33716001)(85426001)(120916001)(64706001)(33656002)(110136001)(19580395003)(19580405001)(76176999)(46406003)(50986999)(97756001)(54356999)(69596002)(104016003)(97736003)(84676001)(86362001)(20776003)(47776003)(23726002)(4396001)(87936001)(31966008)(21056001)(62966003)(105606002)(77156002)(2950100001)(99396003)(50466002)(77096005)(106466001)(68736005)(81156004)(107046002)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0637;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0637;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0637;
X-Forefront-PRVS: 04362AC73B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0637;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2014 03:39:38.4507
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0637
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 05:22:44PM +0100, Stefan Agner wrote:
> On 2014-12-19 10:55, Sanchayan Maity wrote:
> > Define ci_get_revision API to know the controller revision
> > information according to chipidea 1.1a, 2.0a, 2.4 and 2.5a
> > spec. Besides, add one entry in struct ci_hdrc to indicate
> > revision information. This can be used for adding different
> > code for revisions, implementing erratas.
> > 
> > Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
> > ---
> >  drivers/usb/chipidea/bits.h |   10 ++++++++++
> >  drivers/usb/chipidea/core.c |   23 +++++++++++++++++++++--
> >  2 files changed, 31 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/usb/chipidea/bits.h b/drivers/usb/chipidea/bits.h
> > index ca57e3d..e935ccc 100644
> > --- a/drivers/usb/chipidea/bits.h
> > +++ b/drivers/usb/chipidea/bits.h
> > @@ -15,6 +15,16 @@
> >  
> >  #include <linux/usb/ehci_def.h>
> >  
> > +/*
> > + * ID
> > + * For 1.x revision, bit24 - bit31 are reserved
> > + * For 2.x revision, bit25 - bit28 are 0x2
> > + */
> > +#define TAG			(0x1F << 16)
> > +#define REVISION		(0xF << 21)
> > +#define VERSION			(0xF << 25)
> > +#define CIVERSION		(0x7 << 29)
> > +
> 
> Hm, the other defines use spaces in this file, I like tabs more too, but
> I guess uniformity wins here.. Peter?

I will change to use spaces.

> 
> >  /* HCCPARAMS */
> >  #define HCCPARAMS_LEN         BIT(17)
> >  
> > diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> > index 9bdc6bd..33a8c4a 100644
> > --- a/drivers/usb/chipidea/core.c
> > +++ b/drivers/usb/chipidea/core.c
> > @@ -136,6 +136,22 @@ static int hw_alloc_regmap(struct ci_hdrc *ci, bool is_lpm)
> >  	return 0;
> >  }
> >  
> > +static enum CI_REVISION ci_get_revision(struct ci_hdrc *ci)
> > +{
> > +	int ver = hw_read_id_reg(ci, ID_ID, VERSION) >> __ffs(VERSION);
> > +	enum CI_REVISION rev = CI_REVISION_UNKNOWN;
> > +
> > +	if (ver == 0x2) {
> > +		int rev_reg = hw_read_id_reg
> > +			(ci, ID_ID, REVISION) >> __ffs(REVISION);
> 
> This line break is somewhat awkward, doesn't help for good readability.
> 

But it exceeds 80 characters, maybe I change like below:

 		rev += hw_read_id_reg(ci, ID_ID, REVISION)
	       		>> __ffs(REVISION);
> Is the local integer variable necessary at all? Enums are arithmetic
> types, so afaik this should be fine too:
> 		rev = CI_REVISION_20;
> 		rev += hw_read_id_reg(ci, ID_ID, REVISION) >> __ffs(REVISION);

Will change, thanks.

-- 

Best Regards,
Peter Chen
