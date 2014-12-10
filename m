Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbaLJHe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:34:59 -0500
Received: from mail-bl2on0112.outbound.protection.outlook.com ([65.55.169.112]:32160
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757289AbaLJHe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:34:58 -0500
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
Thread-Index: AQHQE7Dm/HqrMoxqVky8TLtsfjYP+ZyIa2wA
Date: Wed, 10 Dec 2014 07:34:19 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E9B7F7@SIXPRD3002MB028.064d.mgd.msft.net>
References: <1418126489-20627-1-git-send-email-decui@microsoft.com>
 <877fy1ht1u.fsf@vitty.brq.redhat.com>
In-Reply-To: <877fy1ht1u.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:206.191.249.68;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(164054003)(189002)(13464003)(377454003)(199003)(51704005)(68736005)(77156002)(31966008)(16796002)(102836002)(46102003)(99396003)(97736003)(50466002)(92566001)(86362001)(76176999)(54356999)(21056001)(50986999)(33656002)(62966003)(97756001)(84676001)(47776003)(20776003)(4396001)(230783001)(87936001)(106466001)(106116001)(81156004)(55846006)(86146001)(105606002)(86612001)(2656002)(64706001)(107046002)(66066001)(69596002)(120916001)(46406003)(23726002)(110136001)(19580395003)(19580405001)(6806004);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1208;H:064-smtp-out.microsoft.com;FPR:;SPF:Fail;MLV:sfv;PTR:ErrorRetry;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BY1PR0301MB1208;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=fail (sender IP is 206.191.249.68)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1208;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, December 9, 2014 21:06 PM
> To: Dexuan Cui
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
>  ......
> > +	 * Here "dhcp_enabled" is only for IPv4 according to Hyper-V host
> team.
> > +	 *
> > +	 * In the case the host only injects 1 IPv6 address:
> > +	 * new_val->dhcp_enabled is true, but we can't pass
> BOOTPROTO=dhcp to
> > +	 * the script hv_set_ifconfig, because in some distros (like RHEL7)
> > +	 * BOOTPROTO=dhcp has a special meaning in the config file (e.g.,
> > +	 * /etc/sysconfig/network-scripts/ifcfg-eth0): the network init
> program
> > +	 * ignores any static IP addr information once there is
> > +	 * BOOTPROTO=dhcp; as a result, IPv6-only injection can't work.
> > +	 *
> > +	 * In the case of IPv6-only injection, BOOTPROTO=dhcp doesn't affect
> > +	 * Ubuntu because it's ignored by the Ubuntu version of
> > +	 * hv_set_ifconfig and it doesn't seem to have special meaning in
> > +	 * Ubuntu.
> > +	 */
> 
> I just checked and adding "IPV6ADDR=something" when "BOOTPROTO=dhcp"
> works for me with both RHEL7 and Fedora21.
It doesn't work in my side. :-(
Running 'ifup eth0' shows some errors(I use "set -x")
...
+ /sbin/dhclient -H localhost -1 -q -lf /var/lib/dhclient/dhclient--eth0.lease -pf /var/run/dhclient-eth0.pid eth0
grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
done.

I'm trying to find out the cause.

> Other than that I think bringing distribution specifics into kernel.git
> is not a good idea. /etc/sysconfig/network-scripts/ifcfg-* format is
> distro-specific and not all Linux distros support it. Moreover,
I agree.

> different distros can treat setting differently. I think it was wrong to
> stick to this format in kvp daemon from very beginning.
We can also think the current format used in kvp daemon is already
distro-agnostic -- it just happens to look like the style of network config file
used in RHEL :-)

> 
> As a solution I would suggest doing the following: kvp daemon writes all
> received request details in distro-agnostic format in some temporary
> place and then calls distro-specific script to set things up. Actually,
> we already have such script: tools/hv/hv_set_ifconfig.sh
Yeah, this is exactly what we already have today.

> As for this bug I propose the following: remove skipping all
> IPADDR/MASK/... settings in case of "BOOTPROTO=dhcp" and let
> distro-specific script deal with the rest.
> --
>   Vitaly
OK, so the patch would be 1-line only:

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 22b0764..53fdaad 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1314,10 +1314,8 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
                        goto setval_error;

                /*
-                * We are done!.
+                * We are not done... TODO: add comment here.
                 */
-               goto setval_done;
-
        } else {
                error = kvp_write_file(file, "BOOTPROTO", "", "none");
                if (error)

I'll send out a v2 after I resolve the "grep ... Permission dinied" issue.

Thanks,
-- Dexuan
