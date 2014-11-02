Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaKBSKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 13:10:50 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48780 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaKBSKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 13:10:47 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18fny2vaIg5zA3nl/4/bsO6
Date: Sun, 2 Nov 2014 10:09:38 -0800
From: Tony Lindgren <tony@atomide.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH] mfd: twl4030-power: Fix regression with missing compatible
 flag
Message-ID: <20141102180938.GI31454@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
configuration") accidentally removed the compatible flag for
"ti,twl4030-power" that should be there as documented in the
binding.

If "ti,twl4030-power" only the poweroff configuration is done
by the driver.

Fixes: e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset configuration")
Cc: stable@vger.kernel.org # v3.16+
Reported-by: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -831,6 +831,9 @@ static struct twl4030_power_data osc_off_idle = {
 
 static struct of_device_id twl4030_power_of_match[] = {
 	{
+		.compatible = "ti,twl4030-power",
+	},
+	{
 		.compatible = "ti,twl4030-power-reset",
 		.data = &omap3_reset,
 	},
