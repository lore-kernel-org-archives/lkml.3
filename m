Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaHTJqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:46:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:60163 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbaHTJm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:42:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,901,1400050800"; 
   d="scan'208";a="587369895"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 07/11] wireless: hostap: proc: print properly escaped SSID
Date: Wed, 20 Aug 2014 12:42:48 +0300
Message-Id: <1408527772-27224-8-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of substituting non-printable characters by '_' let's print SSID
properly escaped by using recently added %*pE specifier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/hostap/hostap_proc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_proc.c b/drivers/net/wireless/hostap/hostap_proc.c
index 4e5c0f8..16a06b6 100644
--- a/drivers/net/wireless/hostap/hostap_proc.c
+++ b/drivers/net/wireless/hostap/hostap_proc.c
@@ -181,9 +181,7 @@ static int prism2_bss_list_proc_show(struct seq_file *m, void *v)
 		   bss->bssid, bss->last_update,
 		   bss->count, bss->capab_info);
 
-	for (i = 0; i < bss->ssid_len; i++)
-		seq_putc(m,bss->ssid[i] >= 32 && bss->ssid[i] < 127 ?
-			   bss->ssid[i] : '_');
+	seq_printf(m, "%*pE", bss->ssid_len, bss->ssid);
 
 	seq_putc(m, '\t');
 	for (i = 0; i < bss->ssid_len; i++)
-- 
2.1.0

