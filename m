Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaHHS76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaHHS74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:59:56 -0400
Date: Fri, 8 Aug 2014 20:57:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] introduce proc_inode->pid_entry
Message-ID: <20140808185732.GA760@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Obviously not for inclusion. The patches are horrible, break task_nommu.c,
untested, etc. Only to explain what I mean and discuss the intent, at least.
On top of recent /proc/pid/*maps* cleanups I sent.

To me it looks a bit annoying that task_mmu.c needs 6 seq_operations's and
6 file_operations's to handle /proc/pid/*maps*. And _only_ because ->show()
differs.

Eric, et al, what do you think? At least something like 1-3 looks like a
good cleanup imho. And afaics we can do more cleanups on top.

Oleg.

 fs/proc/array.c    |   17 +---
 fs/proc/base.c     |   37 +++++++--
 fs/proc/inode.c    |    1 +
 fs/proc/internal.h |   16 ++--
 fs/proc/task_mmu.c |  237 +++++++++++++---------------------------------------
 5 files changed, 98 insertions(+), 210 deletions(-)

