Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaJUE4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:56:33 -0400
Received: from mail-by2on0106.outbound.protection.outlook.com ([207.46.100.106]:1062
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750818AbaJUE4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:56:31 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Jeff Epler <jepler@unpythonic.net>
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
Thread-Index: AQHP6EpL5oa00nhAzECMXNpwI49m+pw5VpSAgAADkACAAIUwkIAAF66AgAAKKYA=
Date: Tue, 21 Oct 2014 04:55:57 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540D2AEF@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
 <alpine.DEB.2.11.1410202027220.5308@nanos>
 <alpine.DEB.2.11.1410202034150.5308@nanos>
 <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141021040212.GA6278@unpythonic.net>
In-Reply-To: <20141021040212.GA6278@unpythonic.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(189002)(24454002)(51704005)(199003)(13464003)(377454003)(81156004)(106466001)(106116001)(95666004)(54356999)(2656002)(87936001)(86146001)(64706001)(31966008)(99396003)(16796002)(46406003)(46102003)(80022003)(107046002)(77096002)(120916001)(50466002)(97736003)(93886004)(85852003)(4396001)(85306004)(97756001)(84676001)(110136001)(76482002)(23726002)(76176999)(50986999)(20776003)(44976005)(33656002)(47776003)(86362001)(66066001)(68736004)(55846006)(19580405001)(69596002)(21056001)(26826002)(86612001)(92726001)(6806004)(19580395003)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1203;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1203;
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
> From: Jeff Epler [mailto:jepler@unpythonic.net]
> Sent: Tuesday, October 21, 2014 12:02 PM
> To: Thomas Shao
> Cc: Thomas Gleixner; gregkh@linuxfoundation.org; LKML;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; John Stultz; Richard Cochran
> Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
> do_adjtimex()
> 
> On Tue, Oct 21, 2014 at 03:18:58AM +0000, Thomas Shao wrote:
> > In some situation, the user is not able to enable guest VM to sync
> > with external time source, like NTP. But the host is still synced with a
> trusted time source.
> > In this case, host-guest time synchronization is useful.
> 
> It's interesting to imagine that a virtualization host could present a time
> service to the guest *userspace*, even when the guest is not otherwise
> exposed to the internet at large.  This could take the form of an NTP server
> on a private network, or as an implementation of a time source directly
> usable by ntpd in the guest, for instance as an emulated serial port with
> synthetic NEMA GPS signal + PPS signal, for instance.

Yeah. There is already some guidance about how to setup a local NTP server. But it 
requires some additional efforts for IT admins. I don't think we need configure
every host as a time source. Typically we could setup one server shared by the 
private network, and that server needs to be synced with upstream NTP server. 

I'm also thinking if NTPd could expose some interface to allow other application to
directly provide time source for it to consume. In my opinion, emulating the ntp 
source should be very hard and error prone.
