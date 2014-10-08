Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaJHFYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 01:24:37 -0400
Received: from mail-by2on0141.outbound.protection.outlook.com ([207.46.100.141]:5123
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750999AbaJHFYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 01:24:36 -0400
From: Dexuan Cui <decui@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>, KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v3] Tools: hv: vssdaemon: ignore the EBUSY on multiple
 freezing the same partition
Thread-Topic: [PATCH v3] Tools: hv: vssdaemon: ignore the EBUSY on multiple
 freezing the same partition
Thread-Index: AQHP2TyNeckjtpCPVUyoTNe23xmUe5wlvOPw
Date: Wed, 8 Oct 2014 05:23:52 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C605CFC4@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1411707124-26037-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1411707124-26037-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(377454003)(189002)(199003)(51704005)(13464003)(164054003)(106116001)(77096002)(26826002)(85852003)(55846006)(86362001)(86612001)(95666004)(23726002)(92566001)(92726001)(2201001)(4396001)(97736003)(50466002)(97756001)(46406003)(33656002)(2501002)(21056001)(107046002)(120916001)(66066001)(64706001)(84676001)(31966008)(16796002)(69596002)(76176999)(99396003)(6806004)(54356999)(50986999)(86146001)(68736004)(19580395003)(44976005)(19580405001)(2656002)(76482002)(81156004)(80022003)(106466001)(46102003)(87936001)(20776003)(47776003)(85306004);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1206;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1206;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0358535363
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1303;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On Behalf
> Of Dexuan Cui
> Sent: Friday, September 26, 2014 12:52 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: Haiyang Zhang
> Subject: [PATCH v3] Tools: hv: vssdaemon: ignore the EBUSY on multiple
> freezing the same partition
> 
> If a partition appears mounted more than once in /proc/mounts, vss_do_freeze()
> succeeds only for the first time and gets EBUSY (on freeze) or EINVAL (on
> thaw) for the second time. The patch ignores these to make the backup feature
> work.
> 
> Also improved the error handling in case a freeze operation fails.
> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
> 
> v2: Add "errno = 0;" before the ioctl()
> (Unnecessary and removed now since we remove syslog() in vss_do_freeze() in
> v3)
> 
> v3: Remove the unsafe syslog() in vss_do_freeze(): that could write the disk.
>     Thaw the filesystems in case the freezing operation fails.
>     In main(), add syslog() when we check the return value of vss_operate().
> 
>  tools/hv/hv_vss_daemon.c | 48

Hi Greg,
Ping.

Thanks,
-- Dexuan
