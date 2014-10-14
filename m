Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaJNIk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:40:28 -0400
Received: from mail-bl2on0131.outbound.protection.outlook.com ([65.55.169.131]:52911
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932075AbaJNIkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:40:11 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
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
Thread-Index: AQHP537vQi6RmPj0HkSu1SY/cpLtvJwvM9iAgAARr+A=
Date: Tue, 14 Oct 2014 08:39:46 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540BF785@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413275026-5645-1-git-send-email-huishao@microsoft.com>
 <20141014073525.GA3189@kroah.com>
In-Reply-To: <20141014073525.GA3189@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(51704005)(24454002)(377454003)(13464003)(189002)(199003)(50466002)(86362001)(81156004)(92726001)(19580395003)(44976005)(92566001)(6806004)(106466001)(84676001)(21056001)(19580405001)(23726002)(69596002)(68736004)(26826002)(33656002)(46406003)(86612001)(77096002)(55846006)(76482002)(85852003)(86146001)(2656002)(80022003)(120916001)(46102003)(87936001)(16796002)(31966008)(110136001)(85306004)(97756001)(76176999)(54356999)(50986999)(97736003)(4396001)(106116001)(107046002)(95666004)(99396003)(64706001)(20776003)(47776003)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1216;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1216;
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
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, October 14, 2014 3:35 PM
> To: Thomas Shao
> Cc: tglx@linutronix.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan
> Subject: Re: [PATCH] hyperv: Implement Time Synchronization using host
> time sample
> 
> On Tue, Oct 14, 2014 at 01:23:46AM -0700, Thomas Shao wrote:
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -1786,6 +1786,7 @@ int do_adjtimex(struct timex *txc)
> >
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL(do_adjtimex);
> 
> EXPORT_SYMBOL_GPL()?

Oh, yes,  I should use EXPORT_SYMBOL_GPL. I'll send a new patch. Thanks Greg.
