Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaHHIMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 04:12:23 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:1996
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751193AbaHHIMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 04:12:17 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Richard Weinberger <richard.weinberger@gmail.com>,
        David Miller <davem@davemloft.net>,
        "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Shao <huishao@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Topic: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Index: AQHPspA/W9GLuVF6+E2lxD+S7UVRVpvF95oQgAAV/QCAAC25AA==
Date: Fri, 8 Aug 2014 08:11:20 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C991569A@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <DC7803B42427924284F2D5252E076A3B4476A479@SINEX14MBXC416.southpacific.corp.microsoft.com>
 <53CCD6F2.6020909@nod.at> <20140721091851.GA28171@aepfle.de>
 <20140721.143225.2040366896972949930.davem@davemloft.net>
 <CAFLxGvyfy1UkxN6_-c_ST7f8n7DvqYsCPKChWmt9CerWb0dh7g@mail.gmail.com>
 <EE124450C0AAF944A40DD71E61F878C99149D0@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140808033220.GB10503@kroah.com>
In-Reply-To: <20140808033220.GB10503@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377454003)(51914003)(51704005)(189002)(199002)(76482001)(86362001)(55846006)(4396001)(46102001)(85306004)(97756001)(87936001)(26826002)(97736001)(93886004)(46406003)(81342001)(85852003)(77096002)(95666004)(81542001)(107046002)(77982001)(106116001)(79102001)(81156004)(106466001)(20776003)(19580405001)(83072002)(110136001)(47776003)(80022001)(74662001)(74502001)(16796002)(99396002)(84676001)(31966008)(85806002)(86612001)(83322001)(21056001)(23726002)(68736004)(92566001)(2656002)(50986999)(64706001)(76176999)(33656002)(44976005)(50466002)(54356999)(69596002)(19580395003)(92726001)(6806004);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0680;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, August 8, 2014 11:32 AM
> > Hi Richard and all,
> >
> > IMO the most feasible and need-the-least-change solution may be:
> > the hyperv network VSC driver passes the event
> > RNDIS_STATUS_NETWORK_CHANGE to the udev daemon?
> >
> > In this way, every distro only needs to add a udev rule, which should
> > be simple.
> 
> No, don't do that, again, act like any other network device, drop the
> link and bring it up when it comes back.
> 
> greg k-h

Hi Greg,
Thanks for the comment!

Do you mean tearing down the net device and re-creating it (by
register_netdev() and unregister_netdev)?

Sorry, I'm new to network drivers. I'll have to try this to see if this
works or not, though I suppose it would work.

-- Dexuan
