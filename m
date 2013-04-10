Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937108Ab3DJJwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:52:40 -0400
Received: from intranet.asianux.com ([58.214.24.6]:4118 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab3DJJwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:52:39 -0400
X-Spam-Score: -100.8
Message-ID: <51653645.90401@asianux.com>
Date: Wed, 10 Apr 2013 17:52:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, eparis@redhat.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: auditfilter: looping issue, memory leak if has 2
 or more AUDIT_FILTERKEYs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  in the 'fcount' looping,
    if 'new->fields[*].type" has 2 or more AUDIT_FILTERKEYs
    need judge new->filterkey whether has value, or memory leak.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/auditfilter.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f9fc54b..936ac79 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -859,6 +859,8 @@ struct audit_entry *audit_dupe_rule(struct audit_krule *old)
 						       &old->fields[i]);
 			break;
 		case AUDIT_FILTERKEY:
+			if (new->filterkey)
+				break;
 			fk = kstrdup(old->filterkey, GFP_KERNEL);
 			if (unlikely(!fk))
 				err = -ENOMEM;
-- 
1.7.7.6
