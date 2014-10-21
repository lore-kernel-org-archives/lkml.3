Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaJUKMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:12:33 -0400
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:44832
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752412AbaJUKMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:12:32 -0400
From: Thomas Shao <huishao@microsoft.com>
To: Richard Cochran <richardcochran@gmail.com>,
        Jeff Epler <jepler@unpythonic.net>
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
Thread-Index: AQHP6EpL5oa00nhAzECMXNpwI49m+pw5VpSAgAADkACAAIUwkIAAF66AgABISwCAABt+4A==
Date: Tue, 21 Oct 2014 10:11:36 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD840141540D33BC@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
 <alpine.DEB.2.11.1410202027220.5308@nanos>
 <alpine.DEB.2.11.1410202034150.5308@nanos>
 <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
 <20141021040212.GA6278@unpythonic.net> <20141021082058.GB6808@netboy>
In-Reply-To: <20141021082058.GB6808@netboy>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.94.22.158]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(24454002)(377454003)(13464003)(189002)(199003)(164054003)(51704005)(16796002)(76176999)(106466001)(55846006)(23726002)(31966008)(50986999)(86612001)(86362001)(92726001)(92566001)(50466002)(54356999)(46406003)(47776003)(81156004)(77096002)(99396003)(95666004)(64706001)(85306004)(20776003)(93886004)(33656002)(80022003)(2656002)(15202345003)(46102003)(86146001)(87936001)(4396001)(97736003)(69596002)(26826002)(76482002)(15975445006)(68736004)(120916001)(97756001)(19580395003)(106116001)(107046002)(6806004)(84676001)(44976005)(19580405001)(85852003)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1207;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1207;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1173;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Richard Cochran
> Sent: Tuesday, October 21, 2014 4:21 PM
> To: Jeff Epler
> Cc: Thomas Shao; Thomas Gleixner; gregkh@linuxfoundation.org; LKML;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; John Stultz; Richard Cochran
> Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
> do_adjtimex()
> 
> On Mon, Oct 20, 2014 at 11:02:13PM -0500, Jeff Epler wrote:
> > It's interesting to imagine that a virtualization host could present a
> > time service to the guest *userspace*, even when the guest is not
> > otherwise exposed to the internet at large.  This could take the form
> > of an NTP server on a private network, or as an implementation of a
> > time source directly usable by ntpd in the guest, for instance as an
> > emulated serial port with synthetic NEMA GPS signal + PPS signal, for
> instance.
> 
> If the idea is to avoid bothering the guest user space, in order to be
> convenient, then the host can provide a synthetic PPS, to be used by the
> kernel's hardpps logic.
> 

This is something I should consider.  I'll do more investigation for this. Thanks Richard.

> Thanks,
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
