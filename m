Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaGUCpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:45:51 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:42947
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751670AbaGUCph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:45:37 -0400
From: "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>
To: Varka Bhadram <varkabhadram@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: Haiyang Zhang <haiyangz@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Thomas Shao <huishao@microsoft.com>, Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Topic: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Index: AQHPom6EfguQ5YHfv0qQpfdXjiDiFZulnN4AgAQ5u9A=
Date: Mon, 21 Jul 2014 02:45:19 +0000
Message-ID: <DC7803B42427924284F2D5252E076A3B44769DDC@SINEX14MBXC416.southpacific.corp.microsoft.com>
References: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
 <53C8F332.8010604@gmail.com>
In-Reply-To: <53C8F332.8010604@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(377454003)(24454002)(189002)(199002)(479174003)(46406003)(33656002)(6806004)(76176999)(21056001)(31966008)(16796002)(74662001)(81342001)(84676001)(107046002)(74502001)(79102001)(81542001)(92726001)(23726002)(55846006)(2201001)(76482001)(77982001)(54356999)(99396002)(95666004)(44976005)(26826002)(83072002)(92566001)(85852003)(106466001)(81156004)(106116001)(85306003)(77096002)(50466002)(20776003)(47776003)(19580405001)(4396001)(19580395003)(86362001)(69596002)(97736001)(68736004)(64706001)(50986999)(83322001)(87936001)(97756001)(2656002)(80022001)(86612001)(46102001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB621;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0279B3DD0D
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=yuezha@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Varka Bhadram [mailto:varkabhadram@gmail.com]
> Sent: Friday, July 18, 2014 6:13 PM
> 
> On 07/18/2014 04:25 PM, Yue Zhang wrote:
> > @@ -816,8 +816,21 @@ static void netvsc_link_change(struct work_struct
> *w)
> >
> >   	rtnl_unlock();
> >
> > -	if (refresh)
> > -		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> > +	if (refresh) {
> > +		/*
> > +		 * Keep the carrier offline for 10 seconds
> > +		 * to notify ifplugd daemon network change
> > +		 */
> 
> This should be networking comment style..
> 
> 	/* bla bla..
> 	 * bla
> 	 */
> 
> --
> Regards,
> Varka Bhadram.

I will fix this.

Thanks
Yue
