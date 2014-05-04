Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaEDPl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaEDPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 3.14 112/158] video: atmel_lcdfb: ensure the hardware is initialized with the correct mode
Date: Sun,  4 May 2014 11:40:21 -0400
Message-Id: <20140504154045.222198988@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine.tenart@free-electrons.com>

commit 7d3477d801808a5037a511cf5a5aae5718e7ecce upstream.

If no driver takeover the atmel_lcdfb, the lcd won't be in a working state
since atmel_lcdfb_set_par() will never be called. Enabling a driver which does,
like fbcon, will call the function and put atmel_lcdfb in a working state.

Fixes: b985172b328a (video: atmel_lcdfb: add device tree suport)

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Reported-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/atmel_lcdfb.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -1298,6 +1298,12 @@ static int __init atmel_lcdfb_probe(stru
 		goto unregister_irqs;
 	}
 
+	ret = atmel_lcdfb_set_par(info);
+	if (ret < 0) {
+		dev_err(dev, "set par failed: %d\n", ret);
+		goto unregister_irqs;
+	}
+
 	dev_set_drvdata(dev, info);
 
 	/*


