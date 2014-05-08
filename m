Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaEHRAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:00:47 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:11198 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbaEHRAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:00:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4KAPm2a1NR87v8/2dsb2JhbABZgwaCQaoiBAQBAQUBmhWBExd0gmYcIxiBAiQTiEUB0FWFVoh8hEYBA48bihwBiwCHe4M4Ow
Date: Thu, 8 May 2014 19:00:43 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>
Subject: [PATCH V2] kernel/res_counter.c: replace simple_strtoull by
 kstrtoull
Message-Id: <20140508190043.19dc5b4c127b5566b087eea6@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Andrew Morton for commenting first version.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: Suggestions by Andrew Morton
-use internal rc variable
-simplify if condition
 kernel/res_counter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index 51dbac6..f65a95c 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -186,8 +186,8 @@ int res_counter_memparse_write_strategy(const char *buf,
 
 	/* return RES_COUNTER_MAX(unlimited) if "-1" is specified */
 	if (*buf == '-') {
-		res = simple_strtoull(buf + 1, &end, 10);
-		if (res != 1 || *end != '\0')
+		int rc = kstrtoull(buf + 1, 10, &res);
+		if ((res != 1) || rc)
 			return -EINVAL;
 		*resp = RES_COUNTER_MAX;
 		return 0;
-- 
1.9.1
