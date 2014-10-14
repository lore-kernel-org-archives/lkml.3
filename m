Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbaJNONH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:13:07 -0400
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:14496
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755272AbaJNONF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:13:05 -0400
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
Thread-Index: AQHP55ZRTp/VO8CmfEuTJogFjyVUzJwve/cAgAAPyNCAAAnTgIAAC9dA
Date: Tue, 14 Oct 2014 14:12:02 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540BFF21@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
 <20141014115412.GC4019@localhost.localdomain>
 <CD2CABCB2C0A0D4682C5F8AD840141540BFD41@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141014132551.GB5994@localhost.localdomain>
In-Reply-To: <20141014132551.GB5994@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.173.50.55]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(164054003)(51704005)(24454002)(189002)(199003)(13464003)(377454003)(97756001)(20776003)(66066001)(69596002)(68736004)(107046002)(47776003)(64706001)(77096002)(76482002)(19580395003)(19580405001)(86362001)(50986999)(54356999)(44976005)(50466002)(80022003)(6806004)(106116001)(92566001)(2656002)(86146001)(106466001)(85306004)(99396003)(87936001)(93886004)(85852003)(81156004)(76176999)(86612001)(95666004)(46102003)(84676001)(97736003)(16796002)(31966008)(33656002)(110136001)(26826002)(120916001)(21056001)(92726001)(4396001)(46406003)(1411001)(23726002)(55846006);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB385;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB385;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03648EFF89
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Richard Cochran [mailto:richardcochran@gmail.com]
> Sent: Tuesday, October 14, 2014 9:26 PM
> To: Thomas Shao
> Cc: tglx@linutronix.de; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; KY Srinivasan
> Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
> time sample
> 
> On Tue, Oct 14, 2014 at 01:04:35PM +0000, Thomas Shao wrote:
> > > I really don't see the need for this. We have NTP. If the guests
> > > want to, they may use it. Otherwise, they have a free running clock, just
> like real machines.
> > >
> > Sometimes the user can't setup NTP. For example the guest OS didn't
> > have network connection. And in some cases, they may want the guest
> time sync with host.
> > With the existing hyper-v time source, the system clock will has
> > around 1.5 second time drift per day. If the workload in the host is heavy,
> the number could be larger.
> > So this feature is really useful for some scenarios.
> 
> Any real machine without networking (and without GPS etc) will drift. That is
> just life, tough as it is. Why should we treat these guests any differently than
> real machines?
> 
> Furthermore, without networking you really don't have a compelling need
> for correct absolute time in the first place.

The host machine can be configure with NTP. And in this case, making guest time sync
with host is useful. 

> 
> Thanks,
> Richard
