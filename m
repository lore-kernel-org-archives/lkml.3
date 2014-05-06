Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbaEFLvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:51:33 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:51079 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbaEFLut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:50:49 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] cgroup: only allow space as the separator for "cgroup.subtree_control"
Date: Tue,  6 May 2014 07:50:42 -0400
Message-Id: <1399377044-29873-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399377044-29873-1-git-send-email-tj@kernel.org>
References: <1399377044-29873-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was confused that strsep() was equivalent to strtok_r() in skipping
over consecutive delimiters.  strsep() just splits at the first
occurrence of one of the delimiters which makes the parsing very
inflexible, which makes allowing multiple whitespace chars as
delimters kinda moot.  Let's just be consistently strict and require
list of tokens separated by a single space.  This is what
Documentation/cgroups/unified-hierarchy.txt describes too.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 54fd12d..9066fe9 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2542,11 +2542,11 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 	int ssid, ret;
 
 	/*
-	 * Parse input - white space separated list of subsystem names
-	 * prefixed with either + or -.
+	 * Parse input - space separated list of subsystem names prefixed
+	 * with either + or -.
 	 */
 	p = buffer;
-	while ((tok = strsep(&p, " \t\n"))) {
+	while ((tok = strsep(&p, " "))) {
 		for_each_subsys(ss, ssid) {
 			if (ss->disabled || strcmp(tok + 1, ss->name))
 				continue;
-- 
1.9.0

