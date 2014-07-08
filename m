Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaGHXCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:02:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54931 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750947AbaGHXCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:02:04 -0400
Date: Tue, 8 Jul 2014 19:02:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.2.60-rt88
Message-ID: <20140708190201.007d1bc9@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.60-rt88 stable release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.2-rt
  Head SHA1: 34960baced3e54506f23abfac25544f212eddea2


Or to build 3.2.60-rt88 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.60.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.60-rt88.patch.xz



You can also build from 3.2.60-rt87 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.60-rt87-rt88.patch.xz



Enjoy,

-- Steve


Changes from v3.2.60-rt87:

---

Ben Hutchings (1):
      Fix latency histogram after "hrtimer: Set expiry time before switch_hrtimer_base()"

Steven Rostedt (Red Hat) (1):
      Linux 3.2.60-rt88

----
 kernel/hrtimer.c | 10 +++++-----
 localversion-rt  |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)
---------------------------
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index f54379023e16..2bd88f06a6d0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1033,6 +1033,11 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 #endif
 	}
 
+	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
+
+	/* Switch the timer base, if necessary: */
+	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
+
 #ifdef CONFIG_MISSED_TIMER_OFFSETS_HIST
 	{
 		ktime_t now = new_base->get_time();
@@ -1044,11 +1049,6 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	}
 #endif
 
-	hrtimer_set_expires_range_ns(timer, tim, delta_ns);
-
-	/* Switch the timer base, if necessary: */
-	new_base = switch_hrtimer_base(timer, base, mode & HRTIMER_MODE_PINNED);
-
 	timer_stats_hrtimer_set_start_info(timer);
 
 	leftmost = enqueue_hrtimer(timer, new_base);
diff --git a/localversion-rt b/localversion-rt
index bd5aee366a48..666227d921a3 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt87
+-rt88
