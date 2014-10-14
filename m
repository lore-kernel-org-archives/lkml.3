Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaJNJiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 05:38:52 -0400
Received: from mail-bn1on0145.outbound.protection.outlook.com ([157.56.110.145]:6182
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752842AbaJNJiv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 05:38:51 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] hyperv: Implement Time Synchronization using host time
 sample
Thread-Topic: [PATCH] hyperv: Implement Time Synchronization using host time
 sample
Thread-Index: AQHP537vQi6RmPj0HkSu1SY/cpLtvJwvM9iAgAARr+CAAAn6gIAABdKQ
Date: Tue, 14 Oct 2014 09:38:32 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540BF92A@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413275026-5645-1-git-send-email-huishao@microsoft.com>
 <20141014073525.GA3189@kroah.com>
 <CD2CABCB2C0A0D4682C5F8AD840141540BF785@HKXPRD3002MB006.064d.mgd.msft.net>
 <alpine.DEB.2.11.1410141113470.5354@nanos>
In-Reply-To: <alpine.DEB.2.11.1410141113470.5354@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(57704003)(13464003)(189002)(24454002)(199003)(51704005)(164054003)(377454003)(99396003)(20776003)(4396001)(86362001)(92726001)(23726002)(92566001)(110136001)(120916001)(76482002)(47776003)(64706001)(33656002)(26826002)(80022003)(46406003)(76176999)(54356999)(31966008)(86612001)(97756001)(16796002)(50986999)(69596002)(97736003)(68736004)(87936001)(106116001)(2656002)(81156004)(106466001)(77096002)(86146001)(84676001)(85306004)(93886004)(55846006)(21056001)(46102003)(85852003)(66066001)(50466002)(19580395003)(6806004)(19580405001)(44976005)(95666004)(107046002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1201;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1201;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03648EFF89
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Tuesday, October 14, 2014 5:14 PM
> To: Thomas Shao
> Cc: Greg KH; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> Subject: RE: [PATCH] hyperv: Implement Time Synchronization using host
> time sample
> 
> On Tue, 14 Oct 2014, Thomas Shao wrote:
> > > -----Original Message-----
> > > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > > Sent: Tuesday, October 14, 2014 3:35 PM
> > > To: Thomas Shao
> > > Cc: tglx@linutronix.de; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com; KY Srinivasan
> > > Subject: Re: [PATCH] hyperv: Implement Time Synchronization using
> > > host time sample
> > >
> > > On Tue, Oct 14, 2014 at 01:23:46AM -0700, Thomas Shao wrote:
> > > > --- a/kernel/time/timekeeping.c
> > > > +++ b/kernel/time/timekeeping.c
> > > > @@ -1786,6 +1786,7 @@ int do_adjtimex(struct timex *txc)
> > > >
> > > >  	return ret;
> > > >  }
> > > > +EXPORT_SYMBOL(do_adjtimex);
> > >
> > > EXPORT_SYMBOL_GPL()?
> >
> > Oh, yes,  I should use EXPORT_SYMBOL_GPL. I'll send a new patch. Thanks
> Greg.
> 
> And please make that export a separate patch.
> 
OK. I'll send the separate patch. For my original patch, do I need to wait? Since it depends on the 
Export patch to build.

> Thanks,
> 
> 	tglx
