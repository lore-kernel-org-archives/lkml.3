Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaCUFLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 01:11:46 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:8362
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750987AbaCUFLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 01:11:44 -0400
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] USB: Gadget: fsl driver pullup fix
Thread-Topic: [PATCH v2] USB: Gadget: fsl driver pullup fix
Thread-Index: AQHPREywH86woTwtqECkodyrB5sINJrqI0MAgADb4qA=
Date: Fri, 21 Mar 2014 05:11:41 +0000
Message-ID: <e0bac17b63014214aaab07750d1b9cc2@BN1PR03MB251.namprd03.prod.outlook.com>
References: <1395347238-22518-1-git-send-email-suresh.gupta@freescale.com>
 <20140320160328.GB18120@kroah.com>
In-Reply-To: <20140320160328.GB18120@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(377454003)(189002)(199002)(51704005)(13464003)(77096001)(76796001)(76786001)(76576001)(46102001)(94316002)(51856001)(74876001)(66066001)(80022001)(65816001)(79102001)(77982001)(59766001)(81342001)(94946001)(74706001)(85306002)(63696002)(20776003)(95416001)(69226001)(54316002)(56776001)(93516002)(54356001)(33646001)(53806001)(81542001)(86362001)(92566001)(83072002)(85852003)(49866001)(47736001)(81686001)(74366001)(4396001)(81816001)(93136001)(47976001)(50986001)(56816005)(2656002)(76482001)(97186001)(97336001)(90146001)(87266001)(95666003)(87936001)(80976001)(74316001)(19580395003)(19580405001)(83322001)(74662001)(74502001)(47446002)(31966008)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB252;H:BN1PR03MB251.namprd03.prod.outlook.com;FPR:68387966.A6379FE6.B1F539E5.C1E2FAF9.2024C;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, March 20, 2014 9:33 PM
> To: Gupta Suresh-B42813
> Cc: balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] USB: Gadget: fsl driver pullup fix
> 
> On Fri, Mar 21, 2014 at 01:57:18AM +0530, Suresh Gupta wrote:
> > This fix the fsl usb gadget driver in a way that the usb device will
> > be only "pulled up" on requests only when vbus is powered
> >
> > Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
> > ---
> > Changes from previous version:
> > * Removed re-factored code, Will send another patch for re-factoring
> >   duplicated code
> > * Changed Description
> >
> >  drivers/usb/gadget/fsl_udc_core.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/usb/gadget/fsl_udc_core.c
> > b/drivers/usb/gadget/fsl_udc_core.c
> > index 35cb972..49d66779 100644
> > --- a/drivers/usb/gadget/fsl_udc_core.c
> > +++ b/drivers/usb/gadget/fsl_udc_core.c
> > @@ -1219,6 +1219,10 @@ static int fsl_pullup(struct usb_gadget *gadget,
> int is_on)
> >  	struct fsl_udc *udc;
> >
> >  	udc = container_of(gadget, struct fsl_udc, gadget);
> > +
> > +	if(!udc->vbus_active)
> > +		return -EOPNOTSUPP;
> 
> Always run your patches through scripts/checkpatch.pl so they don't get
> rejected for silly things like the wrong coding style...
> 
Accepted, Sorry for such a inane mistake 
