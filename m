Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbaLJHhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:37:20 -0500
Received: from mail-bl2on0118.outbound.protection.outlook.com ([65.55.169.118]:5728
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753252AbaLJHhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:37:19 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
Thread-Topic: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
Thread-Index: AQHQE7Dm/HqrMoxqVky8TLtsfjYP+ZyIa2wAgAAE1VA=
Date: Wed, 10 Dec 2014 07:36:16 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E9B80F@SIXPRD3002MB028.064d.mgd.msft.net>
References: <1418126489-20627-1-git-send-email-decui@microsoft.com>
 <877fy1ht1u.fsf@vitty.brq.redhat.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:206.191.249.68;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(13464003)(51704005)(377454003)(199003)(164054003)(46102003)(87936001)(2656002)(86146001)(66066001)(55846006)(20776003)(47776003)(64706001)(68736005)(16796002)(105606002)(107046002)(81156004)(106466001)(106116001)(31966008)(33656002)(102836002)(110136001)(21056001)(84676001)(69596002)(6806004)(97736003)(46406003)(97756001)(50986999)(230783001)(4396001)(54356999)(76176999)(19580395003)(19580405001)(62966003)(77156002)(120916001)(50466002)(23726002)(99396003)(86362001)(92566001)(86612001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1214;H:064-smtp-out.microsoft.com;FPR:;SPF:Fail;MLV:sfv;PTR:ErrorRetry;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:DM2PR0301MB1214;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=fail (sender IP is 206.191.249.68)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0701;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Thanks,
-- Dexuan

> -----Original Message-----
> From: Dexuan Cui
> Sent: Wednesday, December 10, 2014 15:34 PM
> To: 'Vitaly Kuznetsov'
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: RE: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
> 
> > -----Original Message-----
> > From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> > Sent: Tuesday, December 9, 2014 21:06 PM
> > To: Dexuan Cui
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> > Subject: Re: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
> >  ......
> > > +	 * Here "dhcp_enabled" is only for IPv4 according to Hyper-V host
> > team.
> > > +	 *
> > > +	 * In the case the host only injects 1 IPv6 address:
> > > +	 * new_val->dhcp_enabled is true, but we can't pass
> > BOOTPROTO=dhcp to
> > > +	 * the script hv_set_ifconfig, because in some distros (like RHEL7)
> > > +	 * BOOTPROTO=dhcp has a special meaning in the config file (e.g.,
> > > +	 * /etc/sysconfig/network-scripts/ifcfg-eth0): the network init
> > program
> > > +	 * ignores any static IP addr information once there is
> > > +	 * BOOTPROTO=dhcp; as a result, IPv6-only injection can't work.
> > > +	 *
> > > +	 * In the case of IPv6-only injection, BOOTPROTO=dhcp doesn't affect
> > > +	 * Ubuntu because it's ignored by the Ubuntu version of
> > > +	 * hv_set_ifconfig and it doesn't seem to have special meaning in
> > > +	 * Ubuntu.
> > > +	 */
> >
> > I just checked and adding "IPV6ADDR=something" when
> "BOOTPROTO=dhcp"
> > works for me with both RHEL7 and Fedora21.
> It doesn't work in my side. :-(
> Running 'ifup eth0' shows some errors(I use "set -x")
> ...
> + /sbin/dhclient -H localhost -1 -q -lf /var/lib/dhclient/dhclient--eth0.lease -pf
> /var/run/dhclient-eth0.pid eth0
> grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
BTW, I run with root, and
'chown 777 /etc/sysconfig/network-scripts/ifcfg-eth0" doesn't help.

Thanks,
-- Dexuan
