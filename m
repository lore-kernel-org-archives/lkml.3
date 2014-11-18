Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaKRHpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:45:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49557 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaKRHp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:45:26 -0500
Date: Tue, 18 Nov 2014 10:44:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Ionut Alexa <ionut.m.alexa@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] exit: silence a bogus static checker warning
Message-ID: <20141118074422.GA17829@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains about this:

	kernel/exit.c:543 forget_original_parent()
	warn: add some parenthesis here?

I don't normally advocate changing the code to make the static checker
happy but these are normally precedence bugs so I think it's ok to put
parenthesis so it's clear the code is deliberate.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/exit.c b/kernel/exit.c
index 6192422..1192d12 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -540,7 +540,7 @@ static void forget_original_parent(struct task_struct *father)
 	list_for_each_entry(p, &father->children, sibling) {
 		for_each_thread(p, t) {
 			t->real_parent = reaper;
-			BUG_ON(!t->ptrace != (t->parent == father));
+			BUG_ON((!t->ptrace) != (t->parent == father));
 			if (likely(!t->ptrace))
 				t->parent = t->real_parent;
 			if (t->pdeath_signal)
