Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaFXVnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:43:04 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35694 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaFXVmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:42:47 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Kosina <jkosina@suse.cz>, Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 2/2] [media] Cleanup line > 80 character violations
Date: Tue, 24 Jun 2014 23:42:28 +0200
Message-Id: <1403646148-25385-2-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403646148-25385-1-git-send-email-emilgoode@gmail.com>
References: <1403646148-25385-1-git-send-email-emilgoode@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up some line over 80 character violations.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/media/dvb-frontends/stb6100_cfg.h |   12 ++++++++----
 drivers/media/dvb-frontends/tda8261_cfg.h |    9 ++++++---
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb6100_cfg.h b/drivers/media/dvb-frontends/stb6100_cfg.h
index 0e10ad89..6edc153 100644
--- a/drivers/media/dvb-frontends/stb6100_cfg.h
+++ b/drivers/media/dvb-frontends/stb6100_cfg.h
@@ -27,7 +27,8 @@ static int stb6100_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	int err = 0;
 
 	if (tuner_ops->get_state) {
-		if ((err = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &t_state)) < 0) {
+		err = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &t_state);
+		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
@@ -46,7 +47,8 @@ static int stb6100_set_frequency(struct dvb_frontend *fe, u32 frequency)
 	t_state.frequency = frequency;
 
 	if (tuner_ops->set_state) {
-		if ((err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &t_state)) < 0) {
+		err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &t_state);
+		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
@@ -62,7 +64,8 @@ static int stb6100_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 	int err = 0;
 
 	if (tuner_ops->get_state) {
-		if ((err = tuner_ops->get_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state)) < 0) {
+		err = tuner_ops->get_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state);
+		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
@@ -81,7 +84,8 @@ static int stb6100_set_bandwidth(struct dvb_frontend *fe, u32 bandwidth)
 	t_state.bandwidth = bandwidth;
 
 	if (tuner_ops->set_state) {
-		if ((err = tuner_ops->set_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state)) < 0) {
+		err = tuner_ops->set_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state);
+		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
diff --git a/drivers/media/dvb-frontends/tda8261_cfg.h b/drivers/media/dvb-frontends/tda8261_cfg.h
index 7de65c3..04a19e1 100644
--- a/drivers/media/dvb-frontends/tda8261_cfg.h
+++ b/drivers/media/dvb-frontends/tda8261_cfg.h
@@ -25,7 +25,8 @@ static int tda8261_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	int err = 0;
 
 	if (tuner_ops->get_state) {
-		if ((err = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &t_state)) < 0) {
+		err = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &t_state);
+		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
@@ -45,7 +46,8 @@ static int tda8261_set_frequency(struct dvb_frontend *fe, u32 frequency)
 	t_state.frequency = frequency;
 
 	if (tuner_ops->set_state) {
-		if ((err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &t_state)) < 0) {
+		err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &t_state);
+		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
@@ -62,7 +64,8 @@ static int tda8261_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 	int err = 0;
 
 	if (tuner_ops->get_state) {
-		if ((err = tuner_ops->get_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state)) < 0) {
+		err = tuner_ops->get_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state);
+		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
-- 
1.7.10.4

