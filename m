Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbbAFCgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:36:24 -0500
Received: from mail-bn1bon0083.outbound.protection.outlook.com ([157.56.111.83]:7904
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754192AbbAFCgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:36:20 -0500
From: <thloh@altera.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linus.walleij@linaro.org>, <gnurou@gmail.com>,
        <grant.likely@linaro.org>, <akpm@linux-foundation.org>,
        <davem@davemloft.net>, <gregkh@linuxfoundation.org>, <joe@perches.com>,
        <mchehab@osg.samsung.com>, <crope@iki.fi>,
        <linux-gpio@vger.kernel.org>
CC: <thloh.linux@gmail.com>, <thloh@altera.com>
Subject: [PATCH v9 0/2] Altera soft IP GPIO driver
Date: Mon, 5 Jan 2015 18:19:31 -0800
Message-ID: <1420510773-24605-1-git-send-email-thloh@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=thloh@altera.com; 
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(6009001)(199003)(189002)(105596002)(33646002)(106466001)(42186005)(89996001)(64706001)(47776003)(86362001)(19580395003)(19580405001)(87936001)(229853001)(6806004)(21056001)(46102003)(31966008)(20776003)(50986999)(92566001)(107046002)(99396003)(50226001)(4396001)(86152002)(2201001)(50466002)(97736003)(48376002)(68736005)(62966003)(36756003)(84676001)(120916001)(77156002)(7099022)(921003)(83996005)(1121003)(2101003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB222;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY2PR03MB222;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR03MB222;
X-Forefront-PRVS: 0448A97BF2
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB222;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 02:20:08.7357
 (UTC)
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fbd72e03-d4a5-4110-adce-614d51f2077a;Ip=[66.35.236.227]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR03MB222
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB238;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tien Hock Loh <thloh@altera.com>

Adds a new device tree binding and driver for Altera soft GPIO IP.
The driver is able to do read/write and allows GPIO to be a interrupt
controller.

Tested on Altera GHRD on interrupt handling and IO.

v9:
Removed duplicated initialization on set_type
using temporals to improve code readability in calling generic_handle_irq
Using ?: ternary to reduce code size

v8:
Using for_each_set_bit
added const for struct definition
removed naggy pr_err
sort alpha header
remove unused macros
use fixed width data types instead of unsigned long
whitespace issue fixes
removed _relaxed function for better compatibility across different CPU
changed irq_create_mapping to platform_get_irq
updated implementation to use gpiochip_irqchip_add
reserve interrupt-cells number 2 in device tree binding for future use
remove confusing sections on devicetree bindings
Added tristate Kconfig help text

v7:
used dev_warn instead of pr_warn
clean up unnecesarry if else indentation

v6:
Added irq_startup and irq_shutdown
changed bitwise clamping style
cleanup bitwise operation to improve readability
change naming of mapped irqs from virq to mapped_irq

v5:
dispose irq_domain mapping correctly
update optional binding description in binding docs

v4:
added vendor prefix to devicetree binding for IP specific properties
using MMIO GPIO helper library instead of manually map PIO to memory
altera_gpio_chip inline struct documentation to kerneldoc
using dev_ print to print a better failure message

v2, v3:
Do not reference NO_IRQ
Updated irq_set_type to only allow the hardware configured irq type


Tien Hock Loh (2):
  drivers/gpio: Altera soft IP GPIO driver device tree binding
  drivers/gpio: Altera soft IP GPIO driver

 .../devicetree/bindings/gpio/gpio-altera.txt       |  43 +++
 MAINTAINERS                                        |   6 +
 drivers/gpio/Kconfig                               |   8 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-altera.c                         | 405 +++++++++++++++++++++
 5 files changed, 463 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-altera.txt
 create mode 100644 drivers/gpio/gpio-altera.c

-- 
1.7.11.GIT

