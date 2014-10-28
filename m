Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaJ1DhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:37:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbaJ1DhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 035/146] regulator: ltc3589: fix broken voltage transitions
Date: Tue, 28 Oct 2014 11:32:57 +0800
Message-Id: <20141028033344.950022964@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Trumtrar <s.trumtrar@pengutronix.de>

commit c5bb725ac2d1a13e9e766bf9a16bac986ade17cd upstream.

VCCR is used as a trigger to start voltage transitions, so
we need to mark it volatile in order to make sure it gets
written to hardware every time we set a new voltage.

Fixes regulator voltage being stuck at the first voltage
set after driver load.

[lst: reworded commit message]
Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/ltc3589.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/regulator/ltc3589.c
+++ b/drivers/regulator/ltc3589.c
@@ -372,6 +372,7 @@ static bool ltc3589_volatile_reg(struct
 	switch (reg) {
 	case LTC3589_IRQSTAT:
 	case LTC3589_PGSTAT:
+	case LTC3589_VCCR:
 		return true;
 	}
 	return false;


