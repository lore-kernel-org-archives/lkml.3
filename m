Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaGVM2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:28:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbaGVM2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:28:30 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 0/2] module: add within_module() and change return type
Date: Tue, 22 Jul 2014 14:28:08 +0200
Message-Id: <1406032090-16151-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The condition (within_module_init() || within_module_core()) is used on several
locations. We would like to use it also in kGraft when patching modules.

This small patch set introduces within_module() to do the check in one call.
It also modifies the return type from int to bool for all three functions.
It seems to be more appropriate.

The patch set is against linux-next, top commit 594a8bbcd415c ("Add linux-next
specific files for 20140721").

Petr Mladek (2):
  module: add within_module() function
  module: return bool from within_module*()

 include/linux/module.h | 11 +++++++++--
 kernel/module.c        | 12 ++++--------
 2 files changed, 13 insertions(+), 10 deletions(-)

-- 
1.8.4

