Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaFXVms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:42:48 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:48722 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaFXVmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:42:46 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Kosina <jkosina@suse.cz>, Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH 1/2] [media] Remove checks of struct member addresses
Date: Tue, 24 Jun 2014 23:42:27 +0200
Message-Id: <1403646148-25385-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes checks of struct member addresses since they likely result
in the condition always being true. Also in the stb6100_get_bandwidth
and tda8261_get_bandwidth functions the pointers frontend_ops and
tuner_ops are assigned the same addresses twice.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/media/dvb-frontends/stb6100_cfg.h  |   30 +++++++-----------------
 drivers/media/dvb-frontends/stb6100_proc.h |   34 ++++++++--------------------
 drivers/media/dvb-frontends/stv0367.c      |    9 ++------
 drivers/media/dvb-frontends/tda8261_cfg.h  |   21 ++++-------------
 4 files changed, 25 insertions(+), 69 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb6100_cfg.h b/drivers/media/dvb-frontends/stb6100_cfg.h
index 6314d18..0e10ad89 100644
--- a/drivers/media/dvb-frontends/stb6100_cfg.h
+++ b/drivers/media/dvb-frontends/stb6100_cfg.h
@@ -21,15 +21,11 @@
 
 static int stb6100_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	struct dvb_frontend_ops	*frontend_ops = NULL;
-	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
+	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
 	struct tuner_state	t_state;
 	int err = 0;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
 	if (tuner_ops->get_state) {
 		if ((err = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &t_state)) < 0) {
 			printk("%s: Invalid parameter\n", __func__);
@@ -42,16 +38,13 @@ static int stb6100_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static int stb6100_set_frequency(struct dvb_frontend *fe, u32 frequency)
 {
-	struct dvb_frontend_ops	*frontend_ops = NULL;
-	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
+	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
 	struct tuner_state	t_state;
 	int err = 0;
 
 	t_state.frequency = frequency;
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
+
 	if (tuner_ops->set_state) {
 		if ((err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &t_state)) < 0) {
 			printk("%s: Invalid parameter\n", __func__);
@@ -68,10 +61,6 @@ static int stb6100_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 	struct tuner_state	t_state;
 	int err = 0;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
 	if (tuner_ops->get_state) {
 		if ((err = tuner_ops->get_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state)) < 0) {
 			printk("%s: Invalid parameter\n", __func__);
@@ -84,16 +73,13 @@ static int stb6100_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 
 static int stb6100_set_bandwidth(struct dvb_frontend *fe, u32 bandwidth)
 {
-	struct dvb_frontend_ops	*frontend_ops = NULL;
-	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
+	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
 	struct tuner_state	t_state;
 	int err = 0;
 
 	t_state.bandwidth = bandwidth;
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
+
 	if (tuner_ops->set_state) {
 		if ((err = tuner_ops->set_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state)) < 0) {
 			printk("%s: Invalid parameter\n", __func__);
diff --git a/drivers/media/dvb-frontends/stb6100_proc.h b/drivers/media/dvb-frontends/stb6100_proc.h
index 112163a..bd8a0ec 100644
--- a/drivers/media/dvb-frontends/stb6100_proc.h
+++ b/drivers/media/dvb-frontends/stb6100_proc.h
@@ -19,15 +19,11 @@
 
 static int stb6100_get_freq(struct dvb_frontend *fe, u32 *frequency)
 {
-	struct dvb_frontend_ops	*frontend_ops = NULL;
-	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
+	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
 	struct tuner_state	state;
 	int err = 0;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
 	if (tuner_ops->get_state) {
 		if (frontend_ops->i2c_gate_ctrl)
 			frontend_ops->i2c_gate_ctrl(fe, 1);
@@ -49,16 +45,13 @@ static int stb6100_get_freq(struct dvb_frontend *fe, u32 *frequency)
 
 static int stb6100_set_freq(struct dvb_frontend *fe, u32 frequency)
 {
-	struct dvb_frontend_ops	*frontend_ops = NULL;
-	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
+	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
 	struct tuner_state	state;
 	int err = 0;
 
 	state.frequency = frequency;
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
+
 	if (tuner_ops->set_state) {
 		if (frontend_ops->i2c_gate_ctrl)
 			frontend_ops->i2c_gate_ctrl(fe, 1);
@@ -79,15 +72,11 @@ static int stb6100_set_freq(struct dvb_frontend *fe, u32 frequency)
 
 static int stb6100_get_bandw(struct dvb_frontend *fe, u32 *bandwidth)
 {
-	struct dvb_frontend_ops	*frontend_ops = NULL;
-	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
+	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
 	struct tuner_state	state;
 	int err = 0;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
 	if (tuner_ops->get_state) {
 		if (frontend_ops->i2c_gate_ctrl)
 			frontend_ops->i2c_gate_ctrl(fe, 1);
@@ -109,16 +98,13 @@ static int stb6100_get_bandw(struct dvb_frontend *fe, u32 *bandwidth)
 
 static int stb6100_set_bandw(struct dvb_frontend *fe, u32 bandwidth)
 {
-	struct dvb_frontend_ops	*frontend_ops = NULL;
-	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
+	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
 	struct tuner_state	state;
 	int err = 0;
 
 	state.bandwidth = bandwidth;
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
+
 	if (tuner_ops->set_state) {
 		if (frontend_ops->i2c_gate_ctrl)
 			frontend_ops->i2c_gate_ctrl(fe, 1);
diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 4587727..59b6e66 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -922,18 +922,13 @@ static int stv0367ter_gate_ctrl(struct dvb_frontend *fe, int enable)
 
 static u32 stv0367_get_tuner_freq(struct dvb_frontend *fe)
 {
-	struct dvb_frontend_ops	*frontend_ops = NULL;
-	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
+	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
 	u32 freq = 0;
 	int err = 0;
 
 	dprintk("%s:\n", __func__);
 
-
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
 	if (tuner_ops->get_frequency) {
 		err = tuner_ops->get_frequency(fe, &freq);
 		if (err < 0) {
diff --git a/drivers/media/dvb-frontends/tda8261_cfg.h b/drivers/media/dvb-frontends/tda8261_cfg.h
index 4671074..7de65c3 100644
--- a/drivers/media/dvb-frontends/tda8261_cfg.h
+++ b/drivers/media/dvb-frontends/tda8261_cfg.h
@@ -19,15 +19,11 @@
 
 static int tda8261_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
-	struct dvb_frontend_ops	*frontend_ops = NULL;
-	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
+	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
 	struct tuner_state	t_state;
 	int err = 0;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
 	if (tuner_ops->get_state) {
 		if ((err = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &t_state)) < 0) {
 			printk("%s: Invalid parameter\n", __func__);
@@ -41,16 +37,13 @@ static int tda8261_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static int tda8261_set_frequency(struct dvb_frontend *fe, u32 frequency)
 {
-	struct dvb_frontend_ops	*frontend_ops = NULL;
-	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
+	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
 	struct tuner_state	t_state;
 	int err = 0;
 
 	t_state.frequency = frequency;
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
+
 	if (tuner_ops->set_state) {
 		if ((err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &t_state)) < 0) {
 			printk("%s: Invalid parameter\n", __func__);
@@ -68,10 +61,6 @@ static int tda8261_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 	struct tuner_state	t_state;
 	int err = 0;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
 	if (tuner_ops->get_state) {
 		if ((err = tuner_ops->get_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state)) < 0) {
 			printk("%s: Invalid parameter\n", __func__);
-- 
1.7.10.4

