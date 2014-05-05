Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbaEEQsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:48:42 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:40459 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754344AbaEEQsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:48:40 -0400
Date: Mon, 5 May 2014 11:48:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: cooloney@gmail.com
cc: linux-kernel@vger.kernel.org
Subject: drivers/leds: Replace __get_cpu_var use through this_cpu_ptr
Message-ID: <alpine.DEB.2.10.1405051147520.28729@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would you merge this patch please?


Use this_cpu_ptr for the address calculation instead of __get_cpu_var.

Acked-by: Bryan Wu <cooloney@gmail.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/drivers/leds/trigger/ledtrig-cpu.c
===================================================================
--- linux.orig/drivers/leds/trigger/ledtrig-cpu.c	2014-04-14 13:24:54.833360823 -0500
+++ linux/drivers/leds/trigger/ledtrig-cpu.c	2014-04-14 13:24:54.825360977 -0500
@@ -47,7 +47,7 @@
  */
 void ledtrig_cpu(enum cpu_led_event ledevt)
 {
-	struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);
+	struct led_trigger_cpu *trig = this_cpu_ptr(&cpu_trig);

 	/* Locate the correct CPU LED */
 	switch (ledevt) {
