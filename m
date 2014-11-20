Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940AbaKTS6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:58:39 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.28]:22132 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757858AbaKTS6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:58:37 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: RE: [PATCH 1/1] net: Hyper-V: Deletion of an unnecessary check before
 the function call "vfree"
Thread-Topic: [PATCH 1/1] net: Hyper-V: Deletion of an unnecessary check
 before the function call "vfree"
Thread-Index: AQHQBM3lPHoJ7I1S40Wjf3+Jmqo/ZZxp3eHw
Date: Thu, 20 Nov 2014 18:58:22 +0000
Message-ID: <f8c8e81a61634b02b8e1f562588e1ced@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <546DF9D7.6080801@users.sourceforge.net>
In-Reply-To: <546DF9D7.6080801@users.sourceforge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 131.107.159.99)
 smtp.mailfrom=haiyangz@microsoft.com; vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=pass action=none
 header.from=microsoft.com;
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(51704005)(199003)(13464003)(41574002)(189002)(377454003)(2656002)(2201001)(92566001)(87936001)(84676001)(4396001)(86612001)(19580405001)(19580395003)(6806004)(68736004)(44976005)(31966008)(107046002)(93886004)(99396003)(106466001)(77156002)(62966003)(77096003)(46102003)(2501002)(50466002)(21056001)(108616004)(120916001)(2561002)(97736003)(64706001)(2421001)(33646002)(20776003)(1511001)(47776003)(23676002)(66066001)(54356999)(106116001)(50986999)(76176999)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUSR01MB603;H:hybrid.exchange.microsoft.com;FPR:;SPF:Pass;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUSR01MB603;
X-DmarcStatus: Passed
X-DmarcAction: None
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(4001003)(4003003);SRVR:BLUSR01MB603;
X-Forefront-PRVS: 0401647B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUSR01MB603;
X-OriginatorOrg: msft.ccsctp.net
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2014 18:58:34.6617
 (UTC)
X-MS-Exchange-CrossTenant-Id: f686d426-8d16-42db-81b7-ab578e110ccd
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUSR01MB603
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAKIwkNw012704



> -----Original Message-----
> From: SF Markus Elfring [mailto:elfring@users.sourceforge.net]
> Sent: Thursday, November 20, 2014 9:25 AM
> To: Haiyang Zhang; KY Srinivasan; devel@linuxdriverproject.org;
> netdev@vger.kernel.org
> Cc: LKML; kernel-janitors@vger.kernel.org; Julia Lawall
> Subject: [PATCH 1/1] net: Hyper-V: Deletion of an unnecessary check
> before the function call "vfree"
> 
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 20 Nov 2014 15:15:21 +0100
> 
> The vfree() function performs also input parameter validation. Thus the
> test
> around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Thanks!

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
