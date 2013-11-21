Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3KUPf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:35:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47070 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3KUPf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:35:57 -0500
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
CC: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: RE: [PATCH] clk: keystone: gate: don't use reserved bits
Thread-Topic: [PATCH] clk: keystone: gate: don't use reserved bits
Thread-Index: AQHO5s6xpXrHLpwJlEqKkQLqMdCP/Zov0Il3
Date: Thu, 21 Nov 2013 15:35:29 +0000
Message-ID: <448912EABC71F84BBCADFD3C67C4BE52965812@DBDE04.ent.ti.com>
References: <1385047851-14407-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1385047851-14407-1-git-send-email-ivan.khoronzhuk@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.56]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for top posting. The user-guide is not upto date....

State
4:0
R
Actual state
Current Power Domain State. 
Only PSM states Off and On are “key states” that users should consider in normal run time situation. States with bit 4 = 1 are transitional states helpful for debug if PSM is stuck in those states. 

Regards,
Santosh

________________________________________
From: Khoronzhuk, Ivan
Sent: Thursday, November 21, 2013 10:30 AM
To: Shilimkar, Santosh
Cc: Mike Turquette; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Strashko, Grygorii; Khoronzhuk, Ivan
Subject: [PATCH] clk: keystone: gate: don't use reserved bits

According to TRM http://www.ti.com/lit/ug/sprugv4b/sprugv4b.pdf
the Power Domain Status Register (PDSTAT) has 0-1 bits for power
domain status, but PDSTAT_STATE_MASK is defined with 0x1F. In that
case we operate with reserved bits. So correct PDSTAT_STATE_MASK
to be 0x03.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 drivers/clk/keystone/gate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/keystone/gate.c b/drivers/clk/keystone/gate.c
index 1f333bc..995ae80 100644
--- a/drivers/clk/keystone/gate.c
+++ b/drivers/clk/keystone/gate.c
@@ -35,7 +35,7 @@

 #define MDSTAT_STATE_MASK      0x3f
 #define MDSTAT_MCKOUT          BIT(12)
-#define PDSTAT_STATE_MASK      0x1f
+#define PDSTAT_STATE_MASK      0x03
 #define MDCTL_FORCE            BIT(31)
 #define MDCTL_LRESET           BIT(8)
 #define PDCTL_NEXT             BIT(0)
--
1.7.9.5

