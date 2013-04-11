Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340Ab3DKMSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:18:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40964 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3DKMSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:18:33 -0400
Date: Thu, 11 Apr 2013 05:18:10 -0700
From: tip-bot for Martin Bundgaard <tipbot@zytor.com>
Message-ID: <tip-7e9a2f0a080ba2f247559e95eb0df7072bede18a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        martin@mindflux.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        martin@mindflux.org, tglx@linutronix.de
In-Reply-To: <1363286075-62615-1-git-send-email-martin@mindflux.org>
References: <1363286075-62615-1-git-send-email-martin@mindflux.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm/numa: Simplify some bit mangling
Git-Commit-ID: 7e9a2f0a080ba2f247559e95eb0df7072bede18a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 11 Apr 2013 05:18:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e9a2f0a080ba2f247559e95eb0df7072bede18a
Gitweb:     http://git.kernel.org/tip/7e9a2f0a080ba2f247559e95eb0df7072bede18a
Author:     Martin Bundgaard <martin@mindflux.org>
AuthorDate: Thu, 14 Mar 2013 19:34:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 19:06:26 +0200

x86/mm/numa: Simplify some bit mangling

Minor. Reordered a few lines to lose a superfluous OR operation.

Signed-off-by: Martin Bundgaard <martin@mindflux.org>
Link: http://lkml.kernel.org/r/1363286075-62615-1-git-send-email-martin@mindflux.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/amdtopology.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/mm/amdtopology.c b/arch/x86/mm/amdtopology.c
index 5247d01..2ca15b5 100644
--- a/arch/x86/mm/amdtopology.c
+++ b/arch/x86/mm/amdtopology.c
@@ -130,9 +130,8 @@ int __init amd_numa_init(void)
 		}
 
 		limit >>= 16;
-		limit <<= 24;
-		limit |= (1<<24)-1;
 		limit++;
+		limit <<= 24;
 
 		if (limit > end)
 			limit = end;
