Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3JSNJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 09:09:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab3JSNJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 09:09:51 -0400
Date: Sat, 19 Oct 2013 15:02:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: fix fork() with the pending ret-probe(s)
Message-ID: <20131019130212.GA27109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

This fixes the serious bug, a forked process crashes if it returns
from the probed function called by its parent, this cc's stable.

Also the minor fix from Ralf.

Oleg Nesterov (6):
      uprobes: Change the callsite of uprobe_copy_process()
      uprobes: Introduce __create_xol_area()
      uprobes: Teach __create_xol_area() to accept the predefined vaddr
      uprobes: Change uprobe_copy_process() to dup return_instances
      uprobes: Change uprobe_copy_process() to dup xol_area
      uprobes: Teach uprobe_copy_process() to handle CLONE_VFORK

Ralf Baechle (1):
      uprobes: Remove the wrong __weak attribute

 include/linux/uprobes.h |    6 +-
 kernel/events/uprobes.c |  156 ++++++++++++++++++++++++++++++++++++-----------
 kernel/fork.c           |    2 +-
 3 files changed, 124 insertions(+), 40 deletions(-)

