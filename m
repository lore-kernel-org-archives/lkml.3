Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaHUTDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:03:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbaHUTDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:03:21 -0400
Date: Thu, 21 Aug 2014 21:00:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mempolicy: fix show_numa_map() vs exec() +
	do_set_mempolicy() race
Message-ID: <20140821190020.GA8703@redhat.com>
References: <20140805194627.GA30693@redhat.com> <20140820192207.GA8524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820192207.GA8524@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Oleg Nesterov wrote:
>
> I belive that 9e7814404b77c3e8 "hold task->mempolicy while numa_maps scans"
> was wrong and it doesn't fix the problem.

See 2/4.

> I'll try to send the fix tomorrow, could you review the initial preparations?
> To me, these changes make sense as cleanups in any case, but I don't really
> understand this code and this was only compile tested.

Untested again because I do not know how, please review ;) On top of
"mempolicy: get_task_policy() cleanups/preparations" series.

I'll send the final cleanups later.

Oleg.

 fs/proc/task_mmu.c        |   33 ++++++-----------------
 include/linux/mempolicy.h |    5 ++-
 mm/mempolicy.c            |   64 +++++++++++++++++++-------------------------
 3 files changed, 40 insertions(+), 62 deletions(-)

