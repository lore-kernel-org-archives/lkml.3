Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3H3QGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:06:44 -0400
Received: from ns.iliad.fr ([212.27.33.1]:49944 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab3H3QGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:06:43 -0400
Message-ID: <1377878801.559.28.camel@sakura.staff.proxad.net>
Subject: [PATCH] pstore/ram: (really) fix undefined usage of
 rounddown_pow_of_two
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 30 Aug 2013 18:06:41 +0200
Organization: Freebox
Content-Type: text/plain; charset="ANSI_X3.4-1968"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous attempt to fix was b042e47491ba5f487601b5141a3f1d8582304170

Suggested use of is_power_of_2() was bogus because is_power_of_2(0) is
false (documented behaviour).

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
---
 fs/pstore/ram.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index a6119f9..03325bc 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -400,11 +400,11 @@ static int ramoops_probe(struct platform_device *pdev)
 		goto fail_out;
 	}
 
-	if (!is_power_of_2(pdata->record_size))
+	if (pdata->record_size && !is_power_of_2(pdata->record_size))
 		pdata->record_size = rounddown_pow_of_two(pdata->record_size);
-	if (!is_power_of_2(pdata->console_size))
+	if (pdata->console_size && !is_power_of_2(pdata->console_size))
 		pdata->console_size = rounddown_pow_of_two(pdata->console_size);
-	if (!is_power_of_2(pdata->ftrace_size))
+	if (pdata->ftrace_size && !is_power_of_2(pdata->ftrace_size))
 		pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
 
 	cxt->dump_read_cnt = 0;
-- 
1.7.9.5


-- 
Maxime


