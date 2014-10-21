Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaJUJRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:17:18 -0400
Received: from mail-bl2on0143.outbound.protection.outlook.com ([65.55.169.143]:50640
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751597AbaJUJRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:17:16 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Richard Cochran <richardcochran@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <rcochran@linutronix.de>
Subject: RE: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
Thread-Topic: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
 do_adjtimex()
Thread-Index: AQHP6EpL5oa00nhAzECMXNpwI49m+pw5VpSAgAADkACAAIUwkIAAXgGAgAANqWA=
Date: Tue, 21 Oct 2014 09:16:29 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540D31FC@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
 <alpine.DEB.2.11.1410202027220.5308@nanos>
 <alpine.DEB.2.11.1410202034150.5308@nanos>
 <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141021081355.GA6808@netboy>
In-Reply-To: <20141021081355.GA6808@netboy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.94.22.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(199003)(51704005)(24454002)(13464003)(41574002)(189002)(377454003)(164054003)(110136001)(97736003)(21056001)(46406003)(54356999)(76176999)(6806004)(50986999)(85852003)(50466002)(93886004)(31966008)(26826002)(16796002)(87936001)(80022003)(46102003)(97756001)(69596002)(86612001)(92566001)(84676001)(55846006)(92726001)(33656002)(2656002)(86362001)(86146001)(1411001)(81156004)(106466001)(76482002)(19580405001)(95666004)(68736004)(77096002)(44976005)(85306004)(4396001)(106116001)(19580395003)(107046002)(20776003)(99396003)(23726002)(47776003)(120916001)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB602;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB602;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB344;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Richard Cochran [mailto:richardcochran@gmail.com]
> Sent: Tuesday, October 21, 2014 4:14 PM
> To: Thomas Shao
> Cc: Thomas Gleixner; gregkh@linuxfoundation.org; LKML;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; John Stultz; Richard Cochran
> Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
> do_adjtimex()
> 
> On Tue, Oct 21, 2014 at 03:18:58AM +0000, Thomas Shao wrote:
> >
> > In some situation, the user is not able to enable guest VM to sync
> > with external time source, like NTP. But the host is still synced with a
> trusted time source.
> 
> But the guest *is* networked, right?
> 
> (Otherwise syncing the guest's clock is pointless.)
> 

I believe it should be a valid scenario, that NTP is not available in the client,  and we want the guest time sync with host.
Other hypervisor like Xen, VMWare also provide the host-guest time sync feature.

> > I've got some feedbacks from Richard and Mike, including reference NTP
> > implementation and do the adjustment in the host side. I've already
> > referenced some NTP design in my patch. I would consider my patch as a
> simplified implementation.
> 
> I really don't think we want a half baked servo in some random driver.
> Instead, why not present the time difference using a standard interface?

OK. I'll do more investigation. Could you let me know what's the standard interface for presenting time difference you mentioned here? Thanks! 

> 
> > I've also considered
> > the host side implementation. But in host, we can only set time but
> > not gradually slew/adjust time,
> 
> Why not implement adjustment in the host?
> 
> > which is not acceptable for the time sync solution.We still recommend
> > user to configure NTP on the guest, which provides better accuracy.
> > But if NTP is not applicable, this could be another option.
> 
> You did not really answer any of my objections, nor did you consider the
> alternative ideas which I offered. Would you care to address those?

I do not agree the guest VM time adjustment should be handled by the host. In my opinion, the host should not involve in any Guest OS level operation.

> 
> Thanks,
> Richard
