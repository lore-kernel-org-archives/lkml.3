Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3JaShx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab3JaShw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:37:52 -0400
Date: Thu, 31 Oct 2013 19:28:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: David Long <dave.long@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] uprobes: Kill module_init() and module_exit()
Message-ID: <20131031182822.GA11891@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn module_init() into __initcall() and kill module_exit().

This code can't be compiled as a module so these module_*()
calls only add the confusion, especially if arch-dependant
code needs its own initialization hooks.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ae9e1d2..0012c8e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1941,9 +1941,4 @@ static int __init init_uprobes(void)
 
 	return register_die_notifier(&uprobe_exception_nb);
 }
-module_init(init_uprobes);
-
-static void __exit exit_uprobes(void)
-{
-}
-module_exit(exit_uprobes);
+__initcall(init_uprobes);
-- 
1.5.5.1


