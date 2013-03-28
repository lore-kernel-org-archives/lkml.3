Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab3C1TTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:19:54 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36817 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab3C1TTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:19:53 -0400
Message-ID: <1364498379.3559.44.camel@thor.lan>
Subject: Re: [PATCH v2 00/13] rwsem fast-path write lock stealing
From: Peter Hurley <peter@hurleysoftware.com>
To: Michel Lespinasse <walken@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 28 Mar 2013 15:19:39 -0400
In-Reply-To: <1363344869-15732-1-git-send-email-walken@google.com>
References: <1363344869-15732-1-git-send-email-walken@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 03:54 -0700, Michel Lespinasse wrote:
> These patches extend Alex Shi's work (which added write lock stealing
> on the rwsem slow path) in order to provide rwsem write lock stealing
> on the fast path (that is, without taking the rwsem's wait_lock).

Since none of Alex's original code will be in here with these patches
applied, you might as well add this:

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 4e4c889..61f91ca 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -4,6 +4,7 @@
  * Derived from arch/i386/kernel/semaphore.c
  *
  * Writer lock-stealing by Alex Shi <alex.shi@intel.com>
+ * and Michel Lespinasse <walken@google.com>
  */
 #include <linux/rwsem.h>
 #include <linux/sched.h>


> Michel Lespinasse (13):
>   rwsem: make the waiter type an enumeration rather than a bitmask
>   rwsem: shorter spinlocked section in rwsem_down_failed_common()
>   rwsem: move rwsem_down_failed_common code into rwsem_down_{read,write}_failed
>   rwsem: simplify rwsem_down_read_failed
>   rwsem: simplify rwsem_down_write_failed
>   rwsem: more agressive lock stealing in rwsem_down_write_failed
>   rwsem: use cmpxchg for trying to steal write lock
>   rwsem: avoid taking wait_lock in rwsem_down_write_failed
>   rwsem: skip initial trylock in rwsem_down_write_failed
>   rwsem: simplify __rwsem_do_wake
>   rwsem: implement support for write lock stealing on the fastpath
>   rwsem: do not block readers at head of queue if other readers are active
>   x86 rwsem: avoid taking slow path when stealing write lock
> 
>  arch/x86/include/asm/rwsem.h |  28 +++--
>  lib/rwsem-spinlock.c         |  40 +++-----
>  lib/rwsem.c                  | 239 +++++++++++++++++++++----------------------
>  3 files changed, 154 insertions(+), 153 deletions(-)

Because Michel asked:

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>

