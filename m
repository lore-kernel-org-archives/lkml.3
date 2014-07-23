Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbaGWGbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:31:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:29274 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbaGWGbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:31:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,715,1400050800"; 
   d="scan'208";a="574040590"
Message-ID: <53CF56AD.5090902@intel.com>
Date: Wed, 23 Jul 2014 14:31:09 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        mnipxh <mnipxh@gmail.com>
Subject: [PATCH] tty/n_gsm.c: get gsm->num after gsm_activate_mux
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gsm->num is the index of gsm_mux[], it's invalid before calling gsm_activate_mux.

Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
---
 drivers/tty/n_gsm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 2ebe47b..81e7ccb 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2230,8 +2230,7 @@ static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
 
 static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 {
-	int ret, i;
-	int base = gsm->num << 6; /* Base for this MUX */
+	int ret, i, base;
 
 	gsm->tty = tty_kref_get(tty);
 	gsm->output = gsmld_output;
@@ -2241,6 +2240,7 @@ static int gsmld_attach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 	else {
 		/* Don't register device 0 - this is the control channel and not
 		   a usable tty interface */
+		base = gsm->num << 6; /* Base for this MUX */
 		for (i = 1; i < NUM_DLCI; i++)
 			tty_register_device(gsm_tty_driver, base + i, NULL);
 	}
-- 
1.7.9.5
