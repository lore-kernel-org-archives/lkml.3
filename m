Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3J3Lq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:46:29 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:45450 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3J3Lq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:46:28 -0400
Date: Wed, 30 Oct 2013 12:46:24 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: [PATCH] Fix build without CONFIG_INPUT_LEDS [Was: mmotm
 2013-10-29-16-22 uploaded (input)]
Message-ID: <20131030114624.GY5442@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
References: <20131029232351.D2E6F31C173@corp2gmr1-1.hot.corp.google.com>
 <52706790.9090602@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52706790.9090602@infradead.org>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap, le Tue 29 Oct 2013 18:57:36 -0700, a écrit :
> arc_ps2.c:(.text+0x500): multiple definition of `input_led_connect'

D'oh.  I indeed hadn't tested the inlines, sorry about this.

Andrew, could you add the following patch on top of
input-route-kbd-leds-through-the-generic-leds-layer.patch
or perhaps rather fold into it?

Samuel



Really mark inlines as static inlines, so they are not defined multiple
times.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- include/linux/input.h.orig	2013-10-30 12:42:41.169038670 +0100
+++ include/linux/input.h	2013-10-30 12:42:42.908987157 +0100
@@ -540,12 +540,12 @@
 
 #else
 
-int input_led_connect(struct input_dev *dev)
+static inline int input_led_connect(struct input_dev *dev)
 {
 	return 0;
 }
 
-void input_led_disconnect(struct input_dev *dev)
+static inline void input_led_disconnect(struct input_dev *dev)
 {
 }
 
