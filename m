Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaKKDIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:08:00 -0500
Received: from mail-bn1on0135.outbound.protection.outlook.com ([157.56.110.135]:64128
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751221AbaKKDH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:07:58 -0500
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] Tools: hv: vssdaemon: report freeze errors
Thread-Topic: [PATCH v2 1/2] Tools: hv: vssdaemon: report freeze errors
Thread-Index: AQHP/QSmTDkvs8aF8EqpOHM4Gza9PpxavR/Q
Date: Tue, 11 Nov 2014 03:07:02 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C6105DFD0B@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1415637422-27880-1-git-send-email-vkuznets@redhat.com>
 <1415637422-27880-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415637422-27880-2-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(13464003)(199003)(377454003)(189002)(51704005)(51914003)(84676001)(47776003)(20776003)(66066001)(64706001)(19580405001)(68736004)(1511001)(69596002)(19580395003)(97756001)(107046002)(2561002)(97736003)(87936001)(81156004)(106466001)(95666004)(106116001)(44976005)(6806004)(86146001)(23726002)(55846006)(99396003)(120916001)(50986999)(4396001)(2421001)(62966003)(2656002)(77096003)(77156002)(86612001)(16796002)(31966008)(46102003)(86362001)(92726001)(92566001)(50466002)(26826002)(33656002)(21056001)(76176999)(54356999)(46406003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB393;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB393;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB393;
X-Forefront-PRVS: 0392679D18
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB393;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Vitaly Kuznetsov
> Sent: Tuesday, November 11, 2014 0:37 AM
> To: KY Srinivasan; Haiyang Zhang; Greg Kroah-Hartman
> Cc: devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Dexuan Cui
> Subject: [PATCH v2 1/2] Tools: hv: vssdaemon: report freeze errors
> 
> When ioctl(fd, FIFREEZE, 0) results in an error we cannot report it
> to syslog instantly since that can cause write to a frozen disk.
> However, the name of the filesystem which caused the error and errno
> are valuable and we would like to get a nice human-readable message
> in the log. Save errno before calling vss_operate(VSS_OP_THAW) and
> report the error right after.
> 
> Unfortunately, FITHAW errors cannot be reported the same way as we
> need to finish thawing all filesystems before calling syslog().
> 
> We should also avoid calling endmntent() for the second time in
> case we encountered an error during freezing of '/' as it usually
> results in SEGSEGV.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/hv/hv_vss_daemon.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)

Hi Vitaly,
Thanks for the patch -- it does improve the error handling!
 
Acked-by: Dexuan Cui <decui@microsoft.com>

-- Dexuan
