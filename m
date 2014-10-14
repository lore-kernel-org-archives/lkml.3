Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbaJNOIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:08:31 -0400
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:39847
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932176AbaJNOIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:08:30 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Thread-Topic: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Thread-Index: AQHP55ZRTp/VO8CmfEuTJogFjyVUzJwve/cAgAAPyNCAAAgTgIAAC/vA
Date: Tue, 14 Oct 2014 14:08:06 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540BFEEF@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014115412.GC4019@localhost.localdomain>
 <CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141014131935.GA5994@localhost.localdomain>
In-Reply-To: <20141014131935.GA5994@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.173.50.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(13464003)(51704005)(24454002)(377454003)(189002)(199003)(164054003)(54356999)(76176999)(86612001)(80022003)(92726001)(46406003)(120916001)(86146001)(20776003)(87936001)(2656002)(33656002)(85852003)(4396001)(97736003)(64706001)(66066001)(76482002)(110136001)(99396003)(81156004)(46102003)(26826002)(107046002)(50986999)(92566001)(106116001)(19580405001)(19580395003)(44976005)(6806004)(50466002)(68736004)(106466001)(23726002)(21056001)(69596002)(84676001)(77096002)(93886004)(85306004)(1411001)(86362001)(47776003)(97756001)(95666004)(31966008)(55846006)(16796002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1214;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
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
> From: Richard Cochran [mailto:richardcochran@gmail.com]
> Sent: Tuesday, October 14, 2014 9:20 PM
> To: Thomas Shao
> Cc: tglx@linutronix.de; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
> time sample
> 
> On Tue, Oct 14, 2014 at 01:04:35PM +0000, Thomas Shao wrote:
> > > > +		/*
> > > > +		* Use the Hyper-V time sample to adjust the guest time. The
> > > > +		* algorithm is: If the sample offsets exceeds 1 second, we
> > > > +		* directly set the clock to the server time. If the offset is
> > >
> > > So the guests will experience random time jumps in the kernel,
> > > without any rhyme or reason?
> >
> > This behavior is designed for some extreme cases. Like manually
> > setting guest time to some value. Or the host resumes from a hibernate
> > state. Normally, we should not run into this.
> 
> But when it *does* happen, the guest software will have no way of knowing
> what happened. That stinks.
> 
> Taking your example, when the guest sets its time, the time will suddenly
> jump somewhere else, and for no apparent reason.
> 
> From the guest's point of view, this is really not acceptable.
> 

If the user chooses  to sync guest time with host, that's the expected behavior, right?

> Thanks,
> Richard
