Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaLSCe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:34:29 -0500
Received: from mail-bn1bon0063.outbound.protection.outlook.com ([157.56.111.63]:53546
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751158AbaLSCe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:34:27 -0500
From: "Chickles, Derek" <Derek.Chickles@caviumnetworks.com>
To: Joe Perches <joe@perches.com>
CC: "apw@canonical.com" <apw@canonical.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cernekee@gmail.com" <cernekee@gmail.com>
Subject: RE: [PATCH] checkpatch: Fix MAINTAINERS search pattern
Thread-Topic: [PATCH] checkpatch: Fix MAINTAINERS search pattern
Thread-Index: AQHQGv8MqlX3BQwzy02J7ZzErfIh35yV2isAgABXRuA=
Date: Fri, 19 Dec 2014 02:34:24 +0000
Message-ID: <BLUPR07MB4845BEE1160E5945E113E8AFE6B0@BLUPR07MB484.namprd07.prod.outlook.com>
References: <1418801732-19141-1-git-send-email-computersforpeace@gmail.com>
	 <1418933533-8364-1-git-send-email-dchickles@caviumnetworks.com>
 <1418937472.28384.14.camel@perches.com>
In-Reply-To: <1418937472.28384.14.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [64.2.3.194]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Derek.Chickles@caviumnetworks.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR07MB483;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR07MB483;
x-forefront-prvs: 0430FA5CB7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(6009001)(377424004)(199003)(24454002)(164054003)(189002)(51704005)(2656002)(87936001)(76576001)(33656002)(4396001)(66066001)(64706001)(21056001)(46102003)(20776003)(54206007)(19580395003)(101416001)(77096005)(68736005)(2900100001)(2950100001)(110136001)(105586002)(106116001)(107046002)(99286002)(102836002)(106356001)(40100003)(97736003)(62966003)(54356999)(50986999)(76176999)(74316001)(86362001)(77156002)(122556002)(54606007)(120916001)(99396003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR07MB483;H:BLUPR07MB484.namprd07.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: caviumnetworks.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2014 02:34:24.3129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 711e4ccf-2e9b-4bcf-a551-4094005b6194
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR07MB483
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2014-12-18 at 12:12 -0800, Derek Chickles wrote:
> > This fixes the check that was supposed to prevent the MAINTAINERS
> > warning from appearing when you run checkpatch.pl on a patch that
> > includes new files/directories and an updated MAINTAINERS file.
> 
> This suggested patch doesn't work.
> 
> $realfile isn't set until the file shows up
> in the patch itself.
> 
> The current test looks at the changelog
> before the files are modified and is correct.
> 

Thanks, you're right. My mistake was trying to run checkpatch.pl on a diff.
My patch works on diffs while the original code does not. This is by chance
really because MAINTAINERS is early in the patch. Using format-patch on
something that is committed is clearly the correct solution.
