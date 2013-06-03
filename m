Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab3FCTKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:10:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab3FCTKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:10:32 -0400
Date: Mon, 3 Jun 2013 21:06:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] proc: first_tid() fix/cleanup
Message-ID: <20130603190640.GA11481@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

next_thread() should be avoided, probably next_tid() is the
only "valid" user.

But now we have another reason to avoid (and probably even kill)
it, we are going to replace or fix while_each_thread(), almost
every lockless usage is wrong.

Changes:

	1/4: Update the changelog, do not move the comment.

	2/4: No changes.

	3/4: Update the comment following the explanations from
	     Eric.

	     Eric pointed that get_proc_task() without rcu lock
	     can trigger the (bogus) warning. Extract the similar
	     check from pid_delete_dentry() into the new helper
	     and use it instead.

	     I didn't dare to preserve his ack, but the only change
	     is the new proc_inode_is_dead() helper and

		- if (pid_task(proc_pid(inode))
		+ if (proc_inode_is_dead(inode))

	     in proc_task_readdir().

	4/4: New.

Oleg.

