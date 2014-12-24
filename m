Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaLXIh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 03:37:59 -0500
Received: from mail-bn1on0086.outbound.protection.outlook.com ([157.56.110.86]:55040
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752288AbaLXIhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:37:55 -0500
X-Greylist: delayed 899 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Dec 2014 03:37:55 EST
From: <thloh@altera.com>
To: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>
CC: Dinh Nguyen <dinguyen@altera.com>, Tien Hock Loh <thloh@altera.com>
Subject: [PATCH v8 0/2] drivers/gpio: Altera soft IP GPIO driver
Date: Wed, 24 Dec 2014 00:22:23 -0800
Message-ID: <1419409345-8297-1-git-send-email-thloh@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=thloh@altera.com; 
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(87936001)(229853001)(107046002)(2201001)(86152002)(86362001)(105596002)(68736005)(36756003)(106466001)(42186005)(92566001)(50466002)(84676001)(33646002)(89996001)(19580405001)(19580395003)(120916001)(6806004)(50986999)(77156002)(62966003)(31966008)(50226001)(97736003)(48376002)(21056001)(99396003)(64706001)(47776003)(20776003)(46102003)(4396001)(7099022)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB218;H:sj-itexedge03.altera.priv.altera.com;FPR:;SPF:SoftFail;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB218;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR03MB218;
X-Forefront-PRVS: 04359FAD81
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR03MB218;
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2014 08:22:34.8978
 (UTC)
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fbd72e03-d4a5-4110-adce-614d51f2077a;Ip=[66.35.236.227]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR03MB218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tien Hock Loh <thloh@altera.com>

Adds a new device tree binding and driver for Altera soft GPIO IP.
The driver is able to do read/write and allows GPIO to be a interrupt
controller.

Tested on Altera GHRD on interrupt handling and IO.

v8:
Using for_each_set_bit
added const for struct definition
removed naggy pr_err
changed from
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

 .../devicetree/bindings/gpio/gpio-altera.txt       |   43 ++
 MAINTAINERS                                        |    6 +
 drivers/gpio/Kconfig                               |    8 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-altera.c                         |  410 ++++++++++++++++++++
 5 files changed, 468 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-altera.txt
 create mode 100644 drivers/gpio/gpio-altera.c

