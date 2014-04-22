Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaDVGio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:38:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:16603 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaDVGik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:38:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,901,1389772800"; 
   d="scan'208";a="524675473"
Message-ID: <53560E6F.9000806@linux.intel.com>
Date: Tue, 22 Apr 2014 14:38:39 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] soc_button_array: fix a crash during rmmod
References: <53560DD1.5050805@linux.intel.com>
In-Reply-To: <53560DD1.5050805@linux.intel.com>
X-Forwarded-Message-Id: <53560DD1.5050805@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system has zero or one button available, trying to rmmod
soc_button_array will cause crash. Fix this by properly handling -ENODEV
in probe().

Signed-off-by: Lejun Zhu <lejun.zhu@linux.intel.com>
---
 drivers/input/misc/soc_button_array.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/misc/soc_button_array.c
b/drivers/input/misc/soc_button_array.c
index 08ead2a..20c80f5 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -169,6 +169,7 @@ static int soc_button_pnp_probe(struct pnp_dev *pdev,
 				soc_button_remove(pdev);
 				return error;
 			}
+			continue;
 		}

 		priv->children[i] = pd;
-- 
1.8.3.2



















