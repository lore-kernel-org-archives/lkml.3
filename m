Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaKHBY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 20:24:28 -0500
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:64384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752442AbaKHBY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 20:24:27 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/3] Tools: hv: vssdaemon: freeze/thaw logic improvement
 for the failure case
Thread-Topic: [PATCH 0/3] Tools: hv: vssdaemon: freeze/thaw logic
 improvement for the failure case
Thread-Index: AQHP+q2jWasud1Xr60GKU6e4Q9z29JxV6Q+Q
Date: Sat, 8 Nov 2014 01:07:47 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C6105A0E13@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1415380170-641-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415380170-641-1-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [112.65.1.75]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(69234005)(51704005)(199003)(164054003)(377454003)(189002)(13464003)(64706001)(66066001)(120916001)(77096003)(62966003)(77156002)(50986999)(76176999)(4396001)(55846006)(19580405001)(15975445006)(92566001)(26826002)(86362001)(86612001)(69596002)(20776003)(47776003)(19580395003)(84676001)(68736004)(54356999)(50466002)(23726002)(16796002)(97756001)(86146001)(87936001)(31966008)(46406003)(33656002)(44976005)(92726001)(95666004)(2561002)(97736003)(107046002)(106466001)(81156004)(46102003)(1511001)(2421001)(21056001)(6806004)(2656002)(99396003)(106116001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1214;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1214;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0720;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Saturday, November 8, 2014 1:09 AM
> To: KY Srinivasan; Haiyang Zhang; Greg Kroah-Hartman
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH 0/3] Tools: hv: vssdaemon: freeze/thaw logic improvement
> for the failure case
> 
> This patch series addresses the following issues:
> - Wrong error reporting for multiple filesystems case.
> - Skip all readonly-mounted filesystems instead of skipping iso9660.
> - Thaw all filesystems after an unsuccessful freeze attempt.
> 
> Vitaly Kuznetsov (3):
>   Tools: hv: vssdaemon: consult with errno in case of failure only
>   Tools: hv: vssdaemon: skip all filesystems mounted readonly
>   Tools: hv: vssdaemon: thaw everything in case of freeze failure
> 
>  tools/hv/hv_vss_daemon.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

Hi Vitaly,
Thanks for your patchset!

FYI: Greg checked in a patch of mine several hours ago -- my patch
implemented "thaw all filesytems on a failure of freeze" too. :-)

Please see my patch in Greg's char-misc-next tree:
https://git.kernel.org/cgit/linux/kernel/git/gregkh/char-misc.git/commit/?h=char-misc-next&id=4f689190bb55d171d2f6614f8a6cbd4b868e48bd

Can you please rebase  your patch(es) on Greg's tree?

Thanks,
-- Dexuan
