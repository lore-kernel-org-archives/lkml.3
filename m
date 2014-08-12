Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbaHLHw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:52:26 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:12238
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751387AbaHLHwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:52:25 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Bill Fink <billfink@mindspring.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, "olaf@aepfle.de" <olaf@aepfle.de>,
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
Thread-Index: AQHPspA/W9GLuVF6+E2lxD+S7UVRVpvF95oQgAAV/QCAAC25AIAAfa+AgAP4svCAABhVAIAACHwAgAHMKEA=
Date: Tue, 12 Aug 2014 07:51:53 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C99210BC@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <DC7803B42427924284F2D5252E076A3B4476A479@SINEX14MBXC416.southpacific.corp.microsoft.com>
	<53CCD6F2.6020909@nod.at>	<20140721091851.GA28171@aepfle.de>
	<20140721.143225.2040366896972949930.davem@davemloft.net>
	<CAFLxGvyfy1UkxN6_-c_ST7f8n7DvqYsCPKChWmt9CerWb0dh7g@mail.gmail.com>
	<EE124450C0AAF944A40DD71E61F878C99149D0@SINEX14MBXC417.southpacific.corp.microsoft.com>
	<20140808033220.GB10503@kroah.com>
	<EE124450C0AAF944A40DD71E61F878C991569A@SINEX14MBXC417.southpacific.corp.microsoft.com>
	<20140808134549.GD4427@kroah.com>
	<EE124450C0AAF944A40DD71E61F878C991B653@SINEX14MBXC417.southpacific.corp.microsoft.com>
	<53E83DD4.1060500@gmail.com>
 <20140811002210.2a697052767e9ec1989cb219@mindspring.com>
In-Reply-To: <20140811002210.2a697052767e9ec1989cb219@mindspring.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(189002)(164054003)(199003)(13464003)(97736001)(97756001)(46102001)(76176999)(54356999)(50986999)(92726001)(77096002)(92566001)(93886004)(85306004)(83072002)(85852003)(81342001)(99396002)(81542001)(86612001)(106116001)(106466001)(81156004)(23726002)(21056001)(68736004)(69596002)(107046002)(4396001)(26826002)(55846006)(83322001)(20776003)(47776003)(33656002)(77982001)(2656002)(44976005)(6806004)(46406003)(86362001)(50466002)(76482001)(64706001)(80022001)(85806002)(95666004)(79102001)(84676001)(74662001)(16796002)(87936001)(31966008)(74502001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB613;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0301360BF5
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bill Fink 
> In the case of ifplugd, it has parameters -u | --delay-up= which
> defaults to 0 seconds, and -d | --delay-down= which defaults to
> 5 seconds.  Maybe for hyperv you could specify --delay-down=0.
> I don't know if other daemons such as systemd have similar options.
> It might still be good to have some modest delay between the
> netif_carrier_off(net) and netif_carrier_on(net).
> 
> 		-Bill
Thanks, Bill!

I'll try these parameters and see if a modest delay is necessary here.

Thanks,
-- Dexuan
