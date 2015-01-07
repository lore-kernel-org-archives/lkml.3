Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbbAGCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:16:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577AbbAGCQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.17 07/73] mfd: twl4030-power: Fix regression with missing compatible flag
Date: Tue,  6 Jan 2015 18:15:28 -0800
Message-Id: <20150107021557.750788879@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 1b9b46d05f887aec418b3a5f4f55abf79316fcda upstream.

Commit e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset
configuration") accidentally removed the compatible flag for
"ti,twl4030-power" that should be there as documented in the
binding.

If "ti,twl4030-power" only the poweroff configuration is done
by the driver.

Fixes: e7cd1d1eb16f ("mfd: twl4030-power: Add generic reset configuration")
Reported-by: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/twl4030-power.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -828,6 +828,9 @@ static struct twl4030_power_data osc_off
 
 static struct of_device_id twl4030_power_of_match[] = {
 	{
+		.compatible = "ti,twl4030-power",
+	},
+	{
 		.compatible = "ti,twl4030-power-reset",
 		.data = &omap3_reset,
 	},


