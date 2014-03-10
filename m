Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaCJCLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 22:11:46 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:31714
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752615AbaCJCLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 22:11:45 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] drm/fb-helper: Do the mode_set.connectors ZERO_SIZE_PTR
 check
Thread-Topic: [PATCH] drm/fb-helper: Do the mode_set.connectors
 ZERO_SIZE_PTR check
Thread-Index: AQHPORIV9M3coFbSQ0Gt4I24w8DqR5rVTGyAgARNETA=
Date: Mon, 10 Mar 2014 02:11:43 +0000
Message-ID: <a44f7334f3104f57bec084d300283933@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1394087661-24504-1-git-send-email-Li.Xiubo@freescale.com>
 <87bnxi2z06.fsf@intel.com>
In-Reply-To: <87bnxi2z06.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 014617085B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(24454002)(51704005)(80022001)(63696002)(66066001)(65816001)(95666003)(74316001)(74366001)(92566001)(31966008)(94946001)(93516002)(46102001)(94316002)(85306002)(74662001)(74502001)(87266001)(15975445006)(15202345003)(59766001)(81686001)(47976001)(50986001)(93136001)(97336001)(19580395003)(4396001)(86362001)(97186001)(47736001)(49866001)(2201001)(19580405001)(90146001)(95416001)(83322001)(76482001)(54316002)(79102001)(53806001)(51856001)(87936001)(76786001)(33646001)(77982001)(74876001)(81342001)(76576001)(76796001)(74706001)(80976001)(69226001)(56776001)(56816005)(85852003)(54356001)(83072002)(81816001)(81542001)(2656002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB428;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:BFD67A88.10D2D518.A1D521CF.8CE48AC2.2022C;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject: Re: [PATCH] drm/fb-helper: Do the mode_set.connectors ZERO_SIZE_PTR
> check
> 
> On Thu, 06 Mar 2014, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> > Since we cannot make sure the 'max_conn_count' will always be none
> > zero from the users, and then if max_conn_count equals to zero, the
> > kcalloc() will return ZERO_SIZE_PTR, which equals to ((void *)16).
> >
> > So this patch fix this via doing the zero pionter check of it.
> 
> Please just add a check for max_conn_count == 0 up front and handle it.
> 
> BR,
> Jani.
> 

Yes, that's one better choice.
See the next version please.

Thanks very much!

--
Best Regards,
Xiubo 

> 
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  drivers/gpu/drm/drm_fb_helper.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/drm_fb_helper.c
> b/drivers/gpu/drm/drm_fb_helper.c
> > index 3d13ca6e2..c6680ef 100644
> > --- a/drivers/gpu/drm/drm_fb_helper.c
> > +++ b/drivers/gpu/drm/drm_fb_helper.c
> > @@ -536,7 +536,7 @@ int drm_fb_helper_init(struct drm_device *dev,
> >  				sizeof(struct drm_connector *),
> >  				GFP_KERNEL);
> >
> > -		if (!fb_helper->crtc_info[i].mode_set.connectors)
> > +		if (ZERO_OR_NULL_PTR(fb_helper->crtc_info[i].mode_set.connectors))
> >  			goto out_free;
> >  		fb_helper->crtc_info[i].mode_set.num_connectors = 0;
> >  	}
> > --
> > 1.8.4
> >
> >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
> --
> Jani Nikula, Intel Open Source Technology Center
> 

