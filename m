Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab3DJDIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:08:44 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:46047 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab3DJDIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:08:41 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 2/3] pstore ram: remove the power of buffer size limitation
Date: Tue,  9 Apr 2013 22:08:16 -0500
Message-Id: <1365563297-12480-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365563297-12480-1-git-send-email-robherring2@gmail.com>
References: <1365563297-12480-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

There doesn't appear to be any reason for the overall pstore RAM buffer to
be a power of 2 size, so remove it. The individual console, ftrace and oops
buffers are still a power of 2 size.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
---
 fs/pstore/ram.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 288f068..f980077 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -391,8 +391,6 @@ static int ramoops_probe(struct platform_device *pdev)
 		goto fail_out;
 	}
 
-	if (!is_power_of_2(pdata->mem_size))
-		pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
 	if (!is_power_of_2(pdata->record_size))
 		pdata->record_size = rounddown_pow_of_two(pdata->record_size);
 	if (!is_power_of_2(pdata->console_size))
-- 
1.7.10.4

