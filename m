Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaHKDah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:30:37 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:35431
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751841AbaHKDaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:30:35 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Shao <huishao@microsoft.com>,
        "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>,
        "David Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: RE: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Topic: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Index: AQHPspA/W9GLuVF6+E2lxD+S7UVRVpvF95oQgAAV/QCAAC25AIAAfa+AgAP4svCAABDZYA==
Date: Mon, 11 Aug 2014 03:29:51 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C991B6B4@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <DC7803B42427924284F2D5252E076A3B4476A479@SINEX14MBXC416.southpacific.corp.microsoft.com>
 <53CCD6F2.6020909@nod.at> <20140721091851.GA28171@aepfle.de>
 <20140721.143225.2040366896972949930.davem@davemloft.net>
 <CAFLxGvyfy1UkxN6_-c_ST7f8n7DvqYsCPKChWmt9CerWb0dh7g@mail.gmail.com>
 <EE124450C0AAF944A40DD71E61F878C99149D0@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140808033220.GB10503@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C991569A@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140808134549.GD4427@kroah.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(51704005)(189002)(199002)(377454003)(13464003)(50466002)(31966008)(74502001)(16796002)(86612001)(26826002)(107046002)(106116001)(76482001)(81156004)(46102001)(106466001)(79102001)(46406003)(95666004)(47776003)(55846006)(77982001)(64706001)(20776003)(74662001)(84676001)(93886004)(81542001)(83072002)(110136001)(23726002)(87936001)(85306004)(2656002)(6806004)(44976005)(69596002)(68736004)(33656002)(97736001)(97756001)(85806002)(83322001)(77096002)(4396001)(80022001)(21056001)(81342001)(92726001)(92566001)(86362001)(85852003)(76176999)(54356999)(99396002)(50986999);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB247;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03008837BD
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dexuan Cui
> Sent: Monday, August 11, 2014 11:24 AM
> Now I understand it's not good to pass the event to the udev daemon,
> and it's not good to use a SLEEP(10s) in the kernel space(even if it's in a
> "work" task here).
> 
> Please let me know if it's the correct direction to fix the user-space
> daemons (ifplugd, systemd-networkd, etc).
> If you think this is viable and we should do this, I'll submit a
> netif_carrier_off/on patch first and will start to work with the
> projects of ifplugd, systemd-networkd and many OSVs to make the
> while thing work eventually.

I forgot to mention: due to the huge efforts to fix the user-space
daemons, I wish the "tearing down the net device and re-creating it"
method could work with the daemons -- I'm going to try it.

Anybody objects to this method?

Thanks,
-- Dexuan
