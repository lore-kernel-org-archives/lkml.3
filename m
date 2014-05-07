Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaEGUhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:37:43 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:63514 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbaEGUhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:37:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQXAE2YalNXQBiQ/2dsb2JhbABagwaCQXyoawoFAZoKAgKBHRd0gmYcIxiBAiQTiEUB0DOFVoh8hEYBA48bihsBiwCHe4M2Ow
Date: Wed, 7 May 2014 22:37:32 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>
Subject: [PATCH 1/1] kernel/res_counter.c: replace simple_strtoull by
 kstrtoull
Message-Id: <20140507223732.2e9fa81810ce05b72247556c@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/res_counter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 51dbac6..09c1a6a 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -183,11 +183,12 @@ int res_counter_memparse_write_strategy(const char *buf,
 {
 	char *end;
 	unsigned long long res;
+	int rc;
 
 	/* return RES_COUNTER_MAX(unlimited) if "-1" is specified */
 	if (*buf == '-') {
-		res = simple_strtoull(buf + 1, &end, 10);
-		if (res != 1 || *end != '\0')
+		rc = kstrtoull(buf + 1, 10, &res);
+		if ((res != 1) || (rc))
 			return -EINVAL;
 		*resp = RES_COUNTER_MAX;
 		return 0;
-- 
1.8.4.5

