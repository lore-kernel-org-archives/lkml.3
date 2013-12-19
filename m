Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab3LSWSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 17:18:07 -0500
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:51686
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755386Ab3LSWSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 17:18:05 -0500
Message-ID: <1387491465.3140.159.camel@snotra.buserror.net>
Subject: Re: [REPOST][PATCH 2/2] driver core: platform: allow platform
 drivers to bind to any device
From: Scott Wood <scottwood@freescale.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Kim Phillips <kim.phillips@linaro.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <R65777@freescale.com>, <B07421@freescale.com>,
        <B08248@freescale.com>, <christoffer.dall@linaro.org>,
        <alex.williamson@redhat.com>, <a.motakis@virtualopensystems.com>,
        <agraf@suse.de>, <B16395@freescale.com>
Date: Thu, 19 Dec 2013 16:17:45 -0600
In-Reply-To: <20131219204452.GA13301@kroah.com>
References: <20131203123454.3ab18749ed0d0d943b10df9a@linaro.org>
	 <20131219010340.GA23055@kroah.com>
	 <1387484961.3140.141.camel@snotra.buserror.net>
	 <20131219204452.GA13301@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BN1PR04CA004.namprd04.prod.outlook.com (10.255.197.14) To
 BL2PR03MB387.namprd03.prod.outlook.com (10.141.91.152)
X-Forefront-PRVS: 006546F32A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(199002)(189002)(51704005)(377424004)(24454002)(33646001)(74876001)(50986001)(77156001)(46102001)(74706001)(50466002)(49866001)(50226001)(47736001)(47976001)(74366001)(76482001)(23676002)(51856001)(77096001)(53806001)(42186004)(81542001)(63696002)(81342001)(47776003)(88136002)(79102001)(54316002)(83322001)(65816001)(80976001)(80022001)(81816001)(87286001)(81686001)(87266001)(31966008)(74502001)(47446002)(85306002)(74662001)(4396001)(89996001)(85852003)(62966002)(59766001)(87976001)(77982001)(76796001)(76786001)(69226001)(90146001)(83072002)(56776001)(56816005)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB387;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 12:44 -0800, Greg Kroah-Hartman wrote:
> On Thu, Dec 19, 2013 at 02:29:21PM -0600, Scott Wood wrote:
> > On Wed, 2013-12-18 at 17:03 -0800, Greg Kroah-Hartman wrote:
> > > On Tue, Dec 03, 2013 at 12:34:54PM +0000, Kim Phillips wrote:
> > > > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > > > index 3a94b79..78a5b62 100644
> > > > --- a/drivers/base/platform.c
> > > > +++ b/drivers/base/platform.c
> > > > @@ -736,6 +736,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
> > > >  	struct platform_device *pdev = to_platform_device(dev);
> > > >  	struct platform_driver *pdrv = to_platform_driver(drv);
> > > >  
> > > > +	/* the driver matches any device */
> > > > +	if (pdrv->match_any_dev)
> > > > +		return 1;
> > > 
> > > This breaks userspace in that it will never know to load the module that
> > > can "bind to anything".
> > > 
> > > You need a way to encode this in the platform device id that can be a
> > > wildcard type of thing, so that userspace can know about this.
> > 
> > How is userspace broken?  vfio platform is a new thing; there's nothing
> > existing to break.  I don't see how automatic module loading makes sense
> > for it.  Whether the module needs to be loaded depends on the user's
> > intentions, not based on what hardware you have.
> 
> As your driver is saying it can "match any device", you need to tell
> userspace that, which you aren't doing here.

Userspace either knows how to set up VFIO platform devices, in which
case it knows what to do, or it doesn't, in which case why would we want
the module loaded?

> That's what the ids that are exported to userspace do, please add some for platform devices to
> allow this to work properly, like almost all other busses have.

This isn't about platform devices versus "almost all other buses", it's
about VFIO being fundamentally different from normal drivers.

-Scott


