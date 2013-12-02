Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab3LBUbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:31:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3LBTOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Koch <johannes@ortsraum.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.10 170/173] media: cx23885: Fix TeVii S471 regression since introduction of ts2020
Date: Mon,  2 Dec 2013 11:12:33 -0800
Message-Id: <20131202191202.512720142@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Koch <johannes@ortsraum.de>

commit b43ea8068d2090cb1e44632c8a938ab40d2c7419 upstream.

Patch to make TeVii S471 cards use the ts2020 tuner, since ds3000 driver no
longer contains tuning code.

Signed-off-by: Johannes Koch <johannes@ortsraum.de>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/cx23885/cx23885-dvb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1249,6 +1249,10 @@ static int dvb_register(struct cx23885_t
 		fe0->dvb.frontend = dvb_attach(ds3000_attach,
 					&tevii_ds3000_config,
 					&i2c_bus->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(ts2020_attach, fe0->dvb.frontend,
+				&tevii_ts2020_config, &i2c_bus->i2c_adap);
+		}
 		break;
 	case CX23885_BOARD_PROF_8000:
 		i2c_bus = &dev->i2c_bus[0];


