Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaJUDTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:19:18 -0400
Received: from mail-bn1on0145.outbound.protection.outlook.com ([157.56.110.145]:20160
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754307AbaJUDTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:19:16 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
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
Thread-Index: AQHP6EpL5oa00nhAzECMXNpwI49m+pw5VpSAgAADkACAAIUwkA==
Date: Tue, 21 Oct 2014 03:18:58 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
 <alpine.DEB.2.11.1410202027220.5308@nanos>
 <alpine.DEB.2.11.1410202034150.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410202034150.5308@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(13464003)(51704005)(377454003)(164054003)(24454002)(199003)(189002)(4396001)(50466002)(86612001)(2656002)(110136001)(47776003)(92726001)(92566001)(86362001)(20776003)(26826002)(68736004)(55846006)(19580405001)(19580395003)(33656002)(69596002)(6806004)(84676001)(87936001)(44976005)(15202345003)(86146001)(15975445006)(85306004)(85852003)(46406003)(76482002)(21056001)(77096002)(81156004)(106466001)(106116001)(66066001)(95666004)(50986999)(76176999)(64706001)(80022003)(107046002)(46102003)(16796002)(97736003)(120916001)(23726002)(31966008)(97756001)(54356999)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB394;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB394;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Thomas Gleixner
> Sent: Tuesday, October 21, 2014 2:41 AM
> To: Thomas Shao
> Cc: gregkh@linuxfoundation.org; LKML; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com; KY Srinivasan;
> John Stultz; Richard Cochran
> Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
> do_adjtimex()
> 
> On Mon, 20 Oct 2014, Thomas Gleixner wrote:
> 
> > On Wed, 15 Oct 2014, Thomas Shao wrote:
> >
> > And again you forgot to cc John Stultz on this....
> >
> > > Export do_adjtimex function for hyper-v Time Synchronization
> > > component
> 
> Aside of that, we really want to see the use case for this and how you
> addressed the problems which were pointed out by various folks.
> 

In some situation, the user is not able to enable guest VM to sync with external 
time source, like NTP. But the host is still synced with a trusted time source. 
In this case, host-guest time synchronization is useful. Hyper-v host will send time
sample to guest VM every 5 seconds. We will use these time samples to adjust guest
VM time. 

I've got some feedbacks from Richard and Mike, including reference NTP implementation
and do the adjustment in the host side. I've already referenced some NTP design in
my patch. I would consider my patch as a simplified implementation. I've also considered
the host side implementation. But in host, we can only set time but not gradually slew/adjust
time, which is not acceptable for the time sync solution.We still recommend user to configure
NTP on the guest, which provides better accuracy. But if NTP is not applicable, this could be 
another option. 

> I still do not have a consistent argument from you WHY you need to abuse
> do_adjtimex() to do that host - guest synchronization in the first place.
> 

I need a function to gradually slew guest time. do_adjtimex() provides all the 
functionality. Also I could not find any other exposed func to do this. I'd like to
hear any feedback from you for this.

> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
