Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab3LDNCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:02:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab3LDNCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:02:52 -0500
Date: Wed, 4 Dec 2013 14:03:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] initial while_each_thread() fixes
Message-ID: <20131204130351.GA5984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Changes: split the change in mm/oom_kill.c + update the comment above
has_intersects_mems_allowed().

Sergey, Sameer, the resulting code is the same after 1-3, I preserved
your acks.

4/4 is new.

Andrew, just in case, 3/4 and 4/4 try to fix the unrelated bugs, this
has nothing to do with while_each_thread/for_each_thread changes.

To remind, this is the first series which changes the callers of the
buggy while_each_thread(), I'll send more.

Oleg.

 include/linux/init_task.h |    2 +
 include/linux/sched.h     |   12 ++++++++++
 kernel/exit.c             |    1 +
 kernel/fork.c             |    7 ++++++
 mm/oom_kill.c             |   51 +++++++++++++++++++++++++-------------------
 5 files changed, 51 insertions(+), 22 deletions(-)

