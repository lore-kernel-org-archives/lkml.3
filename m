Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaJCCHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 22:07:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbaJCCF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 22:05:56 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Subject: [PATCH 6/7] audit: remove extra audit_get_parent()
Date: Thu,  2 Oct 2014 22:05:23 -0400
Message-Id: <8034d4cbbec0ba350c8e090168b6031e25bb864a.1412285491.git.rgb@redhat.com>
In-Reply-To: <cover.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
In-Reply-To: <cover.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There appears to be an extra parent reference taken.  Remove it.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit_watch.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index c707afb..eb53bc7 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -462,7 +462,6 @@ void audit_remove_watch_rule(struct audit_krule *krule)
 		audit_remove_watch(watch);
 
 		if (list_empty(&parent->watches)) {
-			audit_get_parent(parent);
 			fsnotify_destroy_mark(&parent->mark, audit_watch_group);
 			audit_put_parent(parent);
 		}
-- 
1.7.1

