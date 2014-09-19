Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaISLrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:47:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaISLrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:47:20 -0400
Date: Fri, 19 Sep 2014 04:44:58 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-f139caf2e89713687514d9db847a4fa2e29c87a2@git.kernel.org>
Cc: ktkhai@parallels.com, mingo@kernel.org, torvalds@linux-foundation.org,
        schwidefsky@de.ibm.com, robert.w.love@intel.com,
        gregkh@linuxfoundation.org, rostedt@goodmis.org,
        michael.opdenacker@free-electrons.com, liang.zhen@intel.com,
        deller@gmx.de, bfields@fieldses.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, zlim.lnx@gmail.com,
        lauraa@codeaurora.org, blaschka@linux.vnet.ibm.com, askb23@gmail.com,
        dhowells@redhat.com, bergwolf@gmail.com, neilb@suse.de,
        dmitry.eremin@intel.com, ursula.braun@de.ibm.com, shaggy@kernel.org,
        jdike@addtoit.com, he.huang@intel.com, jesper.nilsson@axis.com,
        peterz@infradead.org, airlied@linux.ie, jslaby@suse.cz, arnd@arndb.de,
        snitzer@redhat.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        trond.myklebust@primarydata.com, richard@nod.at, agk@redhat.com,
        massa.nomura@gmail.com, green@linuxhacker.ru, JBottomley@parallels.com,
        jejb@parisc-linux.org, starvik@axis.com
Reply-To: mingo@kernel.org, ktkhai@parallels.com,
        torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
        robert.w.love@intel.com, gregkh@linuxfoundation.org,
        rostedt@goodmis.org, michael.opdenacker@free-electrons.com,
        liang.zhen@intel.com, deller@gmx.de, bfields@fieldses.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, zlim.lnx@gmail.com,
        lauraa@codeaurora.org, blaschka@linux.vnet.ibm.com, askb23@gmail.com,
        dhowells@redhat.com, dmitry.eremin@intel.com, neilb@suse.de,
        bergwolf@gmail.com, ursula.braun@de.ibm.com, shaggy@kernel.org,
        jdike@addtoit.com, he.huang@intel.com, jesper.nilsson@axis.com,
        peterz@infradead.org, airlied@linux.ie, jslaby@suse.cz, arnd@arndb.de,
        snitzer@redhat.com, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        trond.myklebust@primarydata.com, richard@nod.at, agk@redhat.com,
        massa.nomura@gmail.com, JBottomley@parallels.com, green@linuxhacker.ru,
        jejb@parisc-linux.org, starvik@axis.com
In-Reply-To: <1410529254.3569.23.camel@tkhai>
References: <1410529254.3569.23.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, cleanup, treewide:
  Remove set_current_state(TASK_RUNNING) after schedule()
Git-Commit-ID: f139caf2e89713687514d9db847a4fa2e29c87a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f139caf2e89713687514d9db847a4fa2e29c87a2
Gitweb:     http://git.kernel.org/tip/f139caf2e89713687514d9db847a4fa2e29c87a2
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Fri, 12 Sep 2014 17:40:54 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:17 +0200

sched, cleanup, treewide: Remove set_current_state(TASK_RUNNING) after schedule()

schedule(), io_schedule() and schedule_timeout() always return
with TASK_RUNNING state set, so one more setting is unnecessary.

(All places in patch are visible good, only exception is
 kiblnd_scheduler() from:

      drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c

 Its schedule() is one line above standard 3 lines of unified diff)

No places where set_current_state() is used for mb().

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1410529254.3569.23.camel@tkhai
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Anil Belur <askb23@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: David Howells <dhowells@redhat.com>
Cc: Dmitry Eremin <dmitry.eremin@intel.com>
Cc: Frank Blaschka <blaschka@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Isaac Huang <he.huang@intel.com>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Liang Zhen <liang.zhen@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Masaru Nomura <massa.nomura@gmail.com>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Oleg Drokin <green@linuxhacker.ru>
Cc: Peng Tao <bergwolf@gmail.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Ursula Braun <ursula.braun@de.ibm.com>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: devel@driverdev.osuosl.org
Cc: dm-devel@redhat.com
Cc: dri-devel@lists.freedesktop.org
Cc: fcoe-devel@open-fcoe.org
Cc: jfs-discussion@lists.sourceforge.net
Cc: linux390@de.ibm.com
Cc: linux-afs@lists.infradead.org
Cc: linux-cris-kernel@axis.com
Cc: linux-kernel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: user-mode-linux-user@lists.sourceforge.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/cris/arch-v10/drivers/sync_serial.c               | 1 -
 arch/cris/arch-v32/drivers/sync_serial.c               | 1 -
 arch/um/drivers/random.c                               | 1 -
 drivers/gpu/vga/vgaarb.c                               | 1 -
 drivers/md/dm-bufio.c                                  | 1 -
 drivers/parisc/power.c                                 | 1 -
 drivers/s390/net/claw.c                                | 2 --
 drivers/scsi/fcoe/fcoe.c                               | 1 -
 drivers/scsi/qla2xxx/qla_os.c                          | 1 -
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c | 3 ---
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c | 1 -
 drivers/staging/lustre/lustre/libcfs/fail.c            | 1 -
 drivers/tty/bfin_jtag_comm.c                           | 1 -
 fs/afs/vlocation.c                                     | 1 -
 fs/jfs/jfs_logmgr.c                                    | 2 --
 fs/jfs/jfs_txnmgr.c                                    | 3 ---
 fs/nfs/blocklayout/blocklayoutdev.c                    | 1 -
 fs/nfs/blocklayout/blocklayoutdm.c                     | 1 -
 fs/nfsd/nfs4recover.c                                  | 1 -
 kernel/time/hrtimer.c                                  | 1 -
 kernel/trace/ring_buffer_benchmark.c                   | 3 ---
 21 files changed, 29 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index 29eb02a..0f39832 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -1086,7 +1086,6 @@ static ssize_t sync_serial_write(struct file *file, const char *buf,
 	}
 	local_irq_restore(flags);
 	schedule();
-	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->out_wait_q, &wait);
 	if (signal_pending(current))
 		return -EINTR;
diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index bbb806b..5a14913 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -1089,7 +1089,6 @@ static ssize_t sync_serial_write(struct file *file, const char *buf,
 	}
 
 	schedule();
-	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->out_wait_q, &wait);
 
 	if (signal_pending(current))
diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
index 9e3a722..dd16c90 100644
--- a/arch/um/drivers/random.c
+++ b/arch/um/drivers/random.c
@@ -79,7 +79,6 @@ static ssize_t rng_dev_read (struct file *filp, char __user *buf, size_t size,
 			set_task_state(current, TASK_INTERRUPTIBLE);
 
 			schedule();
-			set_task_state(current, TASK_RUNNING);
 			remove_wait_queue(&host_read_wait, &wait);
 
 			if (atomic_dec_and_test(&host_sleep_count)) {
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index d2077f0..d07f810 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -403,7 +403,6 @@ int vga_get(struct pci_dev *pdev, unsigned int rsrc, int interruptible)
 		}
 		schedule();
 		remove_wait_queue(&vga_wait_queue, &wait);
-		set_current_state(TASK_RUNNING);
 	}
 	return rc;
 }
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index ab472c5..0505559 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -720,7 +720,6 @@ static void __wait_for_free_buffer(struct dm_bufio_client *c)
 
 	io_schedule();
 
-	set_task_state(current, TASK_RUNNING);
 	remove_wait_queue(&c->free_buffer_wait, &wait);
 
 	dm_bufio_lock(c);
diff --git a/drivers/parisc/power.c b/drivers/parisc/power.c
index 90cca5e..ef31b77 100644
--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -121,7 +121,6 @@ static int kpowerswd(void *param)
 		unsigned long soft_power_reg = (unsigned long) param;
 
 		schedule_timeout_interruptible(pwrsw_enabled ? HZ : HZ/POWERSWITCH_POLL_PER_SEC);
-		__set_current_state(TASK_RUNNING);
 
 		if (unlikely(!pwrsw_enabled))
 			continue;
diff --git a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
index fbc6701..213e54e 100644
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -481,7 +481,6 @@ claw_open(struct net_device *dev)
                 spin_unlock_irqrestore(
 			get_ccwdev_lock(privptr->channel[i].cdev), saveflags);
                 schedule();
-		set_current_state(TASK_RUNNING);
                 remove_wait_queue(&privptr->channel[i].wait, &wait);
                 if(rc != 0)
                         ccw_check_return_code(privptr->channel[i].cdev, rc);
@@ -828,7 +827,6 @@ claw_release(struct net_device *dev)
 	        spin_unlock_irqrestore(
 			get_ccwdev_lock(privptr->channel[i].cdev), saveflags);
 	        schedule();
-		set_current_state(TASK_RUNNING);
 	        remove_wait_queue(&privptr->channel[i].wait, &wait);
 	        if (rc != 0) {
                         ccw_check_return_code(privptr->channel[i].cdev, rc);
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 00ee0ed..4a8ac7d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1884,7 +1884,6 @@ retry:
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_bh(&p->fcoe_rx_list.lock);
 			schedule();
-			set_current_state(TASK_RUNNING);
 			goto retry;
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index be9698d..8b5a5dc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4853,7 +4853,6 @@ qla2x00_do_dpc(void *data)
 		    "DPC handler sleeping.\n");
 
 		schedule();
-		__set_current_state(TASK_RUNNING);
 
 		if (!base_vha->flags.init_done || ha->flags.mbox_busy)
 			goto end_loop;
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 306d728..b94f743 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -3215,7 +3215,6 @@ kiblnd_connd (void *arg)
 
 		schedule_timeout(timeout);
 
-		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&kiblnd_data.kib_connd_waitq, &wait);
 		spin_lock_irqsave(&kiblnd_data.kib_connd_lock, flags);
 	}
@@ -3432,7 +3431,6 @@ kiblnd_scheduler(void *arg)
 		busy_loops = 0;
 
 		remove_wait_queue(&sched->ibs_waitq, &wait);
-		set_current_state(TASK_RUNNING);
 		spin_lock_irqsave(&sched->ibs_lock, flags);
 	}
 
@@ -3507,7 +3505,6 @@ kiblnd_failover_thread(void *arg)
 
 		rc = schedule_timeout(long_sleep ? cfs_time_seconds(10) :
 						   cfs_time_seconds(1));
-		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&kiblnd_data.kib_failover_waitq, &wait);
 		write_lock_irqsave(glock, flags);
 
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index 5214399..9994fc6 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -2233,7 +2233,6 @@ ksocknal_connd (void *arg)
 		nloops = 0;
 		schedule_timeout(timeout);
 
-		set_current_state(TASK_RUNNING);
 		remove_wait_queue(&ksocknal_data.ksnd_connd_waitq, &wait);
 		spin_lock_bh(connd_lock);
 	}
diff --git a/drivers/staging/lustre/lustre/libcfs/fail.c b/drivers/staging/lustre/lustre/libcfs/fail.c
index 1bf9c90..e73ca3d 100644
--- a/drivers/staging/lustre/lustre/libcfs/fail.c
+++ b/drivers/staging/lustre/lustre/libcfs/fail.c
@@ -131,7 +131,6 @@ int __cfs_fail_timeout_set(__u32 id, __u32 value, int ms, int set)
 		       id, ms);
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(cfs_time_seconds(ms) / 1000);
-		set_current_state(TASK_RUNNING);
 		CERROR("cfs_fail_timeout id %x awake\n", id);
 	}
 	return ret;
diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index 8096fcb..d7b198c 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -77,7 +77,6 @@ bfin_jc_emudat_manager(void *arg)
 			pr_debug("waiting for readers\n");
 			__set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule();
-			__set_current_state(TASK_RUNNING);
 			continue;
 		}
 
diff --git a/fs/afs/vlocation.c b/fs/afs/vlocation.c
index b6df2e8..5297678 100644
--- a/fs/afs/vlocation.c
+++ b/fs/afs/vlocation.c
@@ -130,7 +130,6 @@ static int afs_vlocation_access_vl_by_id(struct afs_vlocation *vl,
 					/* second+ BUSY - sleep a little bit */
 					set_current_state(TASK_UNINTERRUPTIBLE);
 					schedule_timeout(1);
-					__set_current_state(TASK_RUNNING);
 				}
 				continue;
 			}
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 0acddf6..bc462dc 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1585,7 +1585,6 @@ void jfs_flush_journal(struct jfs_log *log, int wait)
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		LOGGC_UNLOCK(log);
 		schedule();
-		__set_current_state(TASK_RUNNING);
 		LOGGC_LOCK(log);
 		remove_wait_queue(&target->gcwait, &__wait);
 	}
@@ -2359,7 +2358,6 @@ int jfsIOWait(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_irq(&log_redrive_lock);
 			schedule();
-			__set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
 
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 564c4f2..d595856 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -136,7 +136,6 @@ static inline void TXN_SLEEP_DROP_LOCK(wait_queue_head_t * event)
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	TXN_UNLOCK();
 	io_schedule();
-	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(event, &wait);
 }
 
@@ -2808,7 +2807,6 @@ int jfs_lazycommit(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			LAZY_UNLOCK(flags);
 			schedule();
-			__set_current_state(TASK_RUNNING);
 			remove_wait_queue(&jfs_commit_thread_wait, &wq);
 		}
 	} while (!kthread_should_stop());
@@ -2996,7 +2994,6 @@ int jfs_sync(void *arg)
 			set_current_state(TASK_INTERRUPTIBLE);
 			TXN_UNLOCK();
 			schedule();
-			__set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
 
diff --git a/fs/nfs/blocklayout/blocklayoutdev.c b/fs/nfs/blocklayout/blocklayoutdev.c
index 04303b5..9fde840 100644
--- a/fs/nfs/blocklayout/blocklayoutdev.c
+++ b/fs/nfs/blocklayout/blocklayoutdev.c
@@ -146,7 +146,6 @@ nfs4_blk_decode_device(struct nfs_server *server,
 
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	schedule();
-	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&nn->bl_wq, &wq);
 
 	if (reply->status != BL_DEVICE_REQUEST_PROC) {
diff --git a/fs/nfs/blocklayout/blocklayoutdm.c b/fs/nfs/blocklayout/blocklayoutdm.c
index 8999cfd..b18680e 100644
--- a/fs/nfs/blocklayout/blocklayoutdm.c
+++ b/fs/nfs/blocklayout/blocklayoutdm.c
@@ -76,7 +76,6 @@ static void dev_remove(struct net *net, dev_t dev)
 
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	schedule();
-	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&nn->bl_wq, &wq);
 
 out:
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 9c271f4..8f1af78 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -670,7 +670,6 @@ __cld_pipe_upcall(struct rpc_pipe *pipe, struct cld_msg *cmsg)
 	}
 
 	schedule();
-	set_current_state(TASK_RUNNING);
 
 	if (msg.errno < 0)
 		ret = msg.errno;
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 1c2fe7d..ab370ff 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1776,7 +1776,6 @@ schedule_hrtimeout_range_clock(ktime_t *expires, unsigned long delta,
 	 */
 	if (!expires) {
 		schedule();
-		__set_current_state(TASK_RUNNING);
 		return -EINTR;
 	}
 
diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 0434ff1..3f9e328 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -205,7 +205,6 @@ static void ring_buffer_consumer(void)
 			break;
 
 		schedule();
-		__set_current_state(TASK_RUNNING);
 	}
 	reader_finish = 0;
 	complete(&read_done);
@@ -379,7 +378,6 @@ static int ring_buffer_consumer_thread(void *arg)
 			break;
 
 		schedule();
-		__set_current_state(TASK_RUNNING);
 	}
 	__set_current_state(TASK_RUNNING);
 
@@ -407,7 +405,6 @@ static int ring_buffer_producer_thread(void *arg)
 		trace_printk("Sleeping for 10 secs\n");
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ * SLEEP_TIME);
-		__set_current_state(TASK_RUNNING);
 	}
 
 	if (kill_test)
