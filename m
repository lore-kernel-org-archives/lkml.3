Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaAWN0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:26:05 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51379 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaAWN0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:26:03 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-24-52e1186890e2
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Jason Baron <jbaron@akamai.com>
Cc: linux-kernel@vger.kernel.org, Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH 1/3] dynamic_debug: remove wrong error message
Date: Thu, 23 Jan 2014 17:20:30 +0400
Message-id: <1390483232-7160-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHJMWRmVeSWpSXmKPExsVy+t/xy7oZEg+DDI6vELHY9usRm8WMxcdZ
	LS7vmsPmwOwx+cgCZo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DK2PTpG1vBQ7aKVS8+sTUw
	bmLtYuTkkBAwkTj29jSULSZx4d56ti5GLg4hgaWMErd3XGSHcHqYJGb+esMCUsUmoCfxb9Z2
	NhBbREBZ4srHG2DdzAJeEhuvLmXqYuTgEBawk1g+2wzEZBFQlTh+RxGkglfAVeL5k24miF0K
	Esu+rGWewMi9gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkaIn7/sYFx8zOoQowAHoxIP
	b8KX+0FCrIllxZW5hxglOJiVRHhz2R8GCfGmJFZWpRblxxeV5qQWH2Jk4uCUamBk5VHk086R
	kzuuzCb94eTDb7faJC9IVdtUNN1cEP2+LLK3Rd13Q7jgiTJjwXR3W62725WNTZzNw1a91dCY
	GDR9+2S/0rS8/U15/4unODxmvR+wxvuhXPmKLbonzJzn1ghc5tf7EZEdaHj82tvHL4MDXoSc
	uVcv3VuvKe+7R2lHaxz3FmdHbiWW4oxEQy3mouJEAC2iIJTRAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parse_lineno() returns either negative error code or zero.
We don't need to print something here because if parse_lineno
fails it will print error message.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 lib/dynamic_debug.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 600ac57..f959c39 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -348,10 +348,8 @@ static int ddebug_parse_query(char *words[], int nwords,
 			}
 			if (last)
 				*last++ = '\0';
-			if (parse_lineno(first, &query->first_lineno) < 0) {
-				pr_err("line-number is <0\n");
+			if (parse_lineno(first, &query->first_lineno) < 0)
 				return -EINVAL;
-			}
 			if (last) {
 				/* range <first>-<last> */
 				if (parse_lineno(last, &query->last_lineno)
-- 
1.8.3.2

