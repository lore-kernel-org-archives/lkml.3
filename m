Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbbAGCk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:40:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46953 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbbAGCQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markus Pargmann <mpa@pengutronix.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 14/73] regulator: anatop: Set default voltage selector for vddpu
Date: Tue,  6 Jan 2015 18:15:35 -0800
Message-Id: <20150107021557.962162091@linuxfoundation.org>
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

From: Markus Pargmann <mpa@pengutronix.de>

commit fe08be3ec8672ed92b3ed1b85810df9fa0f98931 upstream.

The code reads the default voltage selector from its register. If the
bootloader disables the regulator, the default voltage selector will be
0 which results in faulty behaviour of this regulator driver.

This patch sets a default voltage selector for vddpu if it is not set in
the register.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/anatop-regulator.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -283,6 +283,14 @@ static int anatop_regulator_probe(struct
 			sreg->sel = 0;
 			sreg->bypass = true;
 		}
+
+		/*
+		 * In case vddpu was disabled by the bootloader, we need to set
+		 * a sane default until imx6-cpufreq was probed and changes the
+		 * voltage to the correct value. In this case we set 1.25V.
+		 */
+		if (!sreg->sel && !strcmp(sreg->name, "vddpu"))
+			sreg->sel = 22;
 	} else {
 		rdesc->ops = &anatop_rops;
 	}


