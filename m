Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaC1JXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:23:02 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:53348
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750830AbaC1JXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:23:00 -0400
From: Insop Song <Insop.Song@gainspeed.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: gs_fpgaboot: remove __TIMESTAMP__ macro
Thread-Topic: [PATCH] staging: gs_fpgaboot: remove __TIMESTAMP__ macro
Thread-Index: AQHPSEG0++v2ZX9EMk6QWJsu0vZKipr2PV+i
Date: Fri, 28 Mar 2014 09:22:54 +0000
Message-ID: <66f9d5ab4d6e4e37ac2440d023d62a65@BY2PR07MB011.namprd07.prod.outlook.com>
References: <1398516318.KXtUGEPAeQ@wuerfel>
In-Reply-To: <1398516318.KXtUGEPAeQ@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.218.13.253]
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(189002)(199002)(74316001)(74876001)(53806001)(95416001)(77096001)(81816001)(92566001)(49866001)(47976001)(54316002)(74366001)(56776001)(51856001)(19580395003)(81686001)(19580405001)(83322001)(54356001)(76576001)(76796001)(76786001)(81342001)(97336001)(95666003)(50986001)(47736001)(46102001)(83072002)(80976001)(4396001)(74706001)(33646001)(79102001)(90146001)(2656002)(63696002)(47446002)(74502001)(74662001)(98676001)(81542001)(87936001)(56816005)(87266001)(93516002)(85306002)(93136001)(20776003)(97186001)(65816001)(66066001)(80022001)(31966008)(59766001)(94316002)(77982001)(85852003)(94946001)(69226001)(86362001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR07MB010;H:BY2PR07MB011.namprd07.prod.outlook.com;FPR:88A2B9EA.1C378D99.B85FB7F2.4455DA23.2018C;MLV:sfv;PTR:InfoNoRecords;MX:3;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


________________________________________
From: Arnd Bergmann <arnd@arndb.de>
Sent: Tuesday, March 25, 2014 8:48 AM
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org; Insop Song
Subject: [PATCH] staging: gs_fpgaboot: remove __TIMESTAMP__ macro

We specifically build the kernel with -Werror=date-time to detect
such macros, which gives us this error:

gs_fpgaboot/gs_fpgaboot.c:376:44: error: macro "__TIMESTAMP__" might prevent reproducible builds [-Werror=date-time]
  pr_info("built at %s UTC\n", __TIMESTAMP__);

The obvious fix is to remove the printk output line.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Insop Song <insop.song@gainspeed.com>

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index 89bc84d..7506900 100644
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
+++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
@@ -373,7 +373,6 @@ static int __init gs_fpgaboot_init(void)
        r = -1;

        pr_info("FPGA DOWNLOAD --->\n");
-       pr_info("built at %s UTC\n", __TIMESTAMP__);

        pr_info("FPGA image file name: %s\n", file);

