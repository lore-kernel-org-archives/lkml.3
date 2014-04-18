Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaDRNOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:14:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39242 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaDRNOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:14:04 -0400
Date: Fri, 18 Apr 2014 06:13:16 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-55dhyhocezdw1dg7u19hmh1u@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] arch: Mass conversion of smp_mb__*()
Git-Commit-ID: 4e857c58efeb99393cba5a5d0d8ec7117183137c
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

Commit-ID:  4e857c58efeb99393cba5a5d0d8ec7117183137c
Gitweb:     http://git.kernel.org/tip/4e857c58efeb99393cba5a5d0d8ec7117183137c
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 17 Mar 2014 18:06:10 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 14:20:48 +0200

arch: Mass conversion of smp_mb__*()

Mostly scripted conversion of the smp_mb__* barriers.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-55dhyhocezdw1dg7u19hmh1u@git.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 block/blk-iopoll.c                                |  4 +-
 crypto/chainiv.c                                  |  2 +-
 drivers/base/power/domain.c                       |  2 +-
 drivers/block/mtip32xx/mtip32xx.c                 |  4 +-
 drivers/cpuidle/coupled.c                         |  2 +-
 drivers/firewire/ohci.c                           |  2 +-
 drivers/gpu/drm/drm_irq.c                         | 10 ++--
 drivers/gpu/drm/i915/i915_irq.c                   |  2 +-
 drivers/md/bcache/bcache.h                        |  2 +-
 drivers/md/bcache/closure.h                       |  2 +-
 drivers/md/dm-bufio.c                             |  8 ++--
 drivers/md/dm-snap.c                              |  4 +-
 drivers/md/dm.c                                   |  2 +-
 drivers/md/raid5.c                                |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c       |  6 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  6 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 18 ++++----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c    | 26 +++++------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c |  8 ++--
 drivers/net/ethernet/broadcom/cnic.c              |  8 ++--
 drivers/net/ethernet/brocade/bna/bnad.c           |  6 +--
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c         |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c          |  6 +--
 drivers/net/ethernet/chelsio/cxgb4/sge.c          |  2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c        |  2 +-
 drivers/net/ethernet/freescale/gianfar.c          |  8 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c       |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |  8 ++--
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  6 +--
 drivers/net/wireless/ti/wlcore/main.c             |  2 +-
 drivers/pci/xen-pcifront.c                        |  4 +-
 drivers/scsi/isci/remote_device.c                 |  2 +-
 drivers/target/loopback/tcm_loop.c                |  4 +-
 drivers/target/target_core_alua.c                 | 26 +++++------
 drivers/target/target_core_device.c               |  6 +--
 drivers/target/target_core_iblock.c               |  2 +-
 drivers/target/target_core_pr.c                   | 56 +++++++++++------------
 drivers/target/target_core_transport.c            | 16 +++----
 drivers/target/target_core_ua.c                   | 10 ++--
 drivers/tty/n_tty.c                               |  2 +-
 drivers/tty/serial/mxs-auart.c                    |  4 +-
 drivers/usb/gadget/tcm_usb_gadget.c               |  4 +-
 drivers/usb/serial/usb_wwan.c                     |  2 +-
 drivers/vhost/scsi.c                              |  2 +-
 drivers/w1/w1_family.c                            |  4 +-
 drivers/xen/xen-pciback/pciback_ops.c             |  4 +-
 fs/btrfs/btrfs_inode.h                            |  2 +-
 fs/btrfs/extent_io.c                              |  2 +-
 fs/btrfs/inode.c                                  |  6 +--
 fs/btrfs/ioctl.c                                  |  2 +-
 fs/buffer.c                                       |  2 +-
 fs/ext4/resize.c                                  |  2 +-
 fs/gfs2/glock.c                                   |  8 ++--
 fs/gfs2/glops.c                                   |  2 +-
 fs/gfs2/lock_dlm.c                                |  4 +-
 fs/gfs2/recovery.c                                |  2 +-
 fs/gfs2/sys.c                                     |  4 +-
 fs/jbd2/commit.c                                  |  6 +--
 fs/nfs/dir.c                                      | 12 ++---
 fs/nfs/inode.c                                    |  2 +-
 fs/nfs/nfs4filelayoutdev.c                        |  4 +-
 fs/nfs/nfs4state.c                                |  4 +-
 fs/nfs/pagelist.c                                 |  6 +--
 fs/nfs/pnfs.c                                     |  2 +-
 fs/nfs/pnfs.h                                     |  2 +-
 fs/nfs/write.c                                    |  4 +-
 fs/ubifs/lpt_commit.c                             |  4 +-
 fs/ubifs/tnc_commit.c                             |  4 +-
 include/asm-generic/bitops/atomic.h               |  2 +-
 include/asm-generic/bitops/lock.h                 |  2 +-
 include/linux/buffer_head.h                       |  2 +-
 include/linux/genhd.h                             |  2 +-
 include/linux/interrupt.h                         |  8 ++--
 include/linux/netdevice.h                         |  2 +-
 include/linux/sched.h                             |  6 +--
 include/linux/sunrpc/sched.h                      |  8 ++--
 include/linux/sunrpc/xprt.h                       |  8 ++--
 include/linux/tracehook.h                         |  2 +-
 include/net/ip_vs.h                               |  4 +-
 kernel/debug/debug_core.c                         |  4 +-
 kernel/futex.c                                    |  4 +-
 kernel/kmod.c                                     |  2 +-
 kernel/rcu/tree.c                                 | 22 ++++-----
 kernel/rcu/tree_plugin.h                          |  8 ++--
 kernel/sched/cpupri.c                             |  6 +--
 kernel/sched/wait.c                               |  2 +-
 mm/backing-dev.c                                  |  2 +-
 mm/filemap.c                                      |  4 +-
 net/atm/pppoatm.c                                 |  2 +-
 net/bluetooth/hci_event.c                         |  4 +-
 net/core/dev.c                                    |  8 ++--
 net/core/link_watch.c                             |  2 +-
 net/ipv4/inetpeer.c                               |  2 +-
 net/ipv4/tcp_output.c                             |  4 +-
 net/netfilter/nf_conntrack_core.c                 |  2 +-
 net/rds/ib_recv.c                                 |  4 +-
 net/rds/iw_recv.c                                 |  4 +-
 net/rds/send.c                                    |  6 +--
 net/rds/tcp_send.c                                |  2 +-
 net/sunrpc/auth.c                                 |  2 +-
 net/sunrpc/auth_gss/auth_gss.c                    |  2 +-
 net/sunrpc/backchannel_rqst.c                     |  4 +-
 net/sunrpc/xprt.c                                 |  4 +-
 net/sunrpc/xprtsock.c                             | 16 +++----
 net/unix/af_unix.c                                |  2 +-
 sound/pci/bt87x.c                                 |  4 +-
 106 files changed, 284 insertions(+), 288 deletions(-)

diff --git a/block/blk-iopoll.c b/block/blk-iopoll.c
index c11d24e..f8c6a11 100644
--- a/block/blk-iopoll.c
+++ b/block/blk-iopoll.c
@@ -49,7 +49,7 @@ EXPORT_SYMBOL(blk_iopoll_sched);
 void __blk_iopoll_complete(struct blk_iopoll *iop)
 {
 	list_del(&iop->list);
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit_unlock(IOPOLL_F_SCHED, &iop->state);
 }
 EXPORT_SYMBOL(__blk_iopoll_complete);
@@ -161,7 +161,7 @@ EXPORT_SYMBOL(blk_iopoll_disable);
 void blk_iopoll_enable(struct blk_iopoll *iop)
 {
 	BUG_ON(!test_bit(IOPOLL_F_SCHED, &iop->state));
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit_unlock(IOPOLL_F_SCHED, &iop->state);
 }
 EXPORT_SYMBOL(blk_iopoll_enable);
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index 834d8dd..9c294c8 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -126,7 +126,7 @@ static int async_chainiv_schedule_work(struct async_chainiv_ctx *ctx)
 	int err = ctx->err;
 
 	if (!ctx->queue.qlen) {
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
 
 		if (!ctx->queue.qlen ||
diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index ae098a2..eee55c1 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -105,7 +105,7 @@ static bool genpd_sd_counter_dec(struct generic_pm_domain *genpd)
 static void genpd_sd_counter_inc(struct generic_pm_domain *genpd)
 {
 	atomic_inc(&genpd->sd_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 static void genpd_acquire_lock(struct generic_pm_domain *genpd)
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 59c5abe..4fd8d6c 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -224,9 +224,9 @@ static int get_slot(struct mtip_port *port)
  */
 static inline void release_slot(struct mtip_port *port, int tag)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(tag, port->allocated);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 /*
diff --git a/drivers/cpuidle/coupled.c b/drivers/cpuidle/coupled.c
index cb6654b..73fe2f8 100644
--- a/drivers/cpuidle/coupled.c
+++ b/drivers/cpuidle/coupled.c
@@ -159,7 +159,7 @@ void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev, atomic_t *a)
 {
 	int n = dev->coupled->online_count;
 
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_inc(a);
 
 	while (atomic_read(a) < n)
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 8db6632..995dd42 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -3498,7 +3498,7 @@ static int ohci_flush_iso_completions(struct fw_iso_context *base)
 		}
 
 		clear_bit_unlock(0, &ctx->flushing_completions);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 	}
 
 	tasklet_enable(&ctx->context.tasklet);
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index c2676b5..ec5c3f4 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -156,7 +156,7 @@ static void vblank_disable_and_save(struct drm_device *dev, int crtc)
 	 */
 	if ((vblrc > 0) && (abs64(diff_ns) > 1000000)) {
 		atomic_inc(&dev->vblank[crtc].count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 	}
 
 	/* Invalidate all timestamps while vblank irq's are off. */
@@ -864,9 +864,9 @@ static void drm_update_vblank_count(struct drm_device *dev, int crtc)
 		vblanktimestamp(dev, crtc, tslot) = t_vblank;
 	}
 
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_add(diff, &dev->vblank[crtc].count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 /**
@@ -1330,9 +1330,9 @@ bool drm_handle_vblank(struct drm_device *dev, int crtc)
 		/* Increment cooked vblank count. This also atomically commits
 		 * the timestamp computed above.
 		 */
-		smp_mb__before_atomic_inc();
+		smp_mb__before_atomic();
 		atomic_inc(&dev->vblank[crtc].count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 	} else {
 		DRM_DEBUG("crtc %d: Redundant vblirq ignored. diff_ns = %d\n",
 			  crtc, (int) diff_ns);
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 7753249..5409bfa 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2147,7 +2147,7 @@ static void i915_error_work_func(struct work_struct *work)
 			 * updates before
 			 * the counter increment.
 			 */
-			smp_mb__before_atomic_inc();
+			smp_mb__before_atomic();
 			atomic_inc(&dev_priv->gpu_error.reset_counter);
 
 			kobject_uevent_env(&dev->primary->kdev->kobj,
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 82c9c5d..d2ebcf3 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -828,7 +828,7 @@ static inline bool cached_dev_get(struct cached_dev *dc)
 		return false;
 
 	/* Paired with the mb in cached_dev_attach */
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	return true;
 }
 
diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 7ef7461..a08e3ee 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -243,7 +243,7 @@ static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
 	cl->fn = fn;
 	cl->wq = wq;
 	/* between atomic_dec() in closure_put() */
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 }
 
 static inline void closure_queue(struct closure *cl)
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 66c5d13..4e84095 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -607,9 +607,9 @@ static void write_endio(struct bio *bio, int error)
 
 	BUG_ON(!test_bit(B_WRITING, &b->state));
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(B_WRITING, &b->state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	wake_up_bit(&b->state, B_WRITING);
 }
@@ -997,9 +997,9 @@ static void read_endio(struct bio *bio, int error)
 
 	BUG_ON(!test_bit(B_READING, &b->state));
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(B_READING, &b->state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	wake_up_bit(&b->state, B_READING);
 }
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ebddef5..8e0caed 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -642,7 +642,7 @@ static void free_pending_exception(struct dm_snap_pending_exception *pe)
 	struct dm_snapshot *s = pe->snap;
 
 	mempool_free(pe, s->pending_pool);
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&s->pending_exceptions_count);
 }
 
@@ -783,7 +783,7 @@ static int init_hash_tables(struct dm_snapshot *s)
 static void merge_shutdown(struct dm_snapshot *s)
 {
 	clear_bit_unlock(RUNNING_MERGE, &s->state_bits);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&s->state_bits, RUNNING_MERGE);
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 455e649..2db768e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2447,7 +2447,7 @@ static void dm_wq_work(struct work_struct *work)
 static void dm_queue_flush(struct mapped_device *md)
 {
 	clear_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	queue_work(md->wq, &md->work);
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ad1b9be..2afef4e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4400,7 +4400,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
 			 * STRIPE_ON_UNPLUG_LIST clear but the stripe
 			 * is still in our list
 			 */
-			smp_mb__before_clear_bit();
+			smp_mb__before_atomic();
 			clear_bit(STRIPE_ON_UNPLUG_LIST, &sh->state);
 			/*
 			 * STRIPE_ON_RELEASE_LIST could be set here. In that
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index de02db8..e355806 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -399,7 +399,7 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 
 	/* clear 'streaming' status bit */
 	clear_bit(ADAP_STREAMING, &adap->state_bits);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&adap->state_bits, ADAP_STREAMING);
 skip_feed_stop:
 
@@ -550,7 +550,7 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
 err:
 	if (!adap->suspend_resume_active) {
 		clear_bit(ADAP_INIT, &adap->state_bits);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		wake_up_bit(&adap->state_bits, ADAP_INIT);
 	}
 
@@ -591,7 +591,7 @@ err:
 	if (!adap->suspend_resume_active) {
 		adap->active_fe = -1;
 		clear_bit(ADAP_SLEEP, &adap->state_bits);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		wake_up_bit(&adap->state_bits, ADAP_SLEEP);
 	}
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 9261d53..dd57c7c 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2781,7 +2781,7 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 
 	case LOAD_OPEN:
 		netif_tx_start_all_queues(bp->dev);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		break;
 
 	case LOAD_DIAG:
@@ -4939,9 +4939,9 @@ void bnx2x_update_coalesce_sb_index(struct bnx2x *bp, u8 fw_sb_id,
 void bnx2x_schedule_sp_rtnl(struct bnx2x *bp, enum sp_rtnl_flag flag,
 			    u32 verbose)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	set_bit(flag, &bp->sp_rtnl_state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	DP((BNX2X_MSG_SP | verbose), "Scheduling sp_rtnl task [Flag: %d]\n",
 	   flag);
 	schedule_delayed_work(&bp->sp_rtnl_task, 0);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index a78edac..16391db 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -1858,10 +1858,10 @@ void bnx2x_sp_event(struct bnx2x_fastpath *fp, union eth_rx_cqe *rr_cqe)
 		return;
 #endif
 
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_inc(&bp->cq_spq_left);
 	/* push the change in bp->spq_left and towards the memory */
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 
 	DP(BNX2X_MSG_SP, "bp->cq_spq_left %x\n", atomic_read(&bp->cq_spq_left));
 
@@ -1876,11 +1876,11 @@ void bnx2x_sp_event(struct bnx2x_fastpath *fp, union eth_rx_cqe *rr_cqe)
 		 * sp_state is cleared, and this order prevents
 		 * races
 		 */
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		set_bit(BNX2X_AFEX_PENDING_VIFSET_MCP_ACK, &bp->sp_state);
 		wmb();
 		clear_bit(BNX2X_AFEX_FCOE_Q_UPDATE_PENDING, &bp->sp_state);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 
 		/* schedule the sp task as mcp ack is required */
 		bnx2x_schedule_sp_task(bp);
@@ -5272,9 +5272,9 @@ static void bnx2x_after_function_update(struct bnx2x *bp)
 		__clear_bit(RAMROD_COMP_WAIT, &queue_params.ramrod_flags);
 
 		/* mark latest Q bit */
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		set_bit(BNX2X_AFEX_FCOE_Q_UPDATE_PENDING, &bp->sp_state);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 
 		/* send Q update ramrod for FCoE Q */
 		rc = bnx2x_queue_state_change(bp, &queue_params);
@@ -5500,7 +5500,7 @@ next_spqe:
 		spqe_cnt++;
 	} /* for */
 
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_add(spqe_cnt, &bp->eq_spq_left);
 
 	bp->eq_cons = sw_cons;
@@ -13869,9 +13869,9 @@ static int bnx2x_drv_ctl(struct net_device *dev, struct drv_ctl_info *ctl)
 	case DRV_CTL_RET_L2_SPQ_CREDIT_CMD: {
 		int count = ctl->data.credit.credit_count;
 
-		smp_mb__before_atomic_inc();
+		smp_mb__before_atomic();
 		atomic_add(count, &bp->cq_spq_left);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		break;
 	}
 	case DRV_CTL_ULP_REGISTER_CMD: {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 31297266..d725317 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -258,16 +258,16 @@ static bool bnx2x_raw_check_pending(struct bnx2x_raw_obj *o)
 
 static void bnx2x_raw_clear_pending(struct bnx2x_raw_obj *o)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(o->state, o->pstate);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 static void bnx2x_raw_set_pending(struct bnx2x_raw_obj *o)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	set_bit(o->state, o->pstate);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 /**
@@ -2131,7 +2131,7 @@ static int bnx2x_set_rx_mode_e1x(struct bnx2x *bp,
 
 	/* The operation is completed */
 	clear_bit(p->state, p->pstate);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	return 0;
 }
@@ -3576,16 +3576,16 @@ error_exit1:
 
 static void bnx2x_mcast_clear_sched(struct bnx2x_mcast_obj *o)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(o->sched_state, o->raw.pstate);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 static void bnx2x_mcast_set_sched(struct bnx2x_mcast_obj *o)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	set_bit(o->sched_state, o->raw.pstate);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 static bool bnx2x_mcast_check_sched(struct bnx2x_mcast_obj *o)
@@ -4200,7 +4200,7 @@ int bnx2x_queue_state_change(struct bnx2x *bp,
 		if (rc) {
 			o->next_state = BNX2X_Q_STATE_MAX;
 			clear_bit(pending_bit, pending);
-			smp_mb__after_clear_bit();
+			smp_mb__after_atomic();
 			return rc;
 		}
 
@@ -4288,7 +4288,7 @@ static int bnx2x_queue_comp_cmd(struct bnx2x *bp,
 	wmb();
 
 	clear_bit(cmd, &o->pending);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	return 0;
 }
@@ -5279,7 +5279,7 @@ static inline int bnx2x_func_state_change_comp(struct bnx2x *bp,
 	wmb();
 
 	clear_bit(cmd, &o->pending);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	return 0;
 }
@@ -5926,7 +5926,7 @@ int bnx2x_func_state_change(struct bnx2x *bp,
 		if (rc) {
 			o->next_state = BNX2X_F_STATE_MAX;
 			clear_bit(cmd, pending);
-			smp_mb__after_clear_bit();
+			smp_mb__after_atomic();
 			return rc;
 		}
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 5c523b3..f82ac5a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1626,9 +1626,9 @@ static
 void bnx2x_vf_handle_filters_eqe(struct bnx2x *bp,
 				 struct bnx2x_virtf *vf)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(BNX2X_FILTER_RX_MODE_PENDING, &vf->filter_state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 static void bnx2x_vf_handle_rss_update_eqe(struct bnx2x *bp,
@@ -2960,9 +2960,9 @@ void bnx2x_iov_task(struct work_struct *work)
 
 void bnx2x_schedule_iov_task(struct bnx2x *bp, enum bnx2x_iov_flag flag)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	set_bit(flag, &bp->iov_task_state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	DP(BNX2X_MSG_IOV, "Scheduling iov task [Flag: %d]\n", flag);
 	queue_delayed_work(bnx2x_iov_wq, &bp->iov_task, 0);
 }
diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 09f3fef..4dd48d2 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -436,7 +436,7 @@ static int cnic_offld_prep(struct cnic_sock *csk)
 static int cnic_close_prep(struct cnic_sock *csk)
 {
 	clear_bit(SK_F_CONNECT_START, &csk->flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	if (test_and_clear_bit(SK_F_OFFLD_COMPLETE, &csk->flags)) {
 		while (test_and_set_bit(SK_F_OFFLD_SCHED, &csk->flags))
@@ -450,7 +450,7 @@ static int cnic_close_prep(struct cnic_sock *csk)
 static int cnic_abort_prep(struct cnic_sock *csk)
 {
 	clear_bit(SK_F_CONNECT_START, &csk->flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	while (test_and_set_bit(SK_F_OFFLD_SCHED, &csk->flags))
 		msleep(1);
@@ -3646,7 +3646,7 @@ static int cnic_cm_destroy(struct cnic_sock *csk)
 
 	csk_hold(csk);
 	clear_bit(SK_F_INUSE, &csk->flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	while (atomic_read(&csk->ref_count) != 1)
 		msleep(1);
 	cnic_cm_cleanup(csk);
@@ -4026,7 +4026,7 @@ static void cnic_cm_process_kcqe(struct cnic_dev *dev, struct kcqe *kcqe)
 			 L4_KCQE_COMPLETION_STATUS_PARITY_ERROR)
 			set_bit(SK_F_HW_ERR, &csk->flags);
 
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		clear_bit(SK_F_OFFLD_SCHED, &csk->flags);
 		cnic_cm_upcall(cp, csk, opcode);
 		break;
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 675550f..3a77f9e 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -249,7 +249,7 @@ bnad_tx_complete(struct bnad *bnad, struct bna_tcb *tcb)
 	if (likely(test_bit(BNAD_TXQ_TX_STARTED, &tcb->flags)))
 		bna_ib_ack(tcb->i_dbell, sent);
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(BNAD_TXQ_FREE_SENT, &tcb->flags);
 
 	return sent;
@@ -1126,7 +1126,7 @@ bnad_tx_cleanup(struct delayed_work *work)
 
 		bnad_txq_cleanup(bnad, tcb);
 
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		clear_bit(BNAD_TXQ_FREE_SENT, &tcb->flags);
 	}
 
@@ -2992,7 +2992,7 @@ bnad_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 			sent = bnad_txcmpl_process(bnad, tcb);
 			if (likely(test_bit(BNAD_TXQ_TX_STARTED, &tcb->flags)))
 				bna_ib_ack(tcb->i_dbell, sent);
-			smp_mb__before_clear_bit();
+			smp_mb__before_atomic();
 			clear_bit(BNAD_TXQ_FREE_SENT, &tcb->flags);
 		} else {
 			netif_stop_queue(netdev);
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 0fe7ff7..05613a8 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -281,7 +281,7 @@ static int cxgb_close(struct net_device *dev)
 	if (adapter->params.stats_update_period &&
 	    !(adapter->open_device_map & PORT_MASK)) {
 		/* Stop statistics accumulation. */
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		spin_lock(&adapter->work_lock);   /* sync with update task */
 		spin_unlock(&adapter->work_lock);
 		cancel_mac_stats_update(adapter);
diff --git a/drivers/net/ethernet/chelsio/cxgb3/sge.c b/drivers/net/ethernet/chelsio/cxgb3/sge.c
index 8b069f9..3dfcf60 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
@@ -1379,7 +1379,7 @@ static inline int check_desc_avail(struct adapter *adap, struct sge_txq *q,
 		struct sge_qset *qs = txq_to_qset(q, qid);
 
 		set_bit(qid, &qs->txq_stopped);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 
 		if (should_restart_tx(q) &&
 		    test_and_clear_bit(qid, &qs->txq_stopped))
@@ -1492,7 +1492,7 @@ static void restart_ctrlq(unsigned long data)
 
 	if (!skb_queue_empty(&q->sendq)) {
 		set_bit(TXQ_CTRL, &qs->txq_stopped);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 
 		if (should_restart_tx(q) &&
 		    test_and_clear_bit(TXQ_CTRL, &qs->txq_stopped))
@@ -1697,7 +1697,7 @@ again:	reclaim_completed_tx(adap, q, TX_RECLAIM_CHUNK);
 
 		if (unlikely(q->size - q->in_use < ndesc)) {
 			set_bit(TXQ_OFLD, &qs->txq_stopped);
-			smp_mb__after_clear_bit();
+			smp_mb__after_atomic();
 
 			if (should_restart_tx(q) &&
 			    test_and_clear_bit(TXQ_OFLD, &qs->txq_stopped))
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index ca95cf2..e249528 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2031,7 +2031,7 @@ static void sge_rx_timer_cb(unsigned long data)
 			struct sge_fl *fl = s->egr_map[id];
 
 			clear_bit(id, s->starving_fl);
-			smp_mb__after_clear_bit();
+			smp_mb__after_atomic();
 
 			if (fl_starving(fl)) {
 				rxq = container_of(fl, struct sge_eth_rxq, fl);
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 9cfa4b4..9d88c1d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -1951,7 +1951,7 @@ static void sge_rx_timer_cb(unsigned long data)
 			struct sge_fl *fl = s->egr_map[id];
 
 			clear_bit(id, s->starving_fl);
-			smp_mb__after_clear_bit();
+			smp_mb__after_atomic();
 
 			/*
 			 * Since we are accessing fl without a lock there's a
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 9125d9a..d82f092 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -1797,9 +1797,9 @@ void stop_gfar(struct net_device *dev)
 
 	netif_tx_stop_all_queues(dev);
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	set_bit(GFAR_DOWN, &priv->state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	disable_napi(priv);
 
@@ -2042,9 +2042,9 @@ int startup_gfar(struct net_device *ndev)
 
 	gfar_init_tx_rx_base(priv);
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(GFAR_DOWN, &priv->state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	/* Start Rx/Tx DMA and enable the interrupts */
 	gfar_start(priv);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 861b722..1e526c0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4671,7 +4671,7 @@ static void i40e_service_event_complete(struct i40e_pf *pf)
 	BUG_ON(!test_bit(__I40E_SERVICE_SCHED, &pf->state));
 
 	/* flush memory to make sure state is correct before next watchog */
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(__I40E_SERVICE_SCHED, &pf->state);
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c4c526b..2fecc26 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -376,7 +376,7 @@ static void ixgbe_service_event_complete(struct ixgbe_adapter *adapter)
 	BUG_ON(!test_bit(__IXGBE_SERVICE_SCHED, &adapter->state));
 
 	/* flush memory to make sure state is correct before next watchdog */
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(__IXGBE_SERVICE_SCHED, &adapter->state);
 }
 
@@ -4671,7 +4671,7 @@ static void ixgbe_up_complete(struct ixgbe_adapter *adapter)
 	if (hw->mac.ops.enable_tx_laser)
 		hw->mac.ops.enable_tx_laser(hw);
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(__IXGBE_DOWN, &adapter->state);
 	ixgbe_napi_enable_all(adapter);
 
@@ -5567,7 +5567,7 @@ static int ixgbe_resume(struct pci_dev *pdev)
 		e_dev_err("Cannot enable PCI device from suspend\n");
 		return err;
 	}
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(__IXGBE_DISABLED, &adapter->state);
 	pci_set_master(pdev);
 
@@ -8541,7 +8541,7 @@ static pci_ers_result_t ixgbe_io_slot_reset(struct pci_dev *pdev)
 		e_err(probe, "Cannot re-enable PCI device after reset.\n");
 		result = PCI_ERS_RESULT_DISCONNECT;
 	} else {
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		clear_bit(__IXGBE_DISABLED, &adapter->state);
 		adapter->hw.hw_addr = adapter->io_addr;
 		pci_set_master(pdev);
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index d0799e8..de2793b 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -1668,7 +1668,7 @@ static void ixgbevf_up_complete(struct ixgbevf_adapter *adapter)
 
 	spin_unlock_bh(&adapter->mbx_lock);
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(__IXGBEVF_DOWN, &adapter->state);
 	ixgbevf_napi_enable_all(adapter);
 
@@ -3354,7 +3354,7 @@ static int ixgbevf_resume(struct pci_dev *pdev)
 		dev_err(&pdev->dev, "Cannot enable PCI device from suspend\n");
 		return err;
 	}
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(__IXGBEVF_DISABLED, &adapter->state);
 	pci_set_master(pdev);
 
@@ -3712,7 +3712,7 @@ static pci_ers_result_t ixgbevf_io_slot_reset(struct pci_dev *pdev)
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(__IXGBEVF_DISABLED, &adapter->state);
 	pci_set_master(pdev);
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ed88d39..e71eae3 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -543,7 +543,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 		 * wl1271_ps_elp_wakeup cannot be called concurrently.
 		 */
 		clear_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 
 		ret = wlcore_fw_status(wl, wl->fw_status);
 		if (ret < 0)
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 179b8ed..53df39a 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -662,9 +662,9 @@ static void pcifront_do_aer(struct work_struct *data)
 	notify_remote_via_evtchn(pdev->evtchn);
 
 	/*in case of we lost an aer request in four lines time_window*/
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(_PDEVB_op_active, &pdev->flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	schedule_pcifront_aer_op(pdev);
 
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 96a26f4..cc51f38 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1541,7 +1541,7 @@ void isci_remote_device_release(struct kref *kref)
 	clear_bit(IDEV_STOP_PENDING, &idev->flags);
 	clear_bit(IDEV_IO_READY, &idev->flags);
 	clear_bit(IDEV_GONE, &idev->flags);
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(IDEV_ALLOCATED, &idev->flags);
 	wake_up(&ihost->eventq);
 }
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index c886ad1..73ab75d 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -951,7 +951,7 @@ static int tcm_loop_port_link(
 	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 
 	atomic_inc(&tl_tpg->tl_tpg_port_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	/*
 	 * Add Linux/SCSI struct scsi_device by HCTL
 	 */
@@ -986,7 +986,7 @@ static void tcm_loop_port_unlink(
 	scsi_device_put(sd);
 
 	atomic_dec(&tl_tpg->tl_tpg_port_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 
 	pr_debug("TCM_Loop_ConfigFS: Port Unlink Successful\n");
 }
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index fcbe612..0b79b85 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -393,7 +393,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 					continue;
 
 				atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
-				smp_mb__after_atomic_inc();
+				smp_mb__after_atomic();
 
 				spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
@@ -404,7 +404,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 
 				spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 				atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				break;
 			}
 			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
@@ -990,7 +990,7 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		 * TARGET PORT GROUPS command
 		 */
 		atomic_inc(&mem->tg_pt_gp_mem_ref_cnt);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
 		spin_lock_bh(&port->sep_alua_lock);
@@ -1020,7 +1020,7 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 
 		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 		atomic_dec(&mem->tg_pt_gp_mem_ref_cnt);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	/*
@@ -1054,7 +1054,7 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		core_alua_dump_state(tg_pt_gp->tg_pt_gp_alua_pending_state));
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
 	if (tg_pt_gp->tg_pt_gp_transition_complete)
@@ -1116,7 +1116,7 @@ static int core_alua_do_transition_tg_pt(
 	 */
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
 	if (!explicit && tg_pt_gp->tg_pt_gp_implicit_trans_secs) {
@@ -1159,7 +1159,7 @@ int core_alua_do_port_transition(
 	spin_lock(&local_lu_gp_mem->lu_gp_mem_lock);
 	lu_gp = local_lu_gp_mem->lu_gp;
 	atomic_inc(&lu_gp->lu_gp_ref_cnt);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	spin_unlock(&local_lu_gp_mem->lu_gp_mem_lock);
 	/*
 	 * For storage objects that are members of the 'default_lu_gp',
@@ -1176,7 +1176,7 @@ int core_alua_do_port_transition(
 		rc = core_alua_do_transition_tg_pt(l_tg_pt_gp,
 						   new_state, explicit);
 		atomic_dec(&lu_gp->lu_gp_ref_cnt);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		return rc;
 	}
 	/*
@@ -1190,7 +1190,7 @@ int core_alua_do_port_transition(
 
 		dev = lu_gp_mem->lu_gp_mem_dev;
 		atomic_inc(&lu_gp_mem->lu_gp_mem_ref_cnt);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&lu_gp->lu_gp_lock);
 
 		spin_lock(&dev->t10_alua.tg_pt_gps_lock);
@@ -1219,7 +1219,7 @@ int core_alua_do_port_transition(
 				tg_pt_gp->tg_pt_gp_alua_nacl = NULL;
 			}
 			atomic_inc(&tg_pt_gp->tg_pt_gp_ref_cnt);
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 			/*
 			 * core_alua_do_transition_tg_pt() will always return
@@ -1230,7 +1230,7 @@ int core_alua_do_port_transition(
 
 			spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 			atomic_dec(&tg_pt_gp->tg_pt_gp_ref_cnt);
-			smp_mb__after_atomic_dec();
+			smp_mb__after_atomic();
 			if (rc)
 				break;
 		}
@@ -1238,7 +1238,7 @@ int core_alua_do_port_transition(
 
 		spin_lock(&lu_gp->lu_gp_lock);
 		atomic_dec(&lu_gp_mem->lu_gp_mem_ref_cnt);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&lu_gp->lu_gp_lock);
 
@@ -1252,7 +1252,7 @@ int core_alua_do_port_transition(
 	}
 
 	atomic_dec(&lu_gp->lu_gp_ref_cnt);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 	return rc;
 }
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 65001e1..7261877 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -225,7 +225,7 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 			continue;
 
 		atomic_inc(&deve->pr_ref_count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock_irq(&nacl->device_list_lock);
 
 		return deve;
@@ -1392,7 +1392,7 @@ int core_dev_add_initiator_node_lun_acl(
 	spin_lock(&lun->lun_acl_lock);
 	list_add_tail(&lacl->lacl_list, &lun->lun_acl_list);
 	atomic_inc(&lun->lun_acl_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	spin_unlock(&lun->lun_acl_lock);
 
 	pr_debug("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
@@ -1426,7 +1426,7 @@ int core_dev_del_initiator_node_lun_acl(
 	spin_lock(&lun->lun_acl_lock);
 	list_del(&lacl->lacl_list);
 	atomic_dec(&lun->lun_acl_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 	spin_unlock(&lun->lun_acl_lock);
 
 	core_disable_device_list_for_node(lun, NULL, lacl->mapped_lun,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 9e0232c..7e6b857 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -323,7 +323,7 @@ static void iblock_bio_done(struct bio *bio, int err)
 		 * Bump the ib_bio_err_cnt and release bio.
 		 */
 		atomic_inc(&ibr->ib_bio_err_cnt);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 	}
 
 	bio_put(bio);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 3013287..df35786 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -675,7 +675,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 	spin_lock(&dev->se_port_lock);
 	list_for_each_entry_safe(port, port_tmp, &dev->dev_sep_list, sep_list) {
 		atomic_inc(&port->sep_tg_pt_ref_cnt);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&dev->se_port_lock);
 
 		spin_lock_bh(&port->sep_alua_lock);
@@ -710,7 +710,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				continue;
 
 			atomic_inc(&deve_tmp->pr_ref_count);
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			spin_unlock_bh(&port->sep_alua_lock);
 			/*
 			 * Grab a configfs group dependency that is released
@@ -723,9 +723,9 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
 				atomic_dec(&port->sep_tg_pt_ref_cnt);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				atomic_dec(&deve_tmp->pr_ref_count);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				goto out;
 			}
 			/*
@@ -740,9 +740,9 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
 				atomic_dec(&port->sep_tg_pt_ref_cnt);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				atomic_dec(&deve_tmp->pr_ref_count);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				core_scsi3_lunacl_undepend_item(deve_tmp);
 				goto out;
 			}
@@ -755,7 +755,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 
 		spin_lock(&dev->se_port_lock);
 		atomic_dec(&port->sep_tg_pt_ref_cnt);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&dev->se_port_lock);
 
@@ -1110,7 +1110,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 					continue;
 			}
 			atomic_inc(&pr_reg->pr_res_holders);
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			spin_unlock(&pr_tmpl->registration_lock);
 			return pr_reg;
 		}
@@ -1125,7 +1125,7 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
 			continue;
 
 		atomic_inc(&pr_reg->pr_res_holders);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&pr_tmpl->registration_lock);
 		return pr_reg;
 	}
@@ -1155,7 +1155,7 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(
 static void core_scsi3_put_pr_reg(struct t10_pr_registration *pr_reg)
 {
 	atomic_dec(&pr_reg->pr_res_holders);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static int core_scsi3_check_implicit_release(
@@ -1349,7 +1349,7 @@ static void core_scsi3_tpg_undepend_item(struct se_portal_group *tpg)
 			&tpg->tpg_group.cg_item);
 
 	atomic_dec(&tpg->tpg_pr_ref_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static int core_scsi3_nodeacl_depend_item(struct se_node_acl *nacl)
@@ -1369,7 +1369,7 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
 
 	if (nacl->dynamic_node_acl) {
 		atomic_dec(&nacl->acl_pr_ref_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		return;
 	}
 
@@ -1377,7 +1377,7 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
 			&nacl->acl_group.cg_item);
 
 	atomic_dec(&nacl->acl_pr_ref_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
@@ -1408,7 +1408,7 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 	 */
 	if (!lun_acl) {
 		atomic_dec(&se_deve->pr_ref_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		return;
 	}
 	nacl = lun_acl->se_lun_nacl;
@@ -1418,7 +1418,7 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 			&lun_acl->se_lun_group.cg_item);
 
 	atomic_dec(&se_deve->pr_ref_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static sense_reason_t
@@ -1552,14 +1552,14 @@ core_scsi3_decode_spec_i_port(
 				continue;
 
 			atomic_inc(&tmp_tpg->tpg_pr_ref_count);
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			spin_unlock(&dev->se_port_lock);
 
 			if (core_scsi3_tpg_depend_item(tmp_tpg)) {
 				pr_err(" core_scsi3_tpg_depend_item()"
 					" for tmp_tpg\n");
 				atomic_dec(&tmp_tpg->tpg_pr_ref_count);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 				goto out_unmap;
 			}
@@ -1573,7 +1573,7 @@ core_scsi3_decode_spec_i_port(
 						tmp_tpg, i_str);
 			if (dest_node_acl) {
 				atomic_inc(&dest_node_acl->acl_pr_ref_count);
-				smp_mb__after_atomic_inc();
+				smp_mb__after_atomic();
 			}
 			spin_unlock_irq(&tmp_tpg->acl_node_lock);
 
@@ -1587,7 +1587,7 @@ core_scsi3_decode_spec_i_port(
 				pr_err("configfs_depend_item() failed"
 					" for dest_node_acl->acl_group\n");
 				atomic_dec(&dest_node_acl->acl_pr_ref_count);
-				smp_mb__after_atomic_dec();
+				smp_mb__after_atomic();
 				core_scsi3_tpg_undepend_item(tmp_tpg);
 				ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 				goto out_unmap;
@@ -1647,7 +1647,7 @@ core_scsi3_decode_spec_i_port(
 			pr_err("core_scsi3_lunacl_depend_item()"
 					" failed\n");
 			atomic_dec(&dest_se_deve->pr_ref_count);
-			smp_mb__after_atomic_dec();
+			smp_mb__after_atomic();
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -3168,14 +3168,14 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 			continue;
 
 		atomic_inc(&dest_se_tpg->tpg_pr_ref_count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&dev->se_port_lock);
 
 		if (core_scsi3_tpg_depend_item(dest_se_tpg)) {
 			pr_err("core_scsi3_tpg_depend_item() failed"
 				" for dest_se_tpg\n");
 			atomic_dec(&dest_se_tpg->tpg_pr_ref_count);
-			smp_mb__after_atomic_dec();
+			smp_mb__after_atomic();
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			goto out_put_pr_reg;
 		}
@@ -3273,7 +3273,7 @@ after_iport_check:
 				initiator_str);
 	if (dest_node_acl) {
 		atomic_inc(&dest_node_acl->acl_pr_ref_count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 	}
 	spin_unlock_irq(&dest_se_tpg->acl_node_lock);
 
@@ -3289,7 +3289,7 @@ after_iport_check:
 		pr_err("core_scsi3_nodeacl_depend_item() for"
 			" dest_node_acl\n");
 		atomic_dec(&dest_node_acl->acl_pr_ref_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		dest_node_acl = NULL;
 		ret = TCM_INVALID_PARAMETER_LIST;
 		goto out;
@@ -3314,7 +3314,7 @@ after_iport_check:
 	if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
 		pr_err("core_scsi3_lunacl_depend_item() failed\n");
 		atomic_dec(&dest_se_deve->pr_ref_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		dest_se_deve = NULL;
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
@@ -3880,7 +3880,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		add_desc_len = 0;
 
 		atomic_inc(&pr_reg->pr_res_holders);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		spin_unlock(&pr_tmpl->registration_lock);
 		/*
 		 * Determine expected length of $FABRIC_MOD specific
@@ -3894,7 +3894,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 				" out of buffer: %d\n", cmd->data_length);
 			spin_lock(&pr_tmpl->registration_lock);
 			atomic_dec(&pr_reg->pr_res_holders);
-			smp_mb__after_atomic_dec();
+			smp_mb__after_atomic();
 			break;
 		}
 		/*
@@ -3956,7 +3956,7 @@ core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 
 		spin_lock(&pr_tmpl->registration_lock);
 		atomic_dec(&pr_reg->pr_res_holders);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		/*
 		 * Set the ADDITIONAL DESCRIPTOR LENGTH
 		 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d4b9869..4badca1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -736,7 +736,7 @@ void target_qf_do_work(struct work_struct *work)
 	list_for_each_entry_safe(cmd, cmd_tmp, &qf_cmd_list, se_qf_node) {
 		list_del(&cmd->se_qf_node);
 		atomic_dec(&dev->dev_qf_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 
 		pr_debug("Processing %s cmd: %p QUEUE_FULL in work queue"
 			" context: %s\n", cmd->se_tfo->get_fabric_name(), cmd,
@@ -1148,7 +1148,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
 	 * Dormant to Active status.
 	 */
 	cmd->se_ordered_id = atomic_inc_return(&dev->dev_ordered_id);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	pr_debug("Allocated se_ordered_id: %u for Task Attr: 0x%02x on %s\n",
 			cmd->se_ordered_id, cmd->sam_task_attr,
 			dev->transport->name);
@@ -1705,7 +1705,7 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 		return false;
 	case MSG_ORDERED_TAG:
 		atomic_inc(&dev->dev_ordered_sync);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 
 		pr_debug("Added ORDERED for CDB: 0x%02x to ordered list, "
 			 " se_ordered_id: %u\n",
@@ -1723,7 +1723,7 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 		 * For SIMPLE and UNTAGGED Task Attribute commands
 		 */
 		atomic_inc(&dev->simple_cmds);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		break;
 	}
 
@@ -1828,7 +1828,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 
 	if (cmd->sam_task_attr == MSG_SIMPLE_TAG) {
 		atomic_dec(&dev->simple_cmds);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 		dev->dev_cur_ordered_id++;
 		pr_debug("Incremented dev->dev_cur_ordered_id: %u for"
 			" SIMPLE: %u\n", dev->dev_cur_ordered_id,
@@ -1840,7 +1840,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 			cmd->se_ordered_id);
 	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
 		atomic_dec(&dev->dev_ordered_sync);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 
 		dev->dev_cur_ordered_id++;
 		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED:"
@@ -1899,7 +1899,7 @@ static void transport_handle_queue_full(
 	spin_lock_irq(&dev->qf_cmd_lock);
 	list_add_tail(&cmd->se_qf_node, &cmd->se_dev->qf_cmd_list);
 	atomic_inc(&dev->dev_qf_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	spin_unlock_irq(&cmd->se_dev->qf_cmd_lock);
 
 	schedule_work(&cmd->se_dev->qf_work_queue);
@@ -2875,7 +2875,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
 			cmd->transport_state |= CMD_T_ABORTED;
 			cmd->se_cmd_flags |= SCF_SEND_DELAYED_TAS;
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			return;
 		}
 	}
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 505519b..101858e 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -162,7 +162,7 @@ int core_scsi3_ua_allocate(
 		spin_unlock_irq(&nacl->device_list_lock);
 
 		atomic_inc(&deve->ua_count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		return 0;
 	}
 	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
@@ -175,7 +175,7 @@ int core_scsi3_ua_allocate(
 		asc, ascq);
 
 	atomic_inc(&deve->ua_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	return 0;
 }
 
@@ -190,7 +190,7 @@ void core_scsi3_ua_release_all(
 		kmem_cache_free(se_ua_cache, ua);
 
 		atomic_dec(&deve->ua_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&deve->ua_lock);
 }
@@ -251,7 +251,7 @@ void core_scsi3_ua_for_check_condition(
 		kmem_cache_free(se_ua_cache, ua);
 
 		atomic_dec(&deve->ua_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&deve->ua_lock);
 	spin_unlock_irq(&nacl->device_list_lock);
@@ -310,7 +310,7 @@ int core_scsi3_ua_clear_for_request_sense(
 		kmem_cache_free(se_ua_cache, ua);
 
 		atomic_dec(&deve->ua_count);
-		smp_mb__after_atomic_dec();
+		smp_mb__after_atomic();
 	}
 	spin_unlock(&deve->ua_lock);
 	spin_unlock_irq(&nacl->device_list_lock);
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 41fe8a0..746ae80 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2041,7 +2041,7 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 
 	if (found)
 		clear_bit(eol, ldata->read_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	ldata->read_tail += c;
 
 	if (found) {
diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index aa97fd8..4b5b3c2 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -200,7 +200,7 @@ static void dma_tx_callback(void *param)
 
 	/* clear the bit used to serialize the DMA tx. */
 	clear_bit(MXS_AUART_DMA_TX_SYNC, &s->flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	/* wake up the possible processes. */
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
@@ -275,7 +275,7 @@ static void mxs_auart_tx_chars(struct mxs_auart_port *s)
 			mxs_auart_dma_tx(s, i);
 		} else {
 			clear_bit(MXS_AUART_DMA_TX_SYNC, &s->flags);
-			smp_mb__after_clear_bit();
+			smp_mb__after_atomic();
 		}
 		return;
 	}
diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index f058c03..819875c 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1851,7 +1851,7 @@ static int usbg_port_link(struct se_portal_group *se_tpg, struct se_lun *lun)
 	struct usbg_tpg *tpg = container_of(se_tpg, struct usbg_tpg, se_tpg);
 
 	atomic_inc(&tpg->tpg_port_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	return 0;
 }
 
@@ -1861,7 +1861,7 @@ static void usbg_port_unlink(struct se_portal_group *se_tpg,
 	struct usbg_tpg *tpg = container_of(se_tpg, struct usbg_tpg, se_tpg);
 
 	atomic_dec(&tpg->tpg_port_count);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static int usbg_check_stop_free(struct se_cmd *se_cmd)
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 640fe01..f1ec168 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -325,7 +325,7 @@ static void usb_wwan_outdat_callback(struct urb *urb)
 
 	for (i = 0; i < N_OUT_URB; ++i) {
 		if (portdata->out_urbs[i] == urb) {
-			smp_mb__before_clear_bit();
+			smp_mb__before_atomic();
 			clear_bit(i, &portdata->out_busy);
 			break;
 		}
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index cf50ce9..aeb5131 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1255,7 +1255,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			tpg->tv_tpg_vhost_count++;
 			tpg->vhost_scsi = vs;
 			vs_tpg[tpg->tport_tpgt] = tpg;
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 			match = true;
 		}
 		mutex_unlock(&tpg->tv_tpg_mutex);
diff --git a/drivers/w1/w1_family.c b/drivers/w1/w1_family.c
index 3bff6b3..3651ec8 100644
--- a/drivers/w1/w1_family.c
+++ b/drivers/w1/w1_family.c
@@ -139,9 +139,9 @@ void w1_family_get(struct w1_family *f)
 
 void __w1_family_get(struct w1_family *f)
 {
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_inc(&f->refcnt);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 EXPORT_SYMBOL(w1_unregister_family);
diff --git a/drivers/xen/xen-pciback/pciback_ops.c b/drivers/xen/xen-pciback/pciback_ops.c
index 607e414..c4a0666 100644
--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -348,9 +348,9 @@ void xen_pcibk_do_op(struct work_struct *data)
 	notify_remote_via_irq(pdev->evtchn_irq);
 
 	/* Mark that we're done. */
-	smp_mb__before_clear_bit(); /* /after/ clearing PCIF_active */
+	smp_mb__before_atomic(); /* /after/ clearing PCIF_active */
 	clear_bit(_PDEVF_op_active, &pdev->flags);
-	smp_mb__after_clear_bit(); /* /before/ final check for work */
+	smp_mb__after_atomic(); /* /before/ final check for work */
 
 	/* Check to see if the driver domain tried to start another request in
 	 * between clearing _XEN_PCIF_active and clearing _PDEVF_op_active.
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index c9a2444..2256e9c 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -279,7 +279,7 @@ static inline void btrfs_inode_block_unlocked_dio(struct inode *inode)
 
 static inline void btrfs_inode_resume_unlocked_dio(struct inode *inode)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(BTRFS_INODE_READDIO_NEED_LOCK,
 		  &BTRFS_I(inode)->runtime_flags);
 }
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3955e47..f29a54e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3458,7 +3458,7 @@ static int lock_extent_buffer_for_io(struct extent_buffer *eb,
 static void end_extent_buffer_writeback(struct extent_buffer *eb)
 {
 	clear_bit(EXTENT_BUFFER_WRITEBACK, &eb->bflags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK);
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5f805bc..5a3b837 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7126,7 +7126,7 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 		 * before atomic variable goto zero, we must make sure
 		 * dip->errors is perceived to be set.
 		 */
-		smp_mb__before_atomic_dec();
+		smp_mb__before_atomic();
 	}
 
 	/* if there are more bios still pending for this dio, just exit */
@@ -7306,7 +7306,7 @@ out_err:
 	 * before atomic variable goto zero, we must
 	 * make sure dip->errors is perceived to be set.
 	 */
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	if (atomic_dec_and_test(&dip->pending_bios))
 		bio_io_error(dip->orig_bio);
 
@@ -7449,7 +7449,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		return 0;
 
 	atomic_inc(&inode->i_dio_count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 
 	/*
 	 * The generic stuff only does filemap_write_and_wait_range, which
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e79ff6b..f45040a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -642,7 +642,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
 		return -EINVAL;
 
 	atomic_inc(&root->will_be_snapshoted);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	btrfs_wait_nocow_write(root);
 
 	ret = btrfs_start_delalloc_inodes(root, 0);
diff --git a/fs/buffer.c b/fs/buffer.c
index 9ddb9fc..6a8110c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -77,7 +77,7 @@ EXPORT_SYMBOL(__lock_buffer);
 void unlock_buffer(struct buffer_head *bh)
 {
 	clear_bit_unlock(BH_Lock, &bh->b_state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&bh->b_state, BH_Lock);
 }
 EXPORT_SYMBOL(unlock_buffer);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f3b84cd..08b3c11 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -42,7 +42,7 @@ int ext4_resize_begin(struct super_block *sb)
 void ext4_resize_end(struct super_block *sb)
 {
 	clear_bit_unlock(EXT4_RESIZING, &EXT4_SB(sb)->s_resize_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 static ext4_group_t ext4_meta_bg_first_group(struct super_block *sb,
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index aec7f73..c355f73 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -277,7 +277,7 @@ static inline int may_grant(const struct gfs2_glock *gl, const struct gfs2_holde
 static void gfs2_holder_wake(struct gfs2_holder *gh)
 {
 	clear_bit(HIF_WAIT, &gh->gh_iflags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&gh->gh_iflags, HIF_WAIT);
 }
 
@@ -411,7 +411,7 @@ static void gfs2_demote_wake(struct gfs2_glock *gl)
 {
 	gl->gl_demote_state = LM_ST_EXCLUSIVE;
 	clear_bit(GLF_DEMOTE, &gl->gl_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&gl->gl_flags, GLF_DEMOTE);
 }
 
@@ -620,7 +620,7 @@ out:
 
 out_sched:
 	clear_bit(GLF_LOCK, &gl->gl_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	gl->gl_lockref.count++;
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 		gl->gl_lockref.count--;
@@ -628,7 +628,7 @@ out_sched:
 
 out_unlock:
 	clear_bit(GLF_LOCK, &gl->gl_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	return;
 }
 
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 54b66809..74d9a3d 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -221,7 +221,7 @@ static void inode_go_sync(struct gfs2_glock *gl)
 	 * Writeback of the data mapping may cause the dirty flag to be set
 	 * so we have to clear it again here.
 	 */
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(GLF_DIRTY, &gl->gl_flags);
 }
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index c1eb555..91f274d 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -1134,7 +1134,7 @@ static void gdlm_recover_done(void *arg, struct dlm_slot *slots, int num_slots,
 		queue_delayed_work(gfs2_control_wq, &sdp->sd_control_work, 0);
 
 	clear_bit(DFL_DLM_RECOVERY, &ls->ls_recover_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&ls->ls_recover_flags, DFL_DLM_RECOVERY);
 	spin_unlock(&ls->ls_recover_spin);
 }
@@ -1271,7 +1271,7 @@ static int gdlm_mount(struct gfs2_sbd *sdp, const char *table)
 
 	ls->ls_first = !!test_bit(DFL_FIRST_MOUNT, &ls->ls_recover_flags);
 	clear_bit(SDF_NOJOURNALID, &sdp->sd_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&sdp->sd_flags, SDF_NOJOURNALID);
 	return 0;
 
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 7ad4094..fe7a56f 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -587,7 +587,7 @@ fail:
 	gfs2_recovery_done(sdp, jd->jd_jid, LM_RD_GAVEUP);
 done:
 	clear_bit(JDF_RECOVERY, &jd->jd_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
 }
 
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index de25d55..529d9a9 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -333,7 +333,7 @@ static ssize_t block_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 		set_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
 	else if (val == 0) {
 		clear_bit(DFL_BLOCK_LOCKS, &ls->ls_recover_flags);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		gfs2_glock_thaw(sdp);
 	} else {
 		ret = -EINVAL;
@@ -482,7 +482,7 @@ static ssize_t jid_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 		rv = jid = -EINVAL;
 	sdp->sd_lockstruct.ls_jid = jid;
 	clear_bit(SDF_NOJOURNALID, &sdp->sd_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&sdp->sd_flags, SDF_NOJOURNALID);
 out:
 	spin_unlock(&sdp->sd_jindex_spin);
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 5f26139..6fac743 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -43,7 +43,7 @@ static void journal_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
 		clear_buffer_uptodate(bh);
 	if (orig_bh) {
 		clear_bit_unlock(BH_Shadow, &orig_bh->b_state);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		wake_up_bit(&orig_bh->b_state, BH_Shadow);
 	}
 	unlock_buffer(bh);
@@ -239,7 +239,7 @@ static int journal_submit_data_buffers(journal_t *journal,
 		spin_lock(&journal->j_list_lock);
 		J_ASSERT(jinode->i_transaction == commit_transaction);
 		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
 	}
 	spin_unlock(&journal->j_list_lock);
@@ -277,7 +277,7 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 		}
 		spin_lock(&journal->j_list_lock);
 		clear_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
 	}
 
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index d9f3d06..4a3d4ef 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2032,9 +2032,9 @@ static void nfs_access_free_entry(struct nfs_access_entry *entry)
 {
 	put_rpccred(entry->cred);
 	kfree(entry);
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_long_dec(&nfs_access_nr_entries);
-	smp_mb__after_atomic_dec();
+	smp_mb__after_atomic();
 }
 
 static void nfs_access_free_list(struct list_head *head)
@@ -2082,9 +2082,9 @@ nfs_access_cache_scan(struct shrinker *shrink, struct shrink_control *sc)
 		else {
 remove_lru_entry:
 			list_del_init(&nfsi->access_cache_inode_lru);
-			smp_mb__before_clear_bit();
+			smp_mb__before_atomic();
 			clear_bit(NFS_INO_ACL_LRU_SET, &nfsi->flags);
-			smp_mb__after_clear_bit();
+			smp_mb__after_atomic();
 		}
 		spin_unlock(&inode->i_lock);
 	}
@@ -2232,9 +2232,9 @@ void nfs_access_add_cache(struct inode *inode, struct nfs_access_entry *set)
 	nfs_access_add_rbtree(inode, cache);
 
 	/* Update accounting */
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_long_inc(&nfs_access_nr_entries);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 
 	/* Add inode to global LRU list */
 	if (!test_bit(NFS_INO_ACL_LRU_SET, &NFS_I(inode)->flags)) {
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 0c43897..e6f7398 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1085,7 +1085,7 @@ int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping)
 	trace_nfs_invalidate_mapping_exit(inode, ret);
 
 	clear_bit_unlock(NFS_INO_INVALIDATING, bitlock);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(bitlock, NFS_INO_INVALIDATING);
 out:
 	return ret;
diff --git a/fs/nfs/nfs4filelayoutdev.c b/fs/nfs/nfs4filelayoutdev.c
index efac602..b9c61ef 100644
--- a/fs/nfs/nfs4filelayoutdev.c
+++ b/fs/nfs/nfs4filelayoutdev.c
@@ -789,9 +789,9 @@ static void nfs4_wait_ds_connect(struct nfs4_pnfs_ds *ds)
 
 static void nfs4_clear_ds_conn_bit(struct nfs4_pnfs_ds *ds)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(NFS4DS_CONNECTING, &ds->ds_state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&ds->ds_state, NFS4DS_CONNECTING);
 }
 
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 2349518..c0583b9 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1140,9 +1140,9 @@ static int nfs4_run_state_manager(void *);
 
 static void nfs4_clear_state_manager_bit(struct nfs_client *clp)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&clp->cl_state, NFS4CLNT_MANAGER_RUNNING);
 	rpc_wake_up(&clp->cl_rpcwaitq);
 }
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 2ffebf2..03ed984 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -95,7 +95,7 @@ nfs_iocounter_dec(struct nfs_io_counter *c)
 {
 	if (atomic_dec_and_test(&c->io_count)) {
 		clear_bit(NFS_IO_INPROGRESS, &c->flags);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		wake_up_bit(&c->flags, NFS_IO_INPROGRESS);
 	}
 }
@@ -193,9 +193,9 @@ void nfs_unlock_request(struct nfs_page *req)
 		printk(KERN_ERR "NFS: Invalid unlock attempted\n");
 		BUG();
 	}
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(PG_BUSY, &req->wb_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&req->wb_flags, PG_BUSY);
 }
 
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index cb53d45..fd9536e 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1810,7 +1810,7 @@ static void pnfs_clear_layoutcommitting(struct inode *inode)
 	unsigned long *bitlock = &NFS_I(inode)->flags;
 
 	clear_bit_unlock(NFS_INO_LAYOUTCOMMITTING, bitlock);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(bitlock, NFS_INO_LAYOUTCOMMITTING);
 }
 
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 0237939..c3058a0 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -275,7 +275,7 @@ pnfs_get_lseg(struct pnfs_layout_segment *lseg)
 {
 	if (lseg) {
 		atomic_inc(&lseg->pls_refcount);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 	}
 	return lseg;
 }
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 9a3b6a4..ffb9459 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -405,7 +405,7 @@ int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	nfs_pageio_complete(&pgio);
 
 	clear_bit_unlock(NFS_INO_FLUSHING, bitlock);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(bitlock, NFS_INO_FLUSHING);
 
 	if (err < 0)
@@ -1458,7 +1458,7 @@ static int nfs_commit_set_lock(struct nfs_inode *nfsi, int may_wait)
 static void nfs_commit_clear_lock(struct nfs_inode *nfsi)
 {
 	clear_bit(NFS_INO_COMMIT, &nfsi->flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_bit(&nfsi->flags, NFS_INO_COMMIT);
 }
 
diff --git a/fs/ubifs/lpt_commit.c b/fs/ubifs/lpt_commit.c
index 4b826ab..45d4e96 100644
--- a/fs/ubifs/lpt_commit.c
+++ b/fs/ubifs/lpt_commit.c
@@ -460,9 +460,9 @@ static int write_cnodes(struct ubifs_info *c)
 		 * important.
 		 */
 		clear_bit(DIRTY_CNODE, &cnode->flags);
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		clear_bit(COW_CNODE, &cnode->flags);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		offs += len;
 		dbg_chk_lpt_sz(c, 1, len);
 		cnode = cnode->cnext;
diff --git a/fs/ubifs/tnc_commit.c b/fs/ubifs/tnc_commit.c
index 52a6559..3600994 100644
--- a/fs/ubifs/tnc_commit.c
+++ b/fs/ubifs/tnc_commit.c
@@ -895,9 +895,9 @@ static int write_index(struct ubifs_info *c)
 		 * the reason for the second barrier.
 		 */
 		clear_bit(DIRTY_ZNODE, &znode->flags);
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		clear_bit(COW_ZNODE, &znode->flags);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 
 		/*
 		 * We have marked the znode as clean but have not updated the
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index 9ae6c34..4967351 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -80,7 +80,7 @@ static inline void set_bit(int nr, volatile unsigned long *addr)
  *
  * clear_bit() is atomic and may not be reordered.  However, it does
  * not contain a memory barrier, so if it is used for locking purposes,
- * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
+ * you should call smp_mb__before_atomic() and/or smp_mb__after_atomic()
  * in order to ensure changes are visible on other processors.
  */
 static inline void clear_bit(int nr, volatile unsigned long *addr)
diff --git a/include/asm-generic/bitops/lock.h b/include/asm-generic/bitops/lock.h
index 308a9e2..c30266e 100644
--- a/include/asm-generic/bitops/lock.h
+++ b/include/asm-generic/bitops/lock.h
@@ -20,7 +20,7 @@
  */
 #define clear_bit_unlock(nr, addr)	\
 do {					\
-	smp_mb__before_clear_bit();	\
+	smp_mb__before_atomic();	\
 	clear_bit(nr, addr);		\
 } while (0)
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c40302f..7cbf837 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -278,7 +278,7 @@ static inline void get_bh(struct buffer_head *bh)
 
 static inline void put_bh(struct buffer_head *bh)
 {
-        smp_mb__before_atomic_dec();
+        smp_mb__before_atomic();
         atomic_dec(&bh->b_count);
 }
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 9f3c275..ec274e0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -649,7 +649,7 @@ static inline void hd_ref_init(struct hd_struct *part)
 static inline void hd_struct_get(struct hd_struct *part)
 {
 	atomic_inc(&part->ref);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 static inline int hd_struct_try_get(struct hd_struct *part)
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c7bfac1..1571110 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -453,7 +453,7 @@ static inline int tasklet_trylock(struct tasklet_struct *t)
 
 static inline void tasklet_unlock(struct tasklet_struct *t)
 {
-	smp_mb__before_clear_bit(); 
+	smp_mb__before_atomic();
 	clear_bit(TASKLET_STATE_RUN, &(t)->state);
 }
 
@@ -501,7 +501,7 @@ static inline void tasklet_hi_schedule_first(struct tasklet_struct *t)
 static inline void tasklet_disable_nosync(struct tasklet_struct *t)
 {
 	atomic_inc(&t->count);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 static inline void tasklet_disable(struct tasklet_struct *t)
@@ -513,13 +513,13 @@ static inline void tasklet_disable(struct tasklet_struct *t)
 
 static inline void tasklet_enable(struct tasklet_struct *t)
 {
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&t->count);
 }
 
 static inline void tasklet_hi_enable(struct tasklet_struct *t)
 {
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&t->count);
 }
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7ed3a3a..616415a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -493,7 +493,7 @@ static inline void napi_disable(struct napi_struct *n)
 static inline void napi_enable(struct napi_struct *n)
 {
 	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(NAPI_STATE_SCHED, &n->state);
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..010cde3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2782,10 +2782,8 @@ static inline bool __must_check current_set_polling_and_test(void)
 	/*
 	 * Polling state must be visible before we test NEED_RESCHED,
 	 * paired by resched_task()
-	 *
-	 * XXX: assumes set/clear bit are identical barrier wise.
 	 */
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	return unlikely(tif_need_resched());
 }
@@ -2803,7 +2801,7 @@ static inline bool __must_check current_clr_polling_and_test(void)
 	 * Polling state must be visible before we test NEED_RESCHED,
 	 * paired by resched_task()
 	 */
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	return unlikely(tif_need_resched());
 }
diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index 3a847de..ad7dbe2 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -142,18 +142,18 @@ struct rpc_task_setup {
 				test_and_set_bit(RPC_TASK_RUNNING, &(t)->tk_runstate)
 #define rpc_clear_running(t)	\
 	do { \
-		smp_mb__before_clear_bit(); \
+		smp_mb__before_atomic(); \
 		clear_bit(RPC_TASK_RUNNING, &(t)->tk_runstate); \
-		smp_mb__after_clear_bit(); \
+		smp_mb__after_atomic(); \
 	} while (0)
 
 #define RPC_IS_QUEUED(t)	test_bit(RPC_TASK_QUEUED, &(t)->tk_runstate)
 #define rpc_set_queued(t)	set_bit(RPC_TASK_QUEUED, &(t)->tk_runstate)
 #define rpc_clear_queued(t)	\
 	do { \
-		smp_mb__before_clear_bit(); \
+		smp_mb__before_atomic(); \
 		clear_bit(RPC_TASK_QUEUED, &(t)->tk_runstate); \
-		smp_mb__after_clear_bit(); \
+		smp_mb__after_atomic(); \
 	} while (0)
 
 #define RPC_IS_ACTIVATED(t)	test_bit(RPC_TASK_ACTIVE, &(t)->tk_runstate)
diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index 3e5efb2..3876f0f 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -379,9 +379,9 @@ static inline int xprt_test_and_clear_connected(struct rpc_xprt *xprt)
 
 static inline void xprt_clear_connecting(struct rpc_xprt *xprt)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(XPRT_CONNECTING, &xprt->state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 static inline int xprt_connecting(struct rpc_xprt *xprt)
@@ -411,9 +411,9 @@ static inline void xprt_clear_bound(struct rpc_xprt *xprt)
 
 static inline void xprt_clear_binding(struct rpc_xprt *xprt)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(XPRT_BINDING, &xprt->state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 static inline int xprt_test_and_set_binding(struct rpc_xprt *xprt)
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 1e98b55..6f8ab7d 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -191,7 +191,7 @@ static inline void tracehook_notify_resume(struct pt_regs *regs)
 	 * pairs with task_work_add()->set_notify_resume() after
 	 * hlist_add_head(task->task_works);
 	 */
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	if (unlikely(current->task_works))
 		task_work_run();
 }
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 5679d92..624a8a5 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1204,7 +1204,7 @@ static inline bool __ip_vs_conn_get(struct ip_vs_conn *cp)
 /* put back the conn without restarting its timer */
 static inline void __ip_vs_conn_put(struct ip_vs_conn *cp)
 {
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&cp->refcnt);
 }
 void ip_vs_conn_put(struct ip_vs_conn *cp);
@@ -1408,7 +1408,7 @@ static inline void ip_vs_dest_hold(struct ip_vs_dest *dest)
 
 static inline void ip_vs_dest_put(struct ip_vs_dest *dest)
 {
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&dest->refcnt);
 }
 
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 2956c8d..1adf62b 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -534,7 +534,7 @@ return_normal:
 			kgdb_info[cpu].exception_state &=
 				~(DCPU_WANT_MASTER | DCPU_IS_SLAVE);
 			kgdb_info[cpu].enter_kgdb--;
-			smp_mb__before_atomic_dec();
+			smp_mb__before_atomic();
 			atomic_dec(&slaves_in_kgdb);
 			dbg_touch_watchdogs();
 			local_irq_restore(flags);
@@ -662,7 +662,7 @@ kgdb_restore:
 	kgdb_info[cpu].exception_state &=
 		~(DCPU_WANT_MASTER | DCPU_IS_SLAVE);
 	kgdb_info[cpu].enter_kgdb--;
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&masters_in_kgdb);
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
diff --git a/kernel/futex.c b/kernel/futex.c
index 5f58927..b991ec0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -267,7 +267,7 @@ static inline void futex_get_mm(union futex_key *key)
 	 * get_futex_key() implies a full barrier. This is relied upon
 	 * as full barrier (B), see the ordering comment above.
 	 */
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 /*
@@ -280,7 +280,7 @@ static inline void hb_waiters_inc(struct futex_hash_bucket *hb)
 	/*
 	 * Full barrier (A), see the ordering comment above.
 	 */
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 #endif
 }
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 6b375af..0ac67a5 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -498,7 +498,7 @@ int __usermodehelper_disable(enum umh_disable_depth depth)
 static void helper_lock(void)
 {
 	atomic_inc(&running_helpers);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 }
 
 static void helper_unlock(void)
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0c47e30..88b4a1d 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -387,9 +387,9 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 	}
 	rcu_prepare_for_idle(smp_processor_id());
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
-	smp_mb__before_atomic_inc();  /* See above. */
+	smp_mb__before_atomic();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
-	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
+	smp_mb__after_atomic();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 
 	/*
@@ -507,10 +507,10 @@ void rcu_irq_exit(void)
 static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 			       int user)
 {
-	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
+	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
-	smp_mb__after_atomic_inc();  /* See above. */
+	smp_mb__after_atomic();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 	rcu_cleanup_after_idle(smp_processor_id());
 	trace_rcu_dyntick(TPS("End"), oldval, rdtp->dynticks_nesting);
@@ -635,10 +635,10 @@ void rcu_nmi_enter(void)
 	    (atomic_read(&rdtp->dynticks) & 0x1))
 		return;
 	rdtp->dynticks_nmi_nesting++;
-	smp_mb__before_atomic_inc();  /* Force delay from prior write. */
+	smp_mb__before_atomic();  /* Force delay from prior write. */
 	atomic_inc(&rdtp->dynticks);
 	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
-	smp_mb__after_atomic_inc();  /* See above. */
+	smp_mb__after_atomic();  /* See above. */
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 }
 
@@ -657,9 +657,9 @@ void rcu_nmi_exit(void)
 	    --rdtp->dynticks_nmi_nesting != 0)
 		return;
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
-	smp_mb__before_atomic_inc();  /* See above. */
+	smp_mb__before_atomic();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
-	smp_mb__after_atomic_inc();  /* Force delay to next write. */
+	smp_mb__after_atomic();  /* Force delay to next write. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
 }
 
@@ -2790,7 +2790,7 @@ void synchronize_sched_expedited(void)
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
 			/* ensure test happens before caller kfree */
-			smp_mb__before_atomic_inc(); /* ^^^ */
+			smp_mb__before_atomic(); /* ^^^ */
 			atomic_long_inc(&rsp->expedited_workdone1);
 			return;
 		}
@@ -2808,7 +2808,7 @@ void synchronize_sched_expedited(void)
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)firstsnap)) {
 			/* ensure test happens before caller kfree */
-			smp_mb__before_atomic_inc(); /* ^^^ */
+			smp_mb__before_atomic(); /* ^^^ */
 			atomic_long_inc(&rsp->expedited_workdone2);
 			return;
 		}
@@ -2837,7 +2837,7 @@ void synchronize_sched_expedited(void)
 		s = atomic_long_read(&rsp->expedited_done);
 		if (ULONG_CMP_GE((ulong)s, (ulong)snap)) {
 			/* ensure test happens before caller kfree */
-			smp_mb__before_atomic_inc(); /* ^^^ */
+			smp_mb__before_atomic(); /* ^^^ */
 			atomic_long_inc(&rsp->expedited_done_lost);
 			break;
 		}
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 962d1d5..56db2f8 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2523,9 +2523,9 @@ static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
 	/* Record start of fully idle period. */
 	j = jiffies;
 	ACCESS_ONCE(rdtp->dynticks_idle_jiffies) = j;
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_inc(&rdtp->dynticks_idle);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks_idle) & 0x1);
 }
 
@@ -2590,9 +2590,9 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
 	}
 
 	/* Record end of idle period. */
-	smp_mb__before_atomic_inc();
+	smp_mb__before_atomic();
 	atomic_inc(&rdtp->dynticks_idle);
-	smp_mb__after_atomic_inc();
+	smp_mb__after_atomic();
 	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
 
 	/*
diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 8b836b3..746bc93 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -165,7 +165,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 		 * do a write memory barrier, and then update the count, to
 		 * make sure the vector is visible when count is set.
 		 */
-		smp_mb__before_atomic_inc();
+		smp_mb__before_atomic();
 		atomic_inc(&(vec)->count);
 		do_mb = 1;
 	}
@@ -185,14 +185,14 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
 		 * the new priority vec.
 		 */
 		if (do_mb)
-			smp_mb__after_atomic_inc();
+			smp_mb__after_atomic();
 
 		/*
 		 * When removing from the vector, we decrement the counter first
 		 * do a memory barrier and then clear the mask.
 		 */
 		atomic_dec(&(vec)->count);
-		smp_mb__after_atomic_inc();
+		smp_mb__after_atomic();
 		cpumask_clear_cpu(cpu, vec->mask);
 	}
 
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 7d50f79..0ffa20a 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -394,7 +394,7 @@ EXPORT_SYMBOL(__wake_up_bit);
  *
  * In order for this to function properly, as it uses waitqueue_active()
  * internally, some kind of memory barrier must be done prior to calling
- * this. Typically, this will be smp_mb__after_clear_bit(), but in some
+ * this. Typically, this will be smp_mb__after_atomic(), but in some
  * cases where bitflags are manipulated non-atomically under a lock, one
  * may need to use a less regular barrier, such fs/inode.c's smp_mb(),
  * because spin_unlock() does not guarantee a memory barrier.
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 09d9591..1706cbb 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -557,7 +557,7 @@ void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
 	bit = sync ? BDI_sync_congested : BDI_async_congested;
 	if (test_and_clear_bit(bit, &bdi->state))
 		atomic_dec(&nr_bdi_congested[sync]);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	if (waitqueue_active(wqh))
 		wake_up(wqh);
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index a82fbe4..c73535c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -740,7 +740,7 @@ void unlock_page(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	clear_bit_unlock(PG_locked, &page->flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_page(page, PG_locked);
 }
 EXPORT_SYMBOL(unlock_page);
@@ -757,7 +757,7 @@ void end_page_writeback(struct page *page)
 	if (!test_clear_page_writeback(page))
 		BUG();
 
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	wake_up_page(page, PG_writeback);
 }
 EXPORT_SYMBOL(end_page_writeback);
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index 8c93267..c4e0984 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -252,7 +252,7 @@ static int pppoatm_may_send(struct pppoatm_vcc *pvcc, int size)
 	 * we need to ensure there's a memory barrier after it. The bit
 	 * *must* be set before we do the atomic_inc() on pvcc->inflight.
 	 * There's no smp_mb__after_set_bit(), so it's this or abuse
-	 * smp_mb__after_clear_bit().
+	 * smp_mb__after_atomic().
 	 */
 	test_and_set_bit(BLOCKED, &pvcc->blocked);
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4977491..7401442 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -45,7 +45,7 @@ static void hci_cc_inquiry_cancel(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 
 	clear_bit(HCI_INQUIRY, &hdev->flags);
-	smp_mb__after_clear_bit(); /* wake_up_bit advises about this barrier */
+	smp_mb__after_atomic(); /* wake_up_bit advises about this barrier */
 	wake_up_bit(&hdev->flags, HCI_INQUIRY);
 
 	hci_conn_check_pending(hdev);
@@ -1768,7 +1768,7 @@ static void hci_inquiry_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	if (!test_and_clear_bit(HCI_INQUIRY, &hdev->flags))
 		return;
 
-	smp_mb__after_clear_bit(); /* wake_up_bit advises about this barrier */
+	smp_mb__after_atomic(); /* wake_up_bit advises about this barrier */
 	wake_up_bit(&hdev->flags, HCI_INQUIRY);
 
 	if (!test_bit(HCI_MGMT, &hdev->dev_flags))
diff --git a/net/core/dev.c b/net/core/dev.c
index 5b3042e..e14f1cb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1326,7 +1326,7 @@ static int __dev_close_many(struct list_head *head)
 		 * dev->stop() will invoke napi_disable() on all of it's
 		 * napi_struct instances on this device.
 		 */
-		smp_mb__after_clear_bit(); /* Commit netif_running(). */
+		smp_mb__after_atomic(); /* Commit netif_running(). */
 	}
 
 	dev_deactivate_many(head);
@@ -3343,7 +3343,7 @@ static void net_tx_action(struct softirq_action *h)
 
 			root_lock = qdisc_lock(q);
 			if (spin_trylock(root_lock)) {
-				smp_mb__before_clear_bit();
+				smp_mb__before_atomic();
 				clear_bit(__QDISC_STATE_SCHED,
 					  &q->state);
 				qdisc_run(q);
@@ -3353,7 +3353,7 @@ static void net_tx_action(struct softirq_action *h)
 					      &q->state)) {
 					__netif_reschedule(q);
 				} else {
-					smp_mb__before_clear_bit();
+					smp_mb__before_atomic();
 					clear_bit(__QDISC_STATE_SCHED,
 						  &q->state);
 				}
@@ -4244,7 +4244,7 @@ void __napi_complete(struct napi_struct *n)
 	BUG_ON(n->gro_list);
 
 	list_del(&n->poll_list);
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(NAPI_STATE_SCHED, &n->state);
 }
 EXPORT_SYMBOL(__napi_complete);
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index 9c3a839..bd0767e 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -147,7 +147,7 @@ static void linkwatch_do_dev(struct net_device *dev)
 	 * Make sure the above read is complete since it can be
 	 * rewritten as soon as we clear the bit below.
 	 */
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 
 	/* We are about to handle this device,
 	 * so new events can be accepted
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 48f4244..56cd458 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -522,7 +522,7 @@ EXPORT_SYMBOL_GPL(inet_getpeer);
 void inet_putpeer(struct inet_peer *p)
 {
 	p->dtime = (__u32)jiffies;
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&p->refcnt);
 }
 EXPORT_SYMBOL_GPL(inet_putpeer);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 025e250..366cf06 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1930,10 +1930,8 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 			/* It is possible TX completion already happened
 			 * before we set TSQ_THROTTLED, so we must
 			 * test again the condition.
-			 * We abuse smp_mb__after_clear_bit() because
-			 * there is no smp_mb__after_set_bit() yet
 			 */
-			smp_mb__after_clear_bit();
+			smp_mb__after_atomic();
 			if (atomic_read(&sk->sk_wmem_alloc) > limit)
 				break;
 		}
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 75421f2..1f4f954 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -914,7 +914,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 	nf_ct_ext_destroy(ct);
 	nf_ct_ext_free(ct);
 	kmem_cache_free(net->ct.nf_conntrack_cachep, ct);
-	smp_mb__before_atomic_dec();
+	smp_mb__before_atomic();
 	atomic_dec(&net->ct.count);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_free);
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index b7ebe23..d67de45 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -598,7 +598,7 @@ static void rds_ib_set_ack(struct rds_ib_connection *ic, u64 seq,
 {
 	atomic64_set(&ic->i_ack_next, seq);
 	if (ack_required) {
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		set_bit(IB_ACK_REQUESTED, &ic->i_ack_flags);
 	}
 }
@@ -606,7 +606,7 @@ static void rds_ib_set_ack(struct rds_ib_connection *ic, u64 seq,
 static u64 rds_ib_get_ack(struct rds_ib_connection *ic)
 {
 	clear_bit(IB_ACK_REQUESTED, &ic->i_ack_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	return atomic64_read(&ic->i_ack_next);
 }
diff --git a/net/rds/iw_recv.c b/net/rds/iw_recv.c
index 4503335..aa8bf67 100644
--- a/net/rds/iw_recv.c
+++ b/net/rds/iw_recv.c
@@ -429,7 +429,7 @@ static void rds_iw_set_ack(struct rds_iw_connection *ic, u64 seq,
 {
 	atomic64_set(&ic->i_ack_next, seq);
 	if (ack_required) {
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		set_bit(IB_ACK_REQUESTED, &ic->i_ack_flags);
 	}
 }
@@ -437,7 +437,7 @@ static void rds_iw_set_ack(struct rds_iw_connection *ic, u64 seq,
 static u64 rds_iw_get_ack(struct rds_iw_connection *ic)
 {
 	clear_bit(IB_ACK_REQUESTED, &ic->i_ack_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	return atomic64_read(&ic->i_ack_next);
 }
diff --git a/net/rds/send.c b/net/rds/send.c
index a82fb66..2371816 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -107,7 +107,7 @@ static int acquire_in_xmit(struct rds_connection *conn)
 static void release_in_xmit(struct rds_connection *conn)
 {
 	clear_bit(RDS_IN_XMIT, &conn->c_flags);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	/*
 	 * We don't use wait_on_bit()/wake_up_bit() because our waking is in a
 	 * hot path and finding waiters is very rare.  We don't want to walk
@@ -661,7 +661,7 @@ void rds_send_drop_acked(struct rds_connection *conn, u64 ack,
 
 	/* order flag updates with spin locks */
 	if (!list_empty(&list))
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 
 	spin_unlock_irqrestore(&conn->c_lock, flags);
 
@@ -691,7 +691,7 @@ void rds_send_drop_to(struct rds_sock *rs, struct sockaddr_in *dest)
 	}
 
 	/* order flag updates with the rs lock */
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	spin_unlock_irqrestore(&rs->rs_lock, flags);
 
diff --git a/net/rds/tcp_send.c b/net/rds/tcp_send.c
index 81cf5a4..53b17ca 100644
--- a/net/rds/tcp_send.c
+++ b/net/rds/tcp_send.c
@@ -93,7 +93,7 @@ int rds_tcp_xmit(struct rds_connection *conn, struct rds_message *rm,
 		rm->m_ack_seq = tc->t_last_sent_nxt +
 				sizeof(struct rds_header) +
 				be32_to_cpu(rm->m_inc.i_hdr.h_len) - 1;
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		set_bit(RDS_MSG_HAS_ACK_SEQ, &rm->m_flags);
 		tc->t_last_expected_una = rm->m_ack_seq + 1;
 
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 5285ead..247e973 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -296,7 +296,7 @@ static void
 rpcauth_unhash_cred_locked(struct rpc_cred *cred)
 {
 	hlist_del_rcu(&cred->cr_hash);
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(RPCAUTH_CRED_HASHED, &cred->cr_flags);
 }
 
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 36e431e..b6e440b 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -143,7 +143,7 @@ gss_cred_set_ctx(struct rpc_cred *cred, struct gss_cl_ctx *ctx)
 	gss_get_ctx(ctx);
 	rcu_assign_pointer(gss_cred->gc_ctx, ctx);
 	set_bit(RPCAUTH_CRED_UPTODATE, &cred->cr_flags);
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(RPCAUTH_CRED_NEW, &cred->cr_flags);
 }
 
diff --git a/net/sunrpc/backchannel_rqst.c b/net/sunrpc/backchannel_rqst.c
index 3513d55..9761a0d 100644
--- a/net/sunrpc/backchannel_rqst.c
+++ b/net/sunrpc/backchannel_rqst.c
@@ -244,10 +244,10 @@ void xprt_free_bc_request(struct rpc_rqst *req)
 	dprintk("RPC:       free backchannel req=%p\n", req);
 
 	req->rq_connect_cookie = xprt->connect_cookie - 1;
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	WARN_ON_ONCE(!test_bit(RPC_BC_PA_IN_USE, &req->rq_bc_pa_state));
 	clear_bit(RPC_BC_PA_IN_USE, &req->rq_bc_pa_state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 
 	if (!xprt_need_to_requeue(xprt)) {
 		/*
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index d173f79..89d051d 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -230,9 +230,9 @@ static void xprt_clear_locked(struct rpc_xprt *xprt)
 {
 	xprt->snd_task = NULL;
 	if (!test_bit(XPRT_CLOSE_WAIT, &xprt->state)) {
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		clear_bit(XPRT_LOCKED, &xprt->state);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 	} else
 		queue_work(rpciod_workqueue, &xprt->task_cleanup);
 }
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 25a3dcf..402a7e9 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -893,11 +893,11 @@ static void xs_close(struct rpc_xprt *xprt)
 	xs_reset_transport(transport);
 	xprt->reestablish_timeout = 0;
 
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
 	clear_bit(XPRT_CLOSE_WAIT, &xprt->state);
 	clear_bit(XPRT_CLOSING, &xprt->state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	xprt_disconnect_done(xprt);
 }
 
@@ -1497,12 +1497,12 @@ static void xs_tcp_cancel_linger_timeout(struct rpc_xprt *xprt)
 
 static void xs_sock_reset_connection_flags(struct rpc_xprt *xprt)
 {
-	smp_mb__before_clear_bit();
+	smp_mb__before_atomic();
 	clear_bit(XPRT_CONNECTION_ABORT, &xprt->state);
 	clear_bit(XPRT_CONNECTION_CLOSE, &xprt->state);
 	clear_bit(XPRT_CLOSE_WAIT, &xprt->state);
 	clear_bit(XPRT_CLOSING, &xprt->state);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 }
 
 static void xs_sock_mark_closed(struct rpc_xprt *xprt)
@@ -1556,10 +1556,10 @@ static void xs_tcp_state_change(struct sock *sk)
 		xprt->connect_cookie++;
 		xprt->reestablish_timeout = 0;
 		set_bit(XPRT_CLOSING, &xprt->state);
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		clear_bit(XPRT_CONNECTED, &xprt->state);
 		clear_bit(XPRT_CLOSE_WAIT, &xprt->state);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		xs_tcp_schedule_linger_timeout(xprt, xs_tcp_fin_timeout);
 		break;
 	case TCP_CLOSE_WAIT:
@@ -1578,9 +1578,9 @@ static void xs_tcp_state_change(struct sock *sk)
 	case TCP_LAST_ACK:
 		set_bit(XPRT_CLOSING, &xprt->state);
 		xs_tcp_schedule_linger_timeout(xprt, xs_tcp_fin_timeout);
-		smp_mb__before_clear_bit();
+		smp_mb__before_atomic();
 		clear_bit(XPRT_CONNECTED, &xprt->state);
-		smp_mb__after_clear_bit();
+		smp_mb__after_atomic();
 		break;
 	case TCP_CLOSE:
 		xs_tcp_cancel_linger_timeout(xprt);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index bb7e8ba..749f80c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1207,7 +1207,7 @@ restart:
 	sk->sk_state	= TCP_ESTABLISHED;
 	sock_hold(newsk);
 
-	smp_mb__after_atomic_inc();	/* sock_hold() does an atomic_inc() */
+	smp_mb__after_atomic();	/* sock_hold() does an atomic_inc() */
 	unix_peer(sk)	= newsk;
 
 	unix_state_unlock(sk);
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 8546711..70951fd 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -443,7 +443,7 @@ static int snd_bt87x_pcm_open(struct snd_pcm_substream *substream)
 
 _error:
 	clear_bit(0, &chip->opened);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	return err;
 }
 
@@ -458,7 +458,7 @@ static int snd_bt87x_close(struct snd_pcm_substream *substream)
 
 	chip->substream = NULL;
 	clear_bit(0, &chip->opened);
-	smp_mb__after_clear_bit();
+	smp_mb__after_atomic();
 	return 0;
 }
 
