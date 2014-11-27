Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaK0GWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:22:18 -0500
Received: from mail-bl2on0116.outbound.protection.outlook.com ([65.55.169.116]:43008
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751050AbaK0GWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:22:15 -0500
X-Greylist: delayed 10598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Nov 2014 01:22:14 EST
From: Dexuan Cui <decui@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: RE: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Topic: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
 failure
Thread-Index: AQHQCeusxkAQQtZCDUi02ayowqS7U5x0AMSQ
Date: Thu, 27 Nov 2014 06:21:31 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E6402E@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1415768606-28538-1-git-send-email-decui@microsoft.com>
 <20141126235425.GA5313@kroah.com>
In-Reply-To: <20141126235425.GA5313@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(438002)(164054003)(51704005)(189002)(377454003)(199003)(24454002)(13464003)(23726002)(4396001)(84676001)(46406003)(86362001)(92566001)(92726001)(68736004)(69596002)(26826002)(86612001)(97756001)(66066001)(50986999)(54356999)(19580405001)(76176999)(20776003)(64706001)(19580395003)(6806004)(47776003)(44976005)(2656002)(87936001)(97736003)(55846006)(551934003)(33656002)(86146001)(50466002)(120916001)(99396003)(217423001)(77156002)(77096003)(31966008)(16796002)(46102003)(21056001)(110136001)(106116001)(106466001)(81156004)(107046002)(95666004)(62966003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB276;H:mail.microsoft.com;FPR:;SPF:Pass;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB276;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB276;
X-Forefront-PRVS: 040866B734
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB276;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, November 27, 2014 7:54 AM
> To: Dexuan Cui
> Cc: linux-kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com; KY Srinivasan;
> Haiyang Zhang; vkuznets@redhat.com
> Subject: Re: [PATCH] hv: hv_fcopy: drop the obsolete message on transfer
> failure
> 
> On Tue, Nov 11, 2014 at 09:03:26PM -0800, Dexuan Cui wrote:
> > In the case the user-space daemon crashes, hangs or is killed, we
> > need to down the semaphore, otherwise, after the daemon starts next
> > time, the obsolete data in fcopy_transaction.message or
> > fcopy_transaction.fcopy_msg will be used immediately.
> >
> > Cc: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > ---
> >  drivers/hv/hv_fcopy.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> > index 23b2ce2..177122a 100644
> > --- a/drivers/hv/hv_fcopy.c
> > +++ b/drivers/hv/hv_fcopy.c
> > @@ -86,6 +86,15 @@ static void fcopy_work_func(struct work_struct
> *dummy)
> >  	 * process the pending transaction.
> >  	 */
> >  	fcopy_respond_to_host(HV_E_FAIL);
> > +
> > +	/* In the case the user-space daemon crashes, hangs or is killed, we
> > +	 * need to down the semaphore, otherwise, after the daemon starts
> next
> > +	 * time, the obsolete data in fcopy_transaction.message or
> > +	 * fcopy_transaction.fcopy_msg will be used immediately.
> > +	 */
> > +	if (down_trylock(&fcopy_transaction.read_sema))
> > +		pr_debug("FCP: failed to acquire the semaphore\n");
> 
> Why is "FCP:" needed?  pr_debug() should never need any type of prefix.
> 
> Please fix.
> 
> thanks,
> 
> greg k-h

Ok, I'll send a v2 soon.

Thanks,
-- Dexuan
