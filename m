Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3DAD23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 23:28:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45170 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756547Ab3DAD21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 23:28:27 -0400
Date: Sun, 31 Mar 2013 20:24:29 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>,
        Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 1/3] pstore/ram: Include ecc_size when calculating ecc_block
Message-ID: <20130401032429.GA17424@lizard>
References: <20130401032256.GA13801@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130401032256.GA13801@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Wastes less memory and allows using more memory for ecc than data.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
[jstultz: Tweaked commit subject]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Anton Vorontsov <anton@enomsg.org>
---
 fs/pstore/ram_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 0306303..e5afa22 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -187,7 +187,8 @@ static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
 	prz->ecc_block_size = 128;
 	prz->ecc_size = ecc_size;
 
-	ecc_blocks = DIV_ROUND_UP(prz->buffer_size, prz->ecc_block_size);
+	ecc_blocks = DIV_ROUND_UP(prz->buffer_size - prz->ecc_size,
+				  prz->ecc_block_size + prz->ecc_size);
 	ecc_total = (ecc_blocks + 1) * prz->ecc_size;
 	if (ecc_total >= prz->buffer_size) {
 		pr_err("%s: invalid ecc_size %u (total %zu, buffer size %zu)\n",
-- 
1.8.1.4

