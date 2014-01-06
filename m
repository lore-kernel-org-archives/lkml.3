Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbaAFXmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:42:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632AbaAFWj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.12 133/144] sh-pfc: Fix PINMUX_GPIO macro
Date: Mon,  6 Jan 2014 14:38:14 -0800
Message-Id: <20140106223749.162768784@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit 8620f394c4f9abd13e4fdf927d9c2bbeda74cde7 upstream.

Commit 7cbb0e55e27e ("sh-pfc: Don't duplicate argument to PINMUX_GPIO
macro") erronesouly modified the PINMUX_GPIO macro in a way that
resulted in all pins being named "name". Fix the macro to name the pins
correctly.

Cc: stable@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/sh-pfc/sh_pfc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/sh-pfc/sh_pfc.h
+++ b/drivers/pinctrl/sh-pfc/sh_pfc.h
@@ -254,7 +254,7 @@ struct sh_pfc_soc_info {
 #define PINMUX_GPIO(_pin)						\
 	[GPIO_##_pin] = {						\
 		.pin = (u16)-1,						\
-		.name = __stringify(name),				\
+		.name = __stringify(GPIO_##_pin),			\
 		.enum_id = _pin##_DATA,					\
 	}
 


