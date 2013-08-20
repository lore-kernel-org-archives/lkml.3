Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3HTDj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:39:27 -0400
Received: from intranet.asianux.com ([58.214.24.6]:5101 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3HTDj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:39:26 -0400
X-Spam-Score: -101.1
Message-ID: <5212E4B2.5020708@asianux.com>
Date: Tue, 20 Aug 2013 11:38:26 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] kernel/sysctl.c: check return value after call proc_put_char()
 in __do_proc_doulongvec_minmax()
References: <5212E481.9080204@asianux.com>
In-Reply-To: <5212E481.9080204@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need check the return value of proc_put_char(), just like another have
done in __do_proc_doulongvec_minmax().

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/sysctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7822cd8..ee00986 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2214,8 +2214,11 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 			*i = val;
 		} else {
 			val = convdiv * (*i) / convmul;
-			if (!first)
+			if (!first) {
 				err = proc_put_char(&buffer, &left, '\t');
+				if (err)
+					goto free;
+			}
 			err = proc_put_long(&buffer, &left, val, false);
 			if (err)
 				break;
-- 
1.7.7.6
