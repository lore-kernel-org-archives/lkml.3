Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaKXCf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:35:59 -0500
Received: from mail-bl2on0143.outbound.protection.outlook.com ([65.55.169.143]:35523
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751152AbaKXCfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:35:55 -0500
X-WSS-ID: 0NFIQW8-08-NQR-02
X-M-MSG: 
From: "Xue, Ken" <Ken.Xue@amd.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Jeff" <Jeff.Wu@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>
Subject: RE: [PATCH] acpi:apd:add AMD ACPI2Platform device support for x86
 system.
Thread-Topic: [PATCH] acpi:apd:add AMD ACPI2Platform device support for x86
 system.
Thread-Index: AQHQAvYgXIrCrtqy70GE81FMEpghO5xufEOAgACAwSA=
Date: Mon, 24 Nov 2014 01:02:30 +0000
Message-ID: <4AC89B18A26BAB43B540DB1C94E2802C05A48D06@scybexdag03.amd.com>
References: <1416290291-5802-1-git-send-email-Ken.Xue@amd.com>
 <20864469.6Ozf1NSibZ@vostro.rjw.lan>
In-Reply-To: <20864469.6Ozf1NSibZ@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.96]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(377454003)(199003)(51704005)(24454002)(189002)(4396001)(85806002)(97736003)(84676001)(68736004)(92566001)(46102003)(99396003)(101416001)(92726001)(50466002)(44976005)(19580405001)(19580395003)(33656002)(110136001)(64706001)(47776003)(20776003)(87936001)(2656002)(86362001)(50986999)(76176999)(54356999)(95666004)(31966008)(106116001)(120916001)(53416004)(77156002)(62966003)(23676002)(105586002)(55846006)(21056001)(107046002)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Forefront-PRVS: 040513D301
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ken.Xue@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB456;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAO2a5XC027820


On Tuesday, November 18, 2014 01:58:11 PM Ken Xue wrote:
> This new feature is to interpret AMD specific ACPI device to platform 
> device such as I2C, UART found on AMD CZ and later chipsets. It is 
> based on example INTEL LPSS. Now, it can support AMD I2C & UART.
> 
> Signed-off-by: Ken Xue <Ken.Xue@amd.com>
> Signed-off-by: Jeff Wu <Jeff.Wu@amd.com>

Generally speaking, this seems to duplicate much code from acpi_lpss which should be re-used instead.  What about moving the code that will be common between acpi_lpss and the new driver into a new file (say acpi_soc.c)?

Also, you need to avoid automatic creation of platform devices when !X86_AMD_PLATFORM_DEVICE in analogy with what acpi_lpss does, or bad things will happen.

[ken] sounds fair enough.  Let me take action to merge drivers to acpi_soc.c ? or you have other plan?

[...]
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
