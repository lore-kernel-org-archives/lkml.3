Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbaBNQr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:47:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaBNQrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:47:55 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 0/5] printk: Use whole ring buffer + some clean up
Date: Fri, 14 Feb 2014 17:47:31 +0100
Message-Id: <1392396456-19236-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have found few small problems when working on safe printk in NMI context.
The NMI stuff still needs some love. Here is the independent stuff that is
ready to go.

1st and 5th patch do small optimizations. They remove a duplicate computation.

2nd patch removes some unused code.

3rd patch adds a comment that would have saved me some time when trying to
understand the code. Well, maybe it is useful only for kernel newbies
like me ;-)

4th patch fixes two problems from the "by-one" department. They caused that
we have newer used the last 4 bytes of the ring buffer.

Petr Mladek (5):
  printk: Remove duplicated check for log level
  printk: Remove obsolete check for log level "c"
  printk: Add comment about tricky check for text buffer size
  printk: Use also the last bytes in the ring buffer
  printk: Do not compute the size of the message twice

 include/linux/printk.h | 10 +++-------
 kernel/printk/printk.c | 13 ++++++++-----
 2 files changed, 11 insertions(+), 12 deletions(-)

-- 
1.8.4

