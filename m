Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaL3Lg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 06:36:57 -0500
Received: from mail-bn1on0142.outbound.protection.outlook.com ([157.56.110.142]:48544
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751636AbaL3Lg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 06:36:56 -0500
X-Greylist: delayed 34435 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2014 06:36:56 EST
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "crmafra@gmail.com" <crmafra@gmail.com>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andreas.noever@gmail.com" <andreas.noever@gmail.com>,
        "crmafra2@gmail.com" <crmafra2@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
Subject: Re: Bisected regression from 3.17 still present in 3.19-rc1
Thread-Topic: Bisected regression from 3.17 still present in 3.19-rc1
Thread-Index: AQHQIs7zn+FVxla+ME6mkETDKfie05yn7D/ugAAX8gA=
Date: Tue, 30 Dec 2014 11:36:53 +0000
Message-ID: <1419939412.25226.2.camel@nebula.com>
References: <20141228185409.GA2015@linux-g29b.site>
	 <1419902900.25226.0.camel@nebula.com>
	 <20141230101624.GA5339@linux-g29b.site>
In-Reply-To: <20141230101624.GA5339@linux-g29b.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [88.128.80.30]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.garrett@nebula.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR05MB423;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR05MB423;
x-forefront-prvs: 04410E544A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(377424004)(24454002)(199003)(51704005)(31966008)(107046002)(2351001)(110136001)(120916001)(33646002)(66066001)(99286002)(106116001)(86362001)(2656002)(21056001)(122556002)(2950100001)(68736005)(105586002)(20776003)(106356001)(2900100001)(87936001)(1411001)(62966003)(77156002)(76176999)(4396001)(50986999)(46102003)(19580405001)(101416001)(54356999)(36756003)(103116003)(2501002)(97736003)(19580395003)(92566001)(40100003)(102836002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <169249A6B2BFA1499B3A693AB05048AE@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2014 11:36:53.0851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9cc6df8-58db-46f5-bf3e-083732d8ac63
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR05MB423
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBUBbMo7020685

On Tue, 2014-12-30 at 10:16 +0000, Carlos R. Mafra wrote:
> On Tue, 30 Dec 2014 at  1:28:21 +0000, Matthew Garrett wrote:
> > What is CONFIG_ACPI_SBS set to?
> 
> CONFIG_ACPI_SBS is not set

There's your problem. The Darwin call results in the firmware exposing
the battery via SBS, not as an ACPI control method battery. Enable
CONFIG_ACPI_SBS and you should be good.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
