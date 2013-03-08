Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab3CHHeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:34:08 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48478 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab3CHHeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:34:07 -0500
X-AuditID: 85900ec0-d2ec7b900000151e-fc-5139946c0061
Message-ID: <51399409.4090207@hitachi.com>
Date: Fri, 08 Mar 2013 16:32:25 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: unknown
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 0/2] [GIT PULL][3.9] tracing: Fix in snapshot API
References: <20130307153442.755353831@goodmis.org>
In-Reply-To: <20130307153442.755353831@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

(03/08/2013 12:34 AM), Steven Rostedt wrote:
> The second patch, returns success on a reset of the buffer even if
> the buffer wasn't allocated. Returning -EINVAL is just confusing.

I realized we should update the snapshot documentation together with
this change.
I attached a patch to update the documentation. Could you include this
patch?

Thanks,
Hiraku Toyooka


From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH] tracing: update documentation of snapshot utility

Now, "snapshot" file returns success on a reset of snapshot buffer
even if the buffer wasn't allocated, instead of returning EINVAL.
This patch updates snapshot desctiption according to the change.

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
---
  Documentation/trace/ftrace.txt | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 53d6a3c..a372304 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1873,7 +1873,7 @@ feature:

  	status\input  |     0      |     1      |    else    |
  	--------------+------------+------------+------------+
-	not allocated |(do nothing)| alloc+swap |   EINVAL   |
+	not allocated |(do nothing)| alloc+swap |(do nothing)|
  	--------------+------------+------------+------------+
  	allocated     |    free    |    swap    |   clear    |
  	--------------+------------+------------+------------+
-- 
1.7.11.7

