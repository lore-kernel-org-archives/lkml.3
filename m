Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaJUJCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:02:48 -0400
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:33404
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754994AbaJUJCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:02:45 -0400
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
Thread-Index: AQHP6EpL5oa00nhAzECMXNpwI49m+pw5VpSAgAADkACAAIUwkIAAX3MAgAALj1A=
Date: Tue, 21 Oct 2014 09:02:26 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540D313F@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
 <alpine.DEB.2.11.1410202027220.5308@nanos>
 <alpine.DEB.2.11.1410202034150.5308@nanos>
 <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
 <alpine.DEB.2.11.1410210946470.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410210946470.5308@nanos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.94.22.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(13464003)(377454003)(51704005)(24454002)(189002)(164054003)(199003)(97736003)(26826002)(47776003)(92726001)(20776003)(21056001)(4396001)(92566001)(15975445006)(46102003)(50986999)(33656002)(97756001)(86362001)(93886004)(85306004)(86612001)(46406003)(64706001)(110136001)(80022003)(15202345003)(84676001)(6806004)(55846006)(19580405001)(19580395003)(44976005)(54356999)(16796002)(23726002)(87936001)(85852003)(2656002)(86146001)(31966008)(120916001)(99396003)(69596002)(76482002)(68736004)(76176999)(106466001)(106116001)(95666004)(107046002)(77096002)(50466002)(81156004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1202;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1202;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB0865;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Thomas Gleixner
> Sent: Tuesday, October 21, 2014 4:19 PM
> To: Thomas Shao
> Cc: gregkh@linuxfoundation.org; LKML; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com; KY Srinivasan;
> John Stultz; Richard Cochran
> Subject: RE: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
> do_adjtimex()
> 
> On Tue, 21 Oct 2014, Thomas Shao wrote:
> > > I still do not have a consistent argument from you WHY you need to
> > > abuse
> > > do_adjtimex() to do that host - guest synchronization in the first place.
> > >
> >
> > I need a function to gradually slew guest time. do_adjtimex() provides
> > all the functionality. Also I could not find any other exposed func to
> > do this. I'd like to hear any feedback from you for this.
> 
> As Richard and others told you already, there are various options:
> 
> 1) Use NTP on that private network, which does not involve any kernel
>    changes at all.
> 
>    Your argument, that this is hard for IT-Admins to set up is just
>    ridiculous. If an IT-Admin is not able to set that up, then he
>    should better stay away from setting up a guest in the first place,
>    really.
> 
> 2) As pointed out already by others PPS/PTP might be a proper solution
>    for this.
> 
>    All it takes is a pair of timestamps (host/guest) injected into the
>    proper subsystem and a controlling daemon on the guest side. That
>    would also avoid the problem of running NTPd and your kernel side
>    poor mans NTPd at the same time.
> 
>    That pseudo NTP thing is just hilarious, really.
> 
>    You take the host time stamp in timesync_onchannelcallback() and
>    schedule work. From the work queue you correlate the host time
>    stamp to the current time of the guest. So you correlate time
>    stamps which can be an arbitrary time apart. Brilliant solution
>    that, really.
> 

OK. I'll investigate these options. Thanks.

> Thanks,
> 
> 	tglx
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
