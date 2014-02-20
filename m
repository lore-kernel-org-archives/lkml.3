Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaBTRir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:38:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbaBTRiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:38:46 -0500
Date: Thu, 20 Feb 2014 18:38:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] kill the racy EXIT_ZOMBIE->EXIT_DEAD->EXIT_ZOMBIE
	transition
Message-ID: <20140220173838.GA21825@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

1/7 cc's stable, and imo it is v3.14 material. This hack is reverted
by the next patch.

Many thanks to Michal and Jan for investigating.


And it seems that we need more (unrelated) changes in do_wait(), will
try to do this tomorrow.

Tejun, unless I missed something WSTOPPED logic is broken if a process
has a zombie/ptraced leader, "A zombie ptracee is only visible to its
ptracer" is wrong in this case. Plus perhaps some cleanups make sense.

Oleg.

 fs/proc/array.c       |    4 +-
 include/linux/sched.h |    5 ++-
 kernel/exit.c         |   51 +++++++++++++++++++++++-------------------------
 3 files changed, 29 insertions(+), 31 deletions(-)

