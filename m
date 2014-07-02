Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaGBPxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:53:16 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:42404 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932100AbaGBPwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:52:40 -0400
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, rostedt@goodmis.org
Message-Id: <cover.1404315388.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 0/2] sched: static_key sched_feat race + cleanup
Date: Wed,  2 Jul 2014 15:52:38 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andi Kleen previously pointed out a get/set race in the sched_feat()
infrastructure. I had previously proposed to address this with a new
static_key set_true/set_false API:

http://www.gossamer-threads.com/lists/linux/kernel/1955879

However, I think its simpler to just add higher level locking as
Ingo previously suggested, and that is how other consumers of the
this interface are already operating. It seems a bit like overkill
to add this new API, just for this one case.

So, this locking change is in patch 2. Patch 1 is a small cleanup, but
no functional change.
 
Thanks,

-Jason

Jason Baron (2):
  sched: remove extra static_key function indirection
  sched: fix static_key race with sched_feat

 kernel/sched/core.c  |  5 +++++
 kernel/sched/sched.h | 12 +-----------
 2 files changed, 6 insertions(+), 11 deletions(-)

-- 
1.8.2.rc2

