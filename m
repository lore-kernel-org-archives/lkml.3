Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3KIQRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 11:17:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab3KIQRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 11:17:34 -0500
Date: Sat, 9 Nov 2013 17:18:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <aarapov@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: uprobe_copy_process() and copy_insn() fixes
Message-ID: <20131109161857.GA17484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

I do not like to spam you, but I think that at least the 1st patch
should be merged now, along with other retprobe && fork fixed.

The 1st one-liner fixes the typo in the recently merged aa59c53fd459
"uprobes: Change uprobe_copy_process() to dup xol_area", a ret-probed
child still can crash.

The 2nd patch fixes the easy-to-trigger kernel crash. This bug is very
old, but fortunately only root can enable uprobes.

Oleg Nesterov (2):
      uprobes: Fix the wrong usage of current->utask in uprobe_copy_process()
      uprobes: Fix the memory out of bound overwrite in copy_insn()

 kernel/events/uprobes.c |   49 +++++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

