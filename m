Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3KHAEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:04:02 -0500
Received: from dmz-mailsec-scanner-1.mit.edu ([18.9.25.12]:42611 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756077Ab3KHADv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:03:51 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2013 19:03:51 EST
X-AuditID: 1209190c-b7f058e000005fd9-a8-527c29391099
Date: Thu, 7 Nov 2013 18:58:47 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] random: declare trickle_count unsigned
Message-ID: <20131107235847.GH16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsUixG6nrmupWRNk8GOxhsXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4MrYeXY2U0EzW8WESwUNjI2sXYycHBICJhINGw+yQNhiEhfurWfr
	YuTiEBKYzSRx6cRhJghnA6PEhlXPoDI/GSX+9z9m7GLk4GARUJG4t8EIpJtNQEHix/x1zCC2
	iICyxKqZm5hAbGag+K97m8C2CQvYSqyZvBpsG6+AmcTc1avZQGwhAQOJn9PfQsUFJU7OfMIC
	0aslcePfSyaQVcwC0hLL/3GAhDkFDCXam6+AjRQFumDKyW1sExgFZyHpnoWkexZC9wJG5lWM
	sim5Vbq5iZk5xanJusXJiXl5qUW6hnq5mSV6qSmlmxhBQcopybOD8c1BpUOMAhyMSjy8BReq
	g4RYE8uKK3MPMUpyMCmJ8k5UrwkS4kvKT6nMSCzOiC8qzUktPsQowcGsJML7TBEox5uSWFmV
	WpQPk5LmYFES573JYR8kJJCeWJKanZpakFoEk5Xh4FCS4J2pAdQoWJSanlqRlplTgpBm4uAE
	Gc4DNPwJyGLe4oLE3OLMdIj8KUZFKXFeI5BmAZBERmkeXC8sibxiFAd6RZj3BUg7DzABwXW/
	AhrMBDQ45FclyOCSRISUVAOj1lHGNwt4eY6ryHmXzZwVK+vmuGyHeJLLYw+GhWmrI9JbeB5Y
	7lO8Ex/8+tefhNNS/+0WBr/8kvK81uHyxsl7VDsT0pextPKZSBbI/dimUvHd9dast6pb5m8M
	iJEM13iQE331iGzW3JXB3wIs19hxbmplSXthe7bPvMl967xlDpNN1Z35r+5XYinOSDTUYi4q
	TgQAupSAGf0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cheerfully overflow these variables (at least where "int"
is 32 bits wide), so pedantically they should be unsigned.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 85f5fce..04a117a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -296,7 +296,7 @@ static int random_write_wakeup_thresh = 128;
 
 static int trickle_thresh __read_mostly = INPUT_POOL_WORDS * 28;
 
-static DEFINE_PER_CPU(int, trickle_count);
+static DEFINE_PER_CPU(unsigned int, trickle_count);
 
 /*
  * A pool of size .poolwords is stirred with a primitive polynomial
-- 
1.8.3.2

