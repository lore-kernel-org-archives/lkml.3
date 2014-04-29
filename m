Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaD2EsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:48:21 -0400
Received: from mail-qg0-f65.google.com ([209.85.192.65]:61953 "EHLO
	mail-qg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaD2EsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:48:16 -0400
X-Greylist: delayed 1074 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2014 00:48:15 EDT
MIME-Version: 1.0
Date: Tue, 29 Apr 2014 00:30:20 -0400
Message-ID: <CAJKcOGcayerOcAZ9vtvW3GaysKjL=owzZJjkJYU7pH4hwRJgZw@mail.gmail.com>
Subject: [RFC PATCH 1/1] rename RCU_INIT_POINTER to rcu_init_pointer
From: Romanov Arya <romanov.arya@gmail.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a11394fb4c48fca04f826e3de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11394fb4c48fca04f826e3de
Content-Type: text/plain; charset=UTF-8

Recently RCU_INIT_POINTER is suggested to be used instead of
rcu_assign_pointer for NULL values.
I do not see any reason why this is in all CAPS unlike for other
cases. Rename so that it is consistent with other RCU_* macros.

Please also find the patch attached in case of mail client errors.
Please discard patch if you think this huge change is unnecessary.

Thanks!

Signed-off-by: Romanov Arya <romanov.arya@gmail.com>
---
 arch/powerpc/platforms/cell/spu_syscalls.c         |    2 +-
 drivers/crypto/nx/nx-842.c                         |    4 +-
 drivers/infiniband/hw/qib/qib_qp.c                 |    2 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |   10 ++--
 drivers/ipack/carriers/tpci200.c                   |    2 +-
 drivers/md/dm.c                                    |    2 +-
 drivers/net/bonding/bond_main.c                    |    2 +-
 drivers/net/bonding/bond_options.c                 |    2 +-
 drivers/net/ethernet/broadcom/bnx2.c               |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    2 +-
 drivers/net/ethernet/broadcom/cnic.c               |    6 +--
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |    4 +-
 drivers/net/macvtap.c                              |   10 ++--
 drivers/net/ppp/pptp.c                             |    2 +-
 drivers/net/team/team_mode_activebackup.c          |    2 +-
 drivers/net/team/team_mode_loadbalance.c           |    2 +-
 drivers/net/tun.c                                  |    8 ++--
 drivers/net/veth.c                                 |    4 +-
 drivers/net/wireless/ath/carl9170/main.c           |   12 ++---
 drivers/net/wireless/iwlwifi/mvm/fw.c              |    4 +-
 drivers/vhost/vhost.c                              |    4 +-
 fs/eventpoll.c                                     |    4 +-
 fs/proc/inode.c                                    |    2 +-
 include/linux/rcupdate.h                           |   20 ++++----
 kernel/audit.c                                     |    2 +-
 kernel/cgroup.c                                    |   14 +++---
 kernel/trace/trace_events_filter.c                 |    4 +-
 kernel/trace/trace_events_trigger.c                |    2 +-
 kernel/workqueue.c                                 |    2 +-
 lib/idr.c                                          |    6 +--
 net/802/garp.c                                     |    4 +-
 net/802/mrp.c                                      |    4 +-
 net/802/stp.c                                      |    4 +-
 net/8021q/vlan_core.c                              |    2 +-
 net/bridge/br_vlan.c                               |    8 ++--
 net/bridge/netfilter/ebtable_broute.c              |    4 +-
 net/caif/cfmuxl.c                                  |    4 +-
 net/can/af_can.c                                   |    4 +-
 net/core/dev.c                                     |   14 +++---
 net/core/fib_rules.c                               |    4 +-
 net/core/filter.c                                  |    2 +-
 net/core/neighbour.c                               |    2 +-
 net/core/net-sysfs.c                               |    4 +-
 net/core/netpoll.c                                 |    2 +-
 net/core/netprio_cgroup.c                          |    2 +-
 net/core/sock.c                                    |    4 +-
 net/core/sysctl_net_core.c                         |    2 +-
 net/decnet/dn_dev.c                                |    2 +-
 net/decnet/dn_route.c                              |    2 +-
 net/ipv4/devinet.c                                 |    4 +-
 net/ipv4/fib_semantics.c                           |    2 +-
 net/ipv4/fib_trie.c                                |    2 +-
 net/ipv4/igmp.c                                    |    4 +-
 net/ipv4/inetpeer.c                                |   50 ++++++++++----------
 net/ipv4/ipmr.c                                    |    2 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |   36 +++++++-------
 net/ipv4/netfilter/nf_nat_pptp.c                   |   16 +++----
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |    4 +-
 net/ipv4/route.c                                   |    4 +-
 net/ipv6/addrconf.c                                |    2 +-
 net/ipv6/ip6_tunnel.c                              |    2 +-
 net/ipv6/ip6_vti.c                                 |    2 +-
 net/ipv6/netfilter.c                               |    4 +-
 net/ipv6/raw.c                                     |    2 +-
 net/ipv6/sit.c                                     |    2 +-
 net/mac80211/agg-rx.c                              |    2 +-
 net/mac80211/cfg.c                                 |    8 ++--
 net/mac80211/ibss.c                                |    4 +-
 net/mac80211/mesh.c                                |    2 +-
 net/mac80211/mesh_pathtbl.c                        |    4 +-
 net/mac80211/sta_info.c                            |    2 +-
 net/netfilter/core.c                               |    4 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |    4 +-
 net/netfilter/ipvs/ip_vs_dh.c                      |    6 +--
 net/netfilter/ipvs/ip_vs_sh.c                      |    6 +--
 net/netfilter/nf_conntrack_core.c                  |    8 ++--
 net/netfilter/nf_conntrack_ecache.c                |    4 +-
 net/netfilter/nf_conntrack_extend.c                |    2 +-
 net/netfilter/nf_conntrack_helper.c                |    6 +--
 net/netfilter/nf_conntrack_netlink.c               |    8 ++--
 net/netfilter/nf_conntrack_proto.c                 |    2 +-
 net/netfilter/nf_log.c                             |    4 +-
 net/netfilter/nf_nat_amanda.c                      |    4 +-
 net/netfilter/nf_nat_core.c                        |   22 ++++-----
 net/netfilter/nf_nat_ftp.c                         |    4 +-
 net/netfilter/nf_nat_irc.c                         |    4 +-
 net/netfilter/nf_nat_sip.c                         |    4 +-
 net/netfilter/nf_nat_tftp.c                        |    4 +-
 net/netfilter/nf_queue.c                           |    2 +-
 net/netfilter/nfnetlink.c                          |    2 +-
 net/netfilter/nfnetlink_cttimeout.c                |    8 ++--
 net/netfilter/nft_hash.c                           |   14 +++---
 net/netlabel/netlabel_domainhash.c                 |    2 +-
 net/netlabel/netlabel_unlabeled.c                  |    2 +-
 net/netlink/af_netlink.c                           |    2 +-
 net/packet/af_packet.c                             |    2 +-
 net/phonet/af_phonet.c                             |    2 +-
 net/phonet/pn_dev.c                                |    4 +-
 net/phonet/socket.c                                |    4 +-
 net/socket.c                                       |    4 +-
 net/sunrpc/auth_gss/auth_gss.c                     |    2 +-
 net/tipc/bearer.c                                  |    2 +-
 net/unix/af_unix.c                                 |    2 +-
 net/xfrm/xfrm_input.c                              |    2 +-
 net/xfrm/xfrm_policy.c                             |    2 +-
 net/xfrm/xfrm_state.c                              |    2 +-
 net/xfrm/xfrm_user.c                               |    2 +-
 107 files changed, 268 insertions(+), 268 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c
b/arch/powerpc/platforms/cell/spu_syscalls.c
index 38e0a1a..2feef7c 100644
--- a/arch/powerpc/platforms/cell/spu_syscalls.c
+++ b/arch/powerpc/platforms/cell/spu_syscalls.c
@@ -170,7 +170,7 @@ EXPORT_SYMBOL_GPL(register_spu_syscalls);
 void unregister_spu_syscalls(struct spufs_calls *calls)
 {
     BUG_ON(spufs_calls->owner != calls->owner);
-    RCU_INIT_POINTER(spufs_calls, NULL);
+    rcu_init_pointer(spufs_calls, NULL);
     synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(unregister_spu_syscalls);
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 1e5481d..e72d3d7 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -1262,14 +1262,14 @@ static int __init nx842_init(void)
     struct nx842_devdata *new_devdata;
     pr_info("Registering IBM Power 842 compression driver\n");

-    RCU_INIT_POINTER(devdata, NULL);
+    rcu_init_pointer(devdata, NULL);
     new_devdata = kzalloc(sizeof(*new_devdata), GFP_KERNEL);
     if (!new_devdata) {
         pr_err("Could not allocate memory for device data\n");
         return -ENOMEM;
     }
     new_devdata->status = UNAVAILABLE;
-    RCU_INIT_POINTER(devdata, new_devdata);
+    rcu_init_pointer(devdata, new_devdata);

     return vio_register_driver(&nx842_driver);
 }
diff --git a/drivers/infiniband/hw/qib/qib_qp.c
b/drivers/infiniband/hw/qib/qib_qp.c
index 0cad0c4..e967aa5 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -1041,7 +1041,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
             ret = ERR_PTR(-ENOMEM);
             goto bail_swq;
         }
-        RCU_INIT_POINTER(qp->next, NULL);
+        rcu_init_pointer(qp->next, NULL);
         qp->s_hdr = kzalloc(sizeof(*qp->s_hdr), GFP_KERNEL);
         if (!qp->s_hdr) {
             ret = ERR_PTR(-ENOMEM);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c
b/drivers/infiniband/hw/qib/qib_verbs.c
index 9bcfbd8..8ed08aa9 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -2035,8 +2035,8 @@ static void init_ibport(struct qib_pportdata *ppd)
     ibp->z_excessive_buffer_overrun_errors =
         cntrs.excessive_buffer_overrun_errors;
     ibp->z_vl15_dropped = cntrs.vl15_dropped;
-    RCU_INIT_POINTER(ibp->qp0, NULL);
-    RCU_INIT_POINTER(ibp->qp1, NULL);
+    rcu_init_pointer(ibp->qp0, NULL);
+    rcu_init_pointer(ibp->qp1, NULL);
 }

 /**
@@ -2061,7 +2061,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
         goto err_qpt;
     }
     for (i = 0; i < dev->qp_table_size; i++)
-        RCU_INIT_POINTER(dev->qp_table[i], NULL);
+        rcu_init_pointer(dev->qp_table[i], NULL);

     for (i = 0; i < dd->num_pports; i++)
         init_ibport(ppd + i);
@@ -2094,9 +2094,9 @@ int qib_register_ib_device(struct qib_devdata *dd)
         ret = -ENOMEM;
         goto err_lk;
     }
-    RCU_INIT_POINTER(dev->dma_mr, NULL);
+    rcu_init_pointer(dev->dma_mr, NULL);
     for (i = 0; i < dev->lk_table.max; i++)
-        RCU_INIT_POINTER(dev->lk_table.table[i], NULL);
+        rcu_init_pointer(dev->lk_table.table[i], NULL);
     INIT_LIST_HEAD(&dev->pending_mmaps);
     spin_lock_init(&dev->pending_lock);
     dev->mmap_offset = PAGE_SIZE;
diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
index c276fde..86ae582 100644
--- a/drivers/ipack/carriers/tpci200.c
+++ b/drivers/ipack/carriers/tpci200.c
@@ -187,7 +187,7 @@ static int tpci200_free_irq(struct ipack_device *dev)
     tpci200_disable_irq(tpci200, dev->slot);
     slot_irq = tpci200->slots[dev->slot].irq;
     /* uninstall handler */
-    RCU_INIT_POINTER(tpci200->slots[dev->slot].irq, NULL);
+    rcu_init_pointer(tpci200->slots[dev->slot].irq, NULL);
     synchronize_rcu();
     kfree(slot_irq);
     mutex_unlock(&tpci200->mutex);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 455e649..19e6e9a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2168,7 +2168,7 @@ static struct dm_table *__unbind(struct mapped_device *md)
         return NULL;

     dm_table_event_callback(map, NULL, NULL);
-    RCU_INIT_POINTER(md->map, NULL);
+    rcu_init_pointer(md->map, NULL);
     dm_sync_table(md);

     return map;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 69aff72..d75c7ef 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1704,7 +1704,7 @@ static int __bond_release_one(struct net_device *bond_dev,
     }

     if (all) {
-        RCU_INIT_POINTER(bond->curr_active_slave, NULL);
+        rcu_init_pointer(bond->curr_active_slave, NULL);
     } else if (oldcurrent == slave) {
         /*
          * Note that we hold RTNL over this sequence, so there
diff --git a/drivers/net/bonding/bond_options.c
b/drivers/net/bonding/bond_options.c
index 724e30f..069c7c3 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -712,7 +712,7 @@ static int bond_option_active_slave_set(struct
bonding *bond,
     /* check to see if we are clearing active */
     if (!slave_dev) {
         pr_info("%s: Clearing current active slave\n", bond->dev->name);
-        RCU_INIT_POINTER(bond->curr_active_slave, NULL);
+        rcu_init_pointer(bond->curr_active_slave, NULL);
         bond_select_active_slave(bond);
     } else {
         struct slave *old_active = bond->curr_active_slave;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c
b/drivers/net/ethernet/broadcom/bnx2.c
index 0ab8370..7facbc4 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -409,7 +409,7 @@ static int bnx2_unregister_cnic(struct net_device *dev)
     mutex_lock(&bp->cnic_lock);
     cp->drv_state = 0;
     bnapi->cnic_present = 0;
-    RCU_INIT_POINTER(bp->cnic_ops, NULL);
+    rcu_init_pointer(bp->cnic_ops, NULL);
     mutex_unlock(&bp->cnic_lock);
     synchronize_rcu();
     return 0;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index a78edac..83a228e 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -14048,7 +14048,7 @@ static int bnx2x_unregister_cnic(struct net_device *dev)

     mutex_lock(&bp->cnic_mutex);
     cp->drv_state = 0;
-    RCU_INIT_POINTER(bp->cnic_ops, NULL);
+    rcu_init_pointer(bp->cnic_ops, NULL);
     mutex_unlock(&bp->cnic_mutex);
     synchronize_rcu();
     bp->cnic_enabled = false;
diff --git a/drivers/net/ethernet/broadcom/cnic.c
b/drivers/net/ethernet/broadcom/cnic.c
index 09f3fef..42d5ff3a 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -534,7 +534,7 @@ int cnic_unregister_driver(int ulp_type)
     }
     read_unlock(&cnic_dev_lock);

-    RCU_INIT_POINTER(cnic_ulp_tbl[ulp_type], NULL);
+    rcu_init_pointer(cnic_ulp_tbl[ulp_type], NULL);

     mutex_unlock(&cnic_lock);
     synchronize_rcu();
@@ -610,7 +610,7 @@ static int cnic_unregister_device(struct cnic_dev
*dev, int ulp_type)
     }
     mutex_lock(&cnic_lock);
     if (rcu_dereference(cp->ulp_ops[ulp_type])) {
-        RCU_INIT_POINTER(cp->ulp_ops[ulp_type], NULL);
+        rcu_init_pointer(cp->ulp_ops[ulp_type], NULL);
         cnic_put(dev);
     } else {
         pr_err("%s: device not registered to this ulp type %d\n",
@@ -5414,7 +5414,7 @@ static void cnic_stop_hw(struct cnic_dev *dev)
         cp->stop_cm(dev);
         cp->ethdev->drv_state &= ~CNIC_DRV_STATE_HANDLES_IRQ;
         clear_bit(CNIC_F_CNIC_UP, &dev->flags);
-        RCU_INIT_POINTER(cp->ulp_ops[CNIC_ULP_L4], NULL);
+        rcu_init_pointer(cp->ulp_ops[CNIC_ULP_L4], NULL);
         synchronize_rcu();
         cnic_cm_shutdown(dev);
         cp->stop_hw(dev);
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
index c0a9dd5..466f3b2 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
@@ -1280,7 +1280,7 @@ int cxgb3_offload_activate(struct adapter *adapter)
     INIT_LIST_HEAD(&t->list_node);
     t->dev = dev;

-    RCU_INIT_POINTER(dev->l2opt, l2td);
+    rcu_init_pointer(dev->l2opt, l2td);
     T3C_DATA(dev) = t;
     dev->recv = process_rx;
     dev->neigh_update = t3_l2t_update;
@@ -1324,7 +1324,7 @@ void cxgb3_offload_deactivate(struct adapter *adapter)
     rcu_read_lock();
     d = L2DATA(tdev);
     rcu_read_unlock();
-    RCU_INIT_POINTER(tdev->l2opt, NULL);
+    rcu_init_pointer(tdev->l2opt, NULL);
     call_rcu(&d->rcu_head, clean_l2_data);
     if (t->nofail_skb)
         kfree_skb(t->nofail_skb);
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index ff111a8..c343c1d 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -159,7 +159,7 @@ static int macvtap_disable_queue(struct macvtap_queue *q)
         nq->queue_index = index;

         rcu_assign_pointer(vlan->taps[index], nq);
-        RCU_INIT_POINTER(vlan->taps[vlan->numvtaps - 1], NULL);
+        rcu_init_pointer(vlan->taps[vlan->numvtaps - 1], NULL);
         q->enabled = false;

         vlan->numvtaps--;
@@ -188,7 +188,7 @@ static void macvtap_put_queue(struct macvtap_queue *q)
             BUG_ON(macvtap_disable_queue(q));

         vlan->numqueues--;
-        RCU_INIT_POINTER(q->vlan, NULL);
+        rcu_init_pointer(q->vlan, NULL);
         sock_put(&q->sk);
         list_del_init(&q->next);
     }
@@ -259,13 +259,13 @@ static void macvtap_del_queues(struct net_device *dev)
     list_for_each_entry_safe(q, tmp, &vlan->queue_list, next) {
         list_del_init(&q->next);
         qlist[j++] = q;
-        RCU_INIT_POINTER(q->vlan, NULL);
+        rcu_init_pointer(q->vlan, NULL);
         if (q->enabled)
             vlan->numvtaps--;
         vlan->numqueues--;
     }
     for (i = 0; i < vlan->numvtaps; i++)
-        RCU_INIT_POINTER(vlan->taps[i], NULL);
+        rcu_init_pointer(vlan->taps[i], NULL);
     BUG_ON(vlan->numvtaps);
     BUG_ON(vlan->numqueues);
     /* guarantee that any future macvtap_set_queue will fail */
@@ -459,7 +459,7 @@ static int macvtap_open(struct inode *inode,
struct file *file)
     if (!q)
         goto out;

-    RCU_INIT_POINTER(q->sock.wq, &q->wq);
+    rcu_init_pointer(q->sock.wq, &q->wq);
     init_waitqueue_head(&q->wq.wait);
     q->sock.type = SOCK_RAW;
     q->sock.state = SS_CONNECTED;
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 0180531..b7c2acb 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -162,7 +162,7 @@ static void del_chan(struct pppox_sock *sock)
 {
     spin_lock(&chan_lock);
     clear_bit(sock->proto.pptp.src_addr.call_id, callid_bitmap);
-    RCU_INIT_POINTER(callid_sock[sock->proto.pptp.src_addr.call_id], NULL);
+    rcu_init_pointer(callid_sock[sock->proto.pptp.src_addr.call_id], NULL);
     spin_unlock(&chan_lock);
     synchronize_rcu();
 }
diff --git a/drivers/net/team/team_mode_activebackup.c
b/drivers/net/team/team_mode_activebackup.c
index 40fd338..91b3066 100644
--- a/drivers/net/team/team_mode_activebackup.c
+++ b/drivers/net/team/team_mode_activebackup.c
@@ -56,7 +56,7 @@ drop:
 static void ab_port_leave(struct team *team, struct team_port *port)
 {
     if (ab_priv(team)->active_port == port) {
-        RCU_INIT_POINTER(ab_priv(team)->active_port, NULL);
+        rcu_init_pointer(ab_priv(team)->active_port, NULL);
         team_option_inst_set_change(ab_priv(team)->ap_opt_inst_info);
     }
 }
diff --git a/drivers/net/team/team_mode_loadbalance.c
b/drivers/net/team/team_mode_loadbalance.c
index dbde341..deef2c9 100644
--- a/drivers/net/team/team_mode_loadbalance.c
+++ b/drivers/net/team/team_mode_loadbalance.c
@@ -97,7 +97,7 @@ static void
lb_tx_hash_to_port_mapping_null_port(struct team *team,

         pm = &lb_priv->ex->tx_hash_to_port_mapping[i];
         if (rcu_access_pointer(pm->port) == port) {
-            RCU_INIT_POINTER(pm->port, NULL);
+            rcu_init_pointer(pm->port, NULL);
             team_option_inst_set_change(pm->opt_inst_info);
             changed = true;
         }
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ee328ba..ab06040 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -452,7 +452,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)

         --tun->numqueues;
         if (clean) {
-            RCU_INIT_POINTER(tfile->tun, NULL);
+            rcu_init_pointer(tfile->tun, NULL);
             sock_put(&tfile->sk);
         } else
             tun_disable_queue(tun, tfile);
@@ -499,12 +499,12 @@ static void tun_detach_all(struct net_device *dev)
         tfile = rtnl_dereference(tun->tfiles[i]);
         BUG_ON(!tfile);
         wake_up_all(&tfile->wq.wait);
-        RCU_INIT_POINTER(tfile->tun, NULL);
+        rcu_init_pointer(tfile->tun, NULL);
         --tun->numqueues;
     }
     list_for_each_entry(tfile, &tun->disabled, next) {
         wake_up_all(&tfile->wq.wait);
-        RCU_INIT_POINTER(tfile->tun, NULL);
+        rcu_init_pointer(tfile->tun, NULL);
     }
     BUG_ON(tun->numqueues != 0);

@@ -2194,7 +2194,7 @@ static int tun_chr_open(struct inode *inode,
struct file * file)
                         &tun_proto);
     if (!tfile)
         return -ENOMEM;
-    RCU_INIT_POINTER(tfile->tun, NULL);
+    rcu_init_pointer(tfile->tun, NULL);
     tfile->net = get_net(current->nsproxy->net_ns);
     tfile->flags = 0;
     tfile->ifindex = 0;
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index b4a10bc..b8c026f 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -432,12 +432,12 @@ static void veth_dellink(struct net_device *dev,
struct list_head *head)
      * before a rcu_synchronize() point. The devices are guaranteed
      * not being freed before one RCU grace period.
      */
-    RCU_INIT_POINTER(priv->peer, NULL);
+    rcu_init_pointer(priv->peer, NULL);
     unregister_netdevice_queue(dev, head);

     if (peer) {
         priv = netdev_priv(peer);
-        RCU_INIT_POINTER(priv->peer, NULL);
+        rcu_init_pointer(priv->peer, NULL);
         unregister_netdevice_queue(peer, head);
     }
 }
diff --git a/drivers/net/wireless/ath/carl9170/main.c
b/drivers/net/wireless/ath/carl9170/main.c
index 4c8cdb0..9ba9885 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -450,7 +450,7 @@ static void carl9170_op_stop(struct ieee80211_hw *hw)

     mutex_lock(&ar->mutex);
     if (IS_ACCEPTING_CMD(ar)) {
-        RCU_INIT_POINTER(ar->beacon_iter, NULL);
+        rcu_init_pointer(ar->beacon_iter, NULL);

         carl9170_led_set_state(ar, 0);

@@ -747,7 +747,7 @@ unlock:
         vif_priv->active = false;
         bitmap_release_region(&ar->vif_bitmap, vif_id, 0);
         ar->vifs--;
-        RCU_INIT_POINTER(ar->vif_priv[vif_id].vif, NULL);
+        rcu_init_pointer(ar->vif_priv[vif_id].vif, NULL);
         list_del_rcu(&vif_priv->list);
         mutex_unlock(&ar->mutex);
         synchronize_rcu();
@@ -785,7 +785,7 @@ static void carl9170_op_remove_interface(struct
ieee80211_hw *hw,
     WARN_ON(vif_priv->enable_beacon);
     vif_priv->enable_beacon = false;
     list_del_rcu(&vif_priv->list);
-    RCU_INIT_POINTER(ar->vif_priv[id].vif, NULL);
+    rcu_init_pointer(ar->vif_priv[id].vif, NULL);

     if (vif == main_vif) {
         rcu_read_unlock();
@@ -1333,7 +1333,7 @@ static int carl9170_op_sta_add(struct ieee80211_hw *hw,
         }

         for (i = 0; i < ARRAY_SIZE(sta_info->agg); i++)
-            RCU_INIT_POINTER(sta_info->agg[i], NULL);
+            rcu_init_pointer(sta_info->agg[i], NULL);

         sta_info->ampdu_max_len = 1 << (3 + sta->ht_cap.ampdu_factor);
         sta_info->ht_sta = true;
@@ -1360,7 +1360,7 @@ static int carl9170_op_sta_remove(struct ieee80211_hw *hw,
             struct carl9170_sta_tid *tid_info;

             tid_info = rcu_dereference(sta_info->agg[i]);
-            RCU_INIT_POINTER(sta_info->agg[i], NULL);
+            rcu_init_pointer(sta_info->agg[i], NULL);

             if (!tid_info)
                 continue;
@@ -1477,7 +1477,7 @@ static int carl9170_op_ampdu_action(struct
ieee80211_hw *hw,
             spin_unlock_bh(&ar->tx_ampdu_list_lock);
         }

-        RCU_INIT_POINTER(sta_info->agg[tid], NULL);
+        rcu_init_pointer(sta_info->agg[tid], NULL);
         rcu_read_unlock();

         ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c
b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 7ce2006..751abf0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -443,7 +443,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)

     /* init the fw <-> mac80211 STA mapping */
     for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
-        RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
+        rcu_init_pointer(mvm->fw_id_to_mac_id[i], NULL);

     /* Add auxiliary station for scanning */
     ret = iwl_mvm_add_aux_sta(mvm);
@@ -520,7 +520,7 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm)

     /* init the fw <-> mac80211 STA mapping */
     for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
-        RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
+        rcu_init_pointer(mvm->fw_id_to_mac_id[i], NULL);

     /* Add auxiliary station for scanning */
     ret = iwl_mvm_add_aux_sta(mvm);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 78987e4..92d3fbc 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -419,7 +419,7 @@ void vhost_dev_reset_owner(struct vhost_dev *dev,
struct vhost_memory *memory)

     /* Restore memory to default empty mapping. */
     memory->nregions = 0;
-    RCU_INIT_POINTER(dev->memory, memory);
+    rcu_init_pointer(dev->memory, memory);
 }
 EXPORT_SYMBOL_GPL(vhost_dev_reset_owner);

@@ -465,7 +465,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev, bool locked)
     kfree(rcu_dereference_protected(dev->memory,
                     locked ==
                         lockdep_is_held(&dev->mutex)));
-    RCU_INIT_POINTER(dev->memory, NULL);
+    rcu_init_pointer(dev->memory, NULL);
     WARN_ON(!list_empty(&dev->work_list));
     if (dev->worker) {
         kthread_stop(dev->worker);
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index af90312..bc52fb8 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1250,7 +1250,7 @@ static noinline void
ep_destroy_wakeup_source(struct epitem *epi)
 {
     struct wakeup_source *ws = ep_wakeup_source(epi);

-    RCU_INIT_POINTER(epi->ws, NULL);
+    rcu_init_pointer(epi->ws, NULL);

     /*
      * wait for ep_pm_stay_awake_rcu to finish, synchronize_rcu is
@@ -1293,7 +1293,7 @@ static int ep_insert(struct eventpoll *ep,
struct epoll_event *event,
         if (error)
             goto error_create_wakeup_source;
     } else {
-        RCU_INIT_POINTER(epi->ws, NULL);
+        rcu_init_pointer(epi->ws, NULL);
     }

     /* Initialize the poll table using the queue callback */
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 0adbc02..a8734e0 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -47,7 +47,7 @@ static void proc_evict_inode(struct inode *inode)
         pde_put(de);
     head = PROC_I(inode)->sysctl;
     if (head) {
-        RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
+        rcu_init_pointer(PROC_I(inode)->sysctl, NULL);
         sysctl_head_put(head);
     }
     /* Release any associated namespace */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 00a7fd6..d384392 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -566,13 +566,13 @@ static inline void rcu_preempt_sleep_check(void)
  * assignment.  More importantly, this call documents which pointers
  * will be dereferenced by RCU read-side code.
  *
- * In some special cases, you may use RCU_INIT_POINTER() instead
- * of rcu_assign_pointer().  RCU_INIT_POINTER() is a bit faster due
+ * In some special cases, you may use rcu_init_pointer() instead
+ * of rcu_assign_pointer().  rcu_init_pointer() is a bit faster due
  * to the fact that it does not constrain either the CPU or the compiler.
- * That said, using RCU_INIT_POINTER() when you should have used
+ * That said, using rcu_init_pointer() when you should have used
  * rcu_assign_pointer() is a very bad thing that results in
  * impossible-to-diagnose memory corruption.  So please be careful.
- * See the RCU_INIT_POINTER() comment header for details.
+ * See the rcu_init_pointer() comment header for details.
  *
  * Note that rcu_assign_pointer() evaluates each of its arguments only
  * once, appearances notwithstanding.  One of the "extra" evaluations
@@ -919,13 +919,13 @@ static inline notrace void
rcu_read_unlock_sched_notrace(void)
 }

 /**
- * RCU_INIT_POINTER() - initialize an RCU protected pointer
+ * rcu_init_pointer() - initialize an RCU protected pointer
  *
  * Initialize an RCU-protected pointer in special cases where readers
  * do not need ordering constraints on the CPU or the compiler.  These
  * special cases are:
  *
- * 1.    This use of RCU_INIT_POINTER() is NULLing out the pointer -or-
+ * 1.    This use of rcu_init_pointer() is NULLing out the pointer -or-
  * 2.    The caller has taken whatever steps are required to prevent
  *    RCU readers from concurrently accessing this pointer -or-
  * 3.    The referenced data structure has already been exposed to
@@ -937,20 +937,20 @@ static inline notrace void
rcu_read_unlock_sched_notrace(void)
  *        example, the changes were to statistical counters or to
  *        other state where exact synchronization is not required.)
  *
- * Failure to follow these rules governing use of RCU_INIT_POINTER() will
+ * Failure to follow these rules governing use of rcu_init_pointer() will
  * result in impossible-to-diagnose memory corruption.  As in the structures
  * will look OK in crash dumps, but any concurrent RCU readers might
  * see pre-initialized values of the referenced data structure.  So
- * please be very careful how you use RCU_INIT_POINTER()!!!
+ * please be very careful how you use rcu_init_pointer()!!!
  *
  * If you are creating an RCU-protected linked structure that is accessed
  * by a single external-to-structure RCU-protected pointer, then you may
- * use RCU_INIT_POINTER() to initialize the internal RCU-protected
+ * use rcu_init_pointer() to initialize the internal RCU-protected
  * pointers, but you must use rcu_assign_pointer() to initialize the
  * external-to-structure pointer -after- you have completely initialized
  * the reader-accessible portions of the linked structure.
  */
-#define RCU_INIT_POINTER(p, v) \
+#define rcu_init_pointer(p, v) \
     do { \
         p = RCU_INITIALIZER(v); \
     } while (0)
diff --git a/kernel/audit.c b/kernel/audit.c
index 7c28936..f5bf565 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1102,7 +1102,7 @@ static void __net_exit audit_net_exit(struct net *net)
         audit_sock = NULL;
     }

-    RCU_INIT_POINTER(aunet->nlsk, NULL);
+    rcu_init_pointer(aunet->nlsk, NULL);
     synchronize_net();
     netlink_kernel_release(sock);
 }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9fcdaa7..252320b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1045,7 +1045,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,

         WARN_ON(!css || cgroup_css(&dst_root->cgrp, ss));

-        RCU_INIT_POINTER(src_root->cgrp.subsys[ssid], NULL);
+        rcu_init_pointer(src_root->cgrp.subsys[ssid], NULL);
         rcu_assign_pointer(dst_root->cgrp.subsys[ssid], css);
         ss->root = dst_root;
         css->cgroup = &dst_root->cgrp;
@@ -3567,7 +3567,7 @@ static void css_release(struct percpu_ref *ref)
     struct cgroup_subsys_state *css =
         container_of(ref, struct cgroup_subsys_state, refcnt);

-    RCU_INIT_POINTER(css->cgroup->subsys[css->ss->id], NULL);
+    rcu_init_pointer(css->cgroup->subsys[css->ss->id], NULL);
     call_rcu(&css->rcu_head, css_free_rcu_fn);
 }

@@ -3621,7 +3621,7 @@ static void offline_css(struct cgroup_subsys_state *css)

     css->flags &= ~CSS_ONLINE;
     css->cgroup->nr_css--;
-    RCU_INIT_POINTER(css->cgroup->subsys[ss->id], css);
+    rcu_init_pointer(css->cgroup->subsys[ss->id], css);
 }

 /**
@@ -4044,7 +4044,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
      * after all files under it have been removed.
      */
     kernfs_remove(cgrp->kn);    /* @cgrp has an extra ref on its kn */
-    RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
+    rcu_init_pointer(*(void __rcu __force **)&cgrp->kn->priv, NULL);

     mutex_lock(&cgroup_mutex);

@@ -4169,7 +4169,7 @@ int __init cgroup_init_early(void)
     int i;

     init_cgroup_root(&cgrp_dfl_root, &opts);
-    RCU_INIT_POINTER(init_task.cgroups, &init_css_set);
+    rcu_init_pointer(init_task.cgroups, &init_css_set);

     for_each_subsys(ss, i) {
         WARN(!ss->css_alloc || !ss->css_free || ss->name || ss->id,
@@ -4377,7 +4377,7 @@ static const struct file_operations
proc_cgroupstats_operations = {
  */
 void cgroup_fork(struct task_struct *child)
 {
-    RCU_INIT_POINTER(child->cgroups, &init_css_set);
+    rcu_init_pointer(child->cgroups, &init_css_set);
     INIT_LIST_HEAD(&child->cg_list);
 }

@@ -4481,7 +4481,7 @@ void cgroup_exit(struct task_struct *tsk)

     /* Reassign the task to the init_css_set. */
     cset = task_css_set(tsk);
-    RCU_INIT_POINTER(tsk->cgroups, &init_css_set);
+    rcu_init_pointer(tsk->cgroups, &init_css_set);

     if (need_forkexit_callback) {
         /* see cgroup_post_fork() for details */
diff --git a/kernel/trace/trace_events_filter.c
b/kernel/trace/trace_events_filter.c
index 8a86319..93b0d89 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1708,9 +1708,9 @@ static inline void event_clear_filter(struct
ftrace_event_file *file)
     struct ftrace_event_call *call = file->event_call;

     if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
-        RCU_INIT_POINTER(call->filter, NULL);
+        rcu_init_pointer(call->filter, NULL);
     else
-        RCU_INIT_POINTER(file->filter, NULL);
+        rcu_init_pointer(file->filter, NULL);
 }

 static inline void
diff --git a/kernel/trace/trace_events_trigger.c
b/kernel/trace/trace_events_trigger.c
index 925f537..07dc2eb 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1212,7 +1212,7 @@ event_enable_trigger_func(struct event_command *cmd_ops,
     trigger_data->ops = trigger_ops;
     trigger_data->cmd_ops = cmd_ops;
     INIT_LIST_HEAD(&trigger_data->list);
-    RCU_INIT_POINTER(trigger_data->filter, NULL);
+    rcu_init_pointer(trigger_data->filter, NULL);

     enable_data->enable = enable;
     enable_data->file = event_enable_file;
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0ee63af..3c897f5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4343,7 +4343,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
          */
         for_each_node(node) {
             pwq = rcu_access_pointer(wq->numa_pwq_tbl[node]);
-            RCU_INIT_POINTER(wq->numa_pwq_tbl[node], NULL);
+            rcu_init_pointer(wq->numa_pwq_tbl[node], NULL);
             put_pwq_unlocked(pwq);
         }

diff --git a/lib/idr.c b/lib/idr.c
index 2642fa8..b885650 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -152,7 +152,7 @@ static void idr_layer_rcu_free(struct rcu_head *head)
 static inline void free_layer(struct idr *idr, struct idr_layer *p)
 {
     if (idr->hint && idr->hint == p)
-        RCU_INIT_POINTER(idr->hint, NULL);
+        rcu_init_pointer(idr->hint, NULL);
     call_rcu(&p->rcu_head, idr_layer_rcu_free);
 }

@@ -533,7 +533,7 @@ static void sub_remove(struct idr *idp, int shift, int id)
     n = id & IDR_MASK;
     if (likely(p != NULL && test_bit(n, p->bitmap))) {
         __clear_bit(n, p->bitmap);
-        RCU_INIT_POINTER(p->ary[n], NULL);
+        rcu_init_pointer(p->ary[n], NULL);
         to_free = NULL;
         while(*paa && ! --((**paa)->count)){
             if (to_free)
@@ -602,7 +602,7 @@ static void __idr_remove_all(struct idr *idp)

     n = idp->layers * IDR_BITS;
     p = idp->top;
-    RCU_INIT_POINTER(idp->top, NULL);
+    rcu_init_pointer(idp->top, NULL);
     max = idr_max(idp->layers);

     id = 0;
diff --git a/net/802/garp.c b/net/802/garp.c
index b38ee6d..4bc98ac 100644
--- a/net/802/garp.c
+++ b/net/802/garp.c
@@ -552,7 +552,7 @@ static void garp_release_port(struct net_device *dev)
         if (rtnl_dereference(port->applicants[i]))
             return;
     }
-    RCU_INIT_POINTER(dev->garp_port, NULL);
+    rcu_init_pointer(dev->garp_port, NULL);
     kfree_rcu(port, rcu);
 }

@@ -604,7 +604,7 @@ void garp_uninit_applicant(struct net_device *dev,
struct garp_application *appl

     ASSERT_RTNL();

-    RCU_INIT_POINTER(port->applicants[appl->type], NULL);
+    rcu_init_pointer(port->applicants[appl->type], NULL);

     /* Delete timer and generate a final TRANSMIT_PDU event to flush out
      * all pending messages before the applicant is gone. */
diff --git a/net/802/mrp.c b/net/802/mrp.c
index 72db278..e57b50e 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -834,7 +834,7 @@ static void mrp_release_port(struct net_device *dev)
         if (rtnl_dereference(port->applicants[i]))
             return;
     }
-    RCU_INIT_POINTER(dev->mrp_port, NULL);
+    rcu_init_pointer(dev->mrp_port, NULL);
     kfree_rcu(port, rcu);
 }

@@ -890,7 +890,7 @@ void mrp_uninit_applicant(struct net_device *dev,
struct mrp_application *appl)

     ASSERT_RTNL();

-    RCU_INIT_POINTER(port->applicants[appl->type], NULL);
+    rcu_init_pointer(port->applicants[appl->type], NULL);

     /* Delete timer and generate a final TX event to flush out
      * all pending messages before the applicant is gone.
diff --git a/net/802/stp.c b/net/802/stp.c
index 2c40ba0..75c1a32 100644
--- a/net/802/stp.c
+++ b/net/802/stp.c
@@ -89,9 +89,9 @@ void stp_proto_unregister(const struct stp_proto *proto)
 {
     mutex_lock(&stp_proto_mutex);
     if (is_zero_ether_addr(proto->group_address))
-        RCU_INIT_POINTER(stp_proto, NULL);
+        rcu_init_pointer(stp_proto, NULL);
     else
-        RCU_INIT_POINTER(garp_protos[proto->group_address[5] -
+        rcu_init_pointer(garp_protos[proto->group_address[5] -
                            GARP_ADDR_MIN], NULL);
     synchronize_rcu();

diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 3c32bd2..252d777 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -343,7 +343,7 @@ void vlan_vid_del(struct net_device *dev, __be16
proto, u16 vid)
     if (vid_info->refcount == 0) {
         __vlan_vid_del(vlan_info, vid_info);
         if (vlan_info->nr_vids == 0) {
-            RCU_INIT_POINTER(dev->vlan_info, NULL);
+            rcu_init_pointer(dev->vlan_info, NULL);
             call_rcu(&vlan_info->rcu, vlan_info_rcu_free);
         }
     }
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 4a37161..99ffd42 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -99,9 +99,9 @@ static int __vlan_del(struct net_port_vlans *v, u16 vid)
     v->num_vlans--;
     if (bitmap_empty(v->vlan_bitmap, VLAN_N_VID)) {
         if (v->port_idx)
-            RCU_INIT_POINTER(v->parent.port->vlan_info, NULL);
+            rcu_init_pointer(v->parent.port->vlan_info, NULL);
         else
-            RCU_INIT_POINTER(v->parent.br->vlan_info, NULL);
+            rcu_init_pointer(v->parent.br->vlan_info, NULL);
         kfree_rcu(v, rcu);
     }
     return 0;
@@ -113,9 +113,9 @@ static void __vlan_flush(struct net_port_vlans *v)
     v->pvid = 0;
     bitmap_zero(v->vlan_bitmap, VLAN_N_VID);
     if (v->port_idx)
-        RCU_INIT_POINTER(v->parent.port->vlan_info, NULL);
+        rcu_init_pointer(v->parent.port->vlan_info, NULL);
     else
-        RCU_INIT_POINTER(v->parent.br->vlan_info, NULL);
+        rcu_init_pointer(v->parent.br->vlan_info, NULL);
     kfree_rcu(v, rcu);
 }

diff --git a/net/bridge/netfilter/ebtable_broute.c
b/net/bridge/netfilter/ebtable_broute.c
index d2cdf5d..13445ac 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -83,14 +83,14 @@ static int __init ebtable_broute_init(void)
     if (ret < 0)
         return ret;
     /* see br_input.c */
-    RCU_INIT_POINTER(br_should_route_hook,
+    rcu_init_pointer(br_should_route_hook,
                (br_should_route_hook_t *)ebt_broute);
     return 0;
 }

 static void __exit ebtable_broute_fini(void)
 {
-    RCU_INIT_POINTER(br_should_route_hook, NULL);
+    rcu_init_pointer(br_should_route_hook, NULL);
     synchronize_net();
     unregister_pernet_subsys(&broute_net_ops);
 }
diff --git a/net/caif/cfmuxl.c b/net/caif/cfmuxl.c
index 8c5d638..15d5d6d 100644
--- a/net/caif/cfmuxl.c
+++ b/net/caif/cfmuxl.c
@@ -108,7 +108,7 @@ struct cflayer *cfmuxl_remove_dnlayer(struct
cflayer *layr, u8 phyid)
     int idx = phyid % DN_CACHE_SIZE;

     spin_lock_bh(&muxl->transmit_lock);
-    RCU_INIT_POINTER(muxl->dn_cache[idx], NULL);
+    rcu_init_pointer(muxl->dn_cache[idx], NULL);
     dn = get_from_id(&muxl->frml_list, phyid);
     if (dn == NULL)
         goto out;
@@ -164,7 +164,7 @@ struct cflayer *cfmuxl_remove_uplayer(struct
cflayer *layr, u8 id)
     if (up == NULL)
         goto out;

-    RCU_INIT_POINTER(muxl->up_cache[idx], NULL);
+    rcu_init_pointer(muxl->up_cache[idx], NULL);
     list_del_rcu(&up->node);
 out:
     spin_unlock_bh(&muxl->receive_lock);
diff --git a/net/can/af_can.c b/net/can/af_can.c
index a27f8aa..8df0f52 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -761,7 +761,7 @@ int can_proto_register(const struct can_proto *cp)
         pr_err("can: protocol %d already registered\n", proto);
         err = -EBUSY;
     } else
-        RCU_INIT_POINTER(proto_tab[proto], cp);
+        rcu_init_pointer(proto_tab[proto], cp);

     mutex_unlock(&proto_tab_lock);

@@ -782,7 +782,7 @@ void can_proto_unregister(const struct can_proto *cp)

     mutex_lock(&proto_tab_lock);
     BUG_ON(proto_tab[proto] != cp);
-    RCU_INIT_POINTER(proto_tab[proto], NULL);
+    rcu_init_pointer(proto_tab[proto], NULL);
     mutex_unlock(&proto_tab_lock);

     synchronize_rcu();
diff --git a/net/core/dev.c b/net/core/dev.c
index d2c8a06..a0a93bd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1836,7 +1836,7 @@ static struct xps_map *remove_xps_queue(struct
xps_dev_maps *dev_maps,
             if (map->len > 1) {
                 map->queues[pos] = map->queues[--map->len];
             } else {
-                RCU_INIT_POINTER(dev_maps->cpu_map[cpu], NULL);
+                rcu_init_pointer(dev_maps->cpu_map[cpu], NULL);
                 kfree_rcu(map, rcu);
                 map = NULL;
             }
@@ -1869,7 +1869,7 @@ static void netif_reset_xps_queues_gt(struct
net_device *dev, u16 index)
     }

     if (!active) {
-        RCU_INIT_POINTER(dev->xps_maps, NULL);
+        rcu_init_pointer(dev->xps_maps, NULL);
         kfree_rcu(dev_maps, rcu);
     }

@@ -1948,7 +1948,7 @@ int netif_set_xps_queue(struct net_device *dev,
const struct cpumask *mask,
         if (!map)
             goto error;

-        RCU_INIT_POINTER(new_dev_maps->cpu_map[cpu], map);
+        rcu_init_pointer(new_dev_maps->cpu_map[cpu], map);
     }

     if (!new_dev_maps)
@@ -1974,7 +1974,7 @@ int netif_set_xps_queue(struct net_device *dev,
const struct cpumask *mask,
         } else if (dev_maps) {
             /* fill in the new device map from the old device map */
             map = xmap_dereference(dev_maps->cpu_map[cpu]);
-            RCU_INIT_POINTER(new_dev_maps->cpu_map[cpu], map);
+            rcu_init_pointer(new_dev_maps->cpu_map[cpu], map);
         }

     }
@@ -2016,7 +2016,7 @@ out_no_new_maps:

     /* free map if not active */
     if (!active) {
-        RCU_INIT_POINTER(dev->xps_maps, NULL);
+        rcu_init_pointer(dev->xps_maps, NULL);
         kfree_rcu(dev_maps, rcu);
     }

@@ -3476,13 +3476,13 @@ void netdev_rx_handler_unregister(struct
net_device *dev)
 {

     ASSERT_RTNL();
-    RCU_INIT_POINTER(dev->rx_handler, NULL);
+    rcu_init_pointer(dev->rx_handler, NULL);
     /* a reader seeing a non NULL rx_handler in a rcu_read_lock()
      * section has a guarantee to see a non NULL rx_handler_data
      * as well.
      */
     synchronize_net();
-    RCU_INIT_POINTER(dev->rx_handler_data, NULL);
+    rcu_init_pointer(dev->rx_handler_data, NULL);
 }
 EXPORT_SYMBOL_GPL(netdev_rx_handler_unregister);

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 185c341..e11fc01 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -368,7 +368,7 @@ static int fib_nl_newrule(struct sk_buff *skb,
struct nlmsghdr* nlh)

         list_for_each_entry(r, &ops->rules_list, list) {
             if (r->pref == rule->target) {
-                RCU_INIT_POINTER(rule->ctarget, r);
+                rcu_init_pointer(rule->ctarget, r);
                 break;
             }
         }
@@ -509,7 +509,7 @@ static int fib_nl_delrule(struct sk_buff *skb,
struct nlmsghdr* nlh)
         if (ops->nr_goto_rules > 0) {
             list_for_each_entry(tmp, &ops->rules_list, list) {
                 if (rtnl_dereference(tmp->ctarget) == rule) {
-                    RCU_INIT_POINTER(tmp->ctarget, NULL);
+                    rcu_init_pointer(tmp->ctarget, NULL);
                     ops->unresolved_rules++;
                 }
             }
diff --git a/net/core/filter.c b/net/core/filter.c
index cd58614..cb9125d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1697,7 +1697,7 @@ int sk_detach_filter(struct sock *sk)
     filter = rcu_dereference_protected(sk->sk_filter,
                        sock_owned_by_user(sk));
     if (filter) {
-        RCU_INIT_POINTER(sk->sk_filter, NULL);
+        rcu_init_pointer(sk->sk_filter, NULL);
         sk_filter_uncharge(sk, filter);
         ret = 0;
     }
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 8f8a96e..73d7640 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1550,7 +1550,7 @@ static void neigh_table_init_no_netlink(struct
neigh_table *tbl)
         panic("cannot create neighbour proc dir entry");
 #endif

-    RCU_INIT_POINTER(tbl->nht, neigh_hash_alloc(3));
+    rcu_init_pointer(tbl->nht, neigh_hash_alloc(3));

     phsize = (PNEIGH_HASHMASK + 1) * sizeof(struct pneigh_entry *);
     tbl->phash_buckets = kzalloc(phsize, GFP_KERNEL);
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 1cac29e..cbbf952 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -742,13 +742,13 @@ static void rx_queue_release(struct kobject *kobj)

     map = rcu_dereference_protected(queue->rps_map, 1);
     if (map) {
-        RCU_INIT_POINTER(queue->rps_map, NULL);
+        rcu_init_pointer(queue->rps_map, NULL);
         kfree_rcu(map, rcu);
     }

     flow_table = rcu_dereference_protected(queue->rps_flow_table, 1);
     if (flow_table) {
-        RCU_INIT_POINTER(queue->rps_flow_table, NULL);
+        rcu_init_pointer(queue->rps_flow_table, NULL);
         call_rcu(&flow_table->rcu, rps_dev_flow_table_release);
     }
 #endif
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index e33937f..496ba90 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -820,7 +820,7 @@ void __netpoll_cleanup(struct netpoll *np)
         if (ops->ndo_netpoll_cleanup)
             ops->ndo_netpoll_cleanup(np->dev);

-        RCU_INIT_POINTER(np->dev->npinfo, NULL);
+        rcu_init_pointer(np->dev->npinfo, NULL);
         call_rcu_bh(&npinfo->rcu, rcu_cleanup_netpoll_info);
     }
 }
diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index 3825f66..15c63ac 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -266,7 +266,7 @@ static int netprio_device_event(struct
notifier_block *unused,
     switch (event) {
     case NETDEV_UNREGISTER:
         old = rtnl_dereference(dev->priomap);
-        RCU_INIT_POINTER(dev->priomap, NULL);
+        rcu_init_pointer(dev->priomap, NULL);
         if (old)
             kfree_rcu(old, rcu);
         break;
diff --git a/net/core/sock.c b/net/core/sock.c
index b4fff00..ea565ba 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -481,7 +481,7 @@ struct dst_entry *__sk_dst_check(struct sock *sk,
u32 cookie)

     if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
         sk_tx_queue_clear(sk);
-        RCU_INIT_POINTER(sk->sk_dst_cache, NULL);
+        rcu_init_pointer(sk->sk_dst_cache, NULL);
         dst_release(dst);
         return NULL;
     }
@@ -1365,7 +1365,7 @@ static void __sk_free(struct sock *sk)
                        atomic_read(&sk->sk_wmem_alloc) == 0);
     if (filter) {
         sk_filter_uncharge(sk, filter);
-        RCU_INIT_POINTER(sk->sk_filter, NULL);
+        rcu_init_pointer(sk->sk_filter, NULL);
     }

     sock_disable_timestamp(sk, SK_FLAGS_TIMESTAMP);
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index cf9cd13..f3016f9 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -118,7 +118,7 @@ static int flow_limit_cpu_sysctl(struct ctl_table
*table, int write,
             cur = rcu_dereference_protected(sd->flow_limit,
                      lockdep_is_held(&flow_limit_update_mutex));
             if (cur && !cpumask_test_cpu(i, mask)) {
-                RCU_INIT_POINTER(sd->flow_limit, NULL);
+                rcu_init_pointer(sd->flow_limit, NULL);
                 synchronize_rcu();
                 kfree(cur);
             } else if (!cur && cpumask_test_cpu(i, mask)) {
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index a603823..1680884 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -1100,7 +1100,7 @@ static struct dn_dev *dn_dev_create(struct
net_device *dev, int *err)

     dn_db->neigh_parms = neigh_parms_alloc(dev, &dn_neigh_table);
     if (!dn_db->neigh_parms) {
-        RCU_INIT_POINTER(dev->dn_ptr, NULL);
+        rcu_init_pointer(dev->dn_ptr, NULL);
         kfree(dn_db);
         return NULL;
     }
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index daccc4a..42d4bf0 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -380,7 +380,7 @@ static void dn_run_flush(unsigned long dummy)

         for(; rt; rt = next) {
             next = rcu_dereference_raw(rt->dst.dn_next);
-            RCU_INIT_POINTER(rt->dst.dn_next, NULL);
+            rcu_init_pointer(rt->dst.dn_next, NULL);
             dst_free((struct dst_entry *)rt);
         }

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index bdbf68b..5e2891c 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -294,7 +294,7 @@ static void inetdev_destroy(struct in_device *in_dev)
         inet_free_ifa(ifa);
     }

-    RCU_INIT_POINTER(dev->ip_ptr, NULL);
+    rcu_init_pointer(dev->ip_ptr, NULL);

     devinet_sysctl_unregister(in_dev);
     neigh_parms_release(&arp_tbl, in_dev->arp_parms);
@@ -1367,7 +1367,7 @@ static int inetdev_event(struct notifier_block
*this, unsigned long event,
     switch (event) {
     case NETDEV_REGISTER:
         pr_debug("%s: bug\n", __func__);
-        RCU_INIT_POINTER(dev->ip_ptr, NULL);
+        rcu_init_pointer(dev->ip_ptr, NULL);
         break;
     case NETDEV_UP:
         if (!inetdev_valid_mtu(dev->mtu))
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 8a043f0..aadbeda 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -147,7 +147,7 @@ static void rt_fibinfo_free(struct rtable __rcu **rtp)
     if (!rt)
         return;

-    /* Not even needed : RCU_INIT_POINTER(*rtp, NULL);
+    /* Not even needed : rcu_init_pointer(*rtp, NULL);
      * because we waited an RCU grace period before calling
      * free_fib_info_rcu()
      */
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 5afeb5a..b632346 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1602,7 +1602,7 @@ static void trie_leaf_remove(struct trie *t,
struct leaf *l)
         put_child(tp, cindex, NULL);
         trie_rebalance(t, tp);
     } else
-        RCU_INIT_POINTER(t->trie, NULL);
+        rcu_init_pointer(t->trie, NULL);

     free_leaf(l);
 }
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 97e4d16..54122f1 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1276,7 +1276,7 @@ static void ip_mc_hash_add(struct in_device *in_dev,
     for_each_pmc_rtnl(in_dev, im) {
         hash = ip_mc_hash(im);
         im->next_hash = mc_hash[hash];
-        RCU_INIT_POINTER(mc_hash[hash], im);
+        rcu_init_pointer(mc_hash[hash], im);
     }

     rcu_assign_pointer(in_dev->mc_hash, mc_hash);
@@ -1928,7 +1928,7 @@ static int ip_mc_leave_src(struct sock *sk,
struct ip_mc_socklist *iml,
     }
     err = ip_mc_del_src(in_dev, &iml->multi.imr_multiaddr.s_addr,
             iml->sfmode, psf->sl_count, psf->sl_addr, 0);
-    RCU_INIT_POINTER(iml->sflist, NULL);
+    rcu_init_pointer(iml->sflist, NULL);
     /* decrease mem now to avoid the memleak warning */
     atomic_sub(IP_SFLSIZE(psf->sl_max), &sk->sk_omem_alloc);
     kfree_rcu(psf, rcu);
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 48f4244..3983400 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -309,26 +309,26 @@ static void peer_avl_rebalance(struct inet_peer
__rcu **stack[],
             lr = rcu_deref_locked(l->avl_right, base);
             lrh = node_height(lr);
             if (lrh <= node_height(ll)) {    /* ll: RH+1 */
-                RCU_INIT_POINTER(node->avl_left, lr);    /* lr: RH or RH+1 */
-                RCU_INIT_POINTER(node->avl_right, r);    /* r: RH */
+                rcu_init_pointer(node->avl_left, lr);    /* lr: RH or RH+1 */
+                rcu_init_pointer(node->avl_right, r);    /* r: RH */
                 node->avl_height = lrh + 1; /* RH+1 or RH+2 */
-                RCU_INIT_POINTER(l->avl_left, ll);       /* ll: RH+1 */
-                RCU_INIT_POINTER(l->avl_right, node);    /* node:
RH+1 or RH+2 */
+                rcu_init_pointer(l->avl_left, ll);       /* ll: RH+1 */
+                rcu_init_pointer(l->avl_right, node);    /* node:
RH+1 or RH+2 */
                 l->avl_height = node->avl_height + 1;
-                RCU_INIT_POINTER(*nodep, l);
+                rcu_init_pointer(*nodep, l);
             } else { /* ll: RH, lr: RH+1 */
                 lrl = rcu_deref_locked(lr->avl_left, base);/* lrl: RH
or RH-1 */
                 lrr = rcu_deref_locked(lr->avl_right, base);/* lrr:
RH or RH-1 */
-                RCU_INIT_POINTER(node->avl_left, lrr);    /* lrr: RH or RH-1 */
-                RCU_INIT_POINTER(node->avl_right, r);    /* r: RH */
+                rcu_init_pointer(node->avl_left, lrr);    /* lrr: RH or RH-1 */
+                rcu_init_pointer(node->avl_right, r);    /* r: RH */
                 node->avl_height = rh + 1; /* node: RH+1 */
-                RCU_INIT_POINTER(l->avl_left, ll);    /* ll: RH */
-                RCU_INIT_POINTER(l->avl_right, lrl);    /* lrl: RH or RH-1 */
+                rcu_init_pointer(l->avl_left, ll);    /* ll: RH */
+                rcu_init_pointer(l->avl_right, lrl);    /* lrl: RH or RH-1 */
                 l->avl_height = rh + 1;    /* l: RH+1 */
-                RCU_INIT_POINTER(lr->avl_left, l);    /* l: RH+1 */
-                RCU_INIT_POINTER(lr->avl_right, node);    /* node: RH+1 */
+                rcu_init_pointer(lr->avl_left, l);    /* l: RH+1 */
+                rcu_init_pointer(lr->avl_right, node);    /* node: RH+1 */
                 lr->avl_height = rh + 2;
-                RCU_INIT_POINTER(*nodep, lr);
+                rcu_init_pointer(*nodep, lr);
             }
         } else if (rh > lh + 1) { /* r: LH+2 */
             struct inet_peer *rr, *rl, *rlr, *rll;
@@ -337,26 +337,26 @@ static void peer_avl_rebalance(struct inet_peer
__rcu **stack[],
             rl = rcu_deref_locked(r->avl_left, base);
             rlh = node_height(rl);
             if (rlh <= node_height(rr)) {    /* rr: LH+1 */
-                RCU_INIT_POINTER(node->avl_right, rl);    /* rl: LH or LH+1 */
-                RCU_INIT_POINTER(node->avl_left, l);    /* l: LH */
+                rcu_init_pointer(node->avl_right, rl);    /* rl: LH or LH+1 */
+                rcu_init_pointer(node->avl_left, l);    /* l: LH */
                 node->avl_height = rlh + 1; /* LH+1 or LH+2 */
-                RCU_INIT_POINTER(r->avl_right, rr);    /* rr: LH+1 */
-                RCU_INIT_POINTER(r->avl_left, node);    /* node: LH+1
or LH+2 */
+                rcu_init_pointer(r->avl_right, rr);    /* rr: LH+1 */
+                rcu_init_pointer(r->avl_left, node);    /* node: LH+1
or LH+2 */
                 r->avl_height = node->avl_height + 1;
-                RCU_INIT_POINTER(*nodep, r);
+                rcu_init_pointer(*nodep, r);
             } else { /* rr: RH, rl: RH+1 */
                 rlr = rcu_deref_locked(rl->avl_right, base);/* rlr:
LH or LH-1 */
                 rll = rcu_deref_locked(rl->avl_left, base);/* rll: LH
or LH-1 */
-                RCU_INIT_POINTER(node->avl_right, rll);    /* rll: LH
or LH-1 */
-                RCU_INIT_POINTER(node->avl_left, l);    /* l: LH */
+                rcu_init_pointer(node->avl_right, rll);    /* rll: LH
or LH-1 */
+                rcu_init_pointer(node->avl_left, l);    /* l: LH */
                 node->avl_height = lh + 1; /* node: LH+1 */
-                RCU_INIT_POINTER(r->avl_right, rr);    /* rr: LH */
-                RCU_INIT_POINTER(r->avl_left, rlr);    /* rlr: LH or LH-1 */
+                rcu_init_pointer(r->avl_right, rr);    /* rr: LH */
+                rcu_init_pointer(r->avl_left, rlr);    /* rlr: LH or LH-1 */
                 r->avl_height = lh + 1;    /* r: LH+1 */
-                RCU_INIT_POINTER(rl->avl_right, r);    /* r: LH+1 */
-                RCU_INIT_POINTER(rl->avl_left, node);    /* node: LH+1 */
+                rcu_init_pointer(rl->avl_right, r);    /* r: LH+1 */
+                rcu_init_pointer(rl->avl_left, node);    /* node: LH+1 */
                 rl->avl_height = lh + 2;
-                RCU_INIT_POINTER(*nodep, rl);
+                rcu_init_pointer(*nodep, rl);
             }
         } else {
             node->avl_height = (lh > rh ? lh : rh) + 1;
@@ -400,7 +400,7 @@ static void unlink_from_pool(struct inet_peer *p,
struct inet_peer_base *base,
         /* t is removed, t->daddr > x->daddr for any
          * x in p->avl_left subtree.
          * Put t in the old place of p. */
-        RCU_INIT_POINTER(*delp[0], t);
+        rcu_init_pointer(*delp[0], t);
         t->avl_left = p->avl_left;
         t->avl_right = p->avl_right;
         t->avl_height = p->avl_height;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index d84dc8d..19700ee 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1253,7 +1253,7 @@ static void mrtsock_destruct(struct sock *sk)
             inet_netconf_notify_devconf(net, NETCONFA_MC_FORWARDING,
                             NETCONFA_IFINDEX_ALL,
                             net->ipv4.devconf_all);
-            RCU_INIT_POINTER(mrt->mroute_sk, NULL);
+            rcu_init_pointer(mrt->mroute_sk, NULL);
             mroute_clean_tables(mrt);
         }
     }
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 574f7eb..c927fb1 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -590,15 +590,15 @@ static int __init init(void)
     BUG_ON(nat_callforwarding_hook != NULL);
     BUG_ON(nat_q931_hook != NULL);

-    RCU_INIT_POINTER(set_h245_addr_hook, set_h245_addr);
-    RCU_INIT_POINTER(set_h225_addr_hook, set_h225_addr);
-    RCU_INIT_POINTER(set_sig_addr_hook, set_sig_addr);
-    RCU_INIT_POINTER(set_ras_addr_hook, set_ras_addr);
-    RCU_INIT_POINTER(nat_rtp_rtcp_hook, nat_rtp_rtcp);
-    RCU_INIT_POINTER(nat_t120_hook, nat_t120);
-    RCU_INIT_POINTER(nat_h245_hook, nat_h245);
-    RCU_INIT_POINTER(nat_callforwarding_hook, nat_callforwarding);
-    RCU_INIT_POINTER(nat_q931_hook, nat_q931);
+    rcu_init_pointer(set_h245_addr_hook, set_h245_addr);
+    rcu_init_pointer(set_h225_addr_hook, set_h225_addr);
+    rcu_init_pointer(set_sig_addr_hook, set_sig_addr);
+    rcu_init_pointer(set_ras_addr_hook, set_ras_addr);
+    rcu_init_pointer(nat_rtp_rtcp_hook, nat_rtp_rtcp);
+    rcu_init_pointer(nat_t120_hook, nat_t120);
+    rcu_init_pointer(nat_h245_hook, nat_h245);
+    rcu_init_pointer(nat_callforwarding_hook, nat_callforwarding);
+    rcu_init_pointer(nat_q931_hook, nat_q931);
     nf_ct_helper_expectfn_register(&q931_nat);
     nf_ct_helper_expectfn_register(&callforwarding_nat);
     return 0;
@@ -607,15 +607,15 @@ static int __init init(void)
 /****************************************************************************/
 static void __exit fini(void)
 {
-    RCU_INIT_POINTER(set_h245_addr_hook, NULL);
-    RCU_INIT_POINTER(set_h225_addr_hook, NULL);
-    RCU_INIT_POINTER(set_sig_addr_hook, NULL);
-    RCU_INIT_POINTER(set_ras_addr_hook, NULL);
-    RCU_INIT_POINTER(nat_rtp_rtcp_hook, NULL);
-    RCU_INIT_POINTER(nat_t120_hook, NULL);
-    RCU_INIT_POINTER(nat_h245_hook, NULL);
-    RCU_INIT_POINTER(nat_callforwarding_hook, NULL);
-    RCU_INIT_POINTER(nat_q931_hook, NULL);
+    rcu_init_pointer(set_h245_addr_hook, NULL);
+    rcu_init_pointer(set_h225_addr_hook, NULL);
+    rcu_init_pointer(set_sig_addr_hook, NULL);
+    rcu_init_pointer(set_ras_addr_hook, NULL);
+    rcu_init_pointer(nat_rtp_rtcp_hook, NULL);
+    rcu_init_pointer(nat_t120_hook, NULL);
+    rcu_init_pointer(nat_h245_hook, NULL);
+    rcu_init_pointer(nat_callforwarding_hook, NULL);
+    rcu_init_pointer(nat_q931_hook, NULL);
     nf_ct_helper_expectfn_unregister(&q931_nat);
     nf_ct_helper_expectfn_unregister(&callforwarding_nat);
     synchronize_rcu();
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 657d230..63b58b2 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -285,25 +285,25 @@ static int __init nf_nat_helper_pptp_init(void)
     nf_nat_need_gre();

     BUG_ON(nf_nat_pptp_hook_outbound != NULL);
-    RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
+    rcu_init_pointer(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);

     BUG_ON(nf_nat_pptp_hook_inbound != NULL);
-    RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
+    rcu_init_pointer(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);

     BUG_ON(nf_nat_pptp_hook_exp_gre != NULL);
-    RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
+    rcu_init_pointer(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);

     BUG_ON(nf_nat_pptp_hook_expectfn != NULL);
-    RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
+    rcu_init_pointer(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
     return 0;
 }

 static void __exit nf_nat_helper_pptp_fini(void)
 {
-    RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, NULL);
-    RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, NULL);
-    RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, NULL);
-    RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, NULL);
+    rcu_init_pointer(nf_nat_pptp_hook_expectfn, NULL);
+    rcu_init_pointer(nf_nat_pptp_hook_exp_gre, NULL);
+    rcu_init_pointer(nf_nat_pptp_hook_inbound, NULL);
+    rcu_init_pointer(nf_nat_pptp_hook_outbound, NULL);
     synchronize_rcu();
 }

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c
b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index 7c67667..9b786d1 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -1291,7 +1291,7 @@ static int __init nf_nat_snmp_basic_init(void)
     int ret = 0;

     BUG_ON(nf_nat_snmp_hook != NULL);
-    RCU_INIT_POINTER(nf_nat_snmp_hook, help);
+    rcu_init_pointer(nf_nat_snmp_hook, help);

     ret = nf_conntrack_helper_register(&snmp_trap_helper);
     if (ret < 0) {
@@ -1303,7 +1303,7 @@ static int __init nf_nat_snmp_basic_init(void)

 static void __exit nf_nat_snmp_basic_fini(void)
 {
-    RCU_INIT_POINTER(nf_nat_snmp_hook, NULL);
+    rcu_init_pointer(nf_nat_snmp_hook, NULL);
     nf_conntrack_helper_unregister(&snmp_trap_helper);
 }

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index db1e0da..186ff04 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -563,12 +563,12 @@ static void fnhe_flush_routes(struct
fib_nh_exception *fnhe)

     rt = rcu_dereference(fnhe->fnhe_rth_input);
     if (rt) {
-        RCU_INIT_POINTER(fnhe->fnhe_rth_input, NULL);
+        rcu_init_pointer(fnhe->fnhe_rth_input, NULL);
         rt_free(rt);
     }
     rt = rcu_dereference(fnhe->fnhe_rth_output);
     if (rt) {
-        RCU_INIT_POINTER(fnhe->fnhe_rth_output, NULL);
+        rcu_init_pointer(fnhe->fnhe_rth_output, NULL);
         rt_free(rt);
     }
 }
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6c7fa08..563a9e4 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3017,7 +3017,7 @@ static int addrconf_ifdown(struct net_device
*dev, int how)
         idev->dead = 1;

         /* protected by rtnl_lock */
-        RCU_INIT_POINTER(dev->ip6_ptr, NULL);
+        rcu_init_pointer(dev->ip6_ptr, NULL);

         /* Step 1.5: remove snmp6 entry */
         snmp6_unregister_dev(idev);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index b05b609..652e28a 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -386,7 +386,7 @@ ip6_tnl_dev_uninit(struct net_device *dev)
     struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);

     if (dev == ip6n->fb_tnl_dev)
-        RCU_INIT_POINTER(ip6n->tnls_wc[0], NULL);
+        rcu_init_pointer(ip6n->tnls_wc[0], NULL);
     else
         ip6_tnl_unlink(ip6n, t);
     ip6_tnl_dst_reset(t);
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index b7c0f82..bff37b3 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -275,7 +275,7 @@ static void vti6_dev_uninit(struct net_device *dev)
     struct vti6_net *ip6n = net_generic(net, vti6_net_id);

     if (dev == ip6n->fb_tnl_dev)
-        RCU_INIT_POINTER(ip6n->tnls_wc[0], NULL);
+        rcu_init_pointer(ip6n->tnls_wc[0], NULL);
     else
         vti6_tnl_unlink(ip6n, t);
     dev_put(dev);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 95f3f1d..88d73a1 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -203,7 +203,7 @@ static const struct nf_afinfo nf_ip6_afinfo = {

 int __init ipv6_netfilter_init(void)
 {
-    RCU_INIT_POINTER(nf_ipv6_ops, &ipv6ops);
+    rcu_init_pointer(nf_ipv6_ops, &ipv6ops);
     return nf_register_afinfo(&nf_ip6_afinfo);
 }

@@ -212,6 +212,6 @@ int __init ipv6_netfilter_init(void)
  */
 void ipv6_netfilter_fini(void)
 {
-    RCU_INIT_POINTER(nf_ipv6_ops, NULL);
+    rcu_init_pointer(nf_ipv6_ops, NULL);
     nf_unregister_afinfo(&nf_ip6_afinfo);
 }
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 1f29996..594ac2f 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -140,7 +140,7 @@ EXPORT_SYMBOL(rawv6_mh_filter_register);

 int rawv6_mh_filter_unregister(mh_filter_t filter)
 {
-    RCU_INIT_POINTER(mh_filter, NULL);
+    rcu_init_pointer(mh_filter, NULL);
     synchronize_rcu();
     return 0;
 }
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index e5a453c..bbde433 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -470,7 +470,7 @@ static void ipip6_tunnel_uninit(struct net_device *dev)
     struct sit_net *sitn = net_generic(tunnel->net, sit_net_id);

     if (dev == sitn->fb_tunnel_dev) {
-        RCU_INIT_POINTER(sitn->tunnels_wc[0], NULL);
+        rcu_init_pointer(sitn->tunnels_wc[0], NULL);
     } else {
         ipip6_tunnel_unlink(sitn, tunnel);
         ipip6_tunnel_del_prl(tunnel, NULL);
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 31bf258..22d4d35 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -72,7 +72,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info
*sta, u16 tid,
     if (!tid_rx)
         return;

-    RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
+    rcu_init_pointer(sta->ampdu_mlme.tid_rx[tid], NULL);

     ht_dbg(sta->sdata,
            "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aaa59d7..3839764 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -64,7 +64,7 @@ static int ieee80211_change_iface(struct wiphy *wiphy,

     if (type == NL80211_IFTYPE_AP_VLAN &&
         params && params->use_4addr == 0)
-        RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
+        rcu_init_pointer(sdata->u.vlan.sta, NULL);
     else if (type == NL80211_IFTYPE_STATION &&
          params && params->use_4addr >= 0)
         sdata->u.mgd.use_4addr = params->use_4addr;
@@ -1033,7 +1033,7 @@ static int ieee80211_start_ap(struct wiphy
*wiphy, struct net_device *dev,

         if (old)
             kfree_rcu(old, rcu_head);
-        RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
+        rcu_init_pointer(sdata->u.ap.beacon, NULL);
         ieee80211_vif_release_channel(sdata);
         return err;
     }
@@ -1102,8 +1102,8 @@ static int ieee80211_stop_ap(struct wiphy
*wiphy, struct net_device *dev)
     netif_carrier_off(dev);

     /* remove beacon and probe response */
-    RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
-    RCU_INIT_POINTER(sdata->u.ap.probe_resp, NULL);
+    rcu_init_pointer(sdata->u.ap.beacon, NULL);
+    rcu_init_pointer(sdata->u.ap.probe_resp, NULL);
     kfree_rcu(old_beacon, rcu_head);
     if (old_probe_resp)
         kfree_rcu(old_probe_resp, rcu_head);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 06d2878..bd477c2 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -365,7 +365,7 @@ static void __ieee80211_sta_join_ibss(struct
ieee80211_sub_if_data *sdata,
         sdata->vif.bss_conf.ibss_creator = false;
         sdata->vif.bss_conf.enable_beacon = false;
         sdata->vif.bss_conf.ssid_len = 0;
-        RCU_INIT_POINTER(ifibss->presp, NULL);
+        rcu_init_pointer(ifibss->presp, NULL);
         kfree_rcu(presp, rcu_head);
         mutex_lock(&local->mtx);
         ieee80211_vif_release_channel(sdata);
@@ -735,7 +735,7 @@ static void ieee80211_ibss_disconnect(struct
ieee80211_sub_if_data *sdata)
     /* remove beacon */
     presp = rcu_dereference_protected(ifibss->presp,
                       lockdep_is_held(&sdata->wdev.mtx));
-    RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
+    rcu_init_pointer(sdata->u.ibss.presp, NULL);
     if (presp)
         kfree_rcu(presp, rcu_head);

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f70e9cd..9271537 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1341,7 +1341,7 @@ void ieee80211_mesh_init_sdata(struct
ieee80211_sub_if_data *sdata)
     skb_queue_head_init(&ifmsh->ps.bc_buf);
     spin_lock_init(&ifmsh->mesh_preq_queue_lock);
     spin_lock_init(&ifmsh->sync_offset_lock);
-    RCU_INIT_POINTER(ifmsh->beacon, NULL);
+    rcu_init_pointer(ifmsh->beacon, NULL);

     sdata->vif.bss_conf.bssid = zero_addr;
 }
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 7d050ed..5db5430 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -1068,8 +1068,8 @@ int mesh_pathtbl_init(void)
     INIT_HLIST_HEAD(tbl_mpp->known_gates);

     /* Need no locking since this is during init */
-    RCU_INIT_POINTER(mesh_paths, tbl_path);
-    RCU_INIT_POINTER(mpp_paths, tbl_mpp);
+    rcu_init_pointer(mesh_paths, tbl_path);
+    rcu_init_pointer(mpp_paths, tbl_mpp);

     return 0;

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 137a192..0d2c0bf 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -860,7 +860,7 @@ static int __must_check
__sta_info_destroy_part1(struct sta_info *sta)

     if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
         rcu_access_pointer(sdata->u.vlan.sta) == sta)
-        RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
+        rcu_init_pointer(sdata->u.vlan.sta, NULL);

     return 0;
 }
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 1fbab0c..5f88a73 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -40,7 +40,7 @@ int nf_register_afinfo(const struct nf_afinfo *afinfo)
     err = mutex_lock_interruptible(&afinfo_mutex);
     if (err < 0)
         return err;
-    RCU_INIT_POINTER(nf_afinfo[afinfo->family], afinfo);
+    rcu_init_pointer(nf_afinfo[afinfo->family], afinfo);
     mutex_unlock(&afinfo_mutex);
     return 0;
 }
@@ -49,7 +49,7 @@ EXPORT_SYMBOL_GPL(nf_register_afinfo);
 void nf_unregister_afinfo(const struct nf_afinfo *afinfo)
 {
     mutex_lock(&afinfo_mutex);
-    RCU_INIT_POINTER(nf_afinfo[afinfo->family], NULL);
+    rcu_init_pointer(nf_afinfo[afinfo->family], NULL);
     mutex_unlock(&afinfo_mutex);
     synchronize_rcu();
 }
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c42e83d..e8b609d 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -641,7 +641,7 @@ static void __ip_vs_dst_cache_reset(struct ip_vs_dest *dest)

     old = rcu_dereference_protected(dest->dest_dst, 1);
     if (old) {
-        RCU_INIT_POINTER(dest->dest_dst, NULL);
+        rcu_init_pointer(dest->dest_dst, NULL);
         call_rcu(&old->rcu_head, ip_vs_dest_dst_rcu_free);
     }
 }
@@ -1221,7 +1221,7 @@ ip_vs_add_service(struct net *net, struct
ip_vs_service_user_kern *u,
     sched = NULL;

     /* Bind the ct retriever */
-    RCU_INIT_POINTER(svc->pe, pe);
+    rcu_init_pointer(svc->pe, pe);
     pe = NULL;

     /* Update the virtual service counters */
diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
index c3b8454..6cd09c1 100644
--- a/net/netfilter/ipvs/ip_vs_dh.c
+++ b/net/netfilter/ipvs/ip_vs_dh.c
@@ -115,14 +115,14 @@ ip_vs_dh_reassign(struct ip_vs_dh_state *s,
struct ip_vs_service *svc)
         if (dest)
             ip_vs_dest_put(dest);
         if (empty)
-            RCU_INIT_POINTER(b->dest, NULL);
+            rcu_init_pointer(b->dest, NULL);
         else {
             if (p == &svc->destinations)
                 p = p->next;

             dest = list_entry(p, struct ip_vs_dest, n_list);
             ip_vs_dest_hold(dest);
-            RCU_INIT_POINTER(b->dest, dest);
+            rcu_init_pointer(b->dest, dest);

             p = p->next;
         }
@@ -146,7 +146,7 @@ static void ip_vs_dh_flush(struct ip_vs_dh_state *s)
         dest = rcu_dereference_protected(b->dest, 1);
         if (dest) {
             ip_vs_dest_put(dest);
-            RCU_INIT_POINTER(b->dest, NULL);
+            rcu_init_pointer(b->dest, NULL);
         }
         b++;
     }
diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
index cc65b2f..6a3e885 100644
--- a/net/netfilter/ipvs/ip_vs_sh.c
+++ b/net/netfilter/ipvs/ip_vs_sh.c
@@ -182,14 +182,14 @@ ip_vs_sh_reassign(struct ip_vs_sh_state *s,
struct ip_vs_service *svc)
         if (dest)
             ip_vs_dest_put(dest);
         if (empty)
-            RCU_INIT_POINTER(b->dest, NULL);
+            rcu_init_pointer(b->dest, NULL);
         else {
             if (p == &svc->destinations)
                 p = p->next;

             dest = list_entry(p, struct ip_vs_dest, n_list);
             ip_vs_dest_hold(dest);
-            RCU_INIT_POINTER(b->dest, dest);
+            rcu_init_pointer(b->dest, dest);

             IP_VS_DBG_BUF(6, "assigned i: %d dest: %s weight: %d\n",
                       i, IP_VS_DBG_ADDR(svc->af, &dest->addr),
@@ -222,7 +222,7 @@ static void ip_vs_sh_flush(struct ip_vs_sh_state *s)
         dest = rcu_dereference_protected(b->dest, 1);
         if (dest) {
             ip_vs_dest_put(dest);
-            RCU_INIT_POINTER(b->dest, NULL);
+            rcu_init_pointer(b->dest, NULL);
         }
         b++;
     }
diff --git a/net/netfilter/nf_conntrack_core.c
b/net/netfilter/nf_conntrack_core.c
index 75421f2..57e1308 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1498,12 +1498,12 @@ static int untrack_refs(void)

 void nf_conntrack_cleanup_start(void)
 {
-    RCU_INIT_POINTER(ip_ct_attach, NULL);
+    rcu_init_pointer(ip_ct_attach, NULL);
 }

 void nf_conntrack_cleanup_end(void)
 {
-    RCU_INIT_POINTER(nf_ct_destroy, NULL);
+    rcu_init_pointer(nf_ct_destroy, NULL);
     while (untrack_refs() > 0)
         schedule();

@@ -1778,8 +1778,8 @@ err_expect:
 void nf_conntrack_init_end(void)
 {
     /* For use by REJECT target */
-    RCU_INIT_POINTER(ip_ct_attach, nf_conntrack_attach);
-    RCU_INIT_POINTER(nf_ct_destroy, destroy_conntrack);
+    rcu_init_pointer(ip_ct_attach, nf_conntrack_attach);
+    rcu_init_pointer(nf_ct_destroy, destroy_conntrack);
 }

 /*
diff --git a/net/netfilter/nf_conntrack_ecache.c
b/net/netfilter/nf_conntrack_ecache.c
index 1df1761..30ba3b0 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -114,7 +114,7 @@ void nf_conntrack_unregister_notifier(struct net *net,
     notify = rcu_dereference_protected(net->ct.nf_conntrack_event_cb,
                        lockdep_is_held(&nf_ct_ecache_mutex));
     BUG_ON(notify != new);
-    RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, NULL);
+    rcu_init_pointer(net->ct.nf_conntrack_event_cb, NULL);
     mutex_unlock(&nf_ct_ecache_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
@@ -150,7 +150,7 @@ void nf_ct_expect_unregister_notifier(struct net *net,
     notify = rcu_dereference_protected(net->ct.nf_expect_event_cb,
                        lockdep_is_held(&nf_ct_ecache_mutex));
     BUG_ON(notify != new);
-    RCU_INIT_POINTER(net->ct.nf_expect_event_cb, NULL);
+    rcu_init_pointer(net->ct.nf_expect_event_cb, NULL);
     mutex_unlock(&nf_ct_ecache_mutex);
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
diff --git a/net/netfilter/nf_conntrack_extend.c
b/net/netfilter/nf_conntrack_extend.c
index 1a95459..bbbea59b 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -183,7 +183,7 @@ EXPORT_SYMBOL_GPL(nf_ct_extend_register);
 void nf_ct_extend_unregister(struct nf_ct_ext_type *type)
 {
     mutex_lock(&nf_ct_ext_type_mutex);
-    RCU_INIT_POINTER(nf_ct_ext_types[type->id], NULL);
+    rcu_init_pointer(nf_ct_ext_types[type->id], NULL);
     update_alloc_size(type);
     mutex_unlock(&nf_ct_ext_type_mutex);
     rcu_barrier(); /* Wait for completion of call_rcu()'s */
diff --git a/net/netfilter/nf_conntrack_helper.c
b/net/netfilter/nf_conntrack_helper.c
index 5b3eae7..a4dce7f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -222,7 +222,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct,
struct nf_conn *tmpl,

     if (helper == NULL) {
         if (help)
-            RCU_INIT_POINTER(help->helper, NULL);
+            rcu_init_pointer(help->helper, NULL);
         goto out;
     }

@@ -239,7 +239,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct,
struct nf_conn *tmpl,
         struct nf_conntrack_helper *tmp = rcu_dereference(help->helper);

         if (tmp && tmp->help != helper->help) {
-            RCU_INIT_POINTER(help->helper, NULL);
+            rcu_init_pointer(help->helper, NULL);
             goto out;
         }
     }
@@ -259,7 +259,7 @@ static inline int unhelp(struct nf_conntrack_tuple_hash *i,

     if (help && rcu_dereference_raw(help->helper) == me) {
         nf_conntrack_event(IPCT_HELPER, ct);
-        RCU_INIT_POINTER(help->helper, NULL);
+        rcu_init_pointer(help->helper, NULL);
     }
     return 0;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c
b/net/netfilter/nf_conntrack_netlink.c
index ccc46fa..f147656 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1372,7 +1372,7 @@ ctnetlink_change_helper(struct nf_conn *ct,
const struct nlattr * const cda[])
         if (help && help->helper) {
             /* we had a helper before ... */
             nf_ct_remove_expectations(ct);
-            RCU_INIT_POINTER(help->helper, NULL);
+            rcu_init_pointer(help->helper, NULL);
         }

         return 0;
@@ -1666,7 +1666,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
                 helper->from_nlattr(helpinfo, ct);

             /* not in hash table yet so not strictly necessary */
-            RCU_INIT_POINTER(help->helper, helper);
+            rcu_init_pointer(help->helper, helper);
         }
     } else {
         /* try an implicit helper assignation */
@@ -3213,7 +3213,7 @@ static int __init ctnetlink_init(void)
     }
 #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
     /* setup interaction between nf_queue and nf_conntrack_netlink. */
-    RCU_INIT_POINTER(nfq_ct_hook, &ctnetlink_nfqueue_hook);
+    rcu_init_pointer(nfq_ct_hook, &ctnetlink_nfqueue_hook);
 #endif
     return 0;

@@ -3233,7 +3233,7 @@ static void __exit ctnetlink_exit(void)
     nfnetlink_subsys_unregister(&ctnl_exp_subsys);
     nfnetlink_subsys_unregister(&ctnl_subsys);
 #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
-    RCU_INIT_POINTER(nfq_ct_hook, NULL);
+    rcu_init_pointer(nfq_ct_hook, NULL);
 #endif
 }

diff --git a/net/netfilter/nf_conntrack_proto.c
b/net/netfilter/nf_conntrack_proto.c
index b65d586..2dc7f72 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -384,7 +384,7 @@ int nf_ct_l4proto_register(struct
nf_conntrack_l4proto *l4proto)
         }

         for (i = 0; i < MAX_NF_CT_PROTO; i++)
-            RCU_INIT_POINTER(proto_array[i], &nf_conntrack_l4proto_generic);
+            rcu_init_pointer(proto_array[i], &nf_conntrack_l4proto_generic);

         /* Before making proto_array visible to lockless readers,
          * we must make sure its content is committed to memory.
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 85296d4..a9580ec 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -58,7 +58,7 @@ void nf_log_unset(struct net *net, const struct
nf_logger *logger)
         log = rcu_dereference_protected(net->nf.nf_loggers[i],
                 lockdep_is_held(&nf_log_mutex));
         if (log == logger)
-            RCU_INIT_POINTER(net->nf.nf_loggers[i], NULL);
+            rcu_init_pointer(net->nf.nf_loggers[i], NULL);
     }
     mutex_unlock(&nf_log_mutex);
     synchronize_rcu();
@@ -124,7 +124,7 @@ void nf_log_unbind_pf(struct net *net, u_int8_t pf)
     if (pf >= ARRAY_SIZE(net->nf.nf_loggers))
         return;
     mutex_lock(&nf_log_mutex);
-    RCU_INIT_POINTER(net->nf.nf_loggers[pf], NULL);
+    rcu_init_pointer(net->nf.nf_loggers[pf], NULL);
     mutex_unlock(&nf_log_mutex);
 }
 EXPORT_SYMBOL(nf_log_unbind_pf);
diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
index eb77238..d5ac5b2 100644
--- a/net/netfilter/nf_nat_amanda.c
+++ b/net/netfilter/nf_nat_amanda.c
@@ -75,14 +75,14 @@ static unsigned int help(struct sk_buff *skb,

 static void __exit nf_nat_amanda_fini(void)
 {
-    RCU_INIT_POINTER(nf_nat_amanda_hook, NULL);
+    rcu_init_pointer(nf_nat_amanda_hook, NULL);
     synchronize_rcu();
 }

 static int __init nf_nat_amanda_init(void)
 {
     BUG_ON(nf_nat_amanda_hook != NULL);
-    RCU_INIT_POINTER(nf_nat_amanda_hook, help);
+    rcu_init_pointer(nf_nat_amanda_hook, help);
     return 0;
 }

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 52ca952..1219b5e 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -562,7 +562,7 @@ int nf_nat_l4proto_register(u8 l3proto, const
struct nf_nat_l4proto *l4proto)
         }

         for (i = 0; i < IPPROTO_MAX; i++)
-            RCU_INIT_POINTER(l4protos[i], &nf_nat_l4proto_unknown);
+            rcu_init_pointer(l4protos[i], &nf_nat_l4proto_unknown);

         /* Before making proto_array visible to lockless readers,
          * we must make sure its content is committed to memory.
@@ -579,7 +579,7 @@ int nf_nat_l4proto_register(u8 l3proto, const
struct nf_nat_l4proto *l4proto)
         ret = -EBUSY;
         goto out;
     }
-    RCU_INIT_POINTER(nf_nat_l4protos[l3proto][l4proto->l4proto], l4proto);
+    rcu_init_pointer(nf_nat_l4protos[l3proto][l4proto->l4proto], l4proto);
  out:
     mutex_unlock(&nf_nat_proto_mutex);
     return ret;
@@ -590,7 +590,7 @@ EXPORT_SYMBOL_GPL(nf_nat_l4proto_register);
 void nf_nat_l4proto_unregister(u8 l3proto, const struct
nf_nat_l4proto *l4proto)
 {
     mutex_lock(&nf_nat_proto_mutex);
-    RCU_INIT_POINTER(nf_nat_l4protos[l3proto][l4proto->l4proto],
+    rcu_init_pointer(nf_nat_l4protos[l3proto][l4proto->l4proto],
              &nf_nat_l4proto_unknown);
     mutex_unlock(&nf_nat_proto_mutex);
     synchronize_rcu();
@@ -608,13 +608,13 @@ int nf_nat_l3proto_register(const struct
nf_nat_l3proto *l3proto)
         return err;

     mutex_lock(&nf_nat_proto_mutex);
-    RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_TCP],
+    rcu_init_pointer(nf_nat_l4protos[l3proto->l3proto][IPPROTO_TCP],
              &nf_nat_l4proto_tcp);
-    RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_UDP],
+    rcu_init_pointer(nf_nat_l4protos[l3proto->l3proto][IPPROTO_UDP],
              &nf_nat_l4proto_udp);
     mutex_unlock(&nf_nat_proto_mutex);

-    RCU_INIT_POINTER(nf_nat_l3protos[l3proto->l3proto], l3proto);
+    rcu_init_pointer(nf_nat_l3protos[l3proto->l3proto], l3proto);
     return 0;
 }
 EXPORT_SYMBOL_GPL(nf_nat_l3proto_register);
@@ -622,7 +622,7 @@ EXPORT_SYMBOL_GPL(nf_nat_l3proto_register);
 void nf_nat_l3proto_unregister(const struct nf_nat_l3proto *l3proto)
 {
     mutex_lock(&nf_nat_proto_mutex);
-    RCU_INIT_POINTER(nf_nat_l3protos[l3proto->l3proto], NULL);
+    rcu_init_pointer(nf_nat_l3protos[l3proto->l3proto], NULL);
     mutex_unlock(&nf_nat_proto_mutex);
     synchronize_rcu();

@@ -822,11 +822,11 @@ static int __init nf_nat_init(void)
     nf_ct_untracked_status_or(IPS_NAT_DONE_MASK);

     BUG_ON(nfnetlink_parse_nat_setup_hook != NULL);
-    RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook,
+    rcu_init_pointer(nfnetlink_parse_nat_setup_hook,
                nfnetlink_parse_nat_setup);
 #ifdef CONFIG_XFRM
     BUG_ON(nf_nat_decode_session_hook != NULL);
-    RCU_INIT_POINTER(nf_nat_decode_session_hook, __nf_nat_decode_session);
+    rcu_init_pointer(nf_nat_decode_session_hook, __nf_nat_decode_session);
 #endif
     return 0;

@@ -842,9 +842,9 @@ static void __exit nf_nat_cleanup(void)
     unregister_pernet_subsys(&nf_nat_net_ops);
     nf_ct_extend_unregister(&nat_extend);
     nf_ct_helper_expectfn_unregister(&follow_master_nat);
-    RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook, NULL);
+    rcu_init_pointer(nfnetlink_parse_nat_setup_hook, NULL);
 #ifdef CONFIG_XFRM
-    RCU_INIT_POINTER(nf_nat_decode_session_hook, NULL);
+    rcu_init_pointer(nf_nat_decode_session_hook, NULL);
 #endif
     for (i = 0; i < NFPROTO_NUMPROTO; i++)
         kfree(nf_nat_l4protos[i]);
diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
index e84a578..aaef6c6 100644
--- a/net/netfilter/nf_nat_ftp.c
+++ b/net/netfilter/nf_nat_ftp.c
@@ -122,14 +122,14 @@ out:

 static void __exit nf_nat_ftp_fini(void)
 {
-    RCU_INIT_POINTER(nf_nat_ftp_hook, NULL);
+    rcu_init_pointer(nf_nat_ftp_hook, NULL);
     synchronize_rcu();
 }

 static int __init nf_nat_ftp_init(void)
 {
     BUG_ON(nf_nat_ftp_hook != NULL);
-    RCU_INIT_POINTER(nf_nat_ftp_hook, nf_nat_ftp);
+    rcu_init_pointer(nf_nat_ftp_hook, nf_nat_ftp);
     return 0;
 }

diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index 1fb2258..5bf497d 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -95,14 +95,14 @@ static unsigned int help(struct sk_buff *skb,

 static void __exit nf_nat_irc_fini(void)
 {
-    RCU_INIT_POINTER(nf_nat_irc_hook, NULL);
+    rcu_init_pointer(nf_nat_irc_hook, NULL);
     synchronize_rcu();
 }

 static int __init nf_nat_irc_init(void)
 {
     BUG_ON(nf_nat_irc_hook != NULL);
-    RCU_INIT_POINTER(nf_nat_irc_hook, help);
+    rcu_init_pointer(nf_nat_irc_hook, help);
     return 0;
 }

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index b4d691d..a2a0a39 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -625,7 +625,7 @@ static struct nf_ct_helper_expectfn sip_nat = {

 static void __exit nf_nat_sip_fini(void)
 {
-    RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
+    rcu_init_pointer(nf_nat_sip_hooks, NULL);

     nf_ct_helper_expectfn_unregister(&sip_nat);
     synchronize_rcu();
@@ -644,7 +644,7 @@ static const struct nf_nat_sip_hooks sip_hooks = {
 static int __init nf_nat_sip_init(void)
 {
     BUG_ON(nf_nat_sip_hooks != NULL);
-    RCU_INIT_POINTER(nf_nat_sip_hooks, &sip_hooks);
+    rcu_init_pointer(nf_nat_sip_hooks, &sip_hooks);
     nf_ct_helper_expectfn_register(&sip_nat);
     return 0;
 }
diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
index 7f67e1d..f828ef0 100644
--- a/net/netfilter/nf_nat_tftp.c
+++ b/net/netfilter/nf_nat_tftp.c
@@ -37,14 +37,14 @@ static unsigned int help(struct sk_buff *skb,

 static void __exit nf_nat_tftp_fini(void)
 {
-    RCU_INIT_POINTER(nf_nat_tftp_hook, NULL);
+    rcu_init_pointer(nf_nat_tftp_hook, NULL);
     synchronize_rcu();
 }

 static int __init nf_nat_tftp_init(void)
 {
     BUG_ON(nf_nat_tftp_hook != NULL);
-    RCU_INIT_POINTER(nf_nat_tftp_hook, help);
+    rcu_init_pointer(nf_nat_tftp_hook, help);
     return 0;
 }

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 5d24b1f..93fe802 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -40,7 +40,7 @@ EXPORT_SYMBOL(nf_register_queue_handler);
 /* The caller must flush their queue before this */
 void nf_unregister_queue_handler(void)
 {
-    RCU_INIT_POINTER(queue_handler, NULL);
+    rcu_init_pointer(queue_handler, NULL);
     synchronize_rcu();
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index e8138da..6477a02 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -440,7 +440,7 @@ static void __net_exit
nfnetlink_net_exit_batch(struct list_head *net_exit_list)
     struct net *net;

     list_for_each_entry(net, net_exit_list, exit_list)
-        RCU_INIT_POINTER(net->nfnl, NULL);
+        rcu_init_pointer(net->nfnl, NULL);
     synchronize_net();
     list_for_each_entry(net, net_exit_list, exit_list)
         netlink_kernel_release(net->nfnl_stash);
diff --git a/net/netfilter/nfnetlink_cttimeout.c
b/net/netfilter/nfnetlink_cttimeout.c
index 476accd..836836c 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -551,8 +551,8 @@ static int __init cttimeout_init(void)
         goto err_out;
     }
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-    RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, ctnl_timeout_find_get);
-    RCU_INIT_POINTER(nf_ct_timeout_put_hook, ctnl_timeout_put);
+    rcu_init_pointer(nf_ct_timeout_find_get_hook, ctnl_timeout_find_get);
+    rcu_init_pointer(nf_ct_timeout_put_hook, ctnl_timeout_put);
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
     return 0;

@@ -576,8 +576,8 @@ static void __exit cttimeout_exit(void)
         kfree_rcu(cur, rcu_head);
     }
 #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
-    RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, NULL);
-    RCU_INIT_POINTER(nf_ct_timeout_put_hook, NULL);
+    rcu_init_pointer(nf_ct_timeout_find_get_hook, NULL);
+    rcu_init_pointer(nf_ct_timeout_put_hook, NULL);
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 }

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 3b1ad87..539385b 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -119,7 +119,7 @@ static void nft_hash_chain_unzip(const struct nft_set *set,
     }

     /* Unlink first chain from the old table */
-    RCU_INIT_POINTER(tbl->buckets[n], last->next);
+    rcu_init_pointer(tbl->buckets[n], last->next);

     /* If end of chain reached, done */
     if (he == NULL)
@@ -135,7 +135,7 @@ static void nft_hash_chain_unzip(const struct nft_set *set,
     }

     /* Link the two chains */
-    RCU_INIT_POINTER(last->next, next);
+    rcu_init_pointer(last->next, next);
 }

 static int nft_hash_tbl_expand(const struct nft_set *set, struct
nft_hash *priv)
@@ -157,7 +157,7 @@ static int nft_hash_tbl_expand(const struct
nft_set *set, struct nft_hash *priv)
         nft_hash_for_each_entry(he, tbl->buckets[h]) {
             if (nft_hash_data(&he->key, ntbl->size, set->klen) != i)
                 continue;
-            RCU_INIT_POINTER(ntbl->buckets[i], he);
+            rcu_init_pointer(ntbl->buckets[i], he);
             break;
         }
     }
@@ -199,7 +199,7 @@ static int nft_hash_tbl_shrink(const struct
nft_set *set, struct nft_hash *priv)
         for (pprev = &ntbl->buckets[i]; *pprev != NULL;
              pprev = &nft_dereference(*pprev)->next)
             ;
-        RCU_INIT_POINTER(*pprev, tbl->buckets[i + ntbl->size]);
+        rcu_init_pointer(*pprev, tbl->buckets[i + ntbl->size]);
     }
     ntbl->elements = tbl->elements;

@@ -235,7 +235,7 @@ static int nft_hash_insert(const struct nft_set *set,
         nft_data_copy(he->data, &elem->data);

     h = nft_hash_data(&he->key, tbl->size, set->klen);
-    RCU_INIT_POINTER(he->next, tbl->buckets[h]);
+    rcu_init_pointer(he->next, tbl->buckets[h]);
     rcu_assign_pointer(tbl->buckets[h], he);
     tbl->elements++;

@@ -265,7 +265,7 @@ static void nft_hash_remove(const struct nft_set *set,
     pprev = elem->cookie;
     he = nft_dereference((*pprev));

-    RCU_INIT_POINTER(*pprev, he->next);
+    rcu_init_pointer(*pprev, he->next);
     synchronize_rcu();
     kfree(he);
     tbl->elements--;
@@ -348,7 +348,7 @@ static int nft_hash_init(const struct nft_set *set,
     tbl = nft_hash_tbl_alloc(NFT_HASH_MIN_SIZE);
     if (tbl == NULL)
         return -ENOMEM;
-    RCU_INIT_POINTER(priv->tbl, tbl);
+    rcu_init_pointer(priv->tbl, tbl);
     return 0;
 }

diff --git a/net/netlabel/netlabel_domainhash.c
b/net/netlabel/netlabel_domainhash.c
index f0cb92f..97632af 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -516,7 +516,7 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
         if (entry != rcu_dereference(netlbl_domhsh_def))
             list_del_rcu(&entry->list);
         else
-            RCU_INIT_POINTER(netlbl_domhsh_def, NULL);
+            rcu_init_pointer(netlbl_domhsh_def, NULL);
     } else
         ret_val = -ENOENT;
     spin_unlock(&netlbl_domhsh_lock);
diff --git a/net/netlabel/netlabel_unlabeled.c
b/net/netlabel/netlabel_unlabeled.c
index 78a63c1..b7ebdee 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -620,7 +620,7 @@ static void netlbl_unlhsh_condremove_iface(struct
netlbl_unlhsh_iface *iface)
     if (iface->ifindex > 0)
         list_del_rcu(&iface->list);
     else
-        RCU_INIT_POINTER(netlbl_unlhsh_def, NULL);
+        rcu_init_pointer(netlbl_unlhsh_def, NULL);
     spin_unlock(&netlbl_unlhsh_lock);

     call_rcu(&iface->rcu, netlbl_unlhsh_free_iface);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 894cda0..93f0bd6 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1297,7 +1297,7 @@ static int netlink_release(struct socket *sock)
             struct listeners *old;

             old = nl_deref_protected(nl_table[sk->sk_protocol].listeners);
-            RCU_INIT_POINTER(nl_table[sk->sk_protocol].listeners, NULL);
+            rcu_init_pointer(nl_table[sk->sk_protocol].listeners, NULL);
             kfree_rcu(old, rcu);
             nl_table[sk->sk_protocol].module = NULL;
             nl_table[sk->sk_protocol].bind = NULL;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b85c67c..4740dc6 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -301,7 +301,7 @@ static void packet_cached_dev_assign(struct packet_sock *po,

 static void packet_cached_dev_reset(struct packet_sock *po)
 {
-    RCU_INIT_POINTER(po->cached_dev, NULL);
+    rcu_init_pointer(po->cached_dev, NULL);
 }

 static bool packet_use_direct_xmit(const struct packet_sock *po)
diff --git a/net/phonet/af_phonet.c b/net/phonet/af_phonet.c
index 5a940db..694d5d8 100644
--- a/net/phonet/af_phonet.c
+++ b/net/phonet/af_phonet.c
@@ -491,7 +491,7 @@ void phonet_proto_unregister(unsigned int
protocol, struct phonet_protocol *pp)
 {
     mutex_lock(&proto_tab_lock);
     BUG_ON(proto_tab[protocol] != pp);
-    RCU_INIT_POINTER(proto_tab[protocol], NULL);
+    rcu_init_pointer(proto_tab[protocol], NULL);
     mutex_unlock(&proto_tab_lock);
     synchronize_rcu();
     proto_unregister(pp->prot);
diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index 56a6146..07d5619 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -276,7 +276,7 @@ static void phonet_route_autodel(struct net_device *dev)
     mutex_lock(&pnn->routes.lock);
     for (i = 0; i < 64; i++)
         if (dev == pnn->routes.table[i]) {
-            RCU_INIT_POINTER(pnn->routes.table[i], NULL);
+            rcu_init_pointer(pnn->routes.table[i], NULL);
             set_bit(i, deleted);
         }
     mutex_unlock(&pnn->routes.lock);
@@ -389,7 +389,7 @@ int phonet_route_del(struct net_device *dev, u8 daddr)
     daddr = daddr >> 2;
     mutex_lock(&routes->lock);
     if (dev == routes->table[daddr])
-        RCU_INIT_POINTER(routes->table[daddr], NULL);
+        rcu_init_pointer(routes->table[daddr], NULL);
     else
         dev = NULL;
     mutex_unlock(&routes->lock);
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 008214a..24e0db2 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -693,7 +693,7 @@ int pn_sock_unbind_res(struct sock *sk, u8 res)

     mutex_lock(&resource_mutex);
     if (pnres.sk[res] == sk) {
-        RCU_INIT_POINTER(pnres.sk[res], NULL);
+        rcu_init_pointer(pnres.sk[res], NULL);
         ret = 0;
     }
     mutex_unlock(&resource_mutex);
@@ -712,7 +712,7 @@ void pn_sock_unbind_all_res(struct sock *sk)
     mutex_lock(&resource_mutex);
     for (res = 0; res < 256; res++) {
         if (pnres.sk[res] == sk) {
-            RCU_INIT_POINTER(pnres.sk[res], NULL);
+            rcu_init_pointer(pnres.sk[res], NULL);
             match++;
         }
     }
diff --git a/net/socket.c b/net/socket.c
index abf56b2..9350395 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -260,7 +260,7 @@ static struct inode *sock_alloc_inode(struct
super_block *sb)
     }
     init_waitqueue_head(&wq->wait);
     wq->fasync_list = NULL;
-    RCU_INIT_POINTER(ei->socket.wq, wq);
+    rcu_init_pointer(ei->socket.wq, wq);

     ei->socket.state = SS_UNCONNECTED;
     ei->socket.flags = 0;
@@ -2638,7 +2638,7 @@ void sock_unregister(int family)
     BUG_ON(family < 0 || family >= NPROTO);

     spin_lock(&net_family_lock);
-    RCU_INIT_POINTER(net_families[family], NULL);
+    rcu_init_pointer(net_families[family], NULL);
     spin_unlock(&net_family_lock);

     synchronize_rcu();
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 36e431e..1810c54 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -1262,7 +1262,7 @@ gss_destroy_nullcred(struct rpc_cred *cred)
     struct gss_auth *gss_auth = container_of(cred->cr_auth, struct
gss_auth, rpc_auth);
     struct gss_cl_ctx *ctx = gss_cred->gc_ctx;

-    RCU_INIT_POINTER(gss_cred->gc_ctx, NULL);
+    rcu_init_pointer(gss_cred->gc_ctx, NULL);
     call_rcu(&cred->cr_rcu, gss_free_cred_callback);
     if (ctx)
         gss_put_ctx(ctx);
diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 3fef7eb..3a56cd6 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -464,7 +464,7 @@ int tipc_enable_l2_media(struct tipc_bearer *b)
 void tipc_disable_l2_media(struct tipc_bearer *b)
 {
     struct net_device *dev = (struct net_device *)b->media_ptr;
-    RCU_INIT_POINTER(dev->tipc_ptr, NULL);
+    rcu_init_pointer(dev->tipc_ptr, NULL);
     dev_put(dev);
 }

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index bb7e8ba..ae855b9 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1187,7 +1187,7 @@ restart:
     newsk->sk_type        = sk->sk_type;
     init_peercred(newsk);
     newu = unix_sk(newsk);
-    RCU_INIT_POINTER(newsk->sk_wq, &newu->peer_wq);
+    rcu_init_pointer(newsk->sk_wq, &newu->peer_wq);
     otheru = unix_sk(other);

     /* copy address information from listening to new sock*/
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 85d1d47..deb776d 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -50,7 +50,7 @@ int xfrm_input_unregister_afinfo(struct
xfrm_input_afinfo *afinfo)
         if (unlikely(xfrm_input_afinfo[afinfo->family] != afinfo))
             err = -EINVAL;
         else
-            RCU_INIT_POINTER(xfrm_input_afinfo[afinfo->family], NULL);
+            rcu_init_pointer(xfrm_input_afinfo[afinfo->family], NULL);
     }
     spin_unlock_bh(&xfrm_input_afinfo_lock);
     synchronize_rcu();
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index c08fbd1..326d6ed 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2729,7 +2729,7 @@ int xfrm_policy_unregister_afinfo(struct
xfrm_policy_afinfo *afinfo)
         if (unlikely(xfrm_policy_afinfo[afinfo->family] != afinfo))
             err = -EINVAL;
         else
-            RCU_INIT_POINTER(xfrm_policy_afinfo[afinfo->family],
+            rcu_init_pointer(xfrm_policy_afinfo[afinfo->family],
                      NULL);
     }
     spin_unlock(&xfrm_policy_afinfo_lock);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 8e9c781..cf7e89c 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1942,7 +1942,7 @@ int xfrm_state_unregister_afinfo(struct
xfrm_state_afinfo *afinfo)
         if (unlikely(xfrm_state_afinfo[afinfo->family] != afinfo))
             err = -EINVAL;
         else
-            RCU_INIT_POINTER(xfrm_state_afinfo[afinfo->family], NULL);
+            rcu_init_pointer(xfrm_state_afinfo[afinfo->family], NULL);
     }
     spin_unlock_bh(&xfrm_state_afinfo_lock);
     synchronize_rcu();
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 8f131c1..cdf2a66 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3040,7 +3040,7 @@ static void __net_exit xfrm_user_net_exit(struct
list_head *net_exit_list)
 {
     struct net *net;
     list_for_each_entry(net, net_exit_list, exit_list)
-        RCU_INIT_POINTER(net->xfrm.nlsk, NULL);
+        rcu_init_pointer(net->xfrm.nlsk, NULL);
     synchronize_net();
     list_for_each_entry(net, net_exit_list, exit_list)
         netlink_kernel_release(net->xfrm.nlsk_stash);
-- 
1.7.9.5

--001a11394fb4c48fca04f826e3de
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-rename-RCU_INIT_POINTER-to-rcu_init_pointer.patch"
Content-Disposition: attachment; 
	filename="0001-rename-RCU_INIT_POINTER-to-rcu_init_pointer.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hukp33d60

U2lnbmVkLW9mZi1ieTogUm9tYW5vdiBBcnlhIDxyb21hbm92LmFyeWFAZ21haWwuY29tPgotLS0K
IGFyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvY2VsbC9zcHVfc3lzY2FsbHMuYyAgICAgICAgIHwgICAg
MiArLQogZHJpdmVycy9jcnlwdG8vbngvbngtODQyLmMgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgICA0ICstCiBkcml2ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl9xcC5jICAgICAgICAgICAg
ICAgICB8ICAgIDIgKy0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9xaWIvcWliX3ZlcmJzLmMgICAg
ICAgICAgICAgIHwgICAxMCArKy0tCiBkcml2ZXJzL2lwYWNrL2NhcnJpZXJzL3RwY2kyMDAuYyAg
ICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIGRyaXZlcnMvbWQvZG0uYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgICAgMiArLQogZHJpdmVycy9uZXQvYm9uZGluZy9ib25k
X21haW4uYyAgICAgICAgICAgICAgICAgICAgfCAgICAyICstCiBkcml2ZXJzL25ldC9ib25kaW5n
L2JvbmRfb3B0aW9ucy5jICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIGRyaXZlcnMvbmV0L2V0
aGVybmV0L2Jyb2FkY29tL2JueDIuYyAgICAgICAgICAgICAgIHwgICAgMiArLQogZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54MngvYm54MnhfbWFpbi5jICAgfCAgICAyICstCiBkcml2
ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9jbmljLmMgICAgICAgICAgICAgICB8ICAgIDYgKy0t
CiBkcml2ZXJzL25ldC9ldGhlcm5ldC9jaGVsc2lvL2N4Z2IzL2N4Z2IzX29mZmxvYWQuYyB8ICAg
IDQgKy0KIGRyaXZlcnMvbmV0L21hY3Z0YXAuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwgICAxMCArKy0tCiBkcml2ZXJzL25ldC9wcHAvcHB0cC5jICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8ICAgIDIgKy0KIGRyaXZlcnMvbmV0L3RlYW0vdGVhbV9tb2RlX2FjdGl2ZWJhY2t1
cC5jICAgICAgICAgIHwgICAgMiArLQogZHJpdmVycy9uZXQvdGVhbS90ZWFtX21vZGVfbG9hZGJh
bGFuY2UuYyAgICAgICAgICAgfCAgICAyICstCiBkcml2ZXJzL25ldC90dW4uYyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDggKystLQogZHJpdmVycy9uZXQvdmV0aC5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICA0ICstCiBkcml2ZXJzL25ldC93aXJl
bGVzcy9hdGgvY2FybDkxNzAvbWFpbi5jICAgICAgICAgICB8ICAgMTIgKystLS0KIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL2l3bHdpZmkvbXZtL2Z3LmMgICAgICAgICAgICAgIHwgICAgNCArLQogZHJp
dmVycy92aG9zdC92aG9zdC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICA0ICst
CiBmcy9ldmVudHBvbGwuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAg
IDQgKy0KIGZzL3Byb2MvaW5vZGUuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHwgICAgMiArLQogaW5jbHVkZS9saW51eC9yY3VwZGF0ZS5oICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgIDIwICsrKystLS0tCiBrZXJuZWwvYXVkaXQuYyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIGtlcm5lbC9jZ3JvdXAuYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgICAxNCArKystLS0KIGtlcm5lbC90cmFjZS90cmFjZV9l
dmVudHNfZmlsdGVyLmMgICAgICAgICAgICAgICAgIHwgICAgNCArLQoga2VybmVsL3RyYWNlL3Ry
YWNlX2V2ZW50c190cmlnZ2VyLmMgICAgICAgICAgICAgICAgfCAgICAyICstCiBrZXJuZWwvd29y
a3F1ZXVlLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIGxpYi9p
ZHIuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgNiArLS0K
IG5ldC84MDIvZ2FycC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAg
NCArLQogbmV0LzgwMi9tcnAuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgICA0ICstCiBuZXQvODAyL3N0cC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAgIDQgKy0KIG5ldC84MDIxcS92bGFuX2NvcmUuYyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICAgMiArLQogbmV0L2JyaWRnZS9icl92bGFuLmMgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgICA4ICsrLS0KIG5ldC9icmlkZ2UvbmV0ZmlsdGVyL2VidGFibGVf
YnJvdXRlLmMgICAgICAgICAgICAgIHwgICAgNCArLQogbmV0L2NhaWYvY2ZtdXhsLmMgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICA0ICstCiBuZXQvY2FuL2FmX2Nhbi5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDQgKy0KIG5ldC9jb3JlL2Rldi5j
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAxNCArKystLS0KIG5ldC9j
b3JlL2ZpYl9ydWxlcy5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgNCArLQog
bmV0L2NvcmUvZmlsdGVyLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAy
ICstCiBuZXQvY29yZS9uZWlnaGJvdXIuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAgIDIgKy0KIG5ldC9jb3JlL25ldC1zeXNmcy5jICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgICAgNCArLQogbmV0L2NvcmUvbmV0cG9sbC5jICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgICAyICstCiBuZXQvY29yZS9uZXRwcmlvX2Nncm91cC5jICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgIDIgKy0KIG5ldC9jb3JlL3NvY2suYyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgICAgNCArLQogbmV0L2NvcmUvc3lzY3RsX25ldF9jb3JlLmMg
ICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAyICstCiBuZXQvZGVjbmV0L2RuX2Rldi5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIG5ldC9kZWNuZXQvZG5fcm91
dGUuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMiArLQogbmV0L2lwdjQvZGV2
aW5ldC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICA0ICstCiBuZXQvaXB2
NC9maWJfc2VtYW50aWNzLmMgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIG5l
dC9pcHY0L2ZpYl90cmllLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMiAr
LQogbmV0L2lwdjQvaWdtcC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAg
ICA0ICstCiBuZXQvaXB2NC9pbmV0cGVlci5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICB8ICAgNTAgKysrKysrKysrKy0tLS0tLS0tLS0KIG5ldC9pcHY0L2lwbXIuYyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMiArLQogbmV0L2lwdjQvbmV0ZmlsdGVyL25m
X25hdF9oMzIzLmMgICAgICAgICAgICAgICAgICAgfCAgIDM2ICsrKysrKystLS0tLS0tCiBuZXQv
aXB2NC9uZXRmaWx0ZXIvbmZfbmF0X3BwdHAuYyAgICAgICAgICAgICAgICAgICB8ICAgMTYgKysr
LS0tLQogbmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9zbm1wX2Jhc2ljLmMgICAgICAgICAgICAg
fCAgICA0ICstCiBuZXQvaXB2NC9yb3V0ZS5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAgIDQgKy0KIG5ldC9pcHY2L2FkZHJjb25mLmMgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICAgMiArLQogbmV0L2lwdjYvaXA2X3R1bm5lbC5jICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgICAyICstCiBuZXQvaXB2Ni9pcDZfdnRpLmMgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIG5ldC9pcHY2L25ldGZpbHRlci5jICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgNCArLQogbmV0L2lwdjYvcmF3LmMgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAyICstCiBuZXQvaXB2Ni9zaXQuYyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIG5ldC9tYWM4MDIx
MS9hZ2ctcnguYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMiArLQogbmV0L21h
YzgwMjExL2NmZy5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICA4ICsrLS0K
IG5ldC9tYWM4MDIxMS9pYnNzLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAg
NCArLQogbmV0L21hYzgwMjExL21lc2guYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgICAyICstCiBuZXQvbWFjODAyMTEvbWVzaF9wYXRodGJsLmMgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAgIDQgKy0KIG5ldC9tYWM4MDIxMS9zdGFfaW5mby5jICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICAgMiArLQogbmV0L25ldGZpbHRlci9jb3JlLmMgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgICA0ICstCiBuZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNfY3RsLmMg
ICAgICAgICAgICAgICAgICAgICB8ICAgIDQgKy0KIG5ldC9uZXRmaWx0ZXIvaXB2cy9pcF92c19k
aC5jICAgICAgICAgICAgICAgICAgICAgIHwgICAgNiArLS0KIG5ldC9uZXRmaWx0ZXIvaXB2cy9p
cF92c19zaC5jICAgICAgICAgICAgICAgICAgICAgIHwgICAgNiArLS0KIG5ldC9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX2NvcmUuYyAgICAgICAgICAgICAgICAgIHwgICAgOCArKy0tCiBuZXQvbmV0
ZmlsdGVyL25mX2Nvbm50cmFja19lY2FjaGUuYyAgICAgICAgICAgICAgICB8ICAgIDQgKy0KIG5l
dC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2V4dGVuZC5jICAgICAgICAgICAgICAgIHwgICAgMiAr
LQogbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaGVscGVyLmMgICAgICAgICAgICAgICAgfCAg
ICA2ICstLQogbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfbmV0bGluay5jICAgICAgICAgICAg
ICAgfCAgICA4ICsrLS0KIG5ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvLmMgICAgICAg
ICAgICAgICAgIHwgICAgMiArLQogbmV0L25ldGZpbHRlci9uZl9sb2cuYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgICA0ICstCiBuZXQvbmV0ZmlsdGVyL25mX25hdF9hbWFuZGEuYyAg
ICAgICAgICAgICAgICAgICAgICB8ICAgIDQgKy0KIG5ldC9uZXRmaWx0ZXIvbmZfbmF0X2NvcmUu
YyAgICAgICAgICAgICAgICAgICAgICAgIHwgICAyMiArKysrLS0tLS0KIG5ldC9uZXRmaWx0ZXIv
bmZfbmF0X2Z0cC5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgNCArLQogbmV0L25ldGZp
bHRlci9uZl9uYXRfaXJjLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICA0ICstCiBuZXQv
bmV0ZmlsdGVyL25mX25hdF9zaXAuYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDQgKy0K
IG5ldC9uZXRmaWx0ZXIvbmZfbmF0X3RmdHAuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgICAg
NCArLQogbmV0L25ldGZpbHRlci9uZl9xdWV1ZS5jICAgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgICAyICstCiBuZXQvbmV0ZmlsdGVyL25mbmV0bGluay5jICAgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAgIDIgKy0KIG5ldC9uZXRmaWx0ZXIvbmZuZXRsaW5rX2N0dGltZW91dC5jICAgICAg
ICAgICAgICAgIHwgICAgOCArKy0tCiBuZXQvbmV0ZmlsdGVyL25mdF9oYXNoLmMgICAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgMTQgKysrLS0tCiBuZXQvbmV0bGFiZWwvbmV0bGFiZWxfZG9t
YWluaGFzaC5jICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIG5ldC9uZXRsYWJlbC9uZXRsYWJl
bF91bmxhYmVsZWQuYyAgICAgICAgICAgICAgICAgIHwgICAgMiArLQogbmV0L25ldGxpbmsvYWZf
bmV0bGluay5jICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAyICstCiBuZXQvcGFja2V0
L2FmX3BhY2tldC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIG5ldC9w
aG9uZXQvYWZfcGhvbmV0LmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMiArLQog
bmV0L3Bob25ldC9wbl9kZXYuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICA0
ICstCiBuZXQvcGhvbmV0L3NvY2tldC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAgIDQgKy0KIG5ldC9zb2NrZXQuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgICAgNCArLQogbmV0L3N1bnJwYy9hdXRoX2dzcy9hdXRoX2dzcy5jICAgICAgICAgICAg
ICAgICAgICAgfCAgICAyICstCiBuZXQvdGlwYy9iZWFyZXIuYyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgIDIgKy0KIG5ldC91bml4L2FmX3VuaXguYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgICAgMiArLQogbmV0L3hmcm0veGZybV9pbnB1dC5jICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAyICstCiBuZXQveGZybS94ZnJtX3BvbGljeS5j
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDIgKy0KIG5ldC94ZnJtL3hmcm1fc3Rh
dGUuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMiArLQogbmV0L3hmcm0veGZy
bV91c2VyLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAyICstCiAxMDcgZmls
ZXMgY2hhbmdlZCwgMjY4IGluc2VydGlvbnMoKyksIDI2OCBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9hcmNoL3Bvd2VycGMvcGxhdGZvcm1zL2NlbGwvc3B1X3N5c2NhbGxzLmMgYi9hcmNoL3Bv
d2VycGMvcGxhdGZvcm1zL2NlbGwvc3B1X3N5c2NhbGxzLmMKaW5kZXggMzhlMGExYS4uMmZlZWY3
YyAxMDA2NDQKLS0tIGEvYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9jZWxsL3NwdV9zeXNjYWxscy5j
CisrKyBiL2FyY2gvcG93ZXJwYy9wbGF0Zm9ybXMvY2VsbC9zcHVfc3lzY2FsbHMuYwpAQCAtMTcw
LDcgKzE3MCw3IEBAIEVYUE9SVF9TWU1CT0xfR1BMKHJlZ2lzdGVyX3NwdV9zeXNjYWxscyk7CiB2
b2lkIHVucmVnaXN0ZXJfc3B1X3N5c2NhbGxzKHN0cnVjdCBzcHVmc19jYWxscyAqY2FsbHMpCiB7
CiAJQlVHX09OKHNwdWZzX2NhbGxzLT5vd25lciAhPSBjYWxscy0+b3duZXIpOwotCVJDVV9JTklU
X1BPSU5URVIoc3B1ZnNfY2FsbHMsIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIoc3B1ZnNfY2Fs
bHMsIE5VTEwpOwogCXN5bmNocm9uaXplX3JjdSgpOwogfQogRVhQT1JUX1NZTUJPTF9HUEwodW5y
ZWdpc3Rlcl9zcHVfc3lzY2FsbHMpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcnlwdG8vbngvbngt
ODQyLmMgYi9kcml2ZXJzL2NyeXB0by9ueC9ueC04NDIuYwppbmRleCAxZTU0ODFkLi5lNzJkM2Q3
IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NyeXB0by9ueC9ueC04NDIuYworKysgYi9kcml2ZXJzL2Ny
eXB0by9ueC9ueC04NDIuYwpAQCAtMTI2MiwxNCArMTI2MiwxNCBAQCBzdGF0aWMgaW50IF9faW5p
dCBueDg0Ml9pbml0KHZvaWQpCiAJc3RydWN0IG54ODQyX2RldmRhdGEgKm5ld19kZXZkYXRhOwog
CXByX2luZm8oIlJlZ2lzdGVyaW5nIElCTSBQb3dlciA4NDIgY29tcHJlc3Npb24gZHJpdmVyXG4i
KTsKIAotCVJDVV9JTklUX1BPSU5URVIoZGV2ZGF0YSwgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRl
cihkZXZkYXRhLCBOVUxMKTsKIAluZXdfZGV2ZGF0YSA9IGt6YWxsb2Moc2l6ZW9mKCpuZXdfZGV2
ZGF0YSksIEdGUF9LRVJORUwpOwogCWlmICghbmV3X2RldmRhdGEpIHsKIAkJcHJfZXJyKCJDb3Vs
ZCBub3QgYWxsb2NhdGUgbWVtb3J5IGZvciBkZXZpY2UgZGF0YVxuIik7CiAJCXJldHVybiAtRU5P
TUVNOwogCX0KIAluZXdfZGV2ZGF0YS0+c3RhdHVzID0gVU5BVkFJTEFCTEU7Ci0JUkNVX0lOSVRf
UE9JTlRFUihkZXZkYXRhLCBuZXdfZGV2ZGF0YSk7CisJcmN1X2luaXRfcG9pbnRlcihkZXZkYXRh
LCBuZXdfZGV2ZGF0YSk7CiAKIAlyZXR1cm4gdmlvX3JlZ2lzdGVyX2RyaXZlcigmbng4NDJfZHJp
dmVyKTsKIH0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9xaWIvcWliX3FwLmMg
Yi9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl9xcC5jCmluZGV4IDBjYWQwYzQuLmU5Njdh
YTUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9xaWIvcWliX3FwLmMKKysrIGIv
ZHJpdmVycy9pbmZpbmliYW5kL2h3L3FpYi9xaWJfcXAuYwpAQCAtMTA0MSw3ICsxMDQxLDcgQEAg
c3RydWN0IGliX3FwICpxaWJfY3JlYXRlX3FwKHN0cnVjdCBpYl9wZCAqaWJwZCwKIAkJCXJldCA9
IEVSUl9QVFIoLUVOT01FTSk7CiAJCQlnb3RvIGJhaWxfc3dxOwogCQl9Ci0JCVJDVV9JTklUX1BP
SU5URVIocXAtPm5leHQsIE5VTEwpOworCQlyY3VfaW5pdF9wb2ludGVyKHFwLT5uZXh0LCBOVUxM
KTsKIAkJcXAtPnNfaGRyID0ga3phbGxvYyhzaXplb2YoKnFwLT5zX2hkciksIEdGUF9LRVJORUwp
OwogCQlpZiAoIXFwLT5zX2hkcikgewogCQkJcmV0ID0gRVJSX1BUUigtRU5PTUVNKTsKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9xaWIvcWliX3ZlcmJzLmMgYi9kcml2ZXJzL2lu
ZmluaWJhbmQvaHcvcWliL3FpYl92ZXJicy5jCmluZGV4IDliY2ZiZDguLjhlZDA4YWE5IDEwMDY0
NAotLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvcWliL3FpYl92ZXJicy5jCisrKyBiL2RyaXZl
cnMvaW5maW5pYmFuZC9ody9xaWIvcWliX3ZlcmJzLmMKQEAgLTIwMzUsOCArMjAzNSw4IEBAIHN0
YXRpYyB2b2lkIGluaXRfaWJwb3J0KHN0cnVjdCBxaWJfcHBvcnRkYXRhICpwcGQpCiAJaWJwLT56
X2V4Y2Vzc2l2ZV9idWZmZXJfb3ZlcnJ1bl9lcnJvcnMgPQogCQljbnRycy5leGNlc3NpdmVfYnVm
ZmVyX292ZXJydW5fZXJyb3JzOwogCWlicC0+el92bDE1X2Ryb3BwZWQgPSBjbnRycy52bDE1X2Ry
b3BwZWQ7Ci0JUkNVX0lOSVRfUE9JTlRFUihpYnAtPnFwMCwgTlVMTCk7Ci0JUkNVX0lOSVRfUE9J
TlRFUihpYnAtPnFwMSwgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihpYnAtPnFwMCwgTlVMTCk7
CisJcmN1X2luaXRfcG9pbnRlcihpYnAtPnFwMSwgTlVMTCk7CiB9CiAKIC8qKgpAQCAtMjA2MSw3
ICsyMDYxLDcgQEAgaW50IHFpYl9yZWdpc3Rlcl9pYl9kZXZpY2Uoc3RydWN0IHFpYl9kZXZkYXRh
ICpkZCkKIAkJZ290byBlcnJfcXB0OwogCX0KIAlmb3IgKGkgPSAwOyBpIDwgZGV2LT5xcF90YWJs
ZV9zaXplOyBpKyspCi0JCVJDVV9JTklUX1BPSU5URVIoZGV2LT5xcF90YWJsZVtpXSwgTlVMTCk7
CisJCXJjdV9pbml0X3BvaW50ZXIoZGV2LT5xcF90YWJsZVtpXSwgTlVMTCk7CiAKIAlmb3IgKGkg
PSAwOyBpIDwgZGQtPm51bV9wcG9ydHM7IGkrKykKIAkJaW5pdF9pYnBvcnQocHBkICsgaSk7CkBA
IC0yMDk0LDkgKzIwOTQsOSBAQCBpbnQgcWliX3JlZ2lzdGVyX2liX2RldmljZShzdHJ1Y3QgcWli
X2RldmRhdGEgKmRkKQogCQlyZXQgPSAtRU5PTUVNOwogCQlnb3RvIGVycl9sazsKIAl9Ci0JUkNV
X0lOSVRfUE9JTlRFUihkZXYtPmRtYV9tciwgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihkZXYt
PmRtYV9tciwgTlVMTCk7CiAJZm9yIChpID0gMDsgaSA8IGRldi0+bGtfdGFibGUubWF4OyBpKysp
Ci0JCVJDVV9JTklUX1BPSU5URVIoZGV2LT5sa190YWJsZS50YWJsZVtpXSwgTlVMTCk7CisJCXJj
dV9pbml0X3BvaW50ZXIoZGV2LT5sa190YWJsZS50YWJsZVtpXSwgTlVMTCk7CiAJSU5JVF9MSVNU
X0hFQUQoJmRldi0+cGVuZGluZ19tbWFwcyk7CiAJc3Bpbl9sb2NrX2luaXQoJmRldi0+cGVuZGlu
Z19sb2NrKTsKIAlkZXYtPm1tYXBfb2Zmc2V0ID0gUEFHRV9TSVpFOwpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9pcGFjay9jYXJyaWVycy90cGNpMjAwLmMgYi9kcml2ZXJzL2lwYWNrL2NhcnJpZXJzL3Rw
Y2kyMDAuYwppbmRleCBjMjc2ZmRlLi44NmFlNTgyIDEwMDY0NAotLS0gYS9kcml2ZXJzL2lwYWNr
L2NhcnJpZXJzL3RwY2kyMDAuYworKysgYi9kcml2ZXJzL2lwYWNrL2NhcnJpZXJzL3RwY2kyMDAu
YwpAQCAtMTg3LDcgKzE4Nyw3IEBAIHN0YXRpYyBpbnQgdHBjaTIwMF9mcmVlX2lycShzdHJ1Y3Qg
aXBhY2tfZGV2aWNlICpkZXYpCiAJdHBjaTIwMF9kaXNhYmxlX2lycSh0cGNpMjAwLCBkZXYtPnNs
b3QpOwogCXNsb3RfaXJxID0gdHBjaTIwMC0+c2xvdHNbZGV2LT5zbG90XS5pcnE7CiAJLyogdW5p
bnN0YWxsIGhhbmRsZXIgKi8KLQlSQ1VfSU5JVF9QT0lOVEVSKHRwY2kyMDAtPnNsb3RzW2Rldi0+
c2xvdF0uaXJxLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKHRwY2kyMDAtPnNsb3RzW2Rldi0+
c2xvdF0uaXJxLCBOVUxMKTsKIAlzeW5jaHJvbml6ZV9yY3UoKTsKIAlrZnJlZShzbG90X2lycSk7
CiAJbXV0ZXhfdW5sb2NrKCZ0cGNpMjAwLT5tdXRleCk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL21k
L2RtLmMgYi9kcml2ZXJzL21kL2RtLmMKaW5kZXggNDU1ZTY0OS4uMTllNmU5YSAxMDA2NDQKLS0t
IGEvZHJpdmVycy9tZC9kbS5jCisrKyBiL2RyaXZlcnMvbWQvZG0uYwpAQCAtMjE2OCw3ICsyMTY4
LDcgQEAgc3RhdGljIHN0cnVjdCBkbV90YWJsZSAqX191bmJpbmQoc3RydWN0IG1hcHBlZF9kZXZp
Y2UgKm1kKQogCQlyZXR1cm4gTlVMTDsKIAogCWRtX3RhYmxlX2V2ZW50X2NhbGxiYWNrKG1hcCwg
TlVMTCwgTlVMTCk7Ci0JUkNVX0lOSVRfUE9JTlRFUihtZC0+bWFwLCBOVUxMKTsKKwlyY3VfaW5p
dF9wb2ludGVyKG1kLT5tYXAsIE5VTEwpOwogCWRtX3N5bmNfdGFibGUobWQpOwogCiAJcmV0dXJu
IG1hcDsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMgYi9kcml2
ZXJzL25ldC9ib25kaW5nL2JvbmRfbWFpbi5jCmluZGV4IDY5YWZmNzIuLmQ3NWM3ZWYgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMKKysrIGIvZHJpdmVycy9uZXQv
Ym9uZGluZy9ib25kX21haW4uYwpAQCAtMTcwNCw3ICsxNzA0LDcgQEAgc3RhdGljIGludCBfX2Jv
bmRfcmVsZWFzZV9vbmUoc3RydWN0IG5ldF9kZXZpY2UgKmJvbmRfZGV2LAogCX0KIAogCWlmIChh
bGwpIHsKLQkJUkNVX0lOSVRfUE9JTlRFUihib25kLT5jdXJyX2FjdGl2ZV9zbGF2ZSwgTlVMTCk7
CisJCXJjdV9pbml0X3BvaW50ZXIoYm9uZC0+Y3Vycl9hY3RpdmVfc2xhdmUsIE5VTEwpOwogCX0g
ZWxzZSBpZiAob2xkY3VycmVudCA9PSBzbGF2ZSkgewogCQkvKgogCQkgKiBOb3RlIHRoYXQgd2Ug
aG9sZCBSVE5MIG92ZXIgdGhpcyBzZXF1ZW5jZSwgc28gdGhlcmUKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2JvbmRpbmcvYm9uZF9vcHRpb25zLmMgYi9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRf
b3B0aW9ucy5jCmluZGV4IDcyNGUzMGYuLjA2OWM3YzMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0
L2JvbmRpbmcvYm9uZF9vcHRpb25zLmMKKysrIGIvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX29w
dGlvbnMuYwpAQCAtNzEyLDcgKzcxMiw3IEBAIHN0YXRpYyBpbnQgYm9uZF9vcHRpb25fYWN0aXZl
X3NsYXZlX3NldChzdHJ1Y3QgYm9uZGluZyAqYm9uZCwKIAkvKiBjaGVjayB0byBzZWUgaWYgd2Ug
YXJlIGNsZWFyaW5nIGFjdGl2ZSAqLwogCWlmICghc2xhdmVfZGV2KSB7CiAJCXByX2luZm8oIiVz
OiBDbGVhcmluZyBjdXJyZW50IGFjdGl2ZSBzbGF2ZVxuIiwgYm9uZC0+ZGV2LT5uYW1lKTsKLQkJ
UkNVX0lOSVRfUE9JTlRFUihib25kLT5jdXJyX2FjdGl2ZV9zbGF2ZSwgTlVMTCk7CisJCXJjdV9p
bml0X3BvaW50ZXIoYm9uZC0+Y3Vycl9hY3RpdmVfc2xhdmUsIE5VTEwpOwogCQlib25kX3NlbGVj
dF9hY3RpdmVfc2xhdmUoYm9uZCk7CiAJfSBlbHNlIHsKIAkJc3RydWN0IHNsYXZlICpvbGRfYWN0
aXZlID0gYm9uZC0+Y3Vycl9hY3RpdmVfc2xhdmU7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9icm9hZGNvbS9ibngyLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9i
bngyLmMKaW5kZXggMGFiODM3MC4uN2ZhY2JjNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvYnJvYWRjb20vYm54Mi5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29t
L2JueDIuYwpAQCAtNDA5LDcgKzQwOSw3IEBAIHN0YXRpYyBpbnQgYm54Ml91bnJlZ2lzdGVyX2Nu
aWMoc3RydWN0IG5ldF9kZXZpY2UgKmRldikKIAltdXRleF9sb2NrKCZicC0+Y25pY19sb2NrKTsK
IAljcC0+ZHJ2X3N0YXRlID0gMDsKIAlibmFwaS0+Y25pY19wcmVzZW50ID0gMDsKLQlSQ1VfSU5J
VF9QT0lOVEVSKGJwLT5jbmljX29wcywgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihicC0+Y25p
Y19vcHMsIE5VTEwpOwogCW11dGV4X3VubG9jaygmYnAtPmNuaWNfbG9jayk7CiAJc3luY2hyb25p
emVfcmN1KCk7CiAJcmV0dXJuIDA7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9i
cm9hZGNvbS9ibngyeC9ibngyeF9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNv
bS9ibngyeC9ibngyeF9tYWluLmMKaW5kZXggYTc4ZWRhYy4uODNhMjI4ZSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54MngvYm54MnhfbWFpbi5jCisrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2Jyb2FkY29tL2JueDJ4L2JueDJ4X21haW4uYwpAQCAtMTQwNDgs
NyArMTQwNDgsNyBAQCBzdGF0aWMgaW50IGJueDJ4X3VucmVnaXN0ZXJfY25pYyhzdHJ1Y3QgbmV0
X2RldmljZSAqZGV2KQogCiAJbXV0ZXhfbG9jaygmYnAtPmNuaWNfbXV0ZXgpOwogCWNwLT5kcnZf
c3RhdGUgPSAwOwotCVJDVV9JTklUX1BPSU5URVIoYnAtPmNuaWNfb3BzLCBOVUxMKTsKKwlyY3Vf
aW5pdF9wb2ludGVyKGJwLT5jbmljX29wcywgTlVMTCk7CiAJbXV0ZXhfdW5sb2NrKCZicC0+Y25p
Y19tdXRleCk7CiAJc3luY2hyb25pemVfcmN1KCk7CiAJYnAtPmNuaWNfZW5hYmxlZCA9IGZhbHNl
OwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vY25pYy5jIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vY25pYy5jCmluZGV4IDA5ZjNmZWYuLjQyZDVmZjNh
IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9jbmljLmMKKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vY25pYy5jCkBAIC01MzQsNyArNTM0LDcgQEAg
aW50IGNuaWNfdW5yZWdpc3Rlcl9kcml2ZXIoaW50IHVscF90eXBlKQogCX0KIAlyZWFkX3VubG9j
aygmY25pY19kZXZfbG9jayk7CiAKLQlSQ1VfSU5JVF9QT0lOVEVSKGNuaWNfdWxwX3RibFt1bHBf
dHlwZV0sIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIoY25pY191bHBfdGJsW3VscF90eXBlXSwg
TlVMTCk7CiAKIAltdXRleF91bmxvY2soJmNuaWNfbG9jayk7CiAJc3luY2hyb25pemVfcmN1KCk7
CkBAIC02MTAsNyArNjEwLDcgQEAgc3RhdGljIGludCBjbmljX3VucmVnaXN0ZXJfZGV2aWNlKHN0
cnVjdCBjbmljX2RldiAqZGV2LCBpbnQgdWxwX3R5cGUpCiAJfQogCW11dGV4X2xvY2soJmNuaWNf
bG9jayk7CiAJaWYgKHJjdV9kZXJlZmVyZW5jZShjcC0+dWxwX29wc1t1bHBfdHlwZV0pKSB7Ci0J
CVJDVV9JTklUX1BPSU5URVIoY3AtPnVscF9vcHNbdWxwX3R5cGVdLCBOVUxMKTsKKwkJcmN1X2lu
aXRfcG9pbnRlcihjcC0+dWxwX29wc1t1bHBfdHlwZV0sIE5VTEwpOwogCQljbmljX3B1dChkZXYp
OwogCX0gZWxzZSB7CiAJCXByX2VycigiJXM6IGRldmljZSBub3QgcmVnaXN0ZXJlZCB0byB0aGlz
IHVscCB0eXBlICVkXG4iLApAQCAtNTQxNCw3ICs1NDE0LDcgQEAgc3RhdGljIHZvaWQgY25pY19z
dG9wX2h3KHN0cnVjdCBjbmljX2RldiAqZGV2KQogCQljcC0+c3RvcF9jbShkZXYpOwogCQljcC0+
ZXRoZGV2LT5kcnZfc3RhdGUgJj0gfkNOSUNfRFJWX1NUQVRFX0hBTkRMRVNfSVJROwogCQljbGVh
cl9iaXQoQ05JQ19GX0NOSUNfVVAsICZkZXYtPmZsYWdzKTsKLQkJUkNVX0lOSVRfUE9JTlRFUihj
cC0+dWxwX29wc1tDTklDX1VMUF9MNF0sIE5VTEwpOworCQlyY3VfaW5pdF9wb2ludGVyKGNwLT51
bHBfb3BzW0NOSUNfVUxQX0w0XSwgTlVMTCk7CiAJCXN5bmNocm9uaXplX3JjdSgpOwogCQljbmlj
X2NtX3NodXRkb3duKGRldik7CiAJCWNwLT5zdG9wX2h3KGRldik7CmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9jaGVsc2lvL2N4Z2IzL2N4Z2IzX29mZmxvYWQuYyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NoZWxzaW8vY3hnYjMvY3hnYjNfb2ZmbG9hZC5jCmluZGV4IGMwYTlkZDUu
LjQ2NmYzYjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NoZWxzaW8vY3hnYjMv
Y3hnYjNfb2ZmbG9hZC5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NoZWxzaW8vY3hnYjMv
Y3hnYjNfb2ZmbG9hZC5jCkBAIC0xMjgwLDcgKzEyODAsNyBAQCBpbnQgY3hnYjNfb2ZmbG9hZF9h
Y3RpdmF0ZShzdHJ1Y3QgYWRhcHRlciAqYWRhcHRlcikKIAlJTklUX0xJU1RfSEVBRCgmdC0+bGlz
dF9ub2RlKTsKIAl0LT5kZXYgPSBkZXY7CiAKLQlSQ1VfSU5JVF9QT0lOVEVSKGRldi0+bDJvcHQs
IGwydGQpOworCXJjdV9pbml0X3BvaW50ZXIoZGV2LT5sMm9wdCwgbDJ0ZCk7CiAJVDNDX0RBVEEo
ZGV2KSA9IHQ7CiAJZGV2LT5yZWN2ID0gcHJvY2Vzc19yeDsKIAlkZXYtPm5laWdoX3VwZGF0ZSA9
IHQzX2wydF91cGRhdGU7CkBAIC0xMzI0LDcgKzEzMjQsNyBAQCB2b2lkIGN4Z2IzX29mZmxvYWRf
ZGVhY3RpdmF0ZShzdHJ1Y3QgYWRhcHRlciAqYWRhcHRlcikKIAlyY3VfcmVhZF9sb2NrKCk7CiAJ
ZCA9IEwyREFUQSh0ZGV2KTsKIAlyY3VfcmVhZF91bmxvY2soKTsKLQlSQ1VfSU5JVF9QT0lOVEVS
KHRkZXYtPmwyb3B0LCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKHRkZXYtPmwyb3B0LCBOVUxM
KTsKIAljYWxsX3JjdSgmZC0+cmN1X2hlYWQsIGNsZWFuX2wyX2RhdGEpOwogCWlmICh0LT5ub2Zh
aWxfc2tiKQogCQlrZnJlZV9za2IodC0+bm9mYWlsX3NrYik7CmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9tYWN2dGFwLmMgYi9kcml2ZXJzL25ldC9tYWN2dGFwLmMKaW5kZXggZmYxMTFhOC4uYzM0
M2MxZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvbWFjdnRhcC5jCisrKyBiL2RyaXZlcnMvbmV0
L21hY3Z0YXAuYwpAQCAtMTU5LDcgKzE1OSw3IEBAIHN0YXRpYyBpbnQgbWFjdnRhcF9kaXNhYmxl
X3F1ZXVlKHN0cnVjdCBtYWN2dGFwX3F1ZXVlICpxKQogCQlucS0+cXVldWVfaW5kZXggPSBpbmRl
eDsKIAogCQlyY3VfYXNzaWduX3BvaW50ZXIodmxhbi0+dGFwc1tpbmRleF0sIG5xKTsKLQkJUkNV
X0lOSVRfUE9JTlRFUih2bGFuLT50YXBzW3ZsYW4tPm51bXZ0YXBzIC0gMV0sIE5VTEwpOworCQly
Y3VfaW5pdF9wb2ludGVyKHZsYW4tPnRhcHNbdmxhbi0+bnVtdnRhcHMgLSAxXSwgTlVMTCk7CiAJ
CXEtPmVuYWJsZWQgPSBmYWxzZTsKIAogCQl2bGFuLT5udW12dGFwcy0tOwpAQCAtMTg4LDcgKzE4
OCw3IEBAIHN0YXRpYyB2b2lkIG1hY3Z0YXBfcHV0X3F1ZXVlKHN0cnVjdCBtYWN2dGFwX3F1ZXVl
ICpxKQogCQkJQlVHX09OKG1hY3Z0YXBfZGlzYWJsZV9xdWV1ZShxKSk7CiAKIAkJdmxhbi0+bnVt
cXVldWVzLS07Ci0JCVJDVV9JTklUX1BPSU5URVIocS0+dmxhbiwgTlVMTCk7CisJCXJjdV9pbml0
X3BvaW50ZXIocS0+dmxhbiwgTlVMTCk7CiAJCXNvY2tfcHV0KCZxLT5zayk7CiAJCWxpc3RfZGVs
X2luaXQoJnEtPm5leHQpOwogCX0KQEAgLTI1OSwxMyArMjU5LDEzIEBAIHN0YXRpYyB2b2lkIG1h
Y3Z0YXBfZGVsX3F1ZXVlcyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogCWxpc3RfZm9yX2VhY2hf
ZW50cnlfc2FmZShxLCB0bXAsICZ2bGFuLT5xdWV1ZV9saXN0LCBuZXh0KSB7CiAJCWxpc3RfZGVs
X2luaXQoJnEtPm5leHQpOwogCQlxbGlzdFtqKytdID0gcTsKLQkJUkNVX0lOSVRfUE9JTlRFUihx
LT52bGFuLCBOVUxMKTsKKwkJcmN1X2luaXRfcG9pbnRlcihxLT52bGFuLCBOVUxMKTsKIAkJaWYg
KHEtPmVuYWJsZWQpCiAJCQl2bGFuLT5udW12dGFwcy0tOwogCQl2bGFuLT5udW1xdWV1ZXMtLTsK
IAl9CiAJZm9yIChpID0gMDsgaSA8IHZsYW4tPm51bXZ0YXBzOyBpKyspCi0JCVJDVV9JTklUX1BP
SU5URVIodmxhbi0+dGFwc1tpXSwgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIodmxhbi0+dGFw
c1tpXSwgTlVMTCk7CiAJQlVHX09OKHZsYW4tPm51bXZ0YXBzKTsKIAlCVUdfT04odmxhbi0+bnVt
cXVldWVzKTsKIAkvKiBndWFyYW50ZWUgdGhhdCBhbnkgZnV0dXJlIG1hY3Z0YXBfc2V0X3F1ZXVl
IHdpbGwgZmFpbCAqLwpAQCAtNDU5LDcgKzQ1OSw3IEBAIHN0YXRpYyBpbnQgbWFjdnRhcF9vcGVu
KHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlKQogCWlmICghcSkKIAkJZ290
byBvdXQ7CiAKLQlSQ1VfSU5JVF9QT0lOVEVSKHEtPnNvY2sud3EsICZxLT53cSk7CisJcmN1X2lu
aXRfcG9pbnRlcihxLT5zb2NrLndxLCAmcS0+d3EpOwogCWluaXRfd2FpdHF1ZXVlX2hlYWQoJnEt
PndxLndhaXQpOwogCXEtPnNvY2sudHlwZSA9IFNPQ0tfUkFXOwogCXEtPnNvY2suc3RhdGUgPSBT
U19DT05ORUNURUQ7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9wcHAvcHB0cC5jIGIvZHJpdmVy
cy9uZXQvcHBwL3BwdHAuYwppbmRleCAwMTgwNTMxLi5iN2MyYWNiIDEwMDY0NAotLS0gYS9kcml2
ZXJzL25ldC9wcHAvcHB0cC5jCisrKyBiL2RyaXZlcnMvbmV0L3BwcC9wcHRwLmMKQEAgLTE2Miw3
ICsxNjIsNyBAQCBzdGF0aWMgdm9pZCBkZWxfY2hhbihzdHJ1Y3QgcHBwb3hfc29jayAqc29jaykK
IHsKIAlzcGluX2xvY2soJmNoYW5fbG9jayk7CiAJY2xlYXJfYml0KHNvY2stPnByb3RvLnBwdHAu
c3JjX2FkZHIuY2FsbF9pZCwgY2FsbGlkX2JpdG1hcCk7Ci0JUkNVX0lOSVRfUE9JTlRFUihjYWxs
aWRfc29ja1tzb2NrLT5wcm90by5wcHRwLnNyY19hZGRyLmNhbGxfaWRdLCBOVUxMKTsKKwlyY3Vf
aW5pdF9wb2ludGVyKGNhbGxpZF9zb2NrW3NvY2stPnByb3RvLnBwdHAuc3JjX2FkZHIuY2FsbF9p
ZF0sIE5VTEwpOwogCXNwaW5fdW5sb2NrKCZjaGFuX2xvY2spOwogCXN5bmNocm9uaXplX3JjdSgp
OwogfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdGVhbS90ZWFtX21vZGVfYWN0aXZlYmFja3Vw
LmMgYi9kcml2ZXJzL25ldC90ZWFtL3RlYW1fbW9kZV9hY3RpdmViYWNrdXAuYwppbmRleCA0MGZk
MzM4Li45MWIzMDY2IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC90ZWFtL3RlYW1fbW9kZV9hY3Rp
dmViYWNrdXAuYworKysgYi9kcml2ZXJzL25ldC90ZWFtL3RlYW1fbW9kZV9hY3RpdmViYWNrdXAu
YwpAQCAtNTYsNyArNTYsNyBAQCBkcm9wOgogc3RhdGljIHZvaWQgYWJfcG9ydF9sZWF2ZShzdHJ1
Y3QgdGVhbSAqdGVhbSwgc3RydWN0IHRlYW1fcG9ydCAqcG9ydCkKIHsKIAlpZiAoYWJfcHJpdih0
ZWFtKS0+YWN0aXZlX3BvcnQgPT0gcG9ydCkgewotCQlSQ1VfSU5JVF9QT0lOVEVSKGFiX3ByaXYo
dGVhbSktPmFjdGl2ZV9wb3J0LCBOVUxMKTsKKwkJcmN1X2luaXRfcG9pbnRlcihhYl9wcml2KHRl
YW0pLT5hY3RpdmVfcG9ydCwgTlVMTCk7CiAJCXRlYW1fb3B0aW9uX2luc3Rfc2V0X2NoYW5nZShh
Yl9wcml2KHRlYW0pLT5hcF9vcHRfaW5zdF9pbmZvKTsKIAl9CiB9CmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC90ZWFtL3RlYW1fbW9kZV9sb2FkYmFsYW5jZS5jIGIvZHJpdmVycy9uZXQvdGVhbS90
ZWFtX21vZGVfbG9hZGJhbGFuY2UuYwppbmRleCBkYmRlMzQxLi5kZWVmMmM5IDEwMDY0NAotLS0g
YS9kcml2ZXJzL25ldC90ZWFtL3RlYW1fbW9kZV9sb2FkYmFsYW5jZS5jCisrKyBiL2RyaXZlcnMv
bmV0L3RlYW0vdGVhbV9tb2RlX2xvYWRiYWxhbmNlLmMKQEAgLTk3LDcgKzk3LDcgQEAgc3RhdGlj
IHZvaWQgbGJfdHhfaGFzaF90b19wb3J0X21hcHBpbmdfbnVsbF9wb3J0KHN0cnVjdCB0ZWFtICp0
ZWFtLAogCiAJCXBtID0gJmxiX3ByaXYtPmV4LT50eF9oYXNoX3RvX3BvcnRfbWFwcGluZ1tpXTsK
IAkJaWYgKHJjdV9hY2Nlc3NfcG9pbnRlcihwbS0+cG9ydCkgPT0gcG9ydCkgewotCQkJUkNVX0lO
SVRfUE9JTlRFUihwbS0+cG9ydCwgTlVMTCk7CisJCQlyY3VfaW5pdF9wb2ludGVyKHBtLT5wb3J0
LCBOVUxMKTsKIAkJCXRlYW1fb3B0aW9uX2luc3Rfc2V0X2NoYW5nZShwbS0+b3B0X2luc3RfaW5m
byk7CiAJCQljaGFuZ2VkID0gdHJ1ZTsKIAkJfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdHVu
LmMgYi9kcml2ZXJzL25ldC90dW4uYwppbmRleCBlZTMyOGJhLi5hYjA2MDQwIDEwMDY0NAotLS0g
YS9kcml2ZXJzL25ldC90dW4uYworKysgYi9kcml2ZXJzL25ldC90dW4uYwpAQCAtNDUyLDcgKzQ1
Miw3IEBAIHN0YXRpYyB2b2lkIF9fdHVuX2RldGFjaChzdHJ1Y3QgdHVuX2ZpbGUgKnRmaWxlLCBi
b29sIGNsZWFuKQogCiAJCS0tdHVuLT5udW1xdWV1ZXM7CiAJCWlmIChjbGVhbikgewotCQkJUkNV
X0lOSVRfUE9JTlRFUih0ZmlsZS0+dHVuLCBOVUxMKTsKKwkJCXJjdV9pbml0X3BvaW50ZXIodGZp
bGUtPnR1biwgTlVMTCk7CiAJCQlzb2NrX3B1dCgmdGZpbGUtPnNrKTsKIAkJfSBlbHNlCiAJCQl0
dW5fZGlzYWJsZV9xdWV1ZSh0dW4sIHRmaWxlKTsKQEAgLTQ5OSwxMiArNDk5LDEyIEBAIHN0YXRp
YyB2b2lkIHR1bl9kZXRhY2hfYWxsKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpCiAJCXRmaWxlID0g
cnRubF9kZXJlZmVyZW5jZSh0dW4tPnRmaWxlc1tpXSk7CiAJCUJVR19PTighdGZpbGUpOwogCQl3
YWtlX3VwX2FsbCgmdGZpbGUtPndxLndhaXQpOwotCQlSQ1VfSU5JVF9QT0lOVEVSKHRmaWxlLT50
dW4sIE5VTEwpOworCQlyY3VfaW5pdF9wb2ludGVyKHRmaWxlLT50dW4sIE5VTEwpOwogCQktLXR1
bi0+bnVtcXVldWVzOwogCX0KIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KHRmaWxlLCAmdHVuLT5kaXNh
YmxlZCwgbmV4dCkgewogCQl3YWtlX3VwX2FsbCgmdGZpbGUtPndxLndhaXQpOwotCQlSQ1VfSU5J
VF9QT0lOVEVSKHRmaWxlLT50dW4sIE5VTEwpOworCQlyY3VfaW5pdF9wb2ludGVyKHRmaWxlLT50
dW4sIE5VTEwpOwogCX0KIAlCVUdfT04odHVuLT5udW1xdWV1ZXMgIT0gMCk7CiAKQEAgLTIxOTQs
NyArMjE5NCw3IEBAIHN0YXRpYyBpbnQgdHVuX2Nocl9vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUs
IHN0cnVjdCBmaWxlICogZmlsZSkKIAkJCQkJICAgICZ0dW5fcHJvdG8pOwogCWlmICghdGZpbGUp
CiAJCXJldHVybiAtRU5PTUVNOwotCVJDVV9JTklUX1BPSU5URVIodGZpbGUtPnR1biwgTlVMTCk7
CisJcmN1X2luaXRfcG9pbnRlcih0ZmlsZS0+dHVuLCBOVUxMKTsKIAl0ZmlsZS0+bmV0ID0gZ2V0
X25ldChjdXJyZW50LT5uc3Byb3h5LT5uZXRfbnMpOwogCXRmaWxlLT5mbGFncyA9IDA7CiAJdGZp
bGUtPmlmaW5kZXggPSAwOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdmV0aC5jIGIvZHJpdmVy
cy9uZXQvdmV0aC5jCmluZGV4IGI0YTEwYmMuLmI4YzAyNmYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bmV0L3ZldGguYworKysgYi9kcml2ZXJzL25ldC92ZXRoLmMKQEAgLTQzMiwxMiArNDMyLDEyIEBA
IHN0YXRpYyB2b2lkIHZldGhfZGVsbGluayhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3Qg
bGlzdF9oZWFkICpoZWFkKQogCSAqIGJlZm9yZSBhIHJjdV9zeW5jaHJvbml6ZSgpIHBvaW50LiBU
aGUgZGV2aWNlcyBhcmUgZ3VhcmFudGVlZAogCSAqIG5vdCBiZWluZyBmcmVlZCBiZWZvcmUgb25l
IFJDVSBncmFjZSBwZXJpb2QuCiAJICovCi0JUkNVX0lOSVRfUE9JTlRFUihwcml2LT5wZWVyLCBO
VUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKHByaXYtPnBlZXIsIE5VTEwpOwogCXVucmVnaXN0ZXJf
bmV0ZGV2aWNlX3F1ZXVlKGRldiwgaGVhZCk7CiAKIAlpZiAocGVlcikgewogCQlwcml2ID0gbmV0
ZGV2X3ByaXYocGVlcik7Ci0JCVJDVV9JTklUX1BPSU5URVIocHJpdi0+cGVlciwgTlVMTCk7CisJ
CXJjdV9pbml0X3BvaW50ZXIocHJpdi0+cGVlciwgTlVMTCk7CiAJCXVucmVnaXN0ZXJfbmV0ZGV2
aWNlX3F1ZXVlKHBlZXIsIGhlYWQpOwogCX0KIH0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2F0aC9jYXJsOTE3MC9tYWluLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvY2Fy
bDkxNzAvbWFpbi5jCmluZGV4IDRjOGNkYjAuLjliYTk4ODUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9jYXJsOTE3MC9tYWluLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2Nhcmw5MTcwL21haW4uYwpAQCAtNDUwLDcgKzQ1MCw3IEBAIHN0YXRpYyB2b2lkIGNh
cmw5MTcwX29wX3N0b3Aoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpCiAKIAltdXRleF9sb2NrKCZh
ci0+bXV0ZXgpOwogCWlmIChJU19BQ0NFUFRJTkdfQ01EKGFyKSkgewotCQlSQ1VfSU5JVF9QT0lO
VEVSKGFyLT5iZWFjb25faXRlciwgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIoYXItPmJlYWNv
bl9pdGVyLCBOVUxMKTsKIAogCQljYXJsOTE3MF9sZWRfc2V0X3N0YXRlKGFyLCAwKTsKIApAQCAt
NzQ3LDcgKzc0Nyw3IEBAIHVubG9jazoKIAkJdmlmX3ByaXYtPmFjdGl2ZSA9IGZhbHNlOwogCQli
aXRtYXBfcmVsZWFzZV9yZWdpb24oJmFyLT52aWZfYml0bWFwLCB2aWZfaWQsIDApOwogCQlhci0+
dmlmcy0tOwotCQlSQ1VfSU5JVF9QT0lOVEVSKGFyLT52aWZfcHJpdlt2aWZfaWRdLnZpZiwgTlVM
TCk7CisJCXJjdV9pbml0X3BvaW50ZXIoYXItPnZpZl9wcml2W3ZpZl9pZF0udmlmLCBOVUxMKTsK
IAkJbGlzdF9kZWxfcmN1KCZ2aWZfcHJpdi0+bGlzdCk7CiAJCW11dGV4X3VubG9jaygmYXItPm11
dGV4KTsKIAkJc3luY2hyb25pemVfcmN1KCk7CkBAIC03ODUsNyArNzg1LDcgQEAgc3RhdGljIHZv
aWQgY2FybDkxNzBfb3BfcmVtb3ZlX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywK
IAlXQVJOX09OKHZpZl9wcml2LT5lbmFibGVfYmVhY29uKTsKIAl2aWZfcHJpdi0+ZW5hYmxlX2Jl
YWNvbiA9IGZhbHNlOwogCWxpc3RfZGVsX3JjdSgmdmlmX3ByaXYtPmxpc3QpOwotCVJDVV9JTklU
X1BPSU5URVIoYXItPnZpZl9wcml2W2lkXS52aWYsIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIo
YXItPnZpZl9wcml2W2lkXS52aWYsIE5VTEwpOwogCiAJaWYgKHZpZiA9PSBtYWluX3ZpZikgewog
CQlyY3VfcmVhZF91bmxvY2soKTsKQEAgLTEzMzMsNyArMTMzMyw3IEBAIHN0YXRpYyBpbnQgY2Fy
bDkxNzBfb3Bfc3RhX2FkZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJfQogCiAJCWZvciAo
aSA9IDA7IGkgPCBBUlJBWV9TSVpFKHN0YV9pbmZvLT5hZ2cpOyBpKyspCi0JCQlSQ1VfSU5JVF9Q
T0lOVEVSKHN0YV9pbmZvLT5hZ2dbaV0sIE5VTEwpOworCQkJcmN1X2luaXRfcG9pbnRlcihzdGFf
aW5mby0+YWdnW2ldLCBOVUxMKTsKIAogCQlzdGFfaW5mby0+YW1wZHVfbWF4X2xlbiA9IDEgPDwg
KDMgKyBzdGEtPmh0X2NhcC5hbXBkdV9mYWN0b3IpOwogCQlzdGFfaW5mby0+aHRfc3RhID0gdHJ1
ZTsKQEAgLTEzNjAsNyArMTM2MCw3IEBAIHN0YXRpYyBpbnQgY2FybDkxNzBfb3Bfc3RhX3JlbW92
ZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJCXN0cnVjdCBjYXJsOTE3MF9zdGFfdGlkICp0
aWRfaW5mbzsKIAogCQkJdGlkX2luZm8gPSByY3VfZGVyZWZlcmVuY2Uoc3RhX2luZm8tPmFnZ1tp
XSk7Ci0JCQlSQ1VfSU5JVF9QT0lOVEVSKHN0YV9pbmZvLT5hZ2dbaV0sIE5VTEwpOworCQkJcmN1
X2luaXRfcG9pbnRlcihzdGFfaW5mby0+YWdnW2ldLCBOVUxMKTsKIAogCQkJaWYgKCF0aWRfaW5m
bykKIAkJCQljb250aW51ZTsKQEAgLTE0NzcsNyArMTQ3Nyw3IEBAIHN0YXRpYyBpbnQgY2FybDkx
NzBfb3BfYW1wZHVfYWN0aW9uKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQkJc3Bpbl91bmxv
Y2tfYmgoJmFyLT50eF9hbXBkdV9saXN0X2xvY2spOwogCQl9CiAKLQkJUkNVX0lOSVRfUE9JTlRF
UihzdGFfaW5mby0+YWdnW3RpZF0sIE5VTEwpOworCQlyY3VfaW5pdF9wb2ludGVyKHN0YV9pbmZv
LT5hZ2dbdGlkXSwgTlVMTCk7CiAJCXJjdV9yZWFkX3VubG9jaygpOwogCiAJCWllZWU4MDIxMV9z
dG9wX3R4X2JhX2NiX2lycXNhZmUodmlmLCBzdGEtPmFkZHIsIHRpZCk7CmRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL212bS9mdy5jIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvaXdsd2lmaS9tdm0vZncuYwppbmRleCA3Y2UyMDA2Li43NTFhYmYwIDEwMDY0NAotLS0gYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL212bS9mdy5jCisrKyBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2l3bHdpZmkvbXZtL2Z3LmMKQEAgLTQ0Myw3ICs0NDMsNyBAQCBpbnQgaXdsX212bV91
cChzdHJ1Y3QgaXdsX212bSAqbXZtKQogCiAJLyogaW5pdCB0aGUgZncgPC0+IG1hYzgwMjExIFNU
QSBtYXBwaW5nICovCiAJZm9yIChpID0gMDsgaSA8IElXTF9NVk1fU1RBVElPTl9DT1VOVDsgaSsr
KQotCQlSQ1VfSU5JVF9QT0lOVEVSKG12bS0+ZndfaWRfdG9fbWFjX2lkW2ldLCBOVUxMKTsKKwkJ
cmN1X2luaXRfcG9pbnRlcihtdm0tPmZ3X2lkX3RvX21hY19pZFtpXSwgTlVMTCk7CiAKIAkvKiBB
ZGQgYXV4aWxpYXJ5IHN0YXRpb24gZm9yIHNjYW5uaW5nICovCiAJcmV0ID0gaXdsX212bV9hZGRf
YXV4X3N0YShtdm0pOwpAQCAtNTIwLDcgKzUyMCw3IEBAIGludCBpd2xfbXZtX2xvYWRfZDNfZnco
c3RydWN0IGl3bF9tdm0gKm12bSkKIAogCS8qIGluaXQgdGhlIGZ3IDwtPiBtYWM4MDIxMSBTVEEg
bWFwcGluZyAqLwogCWZvciAoaSA9IDA7IGkgPCBJV0xfTVZNX1NUQVRJT05fQ09VTlQ7IGkrKykK
LQkJUkNVX0lOSVRfUE9JTlRFUihtdm0tPmZ3X2lkX3RvX21hY19pZFtpXSwgTlVMTCk7CisJCXJj
dV9pbml0X3BvaW50ZXIobXZtLT5md19pZF90b19tYWNfaWRbaV0sIE5VTEwpOwogCiAJLyogQWRk
IGF1eGlsaWFyeSBzdGF0aW9uIGZvciBzY2FubmluZyAqLwogCXJldCA9IGl3bF9tdm1fYWRkX2F1
eF9zdGEobXZtKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3Qvdmhvc3QuYyBiL2RyaXZlcnMv
dmhvc3Qvdmhvc3QuYwppbmRleCA3ODk4N2U0Li45MmQzZmJjIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3Zob3N0L3Zob3N0LmMKKysrIGIvZHJpdmVycy92aG9zdC92aG9zdC5jCkBAIC00MTksNyArNDE5
LDcgQEAgdm9pZCB2aG9zdF9kZXZfcmVzZXRfb3duZXIoc3RydWN0IHZob3N0X2RldiAqZGV2LCBz
dHJ1Y3Qgdmhvc3RfbWVtb3J5ICptZW1vcnkpCiAKIAkvKiBSZXN0b3JlIG1lbW9yeSB0byBkZWZh
dWx0IGVtcHR5IG1hcHBpbmcuICovCiAJbWVtb3J5LT5ucmVnaW9ucyA9IDA7Ci0JUkNVX0lOSVRf
UE9JTlRFUihkZXYtPm1lbW9yeSwgbWVtb3J5KTsKKwlyY3VfaW5pdF9wb2ludGVyKGRldi0+bWVt
b3J5LCBtZW1vcnkpOwogfQogRVhQT1JUX1NZTUJPTF9HUEwodmhvc3RfZGV2X3Jlc2V0X293bmVy
KTsKIApAQCAtNDY1LDcgKzQ2NSw3IEBAIHZvaWQgdmhvc3RfZGV2X2NsZWFudXAoc3RydWN0IHZo
b3N0X2RldiAqZGV2LCBib29sIGxvY2tlZCkKIAlrZnJlZShyY3VfZGVyZWZlcmVuY2VfcHJvdGVj
dGVkKGRldi0+bWVtb3J5LAogCQkJCQlsb2NrZWQgPT0KIAkJCQkJCWxvY2tkZXBfaXNfaGVsZCgm
ZGV2LT5tdXRleCkpKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKGRldi0+bWVtb3J5LCBOVUxMKTsKKwly
Y3VfaW5pdF9wb2ludGVyKGRldi0+bWVtb3J5LCBOVUxMKTsKIAlXQVJOX09OKCFsaXN0X2VtcHR5
KCZkZXYtPndvcmtfbGlzdCkpOwogCWlmIChkZXYtPndvcmtlcikgewogCQlrdGhyZWFkX3N0b3Ao
ZGV2LT53b3JrZXIpOwpkaWZmIC0tZ2l0IGEvZnMvZXZlbnRwb2xsLmMgYi9mcy9ldmVudHBvbGwu
YwppbmRleCBhZjkwMzEyLi5iYzUyZmI4IDEwMDY0NAotLS0gYS9mcy9ldmVudHBvbGwuYworKysg
Yi9mcy9ldmVudHBvbGwuYwpAQCAtMTI1MCw3ICsxMjUwLDcgQEAgc3RhdGljIG5vaW5saW5lIHZv
aWQgZXBfZGVzdHJveV93YWtldXBfc291cmNlKHN0cnVjdCBlcGl0ZW0gKmVwaSkKIHsKIAlzdHJ1
Y3Qgd2FrZXVwX3NvdXJjZSAqd3MgPSBlcF93YWtldXBfc291cmNlKGVwaSk7CiAKLQlSQ1VfSU5J
VF9QT0lOVEVSKGVwaS0+d3MsIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIoZXBpLT53cywgTlVM
TCk7CiAKIAkvKgogCSAqIHdhaXQgZm9yIGVwX3BtX3N0YXlfYXdha2VfcmN1IHRvIGZpbmlzaCwg
c3luY2hyb25pemVfcmN1IGlzCkBAIC0xMjkzLDcgKzEyOTMsNyBAQCBzdGF0aWMgaW50IGVwX2lu
c2VydChzdHJ1Y3QgZXZlbnRwb2xsICplcCwgc3RydWN0IGVwb2xsX2V2ZW50ICpldmVudCwKIAkJ
aWYgKGVycm9yKQogCQkJZ290byBlcnJvcl9jcmVhdGVfd2FrZXVwX3NvdXJjZTsKIAl9IGVsc2Ug
ewotCQlSQ1VfSU5JVF9QT0lOVEVSKGVwaS0+d3MsIE5VTEwpOworCQlyY3VfaW5pdF9wb2ludGVy
KGVwaS0+d3MsIE5VTEwpOwogCX0KIAogCS8qIEluaXRpYWxpemUgdGhlIHBvbGwgdGFibGUgdXNp
bmcgdGhlIHF1ZXVlIGNhbGxiYWNrICovCmRpZmYgLS1naXQgYS9mcy9wcm9jL2lub2RlLmMgYi9m
cy9wcm9jL2lub2RlLmMKaW5kZXggMGFkYmMwMi4uYTg3MzRlMCAxMDA2NDQKLS0tIGEvZnMvcHJv
Yy9pbm9kZS5jCisrKyBiL2ZzL3Byb2MvaW5vZGUuYwpAQCAtNDcsNyArNDcsNyBAQCBzdGF0aWMg
dm9pZCBwcm9jX2V2aWN0X2lub2RlKHN0cnVjdCBpbm9kZSAqaW5vZGUpCiAJCXBkZV9wdXQoZGUp
OwogCWhlYWQgPSBQUk9DX0koaW5vZGUpLT5zeXNjdGw7CiAJaWYgKGhlYWQpIHsKLQkJUkNVX0lO
SVRfUE9JTlRFUihQUk9DX0koaW5vZGUpLT5zeXNjdGwsIE5VTEwpOworCQlyY3VfaW5pdF9wb2lu
dGVyKFBST0NfSShpbm9kZSktPnN5c2N0bCwgTlVMTCk7CiAJCXN5c2N0bF9oZWFkX3B1dChoZWFk
KTsKIAl9CiAJLyogUmVsZWFzZSBhbnkgYXNzb2NpYXRlZCBuYW1lc3BhY2UgKi8KZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbGludXgvcmN1cGRhdGUuaCBiL2luY2x1ZGUvbGludXgvcmN1cGRhdGUuaApp
bmRleCAwMGE3ZmQ2Li5kMzg0MzkyIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L3JjdXBkYXRl
LmgKKysrIGIvaW5jbHVkZS9saW51eC9yY3VwZGF0ZS5oCkBAIC01NjYsMTMgKzU2NiwxMyBAQCBz
dGF0aWMgaW5saW5lIHZvaWQgcmN1X3ByZWVtcHRfc2xlZXBfY2hlY2sodm9pZCkKICAqIGFzc2ln
bm1lbnQuICBNb3JlIGltcG9ydGFudGx5LCB0aGlzIGNhbGwgZG9jdW1lbnRzIHdoaWNoIHBvaW50
ZXJzCiAgKiB3aWxsIGJlIGRlcmVmZXJlbmNlZCBieSBSQ1UgcmVhZC1zaWRlIGNvZGUuCiAgKgot
ICogSW4gc29tZSBzcGVjaWFsIGNhc2VzLCB5b3UgbWF5IHVzZSBSQ1VfSU5JVF9QT0lOVEVSKCkg
aW5zdGVhZAotICogb2YgcmN1X2Fzc2lnbl9wb2ludGVyKCkuICBSQ1VfSU5JVF9QT0lOVEVSKCkg
aXMgYSBiaXQgZmFzdGVyIGR1ZQorICogSW4gc29tZSBzcGVjaWFsIGNhc2VzLCB5b3UgbWF5IHVz
ZSByY3VfaW5pdF9wb2ludGVyKCkgaW5zdGVhZAorICogb2YgcmN1X2Fzc2lnbl9wb2ludGVyKCku
ICByY3VfaW5pdF9wb2ludGVyKCkgaXMgYSBiaXQgZmFzdGVyIGR1ZQogICogdG8gdGhlIGZhY3Qg
dGhhdCBpdCBkb2VzIG5vdCBjb25zdHJhaW4gZWl0aGVyIHRoZSBDUFUgb3IgdGhlIGNvbXBpbGVy
LgotICogVGhhdCBzYWlkLCB1c2luZyBSQ1VfSU5JVF9QT0lOVEVSKCkgd2hlbiB5b3Ugc2hvdWxk
IGhhdmUgdXNlZAorICogVGhhdCBzYWlkLCB1c2luZyByY3VfaW5pdF9wb2ludGVyKCkgd2hlbiB5
b3Ugc2hvdWxkIGhhdmUgdXNlZAogICogcmN1X2Fzc2lnbl9wb2ludGVyKCkgaXMgYSB2ZXJ5IGJh
ZCB0aGluZyB0aGF0IHJlc3VsdHMgaW4KICAqIGltcG9zc2libGUtdG8tZGlhZ25vc2UgbWVtb3J5
IGNvcnJ1cHRpb24uICBTbyBwbGVhc2UgYmUgY2FyZWZ1bC4KLSAqIFNlZSB0aGUgUkNVX0lOSVRf
UE9JTlRFUigpIGNvbW1lbnQgaGVhZGVyIGZvciBkZXRhaWxzLgorICogU2VlIHRoZSByY3VfaW5p
dF9wb2ludGVyKCkgY29tbWVudCBoZWFkZXIgZm9yIGRldGFpbHMuCiAgKgogICogTm90ZSB0aGF0
IHJjdV9hc3NpZ25fcG9pbnRlcigpIGV2YWx1YXRlcyBlYWNoIG9mIGl0cyBhcmd1bWVudHMgb25s
eQogICogb25jZSwgYXBwZWFyYW5jZXMgbm90d2l0aHN0YW5kaW5nLiAgT25lIG9mIHRoZSAiZXh0
cmEiIGV2YWx1YXRpb25zCkBAIC05MTksMTMgKzkxOSwxMyBAQCBzdGF0aWMgaW5saW5lIG5vdHJh
Y2Ugdm9pZCByY3VfcmVhZF91bmxvY2tfc2NoZWRfbm90cmFjZSh2b2lkKQogfQogCiAvKioKLSAq
IFJDVV9JTklUX1BPSU5URVIoKSAtIGluaXRpYWxpemUgYW4gUkNVIHByb3RlY3RlZCBwb2ludGVy
CisgKiByY3VfaW5pdF9wb2ludGVyKCkgLSBpbml0aWFsaXplIGFuIFJDVSBwcm90ZWN0ZWQgcG9p
bnRlcgogICoKICAqIEluaXRpYWxpemUgYW4gUkNVLXByb3RlY3RlZCBwb2ludGVyIGluIHNwZWNp
YWwgY2FzZXMgd2hlcmUgcmVhZGVycwogICogZG8gbm90IG5lZWQgb3JkZXJpbmcgY29uc3RyYWlu
dHMgb24gdGhlIENQVSBvciB0aGUgY29tcGlsZXIuICBUaGVzZQogICogc3BlY2lhbCBjYXNlcyBh
cmU6CiAgKgotICogMS4JVGhpcyB1c2Ugb2YgUkNVX0lOSVRfUE9JTlRFUigpIGlzIE5VTExpbmcg
b3V0IHRoZSBwb2ludGVyIC1vci0KKyAqIDEuCVRoaXMgdXNlIG9mIHJjdV9pbml0X3BvaW50ZXIo
KSBpcyBOVUxMaW5nIG91dCB0aGUgcG9pbnRlciAtb3ItCiAgKiAyLglUaGUgY2FsbGVyIGhhcyB0
YWtlbiB3aGF0ZXZlciBzdGVwcyBhcmUgcmVxdWlyZWQgdG8gcHJldmVudAogICoJUkNVIHJlYWRl
cnMgZnJvbSBjb25jdXJyZW50bHkgYWNjZXNzaW5nIHRoaXMgcG9pbnRlciAtb3ItCiAgKiAzLglU
aGUgcmVmZXJlbmNlZCBkYXRhIHN0cnVjdHVyZSBoYXMgYWxyZWFkeSBiZWVuIGV4cG9zZWQgdG8K
QEAgLTkzNywyMCArOTM3LDIwIEBAIHN0YXRpYyBpbmxpbmUgbm90cmFjZSB2b2lkIHJjdV9yZWFk
X3VubG9ja19zY2hlZF9ub3RyYWNlKHZvaWQpCiAgKgkJZXhhbXBsZSwgdGhlIGNoYW5nZXMgd2Vy
ZSB0byBzdGF0aXN0aWNhbCBjb3VudGVycyBvciB0bwogICoJCW90aGVyIHN0YXRlIHdoZXJlIGV4
YWN0IHN5bmNocm9uaXphdGlvbiBpcyBub3QgcmVxdWlyZWQuKQogICoKLSAqIEZhaWx1cmUgdG8g
Zm9sbG93IHRoZXNlIHJ1bGVzIGdvdmVybmluZyB1c2Ugb2YgUkNVX0lOSVRfUE9JTlRFUigpIHdp
bGwKKyAqIEZhaWx1cmUgdG8gZm9sbG93IHRoZXNlIHJ1bGVzIGdvdmVybmluZyB1c2Ugb2YgcmN1
X2luaXRfcG9pbnRlcigpIHdpbGwKICAqIHJlc3VsdCBpbiBpbXBvc3NpYmxlLXRvLWRpYWdub3Nl
IG1lbW9yeSBjb3JydXB0aW9uLiAgQXMgaW4gdGhlIHN0cnVjdHVyZXMKICAqIHdpbGwgbG9vayBP
SyBpbiBjcmFzaCBkdW1wcywgYnV0IGFueSBjb25jdXJyZW50IFJDVSByZWFkZXJzIG1pZ2h0CiAg
KiBzZWUgcHJlLWluaXRpYWxpemVkIHZhbHVlcyBvZiB0aGUgcmVmZXJlbmNlZCBkYXRhIHN0cnVj
dHVyZS4gIFNvCi0gKiBwbGVhc2UgYmUgdmVyeSBjYXJlZnVsIGhvdyB5b3UgdXNlIFJDVV9JTklU
X1BPSU5URVIoKSEhIQorICogcGxlYXNlIGJlIHZlcnkgY2FyZWZ1bCBob3cgeW91IHVzZSByY3Vf
aW5pdF9wb2ludGVyKCkhISEKICAqCiAgKiBJZiB5b3UgYXJlIGNyZWF0aW5nIGFuIFJDVS1wcm90
ZWN0ZWQgbGlua2VkIHN0cnVjdHVyZSB0aGF0IGlzIGFjY2Vzc2VkCiAgKiBieSBhIHNpbmdsZSBl
eHRlcm5hbC10by1zdHJ1Y3R1cmUgUkNVLXByb3RlY3RlZCBwb2ludGVyLCB0aGVuIHlvdSBtYXkK
LSAqIHVzZSBSQ1VfSU5JVF9QT0lOVEVSKCkgdG8gaW5pdGlhbGl6ZSB0aGUgaW50ZXJuYWwgUkNV
LXByb3RlY3RlZAorICogdXNlIHJjdV9pbml0X3BvaW50ZXIoKSB0byBpbml0aWFsaXplIHRoZSBp
bnRlcm5hbCBSQ1UtcHJvdGVjdGVkCiAgKiBwb2ludGVycywgYnV0IHlvdSBtdXN0IHVzZSByY3Vf
YXNzaWduX3BvaW50ZXIoKSB0byBpbml0aWFsaXplIHRoZQogICogZXh0ZXJuYWwtdG8tc3RydWN0
dXJlIHBvaW50ZXIgLWFmdGVyLSB5b3UgaGF2ZSBjb21wbGV0ZWx5IGluaXRpYWxpemVkCiAgKiB0
aGUgcmVhZGVyLWFjY2Vzc2libGUgcG9ydGlvbnMgb2YgdGhlIGxpbmtlZCBzdHJ1Y3R1cmUuCiAg
Ki8KLSNkZWZpbmUgUkNVX0lOSVRfUE9JTlRFUihwLCB2KSBcCisjZGVmaW5lIHJjdV9pbml0X3Bv
aW50ZXIocCwgdikgXAogCWRvIHsgXAogCQlwID0gUkNVX0lOSVRJQUxJWkVSKHYpOyBcCiAJfSB3
aGlsZSAoMCkKZGlmZiAtLWdpdCBhL2tlcm5lbC9hdWRpdC5jIGIva2VybmVsL2F1ZGl0LmMKaW5k
ZXggN2MyODkzNi4uZjViZjU2NSAxMDA2NDQKLS0tIGEva2VybmVsL2F1ZGl0LmMKKysrIGIva2Vy
bmVsL2F1ZGl0LmMKQEAgLTExMDIsNyArMTEwMiw3IEBAIHN0YXRpYyB2b2lkIF9fbmV0X2V4aXQg
YXVkaXRfbmV0X2V4aXQoc3RydWN0IG5ldCAqbmV0KQogCQlhdWRpdF9zb2NrID0gTlVMTDsKIAl9
CiAKLQlSQ1VfSU5JVF9QT0lOVEVSKGF1bmV0LT5ubHNrLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2lu
dGVyKGF1bmV0LT5ubHNrLCBOVUxMKTsKIAlzeW5jaHJvbml6ZV9uZXQoKTsKIAluZXRsaW5rX2tl
cm5lbF9yZWxlYXNlKHNvY2spOwogfQpkaWZmIC0tZ2l0IGEva2VybmVsL2Nncm91cC5jIGIva2Vy
bmVsL2Nncm91cC5jCmluZGV4IDlmY2RhYTcuLjI1MjMyMGIgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9j
Z3JvdXAuYworKysgYi9rZXJuZWwvY2dyb3VwLmMKQEAgLTEwNDUsNyArMTA0NSw3IEBAIHN0YXRp
YyBpbnQgcmViaW5kX3N1YnN5c3RlbXMoc3RydWN0IGNncm91cF9yb290ICpkc3Rfcm9vdCwKIAog
CQlXQVJOX09OKCFjc3MgfHwgY2dyb3VwX2NzcygmZHN0X3Jvb3QtPmNncnAsIHNzKSk7CiAKLQkJ
UkNVX0lOSVRfUE9JTlRFUihzcmNfcm9vdC0+Y2dycC5zdWJzeXNbc3NpZF0sIE5VTEwpOworCQly
Y3VfaW5pdF9wb2ludGVyKHNyY19yb290LT5jZ3JwLnN1YnN5c1tzc2lkXSwgTlVMTCk7CiAJCXJj
dV9hc3NpZ25fcG9pbnRlcihkc3Rfcm9vdC0+Y2dycC5zdWJzeXNbc3NpZF0sIGNzcyk7CiAJCXNz
LT5yb290ID0gZHN0X3Jvb3Q7CiAJCWNzcy0+Y2dyb3VwID0gJmRzdF9yb290LT5jZ3JwOwpAQCAt
MzU2Nyw3ICszNTY3LDcgQEAgc3RhdGljIHZvaWQgY3NzX3JlbGVhc2Uoc3RydWN0IHBlcmNwdV9y
ZWYgKnJlZikKIAlzdHJ1Y3QgY2dyb3VwX3N1YnN5c19zdGF0ZSAqY3NzID0KIAkJY29udGFpbmVy
X29mKHJlZiwgc3RydWN0IGNncm91cF9zdWJzeXNfc3RhdGUsIHJlZmNudCk7CiAKLQlSQ1VfSU5J
VF9QT0lOVEVSKGNzcy0+Y2dyb3VwLT5zdWJzeXNbY3NzLT5zcy0+aWRdLCBOVUxMKTsKKwlyY3Vf
aW5pdF9wb2ludGVyKGNzcy0+Y2dyb3VwLT5zdWJzeXNbY3NzLT5zcy0+aWRdLCBOVUxMKTsKIAlj
YWxsX3JjdSgmY3NzLT5yY3VfaGVhZCwgY3NzX2ZyZWVfcmN1X2ZuKTsKIH0KIApAQCAtMzYyMSw3
ICszNjIxLDcgQEAgc3RhdGljIHZvaWQgb2ZmbGluZV9jc3Moc3RydWN0IGNncm91cF9zdWJzeXNf
c3RhdGUgKmNzcykKIAogCWNzcy0+ZmxhZ3MgJj0gfkNTU19PTkxJTkU7CiAJY3NzLT5jZ3JvdXAt
Pm5yX2Nzcy0tOwotCVJDVV9JTklUX1BPSU5URVIoY3NzLT5jZ3JvdXAtPnN1YnN5c1tzcy0+aWRd
LCBjc3MpOworCXJjdV9pbml0X3BvaW50ZXIoY3NzLT5jZ3JvdXAtPnN1YnN5c1tzcy0+aWRdLCBj
c3MpOwogfQogCiAvKioKQEAgLTQwNDQsNyArNDA0NCw3IEBAIHN0YXRpYyBpbnQgY2dyb3VwX2Rl
c3Ryb3lfbG9ja2VkKHN0cnVjdCBjZ3JvdXAgKmNncnApCiAJICogYWZ0ZXIgYWxsIGZpbGVzIHVu
ZGVyIGl0IGhhdmUgYmVlbiByZW1vdmVkLgogCSAqLwogCWtlcm5mc19yZW1vdmUoY2dycC0+a24p
OwkvKiBAY2dycCBoYXMgYW4gZXh0cmEgcmVmIG9uIGl0cyBrbiAqLwotCVJDVV9JTklUX1BPSU5U
RVIoKih2b2lkIF9fcmN1IF9fZm9yY2UgKiopJmNncnAtPmtuLT5wcml2LCBOVUxMKTsKKwlyY3Vf
aW5pdF9wb2ludGVyKCoodm9pZCBfX3JjdSBfX2ZvcmNlICoqKSZjZ3JwLT5rbi0+cHJpdiwgTlVM
TCk7CiAKIAltdXRleF9sb2NrKCZjZ3JvdXBfbXV0ZXgpOwogCkBAIC00MTY5LDcgKzQxNjksNyBA
QCBpbnQgX19pbml0IGNncm91cF9pbml0X2Vhcmx5KHZvaWQpCiAJaW50IGk7CiAKIAlpbml0X2Nn
cm91cF9yb290KCZjZ3JwX2RmbF9yb290LCAmb3B0cyk7Ci0JUkNVX0lOSVRfUE9JTlRFUihpbml0
X3Rhc2suY2dyb3VwcywgJmluaXRfY3NzX3NldCk7CisJcmN1X2luaXRfcG9pbnRlcihpbml0X3Rh
c2suY2dyb3VwcywgJmluaXRfY3NzX3NldCk7CiAKIAlmb3JfZWFjaF9zdWJzeXMoc3MsIGkpIHsK
IAkJV0FSTighc3MtPmNzc19hbGxvYyB8fCAhc3MtPmNzc19mcmVlIHx8IHNzLT5uYW1lIHx8IHNz
LT5pZCwKQEAgLTQzNzcsNyArNDM3Nyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVy
YXRpb25zIHByb2NfY2dyb3Vwc3RhdHNfb3BlcmF0aW9ucyA9IHsKICAqLwogdm9pZCBjZ3JvdXBf
Zm9yayhzdHJ1Y3QgdGFza19zdHJ1Y3QgKmNoaWxkKQogewotCVJDVV9JTklUX1BPSU5URVIoY2hp
bGQtPmNncm91cHMsICZpbml0X2Nzc19zZXQpOworCXJjdV9pbml0X3BvaW50ZXIoY2hpbGQtPmNn
cm91cHMsICZpbml0X2Nzc19zZXQpOwogCUlOSVRfTElTVF9IRUFEKCZjaGlsZC0+Y2dfbGlzdCk7
CiB9CiAKQEAgLTQ0ODEsNyArNDQ4MSw3IEBAIHZvaWQgY2dyb3VwX2V4aXQoc3RydWN0IHRhc2tf
c3RydWN0ICp0c2spCiAKIAkvKiBSZWFzc2lnbiB0aGUgdGFzayB0byB0aGUgaW5pdF9jc3Nfc2V0
LiAqLwogCWNzZXQgPSB0YXNrX2Nzc19zZXQodHNrKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKHRzay0+
Y2dyb3VwcywgJmluaXRfY3NzX3NldCk7CisJcmN1X2luaXRfcG9pbnRlcih0c2stPmNncm91cHMs
ICZpbml0X2Nzc19zZXQpOwogCiAJaWYgKG5lZWRfZm9ya2V4aXRfY2FsbGJhY2spIHsKIAkJLyog
c2VlIGNncm91cF9wb3N0X2ZvcmsoKSBmb3IgZGV0YWlscyAqLwpkaWZmIC0tZ2l0IGEva2VybmVs
L3RyYWNlL3RyYWNlX2V2ZW50c19maWx0ZXIuYyBiL2tlcm5lbC90cmFjZS90cmFjZV9ldmVudHNf
ZmlsdGVyLmMKaW5kZXggOGE4NjMxOS4uOTNiMGQ4OSAxMDA2NDQKLS0tIGEva2VybmVsL3RyYWNl
L3RyYWNlX2V2ZW50c19maWx0ZXIuYworKysgYi9rZXJuZWwvdHJhY2UvdHJhY2VfZXZlbnRzX2Zp
bHRlci5jCkBAIC0xNzA4LDkgKzE3MDgsOSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgZXZlbnRfY2xl
YXJfZmlsdGVyKHN0cnVjdCBmdHJhY2VfZXZlbnRfZmlsZSAqZmlsZSkKIAlzdHJ1Y3QgZnRyYWNl
X2V2ZW50X2NhbGwgKmNhbGwgPSBmaWxlLT5ldmVudF9jYWxsOwogCiAJaWYgKGNhbGwtPmZsYWdz
ICYgVFJBQ0VfRVZFTlRfRkxfVVNFX0NBTExfRklMVEVSKQotCQlSQ1VfSU5JVF9QT0lOVEVSKGNh
bGwtPmZpbHRlciwgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIoY2FsbC0+ZmlsdGVyLCBOVUxM
KTsKIAllbHNlCi0JCVJDVV9JTklUX1BPSU5URVIoZmlsZS0+ZmlsdGVyLCBOVUxMKTsKKwkJcmN1
X2luaXRfcG9pbnRlcihmaWxlLT5maWx0ZXIsIE5VTEwpOwogfQogCiBzdGF0aWMgaW5saW5lIHZv
aWQKZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS90cmFjZV9ldmVudHNfdHJpZ2dlci5jIGIva2Vy
bmVsL3RyYWNlL3RyYWNlX2V2ZW50c190cmlnZ2VyLmMKaW5kZXggOTI1ZjUzNy4uMDdkYzJlYiAx
MDA2NDQKLS0tIGEva2VybmVsL3RyYWNlL3RyYWNlX2V2ZW50c190cmlnZ2VyLmMKKysrIGIva2Vy
bmVsL3RyYWNlL3RyYWNlX2V2ZW50c190cmlnZ2VyLmMKQEAgLTEyMTIsNyArMTIxMiw3IEBAIGV2
ZW50X2VuYWJsZV90cmlnZ2VyX2Z1bmMoc3RydWN0IGV2ZW50X2NvbW1hbmQgKmNtZF9vcHMsCiAJ
dHJpZ2dlcl9kYXRhLT5vcHMgPSB0cmlnZ2VyX29wczsKIAl0cmlnZ2VyX2RhdGEtPmNtZF9vcHMg
PSBjbWRfb3BzOwogCUlOSVRfTElTVF9IRUFEKCZ0cmlnZ2VyX2RhdGEtPmxpc3QpOwotCVJDVV9J
TklUX1BPSU5URVIodHJpZ2dlcl9kYXRhLT5maWx0ZXIsIE5VTEwpOworCXJjdV9pbml0X3BvaW50
ZXIodHJpZ2dlcl9kYXRhLT5maWx0ZXIsIE5VTEwpOwogCiAJZW5hYmxlX2RhdGEtPmVuYWJsZSA9
IGVuYWJsZTsKIAllbmFibGVfZGF0YS0+ZmlsZSA9IGV2ZW50X2VuYWJsZV9maWxlOwpkaWZmIC0t
Z2l0IGEva2VybmVsL3dvcmtxdWV1ZS5jIGIva2VybmVsL3dvcmtxdWV1ZS5jCmluZGV4IDBlZTYz
YWYuLjNjODk3ZjUgMTAwNjQ0Ci0tLSBhL2tlcm5lbC93b3JrcXVldWUuYworKysgYi9rZXJuZWwv
d29ya3F1ZXVlLmMKQEAgLTQzNDMsNyArNDM0Myw3IEBAIHZvaWQgZGVzdHJveV93b3JrcXVldWUo
c3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKndxKQogCQkgKi8KIAkJZm9yX2VhY2hfbm9kZShub2Rl
KSB7CiAJCQlwd3EgPSByY3VfYWNjZXNzX3BvaW50ZXIod3EtPm51bWFfcHdxX3RibFtub2RlXSk7
Ci0JCQlSQ1VfSU5JVF9QT0lOVEVSKHdxLT5udW1hX3B3cV90Ymxbbm9kZV0sIE5VTEwpOworCQkJ
cmN1X2luaXRfcG9pbnRlcih3cS0+bnVtYV9wd3FfdGJsW25vZGVdLCBOVUxMKTsKIAkJCXB1dF9w
d3FfdW5sb2NrZWQocHdxKTsKIAkJfQogCmRpZmYgLS1naXQgYS9saWIvaWRyLmMgYi9saWIvaWRy
LmMKaW5kZXggMjY0MmZhOC4uYjg4NTY1MCAxMDA2NDQKLS0tIGEvbGliL2lkci5jCisrKyBiL2xp
Yi9pZHIuYwpAQCAtMTUyLDcgKzE1Miw3IEBAIHN0YXRpYyB2b2lkIGlkcl9sYXllcl9yY3VfZnJl
ZShzdHJ1Y3QgcmN1X2hlYWQgKmhlYWQpCiBzdGF0aWMgaW5saW5lIHZvaWQgZnJlZV9sYXllcihz
dHJ1Y3QgaWRyICppZHIsIHN0cnVjdCBpZHJfbGF5ZXIgKnApCiB7CiAJaWYgKGlkci0+aGludCAm
JiBpZHItPmhpbnQgPT0gcCkKLQkJUkNVX0lOSVRfUE9JTlRFUihpZHItPmhpbnQsIE5VTEwpOwor
CQlyY3VfaW5pdF9wb2ludGVyKGlkci0+aGludCwgTlVMTCk7CiAJY2FsbF9yY3UoJnAtPnJjdV9o
ZWFkLCBpZHJfbGF5ZXJfcmN1X2ZyZWUpOwogfQogCkBAIC01MzMsNyArNTMzLDcgQEAgc3RhdGlj
IHZvaWQgc3ViX3JlbW92ZShzdHJ1Y3QgaWRyICppZHAsIGludCBzaGlmdCwgaW50IGlkKQogCW4g
PSBpZCAmIElEUl9NQVNLOwogCWlmIChsaWtlbHkocCAhPSBOVUxMICYmIHRlc3RfYml0KG4sIHAt
PmJpdG1hcCkpKSB7CiAJCV9fY2xlYXJfYml0KG4sIHAtPmJpdG1hcCk7Ci0JCVJDVV9JTklUX1BP
SU5URVIocC0+YXJ5W25dLCBOVUxMKTsKKwkJcmN1X2luaXRfcG9pbnRlcihwLT5hcnlbbl0sIE5V
TEwpOwogCQl0b19mcmVlID0gTlVMTDsKIAkJd2hpbGUoKnBhYSAmJiAhIC0tKCgqKnBhYSktPmNv
dW50KSl7CiAJCQlpZiAodG9fZnJlZSkKQEAgLTYwMiw3ICs2MDIsNyBAQCBzdGF0aWMgdm9pZCBf
X2lkcl9yZW1vdmVfYWxsKHN0cnVjdCBpZHIgKmlkcCkKIAogCW4gPSBpZHAtPmxheWVycyAqIElE
Ul9CSVRTOwogCXAgPSBpZHAtPnRvcDsKLQlSQ1VfSU5JVF9QT0lOVEVSKGlkcC0+dG9wLCBOVUxM
KTsKKwlyY3VfaW5pdF9wb2ludGVyKGlkcC0+dG9wLCBOVUxMKTsKIAltYXggPSBpZHJfbWF4KGlk
cC0+bGF5ZXJzKTsKIAogCWlkID0gMDsKZGlmZiAtLWdpdCBhL25ldC84MDIvZ2FycC5jIGIvbmV0
LzgwMi9nYXJwLmMKaW5kZXggYjM4ZWU2ZC4uNGJjOThhYyAxMDA2NDQKLS0tIGEvbmV0LzgwMi9n
YXJwLmMKKysrIGIvbmV0LzgwMi9nYXJwLmMKQEAgLTU1Miw3ICs1NTIsNyBAQCBzdGF0aWMgdm9p
ZCBnYXJwX3JlbGVhc2VfcG9ydChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogCQlpZiAocnRubF9k
ZXJlZmVyZW5jZShwb3J0LT5hcHBsaWNhbnRzW2ldKSkKIAkJCXJldHVybjsKIAl9Ci0JUkNVX0lO
SVRfUE9JTlRFUihkZXYtPmdhcnBfcG9ydCwgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihkZXYt
PmdhcnBfcG9ydCwgTlVMTCk7CiAJa2ZyZWVfcmN1KHBvcnQsIHJjdSk7CiB9CiAKQEAgLTYwNCw3
ICs2MDQsNyBAQCB2b2lkIGdhcnBfdW5pbml0X2FwcGxpY2FudChzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2LCBzdHJ1Y3QgZ2FycF9hcHBsaWNhdGlvbiAqYXBwbAogCiAJQVNTRVJUX1JUTkwoKTsKIAot
CVJDVV9JTklUX1BPSU5URVIocG9ydC0+YXBwbGljYW50c1thcHBsLT50eXBlXSwgTlVMTCk7CisJ
cmN1X2luaXRfcG9pbnRlcihwb3J0LT5hcHBsaWNhbnRzW2FwcGwtPnR5cGVdLCBOVUxMKTsKIAog
CS8qIERlbGV0ZSB0aW1lciBhbmQgZ2VuZXJhdGUgYSBmaW5hbCBUUkFOU01JVF9QRFUgZXZlbnQg
dG8gZmx1c2ggb3V0CiAJICogYWxsIHBlbmRpbmcgbWVzc2FnZXMgYmVmb3JlIHRoZSBhcHBsaWNh
bnQgaXMgZ29uZS4gKi8KZGlmZiAtLWdpdCBhL25ldC84MDIvbXJwLmMgYi9uZXQvODAyL21ycC5j
CmluZGV4IDcyZGIyNzguLmU1N2I1MGUgMTAwNjQ0Ci0tLSBhL25ldC84MDIvbXJwLmMKKysrIGIv
bmV0LzgwMi9tcnAuYwpAQCAtODM0LDcgKzgzNCw3IEBAIHN0YXRpYyB2b2lkIG1ycF9yZWxlYXNl
X3BvcnQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikKIAkJaWYgKHJ0bmxfZGVyZWZlcmVuY2UocG9y
dC0+YXBwbGljYW50c1tpXSkpCiAJCQlyZXR1cm47CiAJfQotCVJDVV9JTklUX1BPSU5URVIoZGV2
LT5tcnBfcG9ydCwgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihkZXYtPm1ycF9wb3J0LCBOVUxM
KTsKIAlrZnJlZV9yY3UocG9ydCwgcmN1KTsKIH0KIApAQCAtODkwLDcgKzg5MCw3IEBAIHZvaWQg
bXJwX3VuaW5pdF9hcHBsaWNhbnQoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgc3RydWN0IG1ycF9h
cHBsaWNhdGlvbiAqYXBwbCkKIAogCUFTU0VSVF9SVE5MKCk7CiAKLQlSQ1VfSU5JVF9QT0lOVEVS
KHBvcnQtPmFwcGxpY2FudHNbYXBwbC0+dHlwZV0sIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIo
cG9ydC0+YXBwbGljYW50c1thcHBsLT50eXBlXSwgTlVMTCk7CiAKIAkvKiBEZWxldGUgdGltZXIg
YW5kIGdlbmVyYXRlIGEgZmluYWwgVFggZXZlbnQgdG8gZmx1c2ggb3V0CiAJICogYWxsIHBlbmRp
bmcgbWVzc2FnZXMgYmVmb3JlIHRoZSBhcHBsaWNhbnQgaXMgZ29uZS4KZGlmZiAtLWdpdCBhL25l
dC84MDIvc3RwLmMgYi9uZXQvODAyL3N0cC5jCmluZGV4IDJjNDBiYTAuLjc1YzFhMzIgMTAwNjQ0
Ci0tLSBhL25ldC84MDIvc3RwLmMKKysrIGIvbmV0LzgwMi9zdHAuYwpAQCAtODksOSArODksOSBA
QCB2b2lkIHN0cF9wcm90b191bnJlZ2lzdGVyKGNvbnN0IHN0cnVjdCBzdHBfcHJvdG8gKnByb3Rv
KQogewogCW11dGV4X2xvY2soJnN0cF9wcm90b19tdXRleCk7CiAJaWYgKGlzX3plcm9fZXRoZXJf
YWRkcihwcm90by0+Z3JvdXBfYWRkcmVzcykpCi0JCVJDVV9JTklUX1BPSU5URVIoc3RwX3Byb3Rv
LCBOVUxMKTsKKwkJcmN1X2luaXRfcG9pbnRlcihzdHBfcHJvdG8sIE5VTEwpOwogCWVsc2UKLQkJ
UkNVX0lOSVRfUE9JTlRFUihnYXJwX3Byb3Rvc1twcm90by0+Z3JvdXBfYWRkcmVzc1s1XSAtCisJ
CXJjdV9pbml0X3BvaW50ZXIoZ2FycF9wcm90b3NbcHJvdG8tPmdyb3VwX2FkZHJlc3NbNV0gLQog
CQkJCQkgICAgICAgR0FSUF9BRERSX01JTl0sIE5VTEwpOwogCXN5bmNocm9uaXplX3JjdSgpOwog
CmRpZmYgLS1naXQgYS9uZXQvODAyMXEvdmxhbl9jb3JlLmMgYi9uZXQvODAyMXEvdmxhbl9jb3Jl
LmMKaW5kZXggM2MzMmJkMi4uMjUyZDc3NyAxMDA2NDQKLS0tIGEvbmV0LzgwMjFxL3ZsYW5fY29y
ZS5jCisrKyBiL25ldC84MDIxcS92bGFuX2NvcmUuYwpAQCAtMzQzLDcgKzM0Myw3IEBAIHZvaWQg
dmxhbl92aWRfZGVsKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIF9fYmUxNiBwcm90bywgdTE2IHZp
ZCkKIAlpZiAodmlkX2luZm8tPnJlZmNvdW50ID09IDApIHsKIAkJX192bGFuX3ZpZF9kZWwodmxh
bl9pbmZvLCB2aWRfaW5mbyk7CiAJCWlmICh2bGFuX2luZm8tPm5yX3ZpZHMgPT0gMCkgewotCQkJ
UkNVX0lOSVRfUE9JTlRFUihkZXYtPnZsYW5faW5mbywgTlVMTCk7CisJCQlyY3VfaW5pdF9wb2lu
dGVyKGRldi0+dmxhbl9pbmZvLCBOVUxMKTsKIAkJCWNhbGxfcmN1KCZ2bGFuX2luZm8tPnJjdSwg
dmxhbl9pbmZvX3JjdV9mcmVlKTsKIAkJfQogCX0KZGlmZiAtLWdpdCBhL25ldC9icmlkZ2UvYnJf
dmxhbi5jIGIvbmV0L2JyaWRnZS9icl92bGFuLmMKaW5kZXggNGEzNzE2MS4uOTlmZmQ0MiAxMDA2
NDQKLS0tIGEvbmV0L2JyaWRnZS9icl92bGFuLmMKKysrIGIvbmV0L2JyaWRnZS9icl92bGFuLmMK
QEAgLTk5LDkgKzk5LDkgQEAgc3RhdGljIGludCBfX3ZsYW5fZGVsKHN0cnVjdCBuZXRfcG9ydF92
bGFucyAqdiwgdTE2IHZpZCkKIAl2LT5udW1fdmxhbnMtLTsKIAlpZiAoYml0bWFwX2VtcHR5KHYt
PnZsYW5fYml0bWFwLCBWTEFOX05fVklEKSkgewogCQlpZiAodi0+cG9ydF9pZHgpCi0JCQlSQ1Vf
SU5JVF9QT0lOVEVSKHYtPnBhcmVudC5wb3J0LT52bGFuX2luZm8sIE5VTEwpOworCQkJcmN1X2lu
aXRfcG9pbnRlcih2LT5wYXJlbnQucG9ydC0+dmxhbl9pbmZvLCBOVUxMKTsKIAkJZWxzZQotCQkJ
UkNVX0lOSVRfUE9JTlRFUih2LT5wYXJlbnQuYnItPnZsYW5faW5mbywgTlVMTCk7CisJCQlyY3Vf
aW5pdF9wb2ludGVyKHYtPnBhcmVudC5ici0+dmxhbl9pbmZvLCBOVUxMKTsKIAkJa2ZyZWVfcmN1
KHYsIHJjdSk7CiAJfQogCXJldHVybiAwOwpAQCAtMTEzLDkgKzExMyw5IEBAIHN0YXRpYyB2b2lk
IF9fdmxhbl9mbHVzaChzdHJ1Y3QgbmV0X3BvcnRfdmxhbnMgKnYpCiAJdi0+cHZpZCA9IDA7CiAJ
Yml0bWFwX3plcm8odi0+dmxhbl9iaXRtYXAsIFZMQU5fTl9WSUQpOwogCWlmICh2LT5wb3J0X2lk
eCkKLQkJUkNVX0lOSVRfUE9JTlRFUih2LT5wYXJlbnQucG9ydC0+dmxhbl9pbmZvLCBOVUxMKTsK
KwkJcmN1X2luaXRfcG9pbnRlcih2LT5wYXJlbnQucG9ydC0+dmxhbl9pbmZvLCBOVUxMKTsKIAll
bHNlCi0JCVJDVV9JTklUX1BPSU5URVIodi0+cGFyZW50LmJyLT52bGFuX2luZm8sIE5VTEwpOwor
CQlyY3VfaW5pdF9wb2ludGVyKHYtPnBhcmVudC5ici0+dmxhbl9pbmZvLCBOVUxMKTsKIAlrZnJl
ZV9yY3UodiwgcmN1KTsKIH0KIApkaWZmIC0tZ2l0IGEvbmV0L2JyaWRnZS9uZXRmaWx0ZXIvZWJ0
YWJsZV9icm91dGUuYyBiL25ldC9icmlkZ2UvbmV0ZmlsdGVyL2VidGFibGVfYnJvdXRlLmMKaW5k
ZXggZDJjZGY1ZC4uMTM0NDVhYyAxMDA2NDQKLS0tIGEvbmV0L2JyaWRnZS9uZXRmaWx0ZXIvZWJ0
YWJsZV9icm91dGUuYworKysgYi9uZXQvYnJpZGdlL25ldGZpbHRlci9lYnRhYmxlX2Jyb3V0ZS5j
CkBAIC04MywxNCArODMsMTQgQEAgc3RhdGljIGludCBfX2luaXQgZWJ0YWJsZV9icm91dGVfaW5p
dCh2b2lkKQogCWlmIChyZXQgPCAwKQogCQlyZXR1cm4gcmV0OwogCS8qIHNlZSBicl9pbnB1dC5j
ICovCi0JUkNVX0lOSVRfUE9JTlRFUihicl9zaG91bGRfcm91dGVfaG9vaywKKwlyY3VfaW5pdF9w
b2ludGVyKGJyX3Nob3VsZF9yb3V0ZV9ob29rLAogCQkJICAgKGJyX3Nob3VsZF9yb3V0ZV9ob29r
X3QgKillYnRfYnJvdXRlKTsKIAlyZXR1cm4gMDsKIH0KIAogc3RhdGljIHZvaWQgX19leGl0IGVi
dGFibGVfYnJvdXRlX2Zpbmkodm9pZCkKIHsKLQlSQ1VfSU5JVF9QT0lOVEVSKGJyX3Nob3VsZF9y
b3V0ZV9ob29rLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKGJyX3Nob3VsZF9yb3V0ZV9ob29r
LCBOVUxMKTsKIAlzeW5jaHJvbml6ZV9uZXQoKTsKIAl1bnJlZ2lzdGVyX3Blcm5ldF9zdWJzeXMo
JmJyb3V0ZV9uZXRfb3BzKTsKIH0KZGlmZiAtLWdpdCBhL25ldC9jYWlmL2NmbXV4bC5jIGIvbmV0
L2NhaWYvY2ZtdXhsLmMKaW5kZXggOGM1ZDYzOC4uMTVkNWQ2ZCAxMDA2NDQKLS0tIGEvbmV0L2Nh
aWYvY2ZtdXhsLmMKKysrIGIvbmV0L2NhaWYvY2ZtdXhsLmMKQEAgLTEwOCw3ICsxMDgsNyBAQCBz
dHJ1Y3QgY2ZsYXllciAqY2ZtdXhsX3JlbW92ZV9kbmxheWVyKHN0cnVjdCBjZmxheWVyICpsYXly
LCB1OCBwaHlpZCkKIAlpbnQgaWR4ID0gcGh5aWQgJSBETl9DQUNIRV9TSVpFOwogCiAJc3Bpbl9s
b2NrX2JoKCZtdXhsLT50cmFuc21pdF9sb2NrKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKG11eGwtPmRu
X2NhY2hlW2lkeF0sIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIobXV4bC0+ZG5fY2FjaGVbaWR4
XSwgTlVMTCk7CiAJZG4gPSBnZXRfZnJvbV9pZCgmbXV4bC0+ZnJtbF9saXN0LCBwaHlpZCk7CiAJ
aWYgKGRuID09IE5VTEwpCiAJCWdvdG8gb3V0OwpAQCAtMTY0LDcgKzE2NCw3IEBAIHN0cnVjdCBj
ZmxheWVyICpjZm11eGxfcmVtb3ZlX3VwbGF5ZXIoc3RydWN0IGNmbGF5ZXIgKmxheXIsIHU4IGlk
KQogCWlmICh1cCA9PSBOVUxMKQogCQlnb3RvIG91dDsKIAotCVJDVV9JTklUX1BPSU5URVIobXV4
bC0+dXBfY2FjaGVbaWR4XSwgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihtdXhsLT51cF9jYWNo
ZVtpZHhdLCBOVUxMKTsKIAlsaXN0X2RlbF9yY3UoJnVwLT5ub2RlKTsKIG91dDoKIAlzcGluX3Vu
bG9ja19iaCgmbXV4bC0+cmVjZWl2ZV9sb2NrKTsKZGlmZiAtLWdpdCBhL25ldC9jYW4vYWZfY2Fu
LmMgYi9uZXQvY2FuL2FmX2Nhbi5jCmluZGV4IGEyN2Y4YWEuLjhkZjBmNTIgMTAwNjQ0Ci0tLSBh
L25ldC9jYW4vYWZfY2FuLmMKKysrIGIvbmV0L2Nhbi9hZl9jYW4uYwpAQCAtNzYxLDcgKzc2MSw3
IEBAIGludCBjYW5fcHJvdG9fcmVnaXN0ZXIoY29uc3Qgc3RydWN0IGNhbl9wcm90byAqY3ApCiAJ
CXByX2VycigiY2FuOiBwcm90b2NvbCAlZCBhbHJlYWR5IHJlZ2lzdGVyZWRcbiIsIHByb3RvKTsK
IAkJZXJyID0gLUVCVVNZOwogCX0gZWxzZQotCQlSQ1VfSU5JVF9QT0lOVEVSKHByb3RvX3RhYltw
cm90b10sIGNwKTsKKwkJcmN1X2luaXRfcG9pbnRlcihwcm90b190YWJbcHJvdG9dLCBjcCk7CiAK
IAltdXRleF91bmxvY2soJnByb3RvX3RhYl9sb2NrKTsKIApAQCAtNzgyLDcgKzc4Miw3IEBAIHZv
aWQgY2FuX3Byb3RvX3VucmVnaXN0ZXIoY29uc3Qgc3RydWN0IGNhbl9wcm90byAqY3ApCiAKIAlt
dXRleF9sb2NrKCZwcm90b190YWJfbG9jayk7CiAJQlVHX09OKHByb3RvX3RhYltwcm90b10gIT0g
Y3ApOwotCVJDVV9JTklUX1BPSU5URVIocHJvdG9fdGFiW3Byb3RvXSwgTlVMTCk7CisJcmN1X2lu
aXRfcG9pbnRlcihwcm90b190YWJbcHJvdG9dLCBOVUxMKTsKIAltdXRleF91bmxvY2soJnByb3Rv
X3RhYl9sb2NrKTsKIAogCXN5bmNocm9uaXplX3JjdSgpOwpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUv
ZGV2LmMgYi9uZXQvY29yZS9kZXYuYwppbmRleCBkMmM4YTA2Li5hMGE5M2JkIDEwMDY0NAotLS0g
YS9uZXQvY29yZS9kZXYuYworKysgYi9uZXQvY29yZS9kZXYuYwpAQCAtMTgzNiw3ICsxODM2LDcg
QEAgc3RhdGljIHN0cnVjdCB4cHNfbWFwICpyZW1vdmVfeHBzX3F1ZXVlKHN0cnVjdCB4cHNfZGV2
X21hcHMgKmRldl9tYXBzLAogCQkJaWYgKG1hcC0+bGVuID4gMSkgewogCQkJCW1hcC0+cXVldWVz
W3Bvc10gPSBtYXAtPnF1ZXVlc1stLW1hcC0+bGVuXTsKIAkJCX0gZWxzZSB7Ci0JCQkJUkNVX0lO
SVRfUE9JTlRFUihkZXZfbWFwcy0+Y3B1X21hcFtjcHVdLCBOVUxMKTsKKwkJCQlyY3VfaW5pdF9w
b2ludGVyKGRldl9tYXBzLT5jcHVfbWFwW2NwdV0sIE5VTEwpOwogCQkJCWtmcmVlX3JjdShtYXAs
IHJjdSk7CiAJCQkJbWFwID0gTlVMTDsKIAkJCX0KQEAgLTE4NjksNyArMTg2OSw3IEBAIHN0YXRp
YyB2b2lkIG5ldGlmX3Jlc2V0X3hwc19xdWV1ZXNfZ3Qoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwg
dTE2IGluZGV4KQogCX0KIAogCWlmICghYWN0aXZlKSB7Ci0JCVJDVV9JTklUX1BPSU5URVIoZGV2
LT54cHNfbWFwcywgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIoZGV2LT54cHNfbWFwcywgTlVM
TCk7CiAJCWtmcmVlX3JjdShkZXZfbWFwcywgcmN1KTsKIAl9CiAKQEAgLTE5NDgsNyArMTk0OCw3
IEBAIGludCBuZXRpZl9zZXRfeHBzX3F1ZXVlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGNvbnN0
IHN0cnVjdCBjcHVtYXNrICptYXNrLAogCQlpZiAoIW1hcCkKIAkJCWdvdG8gZXJyb3I7CiAKLQkJ
UkNVX0lOSVRfUE9JTlRFUihuZXdfZGV2X21hcHMtPmNwdV9tYXBbY3B1XSwgbWFwKTsKKwkJcmN1
X2luaXRfcG9pbnRlcihuZXdfZGV2X21hcHMtPmNwdV9tYXBbY3B1XSwgbWFwKTsKIAl9CiAKIAlp
ZiAoIW5ld19kZXZfbWFwcykKQEAgLTE5NzQsNyArMTk3NCw3IEBAIGludCBuZXRpZl9zZXRfeHBz
X3F1ZXVlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIGNvbnN0IHN0cnVjdCBjcHVtYXNrICptYXNr
LAogCQl9IGVsc2UgaWYgKGRldl9tYXBzKSB7CiAJCQkvKiBmaWxsIGluIHRoZSBuZXcgZGV2aWNl
IG1hcCBmcm9tIHRoZSBvbGQgZGV2aWNlIG1hcCAqLwogCQkJbWFwID0geG1hcF9kZXJlZmVyZW5j
ZShkZXZfbWFwcy0+Y3B1X21hcFtjcHVdKTsKLQkJCVJDVV9JTklUX1BPSU5URVIobmV3X2Rldl9t
YXBzLT5jcHVfbWFwW2NwdV0sIG1hcCk7CisJCQlyY3VfaW5pdF9wb2ludGVyKG5ld19kZXZfbWFw
cy0+Y3B1X21hcFtjcHVdLCBtYXApOwogCQl9CiAKIAl9CkBAIC0yMDE2LDcgKzIwMTYsNyBAQCBv
dXRfbm9fbmV3X21hcHM6CiAKIAkvKiBmcmVlIG1hcCBpZiBub3QgYWN0aXZlICovCiAJaWYgKCFh
Y3RpdmUpIHsKLQkJUkNVX0lOSVRfUE9JTlRFUihkZXYtPnhwc19tYXBzLCBOVUxMKTsKKwkJcmN1
X2luaXRfcG9pbnRlcihkZXYtPnhwc19tYXBzLCBOVUxMKTsKIAkJa2ZyZWVfcmN1KGRldl9tYXBz
LCByY3UpOwogCX0KIApAQCAtMzQ3NiwxMyArMzQ3NiwxMyBAQCB2b2lkIG5ldGRldl9yeF9oYW5k
bGVyX3VucmVnaXN0ZXIoc3RydWN0IG5ldF9kZXZpY2UgKmRldikKIHsKIAogCUFTU0VSVF9SVE5M
KCk7Ci0JUkNVX0lOSVRfUE9JTlRFUihkZXYtPnJ4X2hhbmRsZXIsIE5VTEwpOworCXJjdV9pbml0
X3BvaW50ZXIoZGV2LT5yeF9oYW5kbGVyLCBOVUxMKTsKIAkvKiBhIHJlYWRlciBzZWVpbmcgYSBu
b24gTlVMTCByeF9oYW5kbGVyIGluIGEgcmN1X3JlYWRfbG9jaygpCiAJICogc2VjdGlvbiBoYXMg
YSBndWFyYW50ZWUgdG8gc2VlIGEgbm9uIE5VTEwgcnhfaGFuZGxlcl9kYXRhCiAJICogYXMgd2Vs
bC4KIAkgKi8KIAlzeW5jaHJvbml6ZV9uZXQoKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKGRldi0+cnhf
aGFuZGxlcl9kYXRhLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKGRldi0+cnhfaGFuZGxlcl9k
YXRhLCBOVUxMKTsKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKG5ldGRldl9yeF9oYW5kbGVyX3VucmVn
aXN0ZXIpOwogCmRpZmYgLS1naXQgYS9uZXQvY29yZS9maWJfcnVsZXMuYyBiL25ldC9jb3JlL2Zp
Yl9ydWxlcy5jCmluZGV4IDE4NWMzNDEuLmUxMWZjMDEgMTAwNjQ0Ci0tLSBhL25ldC9jb3JlL2Zp
Yl9ydWxlcy5jCisrKyBiL25ldC9jb3JlL2ZpYl9ydWxlcy5jCkBAIC0zNjgsNyArMzY4LDcgQEAg
c3RhdGljIGludCBmaWJfbmxfbmV3cnVsZShzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3Qgbmxt
c2doZHIqIG5saCkKIAogCQlsaXN0X2Zvcl9lYWNoX2VudHJ5KHIsICZvcHMtPnJ1bGVzX2xpc3Qs
IGxpc3QpIHsKIAkJCWlmIChyLT5wcmVmID09IHJ1bGUtPnRhcmdldCkgewotCQkJCVJDVV9JTklU
X1BPSU5URVIocnVsZS0+Y3RhcmdldCwgcik7CisJCQkJcmN1X2luaXRfcG9pbnRlcihydWxlLT5j
dGFyZ2V0LCByKTsKIAkJCQlicmVhazsKIAkJCX0KIAkJfQpAQCAtNTA5LDcgKzUwOSw3IEBAIHN0
YXRpYyBpbnQgZmliX25sX2RlbHJ1bGUoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IG5sbXNn
aGRyKiBubGgpCiAJCWlmIChvcHMtPm5yX2dvdG9fcnVsZXMgPiAwKSB7CiAJCQlsaXN0X2Zvcl9l
YWNoX2VudHJ5KHRtcCwgJm9wcy0+cnVsZXNfbGlzdCwgbGlzdCkgewogCQkJCWlmIChydG5sX2Rl
cmVmZXJlbmNlKHRtcC0+Y3RhcmdldCkgPT0gcnVsZSkgewotCQkJCQlSQ1VfSU5JVF9QT0lOVEVS
KHRtcC0+Y3RhcmdldCwgTlVMTCk7CisJCQkJCXJjdV9pbml0X3BvaW50ZXIodG1wLT5jdGFyZ2V0
LCBOVUxMKTsKIAkJCQkJb3BzLT51bnJlc29sdmVkX3J1bGVzKys7CiAJCQkJfQogCQkJfQpkaWZm
IC0tZ2l0IGEvbmV0L2NvcmUvZmlsdGVyLmMgYi9uZXQvY29yZS9maWx0ZXIuYwppbmRleCBjZDU4
NjE0Li5jYjkxMjVkIDEwMDY0NAotLS0gYS9uZXQvY29yZS9maWx0ZXIuYworKysgYi9uZXQvY29y
ZS9maWx0ZXIuYwpAQCAtMTY5Nyw3ICsxNjk3LDcgQEAgaW50IHNrX2RldGFjaF9maWx0ZXIoc3Ry
dWN0IHNvY2sgKnNrKQogCWZpbHRlciA9IHJjdV9kZXJlZmVyZW5jZV9wcm90ZWN0ZWQoc2stPnNr
X2ZpbHRlciwKIAkJCQkJICAgc29ja19vd25lZF9ieV91c2VyKHNrKSk7CiAJaWYgKGZpbHRlcikg
ewotCQlSQ1VfSU5JVF9QT0lOVEVSKHNrLT5za19maWx0ZXIsIE5VTEwpOworCQlyY3VfaW5pdF9w
b2ludGVyKHNrLT5za19maWx0ZXIsIE5VTEwpOwogCQlza19maWx0ZXJfdW5jaGFyZ2Uoc2ssIGZp
bHRlcik7CiAJCXJldCA9IDA7CiAJfQpkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvbmVpZ2hib3VyLmMg
Yi9uZXQvY29yZS9uZWlnaGJvdXIuYwppbmRleCA4ZjhhOTZlLi43M2Q3NjQwIDEwMDY0NAotLS0g
YS9uZXQvY29yZS9uZWlnaGJvdXIuYworKysgYi9uZXQvY29yZS9uZWlnaGJvdXIuYwpAQCAtMTU1
MCw3ICsxNTUwLDcgQEAgc3RhdGljIHZvaWQgbmVpZ2hfdGFibGVfaW5pdF9ub19uZXRsaW5rKHN0
cnVjdCBuZWlnaF90YWJsZSAqdGJsKQogCQlwYW5pYygiY2Fubm90IGNyZWF0ZSBuZWlnaGJvdXIg
cHJvYyBkaXIgZW50cnkiKTsKICNlbmRpZgogCi0JUkNVX0lOSVRfUE9JTlRFUih0YmwtPm5odCwg
bmVpZ2hfaGFzaF9hbGxvYygzKSk7CisJcmN1X2luaXRfcG9pbnRlcih0YmwtPm5odCwgbmVpZ2hf
aGFzaF9hbGxvYygzKSk7CiAKIAlwaHNpemUgPSAoUE5FSUdIX0hBU0hNQVNLICsgMSkgKiBzaXpl
b2Yoc3RydWN0IHBuZWlnaF9lbnRyeSAqKTsKIAl0YmwtPnBoYXNoX2J1Y2tldHMgPSBremFsbG9j
KHBoc2l6ZSwgR0ZQX0tFUk5FTCk7CmRpZmYgLS1naXQgYS9uZXQvY29yZS9uZXQtc3lzZnMuYyBi
L25ldC9jb3JlL25ldC1zeXNmcy5jCmluZGV4IDFjYWMyOWUuLmNiYmY5NTIgMTAwNjQ0Ci0tLSBh
L25ldC9jb3JlL25ldC1zeXNmcy5jCisrKyBiL25ldC9jb3JlL25ldC1zeXNmcy5jCkBAIC03NDIs
MTMgKzc0MiwxMyBAQCBzdGF0aWMgdm9pZCByeF9xdWV1ZV9yZWxlYXNlKHN0cnVjdCBrb2JqZWN0
ICprb2JqKQogCiAJbWFwID0gcmN1X2RlcmVmZXJlbmNlX3Byb3RlY3RlZChxdWV1ZS0+cnBzX21h
cCwgMSk7CiAJaWYgKG1hcCkgewotCQlSQ1VfSU5JVF9QT0lOVEVSKHF1ZXVlLT5ycHNfbWFwLCBO
VUxMKTsKKwkJcmN1X2luaXRfcG9pbnRlcihxdWV1ZS0+cnBzX21hcCwgTlVMTCk7CiAJCWtmcmVl
X3JjdShtYXAsIHJjdSk7CiAJfQogCiAJZmxvd190YWJsZSA9IHJjdV9kZXJlZmVyZW5jZV9wcm90
ZWN0ZWQocXVldWUtPnJwc19mbG93X3RhYmxlLCAxKTsKIAlpZiAoZmxvd190YWJsZSkgewotCQlS
Q1VfSU5JVF9QT0lOVEVSKHF1ZXVlLT5ycHNfZmxvd190YWJsZSwgTlVMTCk7CisJCXJjdV9pbml0
X3BvaW50ZXIocXVldWUtPnJwc19mbG93X3RhYmxlLCBOVUxMKTsKIAkJY2FsbF9yY3UoJmZsb3df
dGFibGUtPnJjdSwgcnBzX2Rldl9mbG93X3RhYmxlX3JlbGVhc2UpOwogCX0KICNlbmRpZgpkaWZm
IC0tZ2l0IGEvbmV0L2NvcmUvbmV0cG9sbC5jIGIvbmV0L2NvcmUvbmV0cG9sbC5jCmluZGV4IGUz
MzkzN2YuLjQ5NmJhOTAgMTAwNjQ0Ci0tLSBhL25ldC9jb3JlL25ldHBvbGwuYworKysgYi9uZXQv
Y29yZS9uZXRwb2xsLmMKQEAgLTgyMCw3ICs4MjAsNyBAQCB2b2lkIF9fbmV0cG9sbF9jbGVhbnVw
KHN0cnVjdCBuZXRwb2xsICpucCkKIAkJaWYgKG9wcy0+bmRvX25ldHBvbGxfY2xlYW51cCkKIAkJ
CW9wcy0+bmRvX25ldHBvbGxfY2xlYW51cChucC0+ZGV2KTsKIAotCQlSQ1VfSU5JVF9QT0lOVEVS
KG5wLT5kZXYtPm5waW5mbywgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIobnAtPmRldi0+bnBp
bmZvLCBOVUxMKTsKIAkJY2FsbF9yY3VfYmgoJm5waW5mby0+cmN1LCByY3VfY2xlYW51cF9uZXRw
b2xsX2luZm8pOwogCX0KIH0KZGlmZiAtLWdpdCBhL25ldC9jb3JlL25ldHByaW9fY2dyb3VwLmMg
Yi9uZXQvY29yZS9uZXRwcmlvX2Nncm91cC5jCmluZGV4IDM4MjVmNjYuLjE1YzYzYWMgMTAwNjQ0
Ci0tLSBhL25ldC9jb3JlL25ldHByaW9fY2dyb3VwLmMKKysrIGIvbmV0L2NvcmUvbmV0cHJpb19j
Z3JvdXAuYwpAQCAtMjY2LDcgKzI2Niw3IEBAIHN0YXRpYyBpbnQgbmV0cHJpb19kZXZpY2VfZXZl
bnQoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICp1bnVzZWQsCiAJc3dpdGNoIChldmVudCkgewogCWNh
c2UgTkVUREVWX1VOUkVHSVNURVI6CiAJCW9sZCA9IHJ0bmxfZGVyZWZlcmVuY2UoZGV2LT5wcmlv
bWFwKTsKLQkJUkNVX0lOSVRfUE9JTlRFUihkZXYtPnByaW9tYXAsIE5VTEwpOworCQlyY3VfaW5p
dF9wb2ludGVyKGRldi0+cHJpb21hcCwgTlVMTCk7CiAJCWlmIChvbGQpCiAJCQlrZnJlZV9yY3Uo
b2xkLCByY3UpOwogCQlicmVhazsKZGlmZiAtLWdpdCBhL25ldC9jb3JlL3NvY2suYyBiL25ldC9j
b3JlL3NvY2suYwppbmRleCBiNGZmZjAwLi5lYTU2NWJhIDEwMDY0NAotLS0gYS9uZXQvY29yZS9z
b2NrLmMKKysrIGIvbmV0L2NvcmUvc29jay5jCkBAIC00ODEsNyArNDgxLDcgQEAgc3RydWN0IGRz
dF9lbnRyeSAqX19za19kc3RfY2hlY2soc3RydWN0IHNvY2sgKnNrLCB1MzIgY29va2llKQogCiAJ
aWYgKGRzdCAmJiBkc3QtPm9ic29sZXRlICYmIGRzdC0+b3BzLT5jaGVjayhkc3QsIGNvb2tpZSkg
PT0gTlVMTCkgewogCQlza190eF9xdWV1ZV9jbGVhcihzayk7Ci0JCVJDVV9JTklUX1BPSU5URVIo
c2stPnNrX2RzdF9jYWNoZSwgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIoc2stPnNrX2RzdF9j
YWNoZSwgTlVMTCk7CiAJCWRzdF9yZWxlYXNlKGRzdCk7CiAJCXJldHVybiBOVUxMOwogCX0KQEAg
LTEzNjUsNyArMTM2NSw3IEBAIHN0YXRpYyB2b2lkIF9fc2tfZnJlZShzdHJ1Y3Qgc29jayAqc2sp
CiAJCQkJICAgICAgIGF0b21pY19yZWFkKCZzay0+c2tfd21lbV9hbGxvYykgPT0gMCk7CiAJaWYg
KGZpbHRlcikgewogCQlza19maWx0ZXJfdW5jaGFyZ2Uoc2ssIGZpbHRlcik7Ci0JCVJDVV9JTklU
X1BPSU5URVIoc2stPnNrX2ZpbHRlciwgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIoc2stPnNr
X2ZpbHRlciwgTlVMTCk7CiAJfQogCiAJc29ja19kaXNhYmxlX3RpbWVzdGFtcChzaywgU0tfRkxB
R1NfVElNRVNUQU1QKTsKZGlmZiAtLWdpdCBhL25ldC9jb3JlL3N5c2N0bF9uZXRfY29yZS5jIGIv
bmV0L2NvcmUvc3lzY3RsX25ldF9jb3JlLmMKaW5kZXggY2Y5Y2QxMy4uZjMwMTZmOSAxMDA2NDQK
LS0tIGEvbmV0L2NvcmUvc3lzY3RsX25ldF9jb3JlLmMKKysrIGIvbmV0L2NvcmUvc3lzY3RsX25l
dF9jb3JlLmMKQEAgLTExOCw3ICsxMTgsNyBAQCBzdGF0aWMgaW50IGZsb3dfbGltaXRfY3B1X3N5
c2N0bChzdHJ1Y3QgY3RsX3RhYmxlICp0YWJsZSwgaW50IHdyaXRlLAogCQkJY3VyID0gcmN1X2Rl
cmVmZXJlbmNlX3Byb3RlY3RlZChzZC0+Zmxvd19saW1pdCwKIAkJCQkgICAgIGxvY2tkZXBfaXNf
aGVsZCgmZmxvd19saW1pdF91cGRhdGVfbXV0ZXgpKTsKIAkJCWlmIChjdXIgJiYgIWNwdW1hc2tf
dGVzdF9jcHUoaSwgbWFzaykpIHsKLQkJCQlSQ1VfSU5JVF9QT0lOVEVSKHNkLT5mbG93X2xpbWl0
LCBOVUxMKTsKKwkJCQlyY3VfaW5pdF9wb2ludGVyKHNkLT5mbG93X2xpbWl0LCBOVUxMKTsKIAkJ
CQlzeW5jaHJvbml6ZV9yY3UoKTsKIAkJCQlrZnJlZShjdXIpOwogCQkJfSBlbHNlIGlmICghY3Vy
ICYmIGNwdW1hc2tfdGVzdF9jcHUoaSwgbWFzaykpIHsKZGlmZiAtLWdpdCBhL25ldC9kZWNuZXQv
ZG5fZGV2LmMgYi9uZXQvZGVjbmV0L2RuX2Rldi5jCmluZGV4IGE2MDM4MjMuLjE2ODA4ODQgMTAw
NjQ0Ci0tLSBhL25ldC9kZWNuZXQvZG5fZGV2LmMKKysrIGIvbmV0L2RlY25ldC9kbl9kZXYuYwpA
QCAtMTEwMCw3ICsxMTAwLDcgQEAgc3RhdGljIHN0cnVjdCBkbl9kZXYgKmRuX2Rldl9jcmVhdGUo
c3RydWN0IG5ldF9kZXZpY2UgKmRldiwgaW50ICplcnIpCiAKIAlkbl9kYi0+bmVpZ2hfcGFybXMg
PSBuZWlnaF9wYXJtc19hbGxvYyhkZXYsICZkbl9uZWlnaF90YWJsZSk7CiAJaWYgKCFkbl9kYi0+
bmVpZ2hfcGFybXMpIHsKLQkJUkNVX0lOSVRfUE9JTlRFUihkZXYtPmRuX3B0ciwgTlVMTCk7CisJ
CXJjdV9pbml0X3BvaW50ZXIoZGV2LT5kbl9wdHIsIE5VTEwpOwogCQlrZnJlZShkbl9kYik7CiAJ
CXJldHVybiBOVUxMOwogCX0KZGlmZiAtLWdpdCBhL25ldC9kZWNuZXQvZG5fcm91dGUuYyBiL25l
dC9kZWNuZXQvZG5fcm91dGUuYwppbmRleCBkYWNjYzRhLi40MmQ0YmYwIDEwMDY0NAotLS0gYS9u
ZXQvZGVjbmV0L2RuX3JvdXRlLmMKKysrIGIvbmV0L2RlY25ldC9kbl9yb3V0ZS5jCkBAIC0zODAs
NyArMzgwLDcgQEAgc3RhdGljIHZvaWQgZG5fcnVuX2ZsdXNoKHVuc2lnbmVkIGxvbmcgZHVtbXkp
CiAKIAkJZm9yKDsgcnQ7IHJ0ID0gbmV4dCkgewogCQkJbmV4dCA9IHJjdV9kZXJlZmVyZW5jZV9y
YXcocnQtPmRzdC5kbl9uZXh0KTsKLQkJCVJDVV9JTklUX1BPSU5URVIocnQtPmRzdC5kbl9uZXh0
LCBOVUxMKTsKKwkJCXJjdV9pbml0X3BvaW50ZXIocnQtPmRzdC5kbl9uZXh0LCBOVUxMKTsKIAkJ
CWRzdF9mcmVlKChzdHJ1Y3QgZHN0X2VudHJ5ICopcnQpOwogCQl9CiAKZGlmZiAtLWdpdCBhL25l
dC9pcHY0L2RldmluZXQuYyBiL25ldC9pcHY0L2RldmluZXQuYwppbmRleCBiZGJmNjhiLi41ZTI4
OTFjIDEwMDY0NAotLS0gYS9uZXQvaXB2NC9kZXZpbmV0LmMKKysrIGIvbmV0L2lwdjQvZGV2aW5l
dC5jCkBAIC0yOTQsNyArMjk0LDcgQEAgc3RhdGljIHZvaWQgaW5ldGRldl9kZXN0cm95KHN0cnVj
dCBpbl9kZXZpY2UgKmluX2RldikKIAkJaW5ldF9mcmVlX2lmYShpZmEpOwogCX0KIAotCVJDVV9J
TklUX1BPSU5URVIoZGV2LT5pcF9wdHIsIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIoZGV2LT5p
cF9wdHIsIE5VTEwpOwogCiAJZGV2aW5ldF9zeXNjdGxfdW5yZWdpc3Rlcihpbl9kZXYpOwogCW5l
aWdoX3Bhcm1zX3JlbGVhc2UoJmFycF90YmwsIGluX2Rldi0+YXJwX3Bhcm1zKTsKQEAgLTEzNjcs
NyArMTM2Nyw3IEBAIHN0YXRpYyBpbnQgaW5ldGRldl9ldmVudChzdHJ1Y3Qgbm90aWZpZXJfYmxv
Y2sgKnRoaXMsIHVuc2lnbmVkIGxvbmcgZXZlbnQsCiAJc3dpdGNoIChldmVudCkgewogCWNhc2Ug
TkVUREVWX1JFR0lTVEVSOgogCQlwcl9kZWJ1ZygiJXM6IGJ1Z1xuIiwgX19mdW5jX18pOwotCQlS
Q1VfSU5JVF9QT0lOVEVSKGRldi0+aXBfcHRyLCBOVUxMKTsKKwkJcmN1X2luaXRfcG9pbnRlcihk
ZXYtPmlwX3B0ciwgTlVMTCk7CiAJCWJyZWFrOwogCWNhc2UgTkVUREVWX1VQOgogCQlpZiAoIWlu
ZXRkZXZfdmFsaWRfbXR1KGRldi0+bXR1KSkKZGlmZiAtLWdpdCBhL25ldC9pcHY0L2ZpYl9zZW1h
bnRpY3MuYyBiL25ldC9pcHY0L2ZpYl9zZW1hbnRpY3MuYwppbmRleCA4YTA0M2YwLi5hYWRiZWRh
IDEwMDY0NAotLS0gYS9uZXQvaXB2NC9maWJfc2VtYW50aWNzLmMKKysrIGIvbmV0L2lwdjQvZmli
X3NlbWFudGljcy5jCkBAIC0xNDcsNyArMTQ3LDcgQEAgc3RhdGljIHZvaWQgcnRfZmliaW5mb19m
cmVlKHN0cnVjdCBydGFibGUgX19yY3UgKipydHApCiAJaWYgKCFydCkKIAkJcmV0dXJuOwogCi0J
LyogTm90IGV2ZW4gbmVlZGVkIDogUkNVX0lOSVRfUE9JTlRFUigqcnRwLCBOVUxMKTsKKwkvKiBO
b3QgZXZlbiBuZWVkZWQgOiByY3VfaW5pdF9wb2ludGVyKCpydHAsIE5VTEwpOwogCSAqIGJlY2F1
c2Ugd2Ugd2FpdGVkIGFuIFJDVSBncmFjZSBwZXJpb2QgYmVmb3JlIGNhbGxpbmcKIAkgKiBmcmVl
X2ZpYl9pbmZvX3JjdSgpCiAJICovCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9maWJfdHJpZS5jIGIv
bmV0L2lwdjQvZmliX3RyaWUuYwppbmRleCA1YWZlYjVhLi5iNjMyMzQ2IDEwMDY0NAotLS0gYS9u
ZXQvaXB2NC9maWJfdHJpZS5jCisrKyBiL25ldC9pcHY0L2ZpYl90cmllLmMKQEAgLTE2MDIsNyAr
MTYwMiw3IEBAIHN0YXRpYyB2b2lkIHRyaWVfbGVhZl9yZW1vdmUoc3RydWN0IHRyaWUgKnQsIHN0
cnVjdCBsZWFmICpsKQogCQlwdXRfY2hpbGQodHAsIGNpbmRleCwgTlVMTCk7CiAJCXRyaWVfcmVi
YWxhbmNlKHQsIHRwKTsKIAl9IGVsc2UKLQkJUkNVX0lOSVRfUE9JTlRFUih0LT50cmllLCBOVUxM
KTsKKwkJcmN1X2luaXRfcG9pbnRlcih0LT50cmllLCBOVUxMKTsKIAogCWZyZWVfbGVhZihsKTsK
IH0KZGlmZiAtLWdpdCBhL25ldC9pcHY0L2lnbXAuYyBiL25ldC9pcHY0L2lnbXAuYwppbmRleCA5
N2U0ZDE2Li41NDEyMmYxIDEwMDY0NAotLS0gYS9uZXQvaXB2NC9pZ21wLmMKKysrIGIvbmV0L2lw
djQvaWdtcC5jCkBAIC0xMjc2LDcgKzEyNzYsNyBAQCBzdGF0aWMgdm9pZCBpcF9tY19oYXNoX2Fk
ZChzdHJ1Y3QgaW5fZGV2aWNlICppbl9kZXYsCiAJZm9yX2VhY2hfcG1jX3J0bmwoaW5fZGV2LCBp
bSkgewogCQloYXNoID0gaXBfbWNfaGFzaChpbSk7CiAJCWltLT5uZXh0X2hhc2ggPSBtY19oYXNo
W2hhc2hdOwotCQlSQ1VfSU5JVF9QT0lOVEVSKG1jX2hhc2hbaGFzaF0sIGltKTsKKwkJcmN1X2lu
aXRfcG9pbnRlcihtY19oYXNoW2hhc2hdLCBpbSk7CiAJfQogCiAJcmN1X2Fzc2lnbl9wb2ludGVy
KGluX2Rldi0+bWNfaGFzaCwgbWNfaGFzaCk7CkBAIC0xOTI4LDcgKzE5MjgsNyBAQCBzdGF0aWMg
aW50IGlwX21jX2xlYXZlX3NyYyhzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBpcF9tY19zb2NrbGlz
dCAqaW1sLAogCX0KIAllcnIgPSBpcF9tY19kZWxfc3JjKGluX2RldiwgJmltbC0+bXVsdGkuaW1y
X211bHRpYWRkci5zX2FkZHIsCiAJCQlpbWwtPnNmbW9kZSwgcHNmLT5zbF9jb3VudCwgcHNmLT5z
bF9hZGRyLCAwKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKGltbC0+c2ZsaXN0LCBOVUxMKTsKKwlyY3Vf
aW5pdF9wb2ludGVyKGltbC0+c2ZsaXN0LCBOVUxMKTsKIAkvKiBkZWNyZWFzZSBtZW0gbm93IHRv
IGF2b2lkIHRoZSBtZW1sZWFrIHdhcm5pbmcgKi8KIAlhdG9taWNfc3ViKElQX1NGTFNJWkUocHNm
LT5zbF9tYXgpLCAmc2stPnNrX29tZW1fYWxsb2MpOwogCWtmcmVlX3JjdShwc2YsIHJjdSk7CmRp
ZmYgLS1naXQgYS9uZXQvaXB2NC9pbmV0cGVlci5jIGIvbmV0L2lwdjQvaW5ldHBlZXIuYwppbmRl
eCA0OGY0MjQ0Li4zOTgzNDAwIDEwMDY0NAotLS0gYS9uZXQvaXB2NC9pbmV0cGVlci5jCisrKyBi
L25ldC9pcHY0L2luZXRwZWVyLmMKQEAgLTMwOSwyNiArMzA5LDI2IEBAIHN0YXRpYyB2b2lkIHBl
ZXJfYXZsX3JlYmFsYW5jZShzdHJ1Y3QgaW5ldF9wZWVyIF9fcmN1ICoqc3RhY2tbXSwKIAkJCWxy
ID0gcmN1X2RlcmVmX2xvY2tlZChsLT5hdmxfcmlnaHQsIGJhc2UpOwogCQkJbHJoID0gbm9kZV9o
ZWlnaHQobHIpOwogCQkJaWYgKGxyaCA8PSBub2RlX2hlaWdodChsbCkpIHsJLyogbGw6IFJIKzEg
Ki8KLQkJCQlSQ1VfSU5JVF9QT0lOVEVSKG5vZGUtPmF2bF9sZWZ0LCBscik7CS8qIGxyOiBSSCBv
ciBSSCsxICovCi0JCQkJUkNVX0lOSVRfUE9JTlRFUihub2RlLT5hdmxfcmlnaHQsIHIpOwkvKiBy
OiBSSCAqLworCQkJCXJjdV9pbml0X3BvaW50ZXIobm9kZS0+YXZsX2xlZnQsIGxyKTsJLyogbHI6
IFJIIG9yIFJIKzEgKi8KKwkJCQlyY3VfaW5pdF9wb2ludGVyKG5vZGUtPmF2bF9yaWdodCwgcik7
CS8qIHI6IFJIICovCiAJCQkJbm9kZS0+YXZsX2hlaWdodCA9IGxyaCArIDE7IC8qIFJIKzEgb3Ig
UkgrMiAqLwotCQkJCVJDVV9JTklUX1BPSU5URVIobC0+YXZsX2xlZnQsIGxsKTsgICAgICAgLyog
bGw6IFJIKzEgKi8KLQkJCQlSQ1VfSU5JVF9QT0lOVEVSKGwtPmF2bF9yaWdodCwgbm9kZSk7CS8q
IG5vZGU6IFJIKzEgb3IgUkgrMiAqLworCQkJCXJjdV9pbml0X3BvaW50ZXIobC0+YXZsX2xlZnQs
IGxsKTsgICAgICAgLyogbGw6IFJIKzEgKi8KKwkJCQlyY3VfaW5pdF9wb2ludGVyKGwtPmF2bF9y
aWdodCwgbm9kZSk7CS8qIG5vZGU6IFJIKzEgb3IgUkgrMiAqLwogCQkJCWwtPmF2bF9oZWlnaHQg
PSBub2RlLT5hdmxfaGVpZ2h0ICsgMTsKLQkJCQlSQ1VfSU5JVF9QT0lOVEVSKCpub2RlcCwgbCk7
CisJCQkJcmN1X2luaXRfcG9pbnRlcigqbm9kZXAsIGwpOwogCQkJfSBlbHNlIHsgLyogbGw6IFJI
LCBscjogUkgrMSAqLwogCQkJCWxybCA9IHJjdV9kZXJlZl9sb2NrZWQobHItPmF2bF9sZWZ0LCBi
YXNlKTsvKiBscmw6IFJIIG9yIFJILTEgKi8KIAkJCQlscnIgPSByY3VfZGVyZWZfbG9ja2VkKGxy
LT5hdmxfcmlnaHQsIGJhc2UpOy8qIGxycjogUkggb3IgUkgtMSAqLwotCQkJCVJDVV9JTklUX1BP
SU5URVIobm9kZS0+YXZsX2xlZnQsIGxycik7CS8qIGxycjogUkggb3IgUkgtMSAqLwotCQkJCVJD
VV9JTklUX1BPSU5URVIobm9kZS0+YXZsX3JpZ2h0LCByKTsJLyogcjogUkggKi8KKwkJCQlyY3Vf
aW5pdF9wb2ludGVyKG5vZGUtPmF2bF9sZWZ0LCBscnIpOwkvKiBscnI6IFJIIG9yIFJILTEgKi8K
KwkJCQlyY3VfaW5pdF9wb2ludGVyKG5vZGUtPmF2bF9yaWdodCwgcik7CS8qIHI6IFJIICovCiAJ
CQkJbm9kZS0+YXZsX2hlaWdodCA9IHJoICsgMTsgLyogbm9kZTogUkgrMSAqLwotCQkJCVJDVV9J
TklUX1BPSU5URVIobC0+YXZsX2xlZnQsIGxsKTsJLyogbGw6IFJIICovCi0JCQkJUkNVX0lOSVRf
UE9JTlRFUihsLT5hdmxfcmlnaHQsIGxybCk7CS8qIGxybDogUkggb3IgUkgtMSAqLworCQkJCXJj
dV9pbml0X3BvaW50ZXIobC0+YXZsX2xlZnQsIGxsKTsJLyogbGw6IFJIICovCisJCQkJcmN1X2lu
aXRfcG9pbnRlcihsLT5hdmxfcmlnaHQsIGxybCk7CS8qIGxybDogUkggb3IgUkgtMSAqLwogCQkJ
CWwtPmF2bF9oZWlnaHQgPSByaCArIDE7CS8qIGw6IFJIKzEgKi8KLQkJCQlSQ1VfSU5JVF9QT0lO
VEVSKGxyLT5hdmxfbGVmdCwgbCk7CS8qIGw6IFJIKzEgKi8KLQkJCQlSQ1VfSU5JVF9QT0lOVEVS
KGxyLT5hdmxfcmlnaHQsIG5vZGUpOwkvKiBub2RlOiBSSCsxICovCisJCQkJcmN1X2luaXRfcG9p
bnRlcihsci0+YXZsX2xlZnQsIGwpOwkvKiBsOiBSSCsxICovCisJCQkJcmN1X2luaXRfcG9pbnRl
cihsci0+YXZsX3JpZ2h0LCBub2RlKTsJLyogbm9kZTogUkgrMSAqLwogCQkJCWxyLT5hdmxfaGVp
Z2h0ID0gcmggKyAyOwotCQkJCVJDVV9JTklUX1BPSU5URVIoKm5vZGVwLCBscik7CisJCQkJcmN1
X2luaXRfcG9pbnRlcigqbm9kZXAsIGxyKTsKIAkJCX0KIAkJfSBlbHNlIGlmIChyaCA+IGxoICsg
MSkgeyAvKiByOiBMSCsyICovCiAJCQlzdHJ1Y3QgaW5ldF9wZWVyICpyciwgKnJsLCAqcmxyLCAq
cmxsOwpAQCAtMzM3LDI2ICszMzcsMjYgQEAgc3RhdGljIHZvaWQgcGVlcl9hdmxfcmViYWxhbmNl
KHN0cnVjdCBpbmV0X3BlZXIgX19yY3UgKipzdGFja1tdLAogCQkJcmwgPSByY3VfZGVyZWZfbG9j
a2VkKHItPmF2bF9sZWZ0LCBiYXNlKTsKIAkJCXJsaCA9IG5vZGVfaGVpZ2h0KHJsKTsKIAkJCWlm
IChybGggPD0gbm9kZV9oZWlnaHQocnIpKSB7CS8qIHJyOiBMSCsxICovCi0JCQkJUkNVX0lOSVRf
UE9JTlRFUihub2RlLT5hdmxfcmlnaHQsIHJsKTsJLyogcmw6IExIIG9yIExIKzEgKi8KLQkJCQlS
Q1VfSU5JVF9QT0lOVEVSKG5vZGUtPmF2bF9sZWZ0LCBsKTsJLyogbDogTEggKi8KKwkJCQlyY3Vf
aW5pdF9wb2ludGVyKG5vZGUtPmF2bF9yaWdodCwgcmwpOwkvKiBybDogTEggb3IgTEgrMSAqLwor
CQkJCXJjdV9pbml0X3BvaW50ZXIobm9kZS0+YXZsX2xlZnQsIGwpOwkvKiBsOiBMSCAqLwogCQkJ
CW5vZGUtPmF2bF9oZWlnaHQgPSBybGggKyAxOyAvKiBMSCsxIG9yIExIKzIgKi8KLQkJCQlSQ1Vf
SU5JVF9QT0lOVEVSKHItPmF2bF9yaWdodCwgcnIpOwkvKiBycjogTEgrMSAqLwotCQkJCVJDVV9J
TklUX1BPSU5URVIoci0+YXZsX2xlZnQsIG5vZGUpOwkvKiBub2RlOiBMSCsxIG9yIExIKzIgKi8K
KwkJCQlyY3VfaW5pdF9wb2ludGVyKHItPmF2bF9yaWdodCwgcnIpOwkvKiBycjogTEgrMSAqLwor
CQkJCXJjdV9pbml0X3BvaW50ZXIoci0+YXZsX2xlZnQsIG5vZGUpOwkvKiBub2RlOiBMSCsxIG9y
IExIKzIgKi8KIAkJCQlyLT5hdmxfaGVpZ2h0ID0gbm9kZS0+YXZsX2hlaWdodCArIDE7Ci0JCQkJ
UkNVX0lOSVRfUE9JTlRFUigqbm9kZXAsIHIpOworCQkJCXJjdV9pbml0X3BvaW50ZXIoKm5vZGVw
LCByKTsKIAkJCX0gZWxzZSB7IC8qIHJyOiBSSCwgcmw6IFJIKzEgKi8KIAkJCQlybHIgPSByY3Vf
ZGVyZWZfbG9ja2VkKHJsLT5hdmxfcmlnaHQsIGJhc2UpOy8qIHJscjogTEggb3IgTEgtMSAqLwog
CQkJCXJsbCA9IHJjdV9kZXJlZl9sb2NrZWQocmwtPmF2bF9sZWZ0LCBiYXNlKTsvKiBybGw6IExI
IG9yIExILTEgKi8KLQkJCQlSQ1VfSU5JVF9QT0lOVEVSKG5vZGUtPmF2bF9yaWdodCwgcmxsKTsJ
LyogcmxsOiBMSCBvciBMSC0xICovCi0JCQkJUkNVX0lOSVRfUE9JTlRFUihub2RlLT5hdmxfbGVm
dCwgbCk7CS8qIGw6IExIICovCisJCQkJcmN1X2luaXRfcG9pbnRlcihub2RlLT5hdmxfcmlnaHQs
IHJsbCk7CS8qIHJsbDogTEggb3IgTEgtMSAqLworCQkJCXJjdV9pbml0X3BvaW50ZXIobm9kZS0+
YXZsX2xlZnQsIGwpOwkvKiBsOiBMSCAqLwogCQkJCW5vZGUtPmF2bF9oZWlnaHQgPSBsaCArIDE7
IC8qIG5vZGU6IExIKzEgKi8KLQkJCQlSQ1VfSU5JVF9QT0lOVEVSKHItPmF2bF9yaWdodCwgcnIp
OwkvKiBycjogTEggKi8KLQkJCQlSQ1VfSU5JVF9QT0lOVEVSKHItPmF2bF9sZWZ0LCBybHIpOwkv
KiBybHI6IExIIG9yIExILTEgKi8KKwkJCQlyY3VfaW5pdF9wb2ludGVyKHItPmF2bF9yaWdodCwg
cnIpOwkvKiBycjogTEggKi8KKwkJCQlyY3VfaW5pdF9wb2ludGVyKHItPmF2bF9sZWZ0LCBybHIp
OwkvKiBybHI6IExIIG9yIExILTEgKi8KIAkJCQlyLT5hdmxfaGVpZ2h0ID0gbGggKyAxOwkvKiBy
OiBMSCsxICovCi0JCQkJUkNVX0lOSVRfUE9JTlRFUihybC0+YXZsX3JpZ2h0LCByKTsJLyogcjog
TEgrMSAqLwotCQkJCVJDVV9JTklUX1BPSU5URVIocmwtPmF2bF9sZWZ0LCBub2RlKTsJLyogbm9k
ZTogTEgrMSAqLworCQkJCXJjdV9pbml0X3BvaW50ZXIocmwtPmF2bF9yaWdodCwgcik7CS8qIHI6
IExIKzEgKi8KKwkJCQlyY3VfaW5pdF9wb2ludGVyKHJsLT5hdmxfbGVmdCwgbm9kZSk7CS8qIG5v
ZGU6IExIKzEgKi8KIAkJCQlybC0+YXZsX2hlaWdodCA9IGxoICsgMjsKLQkJCQlSQ1VfSU5JVF9Q
T0lOVEVSKCpub2RlcCwgcmwpOworCQkJCXJjdV9pbml0X3BvaW50ZXIoKm5vZGVwLCBybCk7CiAJ
CQl9CiAJCX0gZWxzZSB7CiAJCQlub2RlLT5hdmxfaGVpZ2h0ID0gKGxoID4gcmggPyBsaCA6IHJo
KSArIDE7CkBAIC00MDAsNyArNDAwLDcgQEAgc3RhdGljIHZvaWQgdW5saW5rX2Zyb21fcG9vbChz
dHJ1Y3QgaW5ldF9wZWVyICpwLCBzdHJ1Y3QgaW5ldF9wZWVyX2Jhc2UgKmJhc2UsCiAJCS8qIHQg
aXMgcmVtb3ZlZCwgdC0+ZGFkZHIgPiB4LT5kYWRkciBmb3IgYW55CiAJCSAqIHggaW4gcC0+YXZs
X2xlZnQgc3VidHJlZS4KIAkJICogUHV0IHQgaW4gdGhlIG9sZCBwbGFjZSBvZiBwLiAqLwotCQlS
Q1VfSU5JVF9QT0lOVEVSKCpkZWxwWzBdLCB0KTsKKwkJcmN1X2luaXRfcG9pbnRlcigqZGVscFsw
XSwgdCk7CiAJCXQtPmF2bF9sZWZ0ID0gcC0+YXZsX2xlZnQ7CiAJCXQtPmF2bF9yaWdodCA9IHAt
PmF2bF9yaWdodDsKIAkJdC0+YXZsX2hlaWdodCA9IHAtPmF2bF9oZWlnaHQ7CmRpZmYgLS1naXQg
YS9uZXQvaXB2NC9pcG1yLmMgYi9uZXQvaXB2NC9pcG1yLmMKaW5kZXggZDg0ZGM4ZC4uMTk3MDBl
ZSAxMDA2NDQKLS0tIGEvbmV0L2lwdjQvaXBtci5jCisrKyBiL25ldC9pcHY0L2lwbXIuYwpAQCAt
MTI1Myw3ICsxMjUzLDcgQEAgc3RhdGljIHZvaWQgbXJ0c29ja19kZXN0cnVjdChzdHJ1Y3Qgc29j
ayAqc2spCiAJCQlpbmV0X25ldGNvbmZfbm90aWZ5X2RldmNvbmYobmV0LCBORVRDT05GQV9NQ19G
T1JXQVJESU5HLAogCQkJCQkJICAgIE5FVENPTkZBX0lGSU5ERVhfQUxMLAogCQkJCQkJICAgIG5l
dC0+aXB2NC5kZXZjb25mX2FsbCk7Ci0JCQlSQ1VfSU5JVF9QT0lOVEVSKG1ydC0+bXJvdXRlX3Nr
LCBOVUxMKTsKKwkJCXJjdV9pbml0X3BvaW50ZXIobXJ0LT5tcm91dGVfc2ssIE5VTEwpOwogCQkJ
bXJvdXRlX2NsZWFuX3RhYmxlcyhtcnQpOwogCQl9CiAJfQpkaWZmIC0tZ2l0IGEvbmV0L2lwdjQv
bmV0ZmlsdGVyL25mX25hdF9oMzIzLmMgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X2gzMjMu
YwppbmRleCA1NzRmN2ViLi5jOTI3ZmIxIDEwMDY0NAotLS0gYS9uZXQvaXB2NC9uZXRmaWx0ZXIv
bmZfbmF0X2gzMjMuYworKysgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X2gzMjMuYwpAQCAt
NTkwLDE1ICs1OTAsMTUgQEAgc3RhdGljIGludCBfX2luaXQgaW5pdCh2b2lkKQogCUJVR19PTihu
YXRfY2FsbGZvcndhcmRpbmdfaG9vayAhPSBOVUxMKTsKIAlCVUdfT04obmF0X3E5MzFfaG9vayAh
PSBOVUxMKTsKIAotCVJDVV9JTklUX1BPSU5URVIoc2V0X2gyNDVfYWRkcl9ob29rLCBzZXRfaDI0
NV9hZGRyKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKHNldF9oMjI1X2FkZHJfaG9vaywgc2V0X2gyMjVf
YWRkcik7Ci0JUkNVX0lOSVRfUE9JTlRFUihzZXRfc2lnX2FkZHJfaG9vaywgc2V0X3NpZ19hZGRy
KTsKLQlSQ1VfSU5JVF9QT0lOVEVSKHNldF9yYXNfYWRkcl9ob29rLCBzZXRfcmFzX2FkZHIpOwot
CVJDVV9JTklUX1BPSU5URVIobmF0X3J0cF9ydGNwX2hvb2ssIG5hdF9ydHBfcnRjcCk7Ci0JUkNV
X0lOSVRfUE9JTlRFUihuYXRfdDEyMF9ob29rLCBuYXRfdDEyMCk7Ci0JUkNVX0lOSVRfUE9JTlRF
UihuYXRfaDI0NV9ob29rLCBuYXRfaDI0NSk7Ci0JUkNVX0lOSVRfUE9JTlRFUihuYXRfY2FsbGZv
cndhcmRpbmdfaG9vaywgbmF0X2NhbGxmb3J3YXJkaW5nKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5h
dF9xOTMxX2hvb2ssIG5hdF9xOTMxKTsKKwlyY3VfaW5pdF9wb2ludGVyKHNldF9oMjQ1X2FkZHJf
aG9vaywgc2V0X2gyNDVfYWRkcik7CisJcmN1X2luaXRfcG9pbnRlcihzZXRfaDIyNV9hZGRyX2hv
b2ssIHNldF9oMjI1X2FkZHIpOworCXJjdV9pbml0X3BvaW50ZXIoc2V0X3NpZ19hZGRyX2hvb2ss
IHNldF9zaWdfYWRkcik7CisJcmN1X2luaXRfcG9pbnRlcihzZXRfcmFzX2FkZHJfaG9vaywgc2V0
X3Jhc19hZGRyKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5hdF9ydHBfcnRjcF9ob29rLCBuYXRfcnRw
X3J0Y3ApOworCXJjdV9pbml0X3BvaW50ZXIobmF0X3QxMjBfaG9vaywgbmF0X3QxMjApOworCXJj
dV9pbml0X3BvaW50ZXIobmF0X2gyNDVfaG9vaywgbmF0X2gyNDUpOworCXJjdV9pbml0X3BvaW50
ZXIobmF0X2NhbGxmb3J3YXJkaW5nX2hvb2ssIG5hdF9jYWxsZm9yd2FyZGluZyk7CisJcmN1X2lu
aXRfcG9pbnRlcihuYXRfcTkzMV9ob29rLCBuYXRfcTkzMSk7CiAJbmZfY3RfaGVscGVyX2V4cGVj
dGZuX3JlZ2lzdGVyKCZxOTMxX25hdCk7CiAJbmZfY3RfaGVscGVyX2V4cGVjdGZuX3JlZ2lzdGVy
KCZjYWxsZm9yd2FyZGluZ19uYXQpOwogCXJldHVybiAwOwpAQCAtNjA3LDE1ICs2MDcsMTUgQEAg
c3RhdGljIGludCBfX2luaXQgaW5pdCh2b2lkKQogLyoqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKiovCiBzdGF0
aWMgdm9pZCBfX2V4aXQgZmluaSh2b2lkKQogewotCVJDVV9JTklUX1BPSU5URVIoc2V0X2gyNDVf
YWRkcl9ob29rLCBOVUxMKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKHNldF9oMjI1X2FkZHJfaG9vaywg
TlVMTCk7Ci0JUkNVX0lOSVRfUE9JTlRFUihzZXRfc2lnX2FkZHJfaG9vaywgTlVMTCk7Ci0JUkNV
X0lOSVRfUE9JTlRFUihzZXRfcmFzX2FkZHJfaG9vaywgTlVMTCk7Ci0JUkNVX0lOSVRfUE9JTlRF
UihuYXRfcnRwX3J0Y3BfaG9vaywgTlVMTCk7Ci0JUkNVX0lOSVRfUE9JTlRFUihuYXRfdDEyMF9o
b29rLCBOVUxMKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5hdF9oMjQ1X2hvb2ssIE5VTEwpOwotCVJD
VV9JTklUX1BPSU5URVIobmF0X2NhbGxmb3J3YXJkaW5nX2hvb2ssIE5VTEwpOwotCVJDVV9JTklU
X1BPSU5URVIobmF0X3E5MzFfaG9vaywgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihzZXRfaDI0
NV9hZGRyX2hvb2ssIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIoc2V0X2gyMjVfYWRkcl9ob29r
LCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKHNldF9zaWdfYWRkcl9ob29rLCBOVUxMKTsKKwly
Y3VfaW5pdF9wb2ludGVyKHNldF9yYXNfYWRkcl9ob29rLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2lu
dGVyKG5hdF9ydHBfcnRjcF9ob29rLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5hdF90MTIw
X2hvb2ssIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIobmF0X2gyNDVfaG9vaywgTlVMTCk7CisJ
cmN1X2luaXRfcG9pbnRlcihuYXRfY2FsbGZvcndhcmRpbmdfaG9vaywgTlVMTCk7CisJcmN1X2lu
aXRfcG9pbnRlcihuYXRfcTkzMV9ob29rLCBOVUxMKTsKIAluZl9jdF9oZWxwZXJfZXhwZWN0Zm5f
dW5yZWdpc3RlcigmcTkzMV9uYXQpOwogCW5mX2N0X2hlbHBlcl9leHBlY3Rmbl91bnJlZ2lzdGVy
KCZjYWxsZm9yd2FyZGluZ19uYXQpOwogCXN5bmNocm9uaXplX3JjdSgpOwpkaWZmIC0tZ2l0IGEv
bmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9wcHRwLmMgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZf
bmF0X3BwdHAuYwppbmRleCA2NTdkMjMwLi42M2I1OGIyIDEwMDY0NAotLS0gYS9uZXQvaXB2NC9u
ZXRmaWx0ZXIvbmZfbmF0X3BwdHAuYworKysgYi9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X3Bw
dHAuYwpAQCAtMjg1LDI1ICsyODUsMjUgQEAgc3RhdGljIGludCBfX2luaXQgbmZfbmF0X2hlbHBl
cl9wcHRwX2luaXQodm9pZCkKIAluZl9uYXRfbmVlZF9ncmUoKTsKIAogCUJVR19PTihuZl9uYXRf
cHB0cF9ob29rX291dGJvdW5kICE9IE5VTEwpOwotCVJDVV9JTklUX1BPSU5URVIobmZfbmF0X3Bw
dHBfaG9va19vdXRib3VuZCwgcHB0cF9vdXRib3VuZF9wa3QpOworCXJjdV9pbml0X3BvaW50ZXIo
bmZfbmF0X3BwdHBfaG9va19vdXRib3VuZCwgcHB0cF9vdXRib3VuZF9wa3QpOwogCiAJQlVHX09O
KG5mX25hdF9wcHRwX2hvb2tfaW5ib3VuZCAhPSBOVUxMKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5m
X25hdF9wcHRwX2hvb2tfaW5ib3VuZCwgcHB0cF9pbmJvdW5kX3BrdCk7CisJcmN1X2luaXRfcG9p
bnRlcihuZl9uYXRfcHB0cF9ob29rX2luYm91bmQsIHBwdHBfaW5ib3VuZF9wa3QpOwogCiAJQlVH
X09OKG5mX25hdF9wcHRwX2hvb2tfZXhwX2dyZSAhPSBOVUxMKTsKLQlSQ1VfSU5JVF9QT0lOVEVS
KG5mX25hdF9wcHRwX2hvb2tfZXhwX2dyZSwgcHB0cF9leHBfZ3JlKTsKKwlyY3VfaW5pdF9wb2lu
dGVyKG5mX25hdF9wcHRwX2hvb2tfZXhwX2dyZSwgcHB0cF9leHBfZ3JlKTsKIAogCUJVR19PTihu
Zl9uYXRfcHB0cF9ob29rX2V4cGVjdGZuICE9IE5VTEwpOwotCVJDVV9JTklUX1BPSU5URVIobmZf
bmF0X3BwdHBfaG9va19leHBlY3RmbiwgcHB0cF9uYXRfZXhwZWN0ZWQpOworCXJjdV9pbml0X3Bv
aW50ZXIobmZfbmF0X3BwdHBfaG9va19leHBlY3RmbiwgcHB0cF9uYXRfZXhwZWN0ZWQpOwogCXJl
dHVybiAwOwogfQogCiBzdGF0aWMgdm9pZCBfX2V4aXQgbmZfbmF0X2hlbHBlcl9wcHRwX2Zpbmko
dm9pZCkKIHsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5mX25hdF9wcHRwX2hvb2tfZXhwZWN0Zm4sIE5V
TEwpOwotCVJDVV9JTklUX1BPSU5URVIobmZfbmF0X3BwdHBfaG9va19leHBfZ3JlLCBOVUxMKTsK
LQlSQ1VfSU5JVF9QT0lOVEVSKG5mX25hdF9wcHRwX2hvb2tfaW5ib3VuZCwgTlVMTCk7Ci0JUkNV
X0lOSVRfUE9JTlRFUihuZl9uYXRfcHB0cF9ob29rX291dGJvdW5kLCBOVUxMKTsKKwlyY3VfaW5p
dF9wb2ludGVyKG5mX25hdF9wcHRwX2hvb2tfZXhwZWN0Zm4sIE5VTEwpOworCXJjdV9pbml0X3Bv
aW50ZXIobmZfbmF0X3BwdHBfaG9va19leHBfZ3JlLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVy
KG5mX25hdF9wcHRwX2hvb2tfaW5ib3VuZCwgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihuZl9u
YXRfcHB0cF9ob29rX291dGJvdW5kLCBOVUxMKTsKIAlzeW5jaHJvbml6ZV9yY3UoKTsKIH0KIApk
aWZmIC0tZ2l0IGEvbmV0L2lwdjQvbmV0ZmlsdGVyL25mX25hdF9zbm1wX2Jhc2ljLmMgYi9uZXQv
aXB2NC9uZXRmaWx0ZXIvbmZfbmF0X3NubXBfYmFzaWMuYwppbmRleCA3YzY3NjY3Li45Yjc4NmQx
IDEwMDY0NAotLS0gYS9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X3NubXBfYmFzaWMuYworKysg
Yi9uZXQvaXB2NC9uZXRmaWx0ZXIvbmZfbmF0X3NubXBfYmFzaWMuYwpAQCAtMTI5MSw3ICsxMjkx
LDcgQEAgc3RhdGljIGludCBfX2luaXQgbmZfbmF0X3NubXBfYmFzaWNfaW5pdCh2b2lkKQogCWlu
dCByZXQgPSAwOwogCiAJQlVHX09OKG5mX25hdF9zbm1wX2hvb2sgIT0gTlVMTCk7Ci0JUkNVX0lO
SVRfUE9JTlRFUihuZl9uYXRfc25tcF9ob29rLCBoZWxwKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5m
X25hdF9zbm1wX2hvb2ssIGhlbHApOwogCiAJcmV0ID0gbmZfY29ubnRyYWNrX2hlbHBlcl9yZWdp
c3Rlcigmc25tcF90cmFwX2hlbHBlcik7CiAJaWYgKHJldCA8IDApIHsKQEAgLTEzMDMsNyArMTMw
Myw3IEBAIHN0YXRpYyBpbnQgX19pbml0IG5mX25hdF9zbm1wX2Jhc2ljX2luaXQodm9pZCkKIAog
c3RhdGljIHZvaWQgX19leGl0IG5mX25hdF9zbm1wX2Jhc2ljX2Zpbmkodm9pZCkKIHsKLQlSQ1Vf
SU5JVF9QT0lOVEVSKG5mX25hdF9zbm1wX2hvb2ssIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIo
bmZfbmF0X3NubXBfaG9vaywgTlVMTCk7CiAJbmZfY29ubnRyYWNrX2hlbHBlcl91bnJlZ2lzdGVy
KCZzbm1wX3RyYXBfaGVscGVyKTsKIH0KIApkaWZmIC0tZ2l0IGEvbmV0L2lwdjQvcm91dGUuYyBi
L25ldC9pcHY0L3JvdXRlLmMKaW5kZXggZGIxZTBkYS4uMTg2ZmYwNCAxMDA2NDQKLS0tIGEvbmV0
L2lwdjQvcm91dGUuYworKysgYi9uZXQvaXB2NC9yb3V0ZS5jCkBAIC01NjMsMTIgKzU2MywxMiBA
QCBzdGF0aWMgdm9pZCBmbmhlX2ZsdXNoX3JvdXRlcyhzdHJ1Y3QgZmliX25oX2V4Y2VwdGlvbiAq
Zm5oZSkKIAogCXJ0ID0gcmN1X2RlcmVmZXJlbmNlKGZuaGUtPmZuaGVfcnRoX2lucHV0KTsKIAlp
ZiAocnQpIHsKLQkJUkNVX0lOSVRfUE9JTlRFUihmbmhlLT5mbmhlX3J0aF9pbnB1dCwgTlVMTCk7
CisJCXJjdV9pbml0X3BvaW50ZXIoZm5oZS0+Zm5oZV9ydGhfaW5wdXQsIE5VTEwpOwogCQlydF9m
cmVlKHJ0KTsKIAl9CiAJcnQgPSByY3VfZGVyZWZlcmVuY2UoZm5oZS0+Zm5oZV9ydGhfb3V0cHV0
KTsKIAlpZiAocnQpIHsKLQkJUkNVX0lOSVRfUE9JTlRFUihmbmhlLT5mbmhlX3J0aF9vdXRwdXQs
IE5VTEwpOworCQlyY3VfaW5pdF9wb2ludGVyKGZuaGUtPmZuaGVfcnRoX291dHB1dCwgTlVMTCk7
CiAJCXJ0X2ZyZWUocnQpOwogCX0KIH0KZGlmZiAtLWdpdCBhL25ldC9pcHY2L2FkZHJjb25mLmMg
Yi9uZXQvaXB2Ni9hZGRyY29uZi5jCmluZGV4IDZjN2ZhMDguLjU2M2E5ZTQgMTAwNjQ0Ci0tLSBh
L25ldC9pcHY2L2FkZHJjb25mLmMKKysrIGIvbmV0L2lwdjYvYWRkcmNvbmYuYwpAQCAtMzAxNyw3
ICszMDE3LDcgQEAgc3RhdGljIGludCBhZGRyY29uZl9pZmRvd24oc3RydWN0IG5ldF9kZXZpY2Ug
KmRldiwgaW50IGhvdykKIAkJaWRldi0+ZGVhZCA9IDE7CiAKIAkJLyogcHJvdGVjdGVkIGJ5IHJ0
bmxfbG9jayAqLwotCQlSQ1VfSU5JVF9QT0lOVEVSKGRldi0+aXA2X3B0ciwgTlVMTCk7CisJCXJj
dV9pbml0X3BvaW50ZXIoZGV2LT5pcDZfcHRyLCBOVUxMKTsKIAogCQkvKiBTdGVwIDEuNTogcmVt
b3ZlIHNubXA2IGVudHJ5ICovCiAJCXNubXA2X3VucmVnaXN0ZXJfZGV2KGlkZXYpOwpkaWZmIC0t
Z2l0IGEvbmV0L2lwdjYvaXA2X3R1bm5lbC5jIGIvbmV0L2lwdjYvaXA2X3R1bm5lbC5jCmluZGV4
IGIwNWI2MDkuLjY1MmUyOGEgMTAwNjQ0Ci0tLSBhL25ldC9pcHY2L2lwNl90dW5uZWwuYworKysg
Yi9uZXQvaXB2Ni9pcDZfdHVubmVsLmMKQEAgLTM4Niw3ICszODYsNyBAQCBpcDZfdG5sX2Rldl91
bmluaXQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikKIAlzdHJ1Y3QgaXA2X3RubF9uZXQgKmlwNm4g
PSBuZXRfZ2VuZXJpYyhuZXQsIGlwNl90bmxfbmV0X2lkKTsKIAogCWlmIChkZXYgPT0gaXA2bi0+
ZmJfdG5sX2RldikKLQkJUkNVX0lOSVRfUE9JTlRFUihpcDZuLT50bmxzX3djWzBdLCBOVUxMKTsK
KwkJcmN1X2luaXRfcG9pbnRlcihpcDZuLT50bmxzX3djWzBdLCBOVUxMKTsKIAllbHNlCiAJCWlw
Nl90bmxfdW5saW5rKGlwNm4sIHQpOwogCWlwNl90bmxfZHN0X3Jlc2V0KHQpOwpkaWZmIC0tZ2l0
IGEvbmV0L2lwdjYvaXA2X3Z0aS5jIGIvbmV0L2lwdjYvaXA2X3Z0aS5jCmluZGV4IGI3YzBmODIu
LmJmZjM3YjMgMTAwNjQ0Ci0tLSBhL25ldC9pcHY2L2lwNl92dGkuYworKysgYi9uZXQvaXB2Ni9p
cDZfdnRpLmMKQEAgLTI3NSw3ICsyNzUsNyBAQCBzdGF0aWMgdm9pZCB2dGk2X2Rldl91bmluaXQo
c3RydWN0IG5ldF9kZXZpY2UgKmRldikKIAlzdHJ1Y3QgdnRpNl9uZXQgKmlwNm4gPSBuZXRfZ2Vu
ZXJpYyhuZXQsIHZ0aTZfbmV0X2lkKTsKIAogCWlmIChkZXYgPT0gaXA2bi0+ZmJfdG5sX2RldikK
LQkJUkNVX0lOSVRfUE9JTlRFUihpcDZuLT50bmxzX3djWzBdLCBOVUxMKTsKKwkJcmN1X2luaXRf
cG9pbnRlcihpcDZuLT50bmxzX3djWzBdLCBOVUxMKTsKIAllbHNlCiAJCXZ0aTZfdG5sX3VubGlu
ayhpcDZuLCB0KTsKIAlkZXZfcHV0KGRldik7CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9uZXRmaWx0
ZXIuYyBiL25ldC9pcHY2L25ldGZpbHRlci5jCmluZGV4IDk1ZjNmMWQuLjg4ZDczYTEgMTAwNjQ0
Ci0tLSBhL25ldC9pcHY2L25ldGZpbHRlci5jCisrKyBiL25ldC9pcHY2L25ldGZpbHRlci5jCkBA
IC0yMDMsNyArMjAzLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBuZl9hZmluZm8gbmZfaXA2X2Fm
aW5mbyA9IHsKIAogaW50IF9faW5pdCBpcHY2X25ldGZpbHRlcl9pbml0KHZvaWQpCiB7Ci0JUkNV
X0lOSVRfUE9JTlRFUihuZl9pcHY2X29wcywgJmlwdjZvcHMpOworCXJjdV9pbml0X3BvaW50ZXIo
bmZfaXB2Nl9vcHMsICZpcHY2b3BzKTsKIAlyZXR1cm4gbmZfcmVnaXN0ZXJfYWZpbmZvKCZuZl9p
cDZfYWZpbmZvKTsKIH0KIApAQCAtMjEyLDYgKzIxMiw2IEBAIGludCBfX2luaXQgaXB2Nl9uZXRm
aWx0ZXJfaW5pdCh2b2lkKQogICovCiB2b2lkIGlwdjZfbmV0ZmlsdGVyX2Zpbmkodm9pZCkKIHsK
LQlSQ1VfSU5JVF9QT0lOVEVSKG5mX2lwdjZfb3BzLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVy
KG5mX2lwdjZfb3BzLCBOVUxMKTsKIAluZl91bnJlZ2lzdGVyX2FmaW5mbygmbmZfaXA2X2FmaW5m
byk7CiB9CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9yYXcuYyBiL25ldC9pcHY2L3Jhdy5jCmluZGV4
IDFmMjk5OTYuLjU5NGFjMmYgMTAwNjQ0Ci0tLSBhL25ldC9pcHY2L3Jhdy5jCisrKyBiL25ldC9p
cHY2L3Jhdy5jCkBAIC0xNDAsNyArMTQwLDcgQEAgRVhQT1JUX1NZTUJPTChyYXd2Nl9taF9maWx0
ZXJfcmVnaXN0ZXIpOwogCiBpbnQgcmF3djZfbWhfZmlsdGVyX3VucmVnaXN0ZXIobWhfZmlsdGVy
X3QgZmlsdGVyKQogewotCVJDVV9JTklUX1BPSU5URVIobWhfZmlsdGVyLCBOVUxMKTsKKwlyY3Vf
aW5pdF9wb2ludGVyKG1oX2ZpbHRlciwgTlVMTCk7CiAJc3luY2hyb25pemVfcmN1KCk7CiAJcmV0
dXJuIDA7CiB9CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9zaXQuYyBiL25ldC9pcHY2L3NpdC5jCmlu
ZGV4IGU1YTQ1M2MuLmJiZGU0MzMgMTAwNjQ0Ci0tLSBhL25ldC9pcHY2L3NpdC5jCisrKyBiL25l
dC9pcHY2L3NpdC5jCkBAIC00NzAsNyArNDcwLDcgQEAgc3RhdGljIHZvaWQgaXBpcDZfdHVubmVs
X3VuaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogCXN0cnVjdCBzaXRfbmV0ICpzaXRuID0g
bmV0X2dlbmVyaWModHVubmVsLT5uZXQsIHNpdF9uZXRfaWQpOwogCiAJaWYgKGRldiA9PSBzaXRu
LT5mYl90dW5uZWxfZGV2KSB7Ci0JCVJDVV9JTklUX1BPSU5URVIoc2l0bi0+dHVubmVsc193Y1sw
XSwgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIoc2l0bi0+dHVubmVsc193Y1swXSwgTlVMTCk7
CiAJfSBlbHNlIHsKIAkJaXBpcDZfdHVubmVsX3VubGluayhzaXRuLCB0dW5uZWwpOwogCQlpcGlw
Nl90dW5uZWxfZGVsX3BybCh0dW5uZWwsIE5VTEwpOwpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjEx
L2FnZy1yeC5jIGIvbmV0L21hYzgwMjExL2FnZy1yeC5jCmluZGV4IDMxYmYyNTguLjIyZDRkMzUg
MTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9hZ2ctcnguYworKysgYi9uZXQvbWFjODAyMTEvYWdn
LXJ4LmMKQEAgLTcyLDcgKzcyLDcgQEAgdm9pZCBfX19pZWVlODAyMTFfc3RvcF9yeF9iYV9zZXNz
aW9uKHN0cnVjdCBzdGFfaW5mbyAqc3RhLCB1MTYgdGlkLAogCWlmICghdGlkX3J4KQogCQlyZXR1
cm47CiAKLQlSQ1VfSU5JVF9QT0lOVEVSKHN0YS0+YW1wZHVfbWxtZS50aWRfcnhbdGlkXSwgTlVM
TCk7CisJcmN1X2luaXRfcG9pbnRlcihzdGEtPmFtcGR1X21sbWUudGlkX3J4W3RpZF0sIE5VTEwp
OwogCiAJaHRfZGJnKHN0YS0+c2RhdGEsCiAJICAgICAgICJSeCBCQSBzZXNzaW9uIHN0b3AgcmVx
dWVzdGVkIGZvciAlcE0gdGlkICV1ICVzIHJlYXNvbjogJWRcbiIsCmRpZmYgLS1naXQgYS9uZXQv
bWFjODAyMTEvY2ZnLmMgYi9uZXQvbWFjODAyMTEvY2ZnLmMKaW5kZXggYWFhNTlkNy4uMzgzOTc2
NCAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL2NmZy5jCisrKyBiL25ldC9tYWM4MDIxMS9jZmcu
YwpAQCAtNjQsNyArNjQsNyBAQCBzdGF0aWMgaW50IGllZWU4MDIxMV9jaGFuZ2VfaWZhY2Uoc3Ry
dWN0IHdpcGh5ICp3aXBoeSwKIAogCWlmICh0eXBlID09IE5MODAyMTFfSUZUWVBFX0FQX1ZMQU4g
JiYKIAkgICAgcGFyYW1zICYmIHBhcmFtcy0+dXNlXzRhZGRyID09IDApCi0JCVJDVV9JTklUX1BP
SU5URVIoc2RhdGEtPnUudmxhbi5zdGEsIE5VTEwpOworCQlyY3VfaW5pdF9wb2ludGVyKHNkYXRh
LT51LnZsYW4uc3RhLCBOVUxMKTsKIAllbHNlIGlmICh0eXBlID09IE5MODAyMTFfSUZUWVBFX1NU
QVRJT04gJiYKIAkJIHBhcmFtcyAmJiBwYXJhbXMtPnVzZV80YWRkciA+PSAwKQogCQlzZGF0YS0+
dS5tZ2QudXNlXzRhZGRyID0gcGFyYW1zLT51c2VfNGFkZHI7CkBAIC0xMDMzLDcgKzEwMzMsNyBA
QCBzdGF0aWMgaW50IGllZWU4MDIxMV9zdGFydF9hcChzdHJ1Y3Qgd2lwaHkgKndpcGh5LCBzdHJ1
Y3QgbmV0X2RldmljZSAqZGV2LAogCiAJCWlmIChvbGQpCiAJCQlrZnJlZV9yY3Uob2xkLCByY3Vf
aGVhZCk7Ci0JCVJDVV9JTklUX1BPSU5URVIoc2RhdGEtPnUuYXAuYmVhY29uLCBOVUxMKTsKKwkJ
cmN1X2luaXRfcG9pbnRlcihzZGF0YS0+dS5hcC5iZWFjb24sIE5VTEwpOwogCQlpZWVlODAyMTFf
dmlmX3JlbGVhc2VfY2hhbm5lbChzZGF0YSk7CiAJCXJldHVybiBlcnI7CiAJfQpAQCAtMTEwMiw4
ICsxMTAyLDggQEAgc3RhdGljIGludCBpZWVlODAyMTFfc3RvcF9hcChzdHJ1Y3Qgd2lwaHkgKndp
cGh5LCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogCW5ldGlmX2NhcnJpZXJfb2ZmKGRldik7CiAK
IAkvKiByZW1vdmUgYmVhY29uIGFuZCBwcm9iZSByZXNwb25zZSAqLwotCVJDVV9JTklUX1BPSU5U
RVIoc2RhdGEtPnUuYXAuYmVhY29uLCBOVUxMKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKHNkYXRhLT51
LmFwLnByb2JlX3Jlc3AsIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIoc2RhdGEtPnUuYXAuYmVh
Y29uLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKHNkYXRhLT51LmFwLnByb2JlX3Jlc3AsIE5V
TEwpOwogCWtmcmVlX3JjdShvbGRfYmVhY29uLCByY3VfaGVhZCk7CiAJaWYgKG9sZF9wcm9iZV9y
ZXNwKQogCQlrZnJlZV9yY3Uob2xkX3Byb2JlX3Jlc3AsIHJjdV9oZWFkKTsKZGlmZiAtLWdpdCBh
L25ldC9tYWM4MDIxMS9pYnNzLmMgYi9uZXQvbWFjODAyMTEvaWJzcy5jCmluZGV4IDA2ZDI4Nzgu
LmJkNDc3YzIgMTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9pYnNzLmMKKysrIGIvbmV0L21hYzgw
MjExL2lic3MuYwpAQCAtMzY1LDcgKzM2NSw3IEBAIHN0YXRpYyB2b2lkIF9faWVlZTgwMjExX3N0
YV9qb2luX2lic3Moc3RydWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGEsCiAJCXNkYXRh
LT52aWYuYnNzX2NvbmYuaWJzc19jcmVhdG9yID0gZmFsc2U7CiAJCXNkYXRhLT52aWYuYnNzX2Nv
bmYuZW5hYmxlX2JlYWNvbiA9IGZhbHNlOwogCQlzZGF0YS0+dmlmLmJzc19jb25mLnNzaWRfbGVu
ID0gMDsKLQkJUkNVX0lOSVRfUE9JTlRFUihpZmlic3MtPnByZXNwLCBOVUxMKTsKKwkJcmN1X2lu
aXRfcG9pbnRlcihpZmlic3MtPnByZXNwLCBOVUxMKTsKIAkJa2ZyZWVfcmN1KHByZXNwLCByY3Vf
aGVhZCk7CiAJCW11dGV4X2xvY2soJmxvY2FsLT5tdHgpOwogCQlpZWVlODAyMTFfdmlmX3JlbGVh
c2VfY2hhbm5lbChzZGF0YSk7CkBAIC03MzUsNyArNzM1LDcgQEAgc3RhdGljIHZvaWQgaWVlZTgw
MjExX2lic3NfZGlzY29ubmVjdChzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSkK
IAkvKiByZW1vdmUgYmVhY29uICovCiAJcHJlc3AgPSByY3VfZGVyZWZlcmVuY2VfcHJvdGVjdGVk
KGlmaWJzcy0+cHJlc3AsCiAJCQkJCSAgbG9ja2RlcF9pc19oZWxkKCZzZGF0YS0+d2Rldi5tdHgp
KTsKLQlSQ1VfSU5JVF9QT0lOVEVSKHNkYXRhLT51Lmlic3MucHJlc3AsIE5VTEwpOworCXJjdV9p
bml0X3BvaW50ZXIoc2RhdGEtPnUuaWJzcy5wcmVzcCwgTlVMTCk7CiAJaWYgKHByZXNwKQogCQlr
ZnJlZV9yY3UocHJlc3AsIHJjdV9oZWFkKTsKIApkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL21l
c2guYyBiL25ldC9tYWM4MDIxMS9tZXNoLmMKaW5kZXggZjcwZTljZC4uOTI3MTUzNyAxMDA2NDQK
LS0tIGEvbmV0L21hYzgwMjExL21lc2guYworKysgYi9uZXQvbWFjODAyMTEvbWVzaC5jCkBAIC0x
MzQxLDcgKzEzNDEsNyBAQCB2b2lkIGllZWU4MDIxMV9tZXNoX2luaXRfc2RhdGEoc3RydWN0IGll
ZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGEpCiAJc2tiX3F1ZXVlX2hlYWRfaW5pdCgmaWZtc2gt
PnBzLmJjX2J1Zik7CiAJc3Bpbl9sb2NrX2luaXQoJmlmbXNoLT5tZXNoX3ByZXFfcXVldWVfbG9j
ayk7CiAJc3Bpbl9sb2NrX2luaXQoJmlmbXNoLT5zeW5jX29mZnNldF9sb2NrKTsKLQlSQ1VfSU5J
VF9QT0lOVEVSKGlmbXNoLT5iZWFjb24sIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIoaWZtc2gt
PmJlYWNvbiwgTlVMTCk7CiAKIAlzZGF0YS0+dmlmLmJzc19jb25mLmJzc2lkID0gemVyb19hZGRy
OwogfQpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL21lc2hfcGF0aHRibC5jIGIvbmV0L21hYzgw
MjExL21lc2hfcGF0aHRibC5jCmluZGV4IDdkMDUwZWQuLjVkYjU0MzAgMTAwNjQ0Ci0tLSBhL25l
dC9tYWM4MDIxMS9tZXNoX3BhdGh0YmwuYworKysgYi9uZXQvbWFjODAyMTEvbWVzaF9wYXRodGJs
LmMKQEAgLTEwNjgsOCArMTA2OCw4IEBAIGludCBtZXNoX3BhdGh0YmxfaW5pdCh2b2lkKQogCUlO
SVRfSExJU1RfSEVBRCh0YmxfbXBwLT5rbm93bl9nYXRlcyk7CiAKIAkvKiBOZWVkIG5vIGxvY2tp
bmcgc2luY2UgdGhpcyBpcyBkdXJpbmcgaW5pdCAqLwotCVJDVV9JTklUX1BPSU5URVIobWVzaF9w
YXRocywgdGJsX3BhdGgpOwotCVJDVV9JTklUX1BPSU5URVIobXBwX3BhdGhzLCB0YmxfbXBwKTsK
KwlyY3VfaW5pdF9wb2ludGVyKG1lc2hfcGF0aHMsIHRibF9wYXRoKTsKKwlyY3VfaW5pdF9wb2lu
dGVyKG1wcF9wYXRocywgdGJsX21wcCk7CiAKIAlyZXR1cm4gMDsKIApkaWZmIC0tZ2l0IGEvbmV0
L21hYzgwMjExL3N0YV9pbmZvLmMgYi9uZXQvbWFjODAyMTEvc3RhX2luZm8uYwppbmRleCAxMzdh
MTkyLi4wZDJjMGJmIDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEvc3RhX2luZm8uYworKysgYi9u
ZXQvbWFjODAyMTEvc3RhX2luZm8uYwpAQCAtODYwLDcgKzg2MCw3IEBAIHN0YXRpYyBpbnQgX19t
dXN0X2NoZWNrIF9fc3RhX2luZm9fZGVzdHJveV9wYXJ0MShzdHJ1Y3Qgc3RhX2luZm8gKnN0YSkK
IAogCWlmIChzZGF0YS0+dmlmLnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfQVBfVkxBTiAmJgogCSAg
ICByY3VfYWNjZXNzX3BvaW50ZXIoc2RhdGEtPnUudmxhbi5zdGEpID09IHN0YSkKLQkJUkNVX0lO
SVRfUE9JTlRFUihzZGF0YS0+dS52bGFuLnN0YSwgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIo
c2RhdGEtPnUudmxhbi5zdGEsIE5VTEwpOwogCiAJcmV0dXJuIDA7CiB9CmRpZmYgLS1naXQgYS9u
ZXQvbmV0ZmlsdGVyL2NvcmUuYyBiL25ldC9uZXRmaWx0ZXIvY29yZS5jCmluZGV4IDFmYmFiMGMu
LjVmODhhNzMgMTAwNjQ0Ci0tLSBhL25ldC9uZXRmaWx0ZXIvY29yZS5jCisrKyBiL25ldC9uZXRm
aWx0ZXIvY29yZS5jCkBAIC00MCw3ICs0MCw3IEBAIGludCBuZl9yZWdpc3Rlcl9hZmluZm8oY29u
c3Qgc3RydWN0IG5mX2FmaW5mbyAqYWZpbmZvKQogCWVyciA9IG11dGV4X2xvY2tfaW50ZXJydXB0
aWJsZSgmYWZpbmZvX211dGV4KTsKIAlpZiAoZXJyIDwgMCkKIAkJcmV0dXJuIGVycjsKLQlSQ1Vf
SU5JVF9QT0lOVEVSKG5mX2FmaW5mb1thZmluZm8tPmZhbWlseV0sIGFmaW5mbyk7CisJcmN1X2lu
aXRfcG9pbnRlcihuZl9hZmluZm9bYWZpbmZvLT5mYW1pbHldLCBhZmluZm8pOwogCW11dGV4X3Vu
bG9jaygmYWZpbmZvX211dGV4KTsKIAlyZXR1cm4gMDsKIH0KQEAgLTQ5LDcgKzQ5LDcgQEAgRVhQ
T1JUX1NZTUJPTF9HUEwobmZfcmVnaXN0ZXJfYWZpbmZvKTsKIHZvaWQgbmZfdW5yZWdpc3Rlcl9h
ZmluZm8oY29uc3Qgc3RydWN0IG5mX2FmaW5mbyAqYWZpbmZvKQogewogCW11dGV4X2xvY2soJmFm
aW5mb19tdXRleCk7Ci0JUkNVX0lOSVRfUE9JTlRFUihuZl9hZmluZm9bYWZpbmZvLT5mYW1pbHld
LCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5mX2FmaW5mb1thZmluZm8tPmZhbWlseV0sIE5V
TEwpOwogCW11dGV4X3VubG9jaygmYWZpbmZvX211dGV4KTsKIAlzeW5jaHJvbml6ZV9yY3UoKTsK
IH0KZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvaXB2cy9pcF92c19jdGwuYyBiL25ldC9uZXRm
aWx0ZXIvaXB2cy9pcF92c19jdGwuYwppbmRleCBjNDJlODNkLi5lOGI2MDlkIDEwMDY0NAotLS0g
YS9uZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNfY3RsLmMKKysrIGIvbmV0L25ldGZpbHRlci9pcHZz
L2lwX3ZzX2N0bC5jCkBAIC02NDEsNyArNjQxLDcgQEAgc3RhdGljIHZvaWQgX19pcF92c19kc3Rf
Y2FjaGVfcmVzZXQoc3RydWN0IGlwX3ZzX2Rlc3QgKmRlc3QpCiAKIAlvbGQgPSByY3VfZGVyZWZl
cmVuY2VfcHJvdGVjdGVkKGRlc3QtPmRlc3RfZHN0LCAxKTsKIAlpZiAob2xkKSB7Ci0JCVJDVV9J
TklUX1BPSU5URVIoZGVzdC0+ZGVzdF9kc3QsIE5VTEwpOworCQlyY3VfaW5pdF9wb2ludGVyKGRl
c3QtPmRlc3RfZHN0LCBOVUxMKTsKIAkJY2FsbF9yY3UoJm9sZC0+cmN1X2hlYWQsIGlwX3ZzX2Rl
c3RfZHN0X3JjdV9mcmVlKTsKIAl9CiB9CkBAIC0xMjIxLDcgKzEyMjEsNyBAQCBpcF92c19hZGRf
c2VydmljZShzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBpcF92c19zZXJ2aWNlX3VzZXJfa2VybiAq
dSwKIAlzY2hlZCA9IE5VTEw7CiAKIAkvKiBCaW5kIHRoZSBjdCByZXRyaWV2ZXIgKi8KLQlSQ1Vf
SU5JVF9QT0lOVEVSKHN2Yy0+cGUsIHBlKTsKKwlyY3VfaW5pdF9wb2ludGVyKHN2Yy0+cGUsIHBl
KTsKIAlwZSA9IE5VTEw7CiAKIAkvKiBVcGRhdGUgdGhlIHZpcnR1YWwgc2VydmljZSBjb3VudGVy
cyAqLwpkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9pcHZzL2lwX3ZzX2RoLmMgYi9uZXQvbmV0
ZmlsdGVyL2lwdnMvaXBfdnNfZGguYwppbmRleCBjM2I4NDU0Li42Y2QwOWMxIDEwMDY0NAotLS0g
YS9uZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNfZGguYworKysgYi9uZXQvbmV0ZmlsdGVyL2lwdnMv
aXBfdnNfZGguYwpAQCAtMTE1LDE0ICsxMTUsMTQgQEAgaXBfdnNfZGhfcmVhc3NpZ24oc3RydWN0
IGlwX3ZzX2RoX3N0YXRlICpzLCBzdHJ1Y3QgaXBfdnNfc2VydmljZSAqc3ZjKQogCQlpZiAoZGVz
dCkKIAkJCWlwX3ZzX2Rlc3RfcHV0KGRlc3QpOwogCQlpZiAoZW1wdHkpCi0JCQlSQ1VfSU5JVF9Q
T0lOVEVSKGItPmRlc3QsIE5VTEwpOworCQkJcmN1X2luaXRfcG9pbnRlcihiLT5kZXN0LCBOVUxM
KTsKIAkJZWxzZSB7CiAJCQlpZiAocCA9PSAmc3ZjLT5kZXN0aW5hdGlvbnMpCiAJCQkJcCA9IHAt
Pm5leHQ7CiAKIAkJCWRlc3QgPSBsaXN0X2VudHJ5KHAsIHN0cnVjdCBpcF92c19kZXN0LCBuX2xp
c3QpOwogCQkJaXBfdnNfZGVzdF9ob2xkKGRlc3QpOwotCQkJUkNVX0lOSVRfUE9JTlRFUihiLT5k
ZXN0LCBkZXN0KTsKKwkJCXJjdV9pbml0X3BvaW50ZXIoYi0+ZGVzdCwgZGVzdCk7CiAKIAkJCXAg
PSBwLT5uZXh0OwogCQl9CkBAIC0xNDYsNyArMTQ2LDcgQEAgc3RhdGljIHZvaWQgaXBfdnNfZGhf
Zmx1c2goc3RydWN0IGlwX3ZzX2RoX3N0YXRlICpzKQogCQlkZXN0ID0gcmN1X2RlcmVmZXJlbmNl
X3Byb3RlY3RlZChiLT5kZXN0LCAxKTsKIAkJaWYgKGRlc3QpIHsKIAkJCWlwX3ZzX2Rlc3RfcHV0
KGRlc3QpOwotCQkJUkNVX0lOSVRfUE9JTlRFUihiLT5kZXN0LCBOVUxMKTsKKwkJCXJjdV9pbml0
X3BvaW50ZXIoYi0+ZGVzdCwgTlVMTCk7CiAJCX0KIAkJYisrOwogCX0KZGlmZiAtLWdpdCBhL25l
dC9uZXRmaWx0ZXIvaXB2cy9pcF92c19zaC5jIGIvbmV0L25ldGZpbHRlci9pcHZzL2lwX3ZzX3No
LmMKaW5kZXggY2M2NWIyZi4uNmEzZTg4NSAxMDA2NDQKLS0tIGEvbmV0L25ldGZpbHRlci9pcHZz
L2lwX3ZzX3NoLmMKKysrIGIvbmV0L25ldGZpbHRlci9pcHZzL2lwX3ZzX3NoLmMKQEAgLTE4Miwx
NCArMTgyLDE0IEBAIGlwX3ZzX3NoX3JlYXNzaWduKHN0cnVjdCBpcF92c19zaF9zdGF0ZSAqcywg
c3RydWN0IGlwX3ZzX3NlcnZpY2UgKnN2YykKIAkJaWYgKGRlc3QpCiAJCQlpcF92c19kZXN0X3B1
dChkZXN0KTsKIAkJaWYgKGVtcHR5KQotCQkJUkNVX0lOSVRfUE9JTlRFUihiLT5kZXN0LCBOVUxM
KTsKKwkJCXJjdV9pbml0X3BvaW50ZXIoYi0+ZGVzdCwgTlVMTCk7CiAJCWVsc2UgewogCQkJaWYg
KHAgPT0gJnN2Yy0+ZGVzdGluYXRpb25zKQogCQkJCXAgPSBwLT5uZXh0OwogCiAJCQlkZXN0ID0g
bGlzdF9lbnRyeShwLCBzdHJ1Y3QgaXBfdnNfZGVzdCwgbl9saXN0KTsKIAkJCWlwX3ZzX2Rlc3Rf
aG9sZChkZXN0KTsKLQkJCVJDVV9JTklUX1BPSU5URVIoYi0+ZGVzdCwgZGVzdCk7CisJCQlyY3Vf
aW5pdF9wb2ludGVyKGItPmRlc3QsIGRlc3QpOwogCiAJCQlJUF9WU19EQkdfQlVGKDYsICJhc3Np
Z25lZCBpOiAlZCBkZXN0OiAlcyB3ZWlnaHQ6ICVkXG4iLAogCQkJCSAgICAgIGksIElQX1ZTX0RC
R19BRERSKHN2Yy0+YWYsICZkZXN0LT5hZGRyKSwKQEAgLTIyMiw3ICsyMjIsNyBAQCBzdGF0aWMg
dm9pZCBpcF92c19zaF9mbHVzaChzdHJ1Y3QgaXBfdnNfc2hfc3RhdGUgKnMpCiAJCWRlc3QgPSBy
Y3VfZGVyZWZlcmVuY2VfcHJvdGVjdGVkKGItPmRlc3QsIDEpOwogCQlpZiAoZGVzdCkgewogCQkJ
aXBfdnNfZGVzdF9wdXQoZGVzdCk7Ci0JCQlSQ1VfSU5JVF9QT0lOVEVSKGItPmRlc3QsIE5VTEwp
OworCQkJcmN1X2luaXRfcG9pbnRlcihiLT5kZXN0LCBOVUxMKTsKIAkJfQogCQliKys7CiAJfQpk
aWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfY29yZS5jIGIvbmV0L25ldGZp
bHRlci9uZl9jb25udHJhY2tfY29yZS5jCmluZGV4IDc1NDIxZjIuLjU3ZTEzMDggMTAwNjQ0Ci0t
LSBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2NvcmUuYworKysgYi9uZXQvbmV0ZmlsdGVy
L25mX2Nvbm50cmFja19jb3JlLmMKQEAgLTE0OTgsMTIgKzE0OTgsMTIgQEAgc3RhdGljIGludCB1
bnRyYWNrX3JlZnModm9pZCkKIAogdm9pZCBuZl9jb25udHJhY2tfY2xlYW51cF9zdGFydCh2b2lk
KQogewotCVJDVV9JTklUX1BPSU5URVIoaXBfY3RfYXR0YWNoLCBOVUxMKTsKKwlyY3VfaW5pdF9w
b2ludGVyKGlwX2N0X2F0dGFjaCwgTlVMTCk7CiB9CiAKIHZvaWQgbmZfY29ubnRyYWNrX2NsZWFu
dXBfZW5kKHZvaWQpCiB7Ci0JUkNVX0lOSVRfUE9JTlRFUihuZl9jdF9kZXN0cm95LCBOVUxMKTsK
KwlyY3VfaW5pdF9wb2ludGVyKG5mX2N0X2Rlc3Ryb3ksIE5VTEwpOwogCXdoaWxlICh1bnRyYWNr
X3JlZnMoKSA+IDApCiAJCXNjaGVkdWxlKCk7CiAKQEAgLTE3NzgsOCArMTc3OCw4IEBAIGVycl9l
eHBlY3Q6CiB2b2lkIG5mX2Nvbm50cmFja19pbml0X2VuZCh2b2lkKQogewogCS8qIEZvciB1c2Ug
YnkgUkVKRUNUIHRhcmdldCAqLwotCVJDVV9JTklUX1BPSU5URVIoaXBfY3RfYXR0YWNoLCBuZl9j
b25udHJhY2tfYXR0YWNoKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5mX2N0X2Rlc3Ryb3ksIGRlc3Ry
b3lfY29ubnRyYWNrKTsKKwlyY3VfaW5pdF9wb2ludGVyKGlwX2N0X2F0dGFjaCwgbmZfY29ubnRy
YWNrX2F0dGFjaCk7CisJcmN1X2luaXRfcG9pbnRlcihuZl9jdF9kZXN0cm95LCBkZXN0cm95X2Nv
bm50cmFjayk7CiB9CiAKIC8qCmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFj
a19lY2FjaGUuYyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2VjYWNoZS5jCmluZGV4IDFk
ZjE3NjEuLjMwYmEzYjAgMTAwNjQ0Ci0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2Vj
YWNoZS5jCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2VjYWNoZS5jCkBAIC0xMTQs
NyArMTE0LDcgQEAgdm9pZCBuZl9jb25udHJhY2tfdW5yZWdpc3Rlcl9ub3RpZmllcihzdHJ1Y3Qg
bmV0ICpuZXQsCiAJbm90aWZ5ID0gcmN1X2RlcmVmZXJlbmNlX3Byb3RlY3RlZChuZXQtPmN0Lm5m
X2Nvbm50cmFja19ldmVudF9jYiwKIAkJCQkJICAgbG9ja2RlcF9pc19oZWxkKCZuZl9jdF9lY2Fj
aGVfbXV0ZXgpKTsKIAlCVUdfT04obm90aWZ5ICE9IG5ldyk7Ci0JUkNVX0lOSVRfUE9JTlRFUihu
ZXQtPmN0Lm5mX2Nvbm50cmFja19ldmVudF9jYiwgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihu
ZXQtPmN0Lm5mX2Nvbm50cmFja19ldmVudF9jYiwgTlVMTCk7CiAJbXV0ZXhfdW5sb2NrKCZuZl9j
dF9lY2FjaGVfbXV0ZXgpOwogfQogRVhQT1JUX1NZTUJPTF9HUEwobmZfY29ubnRyYWNrX3VucmVn
aXN0ZXJfbm90aWZpZXIpOwpAQCAtMTUwLDcgKzE1MCw3IEBAIHZvaWQgbmZfY3RfZXhwZWN0X3Vu
cmVnaXN0ZXJfbm90aWZpZXIoc3RydWN0IG5ldCAqbmV0LAogCW5vdGlmeSA9IHJjdV9kZXJlZmVy
ZW5jZV9wcm90ZWN0ZWQobmV0LT5jdC5uZl9leHBlY3RfZXZlbnRfY2IsCiAJCQkJCSAgIGxvY2tk
ZXBfaXNfaGVsZCgmbmZfY3RfZWNhY2hlX211dGV4KSk7CiAJQlVHX09OKG5vdGlmeSAhPSBuZXcp
OwotCVJDVV9JTklUX1BPSU5URVIobmV0LT5jdC5uZl9leHBlY3RfZXZlbnRfY2IsIE5VTEwpOwor
CXJjdV9pbml0X3BvaW50ZXIobmV0LT5jdC5uZl9leHBlY3RfZXZlbnRfY2IsIE5VTEwpOwogCW11
dGV4X3VubG9jaygmbmZfY3RfZWNhY2hlX211dGV4KTsKIH0KIEVYUE9SVF9TWU1CT0xfR1BMKG5m
X2N0X2V4cGVjdF91bnJlZ2lzdGVyX25vdGlmaWVyKTsKZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0
ZXIvbmZfY29ubnRyYWNrX2V4dGVuZC5jIGIvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfZXh0
ZW5kLmMKaW5kZXggMWE5NTQ1OS4uYmJiZWE1OWIgMTAwNjQ0Ci0tLSBhL25ldC9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX2V4dGVuZC5jCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2V4
dGVuZC5jCkBAIC0xODMsNyArMTgzLDcgQEAgRVhQT1JUX1NZTUJPTF9HUEwobmZfY3RfZXh0ZW5k
X3JlZ2lzdGVyKTsKIHZvaWQgbmZfY3RfZXh0ZW5kX3VucmVnaXN0ZXIoc3RydWN0IG5mX2N0X2V4
dF90eXBlICp0eXBlKQogewogCW11dGV4X2xvY2soJm5mX2N0X2V4dF90eXBlX211dGV4KTsKLQlS
Q1VfSU5JVF9QT0lOVEVSKG5mX2N0X2V4dF90eXBlc1t0eXBlLT5pZF0sIE5VTEwpOworCXJjdV9p
bml0X3BvaW50ZXIobmZfY3RfZXh0X3R5cGVzW3R5cGUtPmlkXSwgTlVMTCk7CiAJdXBkYXRlX2Fs
bG9jX3NpemUodHlwZSk7CiAJbXV0ZXhfdW5sb2NrKCZuZl9jdF9leHRfdHlwZV9tdXRleCk7CiAJ
cmN1X2JhcnJpZXIoKTsgLyogV2FpdCBmb3IgY29tcGxldGlvbiBvZiBjYWxsX3JjdSgpJ3MgKi8K
ZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2hlbHBlci5jIGIvbmV0L25l
dGZpbHRlci9uZl9jb25udHJhY2tfaGVscGVyLmMKaW5kZXggNWIzZWFlNy4uYTRkY2U3ZiAxMDA2
NDQKLS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfaGVscGVyLmMKKysrIGIvbmV0L25l
dGZpbHRlci9uZl9jb25udHJhY2tfaGVscGVyLmMKQEAgLTIyMiw3ICsyMjIsNyBAQCBpbnQgX19u
Zl9jdF90cnlfYXNzaWduX2hlbHBlcihzdHJ1Y3QgbmZfY29ubiAqY3QsIHN0cnVjdCBuZl9jb25u
ICp0bXBsLAogCiAJaWYgKGhlbHBlciA9PSBOVUxMKSB7CiAJCWlmIChoZWxwKQotCQkJUkNVX0lO
SVRfUE9JTlRFUihoZWxwLT5oZWxwZXIsIE5VTEwpOworCQkJcmN1X2luaXRfcG9pbnRlcihoZWxw
LT5oZWxwZXIsIE5VTEwpOwogCQlnb3RvIG91dDsKIAl9CiAKQEAgLTIzOSw3ICsyMzksNyBAQCBp
bnQgX19uZl9jdF90cnlfYXNzaWduX2hlbHBlcihzdHJ1Y3QgbmZfY29ubiAqY3QsIHN0cnVjdCBu
Zl9jb25uICp0bXBsLAogCQlzdHJ1Y3QgbmZfY29ubnRyYWNrX2hlbHBlciAqdG1wID0gcmN1X2Rl
cmVmZXJlbmNlKGhlbHAtPmhlbHBlcik7CiAKIAkJaWYgKHRtcCAmJiB0bXAtPmhlbHAgIT0gaGVs
cGVyLT5oZWxwKSB7Ci0JCQlSQ1VfSU5JVF9QT0lOVEVSKGhlbHAtPmhlbHBlciwgTlVMTCk7CisJ
CQlyY3VfaW5pdF9wb2ludGVyKGhlbHAtPmhlbHBlciwgTlVMTCk7CiAJCQlnb3RvIG91dDsKIAkJ
fQogCX0KQEAgLTI1OSw3ICsyNTksNyBAQCBzdGF0aWMgaW5saW5lIGludCB1bmhlbHAoc3RydWN0
IG5mX2Nvbm50cmFja190dXBsZV9oYXNoICppLAogCiAJaWYgKGhlbHAgJiYgcmN1X2RlcmVmZXJl
bmNlX3JhdyhoZWxwLT5oZWxwZXIpID09IG1lKSB7CiAJCW5mX2Nvbm50cmFja19ldmVudChJUENU
X0hFTFBFUiwgY3QpOwotCQlSQ1VfSU5JVF9QT0lOVEVSKGhlbHAtPmhlbHBlciwgTlVMTCk7CisJ
CXJjdV9pbml0X3BvaW50ZXIoaGVscC0+aGVscGVyLCBOVUxMKTsKIAl9CiAJcmV0dXJuIDA7CiB9
CmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19uZXRsaW5rLmMgYi9uZXQv
bmV0ZmlsdGVyL25mX2Nvbm50cmFja19uZXRsaW5rLmMKaW5kZXggY2NjNDZmYS4uZjE0NzY1NiAx
MDA2NDQKLS0tIGEvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfbmV0bGluay5jCisrKyBiL25l
dC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX25ldGxpbmsuYwpAQCAtMTM3Miw3ICsxMzcyLDcgQEAg
Y3RuZXRsaW5rX2NoYW5nZV9oZWxwZXIoc3RydWN0IG5mX2Nvbm4gKmN0LCBjb25zdCBzdHJ1Y3Qg
bmxhdHRyICogY29uc3QgY2RhW10pCiAJCWlmIChoZWxwICYmIGhlbHAtPmhlbHBlcikgewogCQkJ
Lyogd2UgaGFkIGEgaGVscGVyIGJlZm9yZSAuLi4gKi8KIAkJCW5mX2N0X3JlbW92ZV9leHBlY3Rh
dGlvbnMoY3QpOwotCQkJUkNVX0lOSVRfUE9JTlRFUihoZWxwLT5oZWxwZXIsIE5VTEwpOworCQkJ
cmN1X2luaXRfcG9pbnRlcihoZWxwLT5oZWxwZXIsIE5VTEwpOwogCQl9CiAKIAkJcmV0dXJuIDA7
CkBAIC0xNjY2LDcgKzE2NjYsNyBAQCBjdG5ldGxpbmtfY3JlYXRlX2Nvbm50cmFjayhzdHJ1Y3Qg
bmV0ICpuZXQsIHUxNiB6b25lLAogCQkJCWhlbHBlci0+ZnJvbV9ubGF0dHIoaGVscGluZm8sIGN0
KTsKIAogCQkJLyogbm90IGluIGhhc2ggdGFibGUgeWV0IHNvIG5vdCBzdHJpY3RseSBuZWNlc3Nh
cnkgKi8KLQkJCVJDVV9JTklUX1BPSU5URVIoaGVscC0+aGVscGVyLCBoZWxwZXIpOworCQkJcmN1
X2luaXRfcG9pbnRlcihoZWxwLT5oZWxwZXIsIGhlbHBlcik7CiAJCX0KIAl9IGVsc2UgewogCQkv
KiB0cnkgYW4gaW1wbGljaXQgaGVscGVyIGFzc2lnbmF0aW9uICovCkBAIC0zMjEzLDcgKzMyMTMs
NyBAQCBzdGF0aWMgaW50IF9faW5pdCBjdG5ldGxpbmtfaW5pdCh2b2lkKQogCX0KICNpZmRlZiBD
T05GSUdfTkVURklMVEVSX05FVExJTktfUVVFVUVfQ1QKIAkvKiBzZXR1cCBpbnRlcmFjdGlvbiBi
ZXR3ZWVuIG5mX3F1ZXVlIGFuZCBuZl9jb25udHJhY2tfbmV0bGluay4gKi8KLQlSQ1VfSU5JVF9Q
T0lOVEVSKG5mcV9jdF9ob29rLCAmY3RuZXRsaW5rX25mcXVldWVfaG9vayk7CisJcmN1X2luaXRf
cG9pbnRlcihuZnFfY3RfaG9vaywgJmN0bmV0bGlua19uZnF1ZXVlX2hvb2spOwogI2VuZGlmCiAJ
cmV0dXJuIDA7CiAKQEAgLTMyMzMsNyArMzIzMyw3IEBAIHN0YXRpYyB2b2lkIF9fZXhpdCBjdG5l
dGxpbmtfZXhpdCh2b2lkKQogCW5mbmV0bGlua19zdWJzeXNfdW5yZWdpc3RlcigmY3RubF9leHBf
c3Vic3lzKTsKIAluZm5ldGxpbmtfc3Vic3lzX3VucmVnaXN0ZXIoJmN0bmxfc3Vic3lzKTsKICNp
ZmRlZiBDT05GSUdfTkVURklMVEVSX05FVExJTktfUVVFVUVfQ1QKLQlSQ1VfSU5JVF9QT0lOVEVS
KG5mcV9jdF9ob29rLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5mcV9jdF9ob29rLCBOVUxM
KTsKICNlbmRpZgogfQogCmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19w
cm90by5jIGIvbmV0L25ldGZpbHRlci9uZl9jb25udHJhY2tfcHJvdG8uYwppbmRleCBiNjVkNTg2
Li4yZGM3ZjcyIDEwMDY0NAotLS0gYS9uZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19wcm90by5j
CisrKyBiL25ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvLmMKQEAgLTM4NCw3ICszODQs
NyBAQCBpbnQgbmZfY3RfbDRwcm90b19yZWdpc3RlcihzdHJ1Y3QgbmZfY29ubnRyYWNrX2w0cHJv
dG8gKmw0cHJvdG8pCiAJCX0KIAogCQlmb3IgKGkgPSAwOyBpIDwgTUFYX05GX0NUX1BST1RPOyBp
KyspCi0JCQlSQ1VfSU5JVF9QT0lOVEVSKHByb3RvX2FycmF5W2ldLCAmbmZfY29ubnRyYWNrX2w0
cHJvdG9fZ2VuZXJpYyk7CisJCQlyY3VfaW5pdF9wb2ludGVyKHByb3RvX2FycmF5W2ldLCAmbmZf
Y29ubnRyYWNrX2w0cHJvdG9fZ2VuZXJpYyk7CiAKIAkJLyogQmVmb3JlIG1ha2luZyBwcm90b19h
cnJheSB2aXNpYmxlIHRvIGxvY2tsZXNzIHJlYWRlcnMsCiAJCSAqIHdlIG11c3QgbWFrZSBzdXJl
IGl0cyBjb250ZW50IGlzIGNvbW1pdHRlZCB0byBtZW1vcnkuCmRpZmYgLS1naXQgYS9uZXQvbmV0
ZmlsdGVyL25mX2xvZy5jIGIvbmV0L25ldGZpbHRlci9uZl9sb2cuYwppbmRleCA4NTI5NmQ0Li5h
OTU4MGVjIDEwMDY0NAotLS0gYS9uZXQvbmV0ZmlsdGVyL25mX2xvZy5jCisrKyBiL25ldC9uZXRm
aWx0ZXIvbmZfbG9nLmMKQEAgLTU4LDcgKzU4LDcgQEAgdm9pZCBuZl9sb2dfdW5zZXQoc3RydWN0
IG5ldCAqbmV0LCBjb25zdCBzdHJ1Y3QgbmZfbG9nZ2VyICpsb2dnZXIpCiAJCWxvZyA9IHJjdV9k
ZXJlZmVyZW5jZV9wcm90ZWN0ZWQobmV0LT5uZi5uZl9sb2dnZXJzW2ldLAogCQkJCWxvY2tkZXBf
aXNfaGVsZCgmbmZfbG9nX211dGV4KSk7CiAJCWlmIChsb2cgPT0gbG9nZ2VyKQotCQkJUkNVX0lO
SVRfUE9JTlRFUihuZXQtPm5mLm5mX2xvZ2dlcnNbaV0sIE5VTEwpOworCQkJcmN1X2luaXRfcG9p
bnRlcihuZXQtPm5mLm5mX2xvZ2dlcnNbaV0sIE5VTEwpOwogCX0KIAltdXRleF91bmxvY2soJm5m
X2xvZ19tdXRleCk7CiAJc3luY2hyb25pemVfcmN1KCk7CkBAIC0xMjQsNyArMTI0LDcgQEAgdm9p
ZCBuZl9sb2dfdW5iaW5kX3BmKHN0cnVjdCBuZXQgKm5ldCwgdV9pbnQ4X3QgcGYpCiAJaWYgKHBm
ID49IEFSUkFZX1NJWkUobmV0LT5uZi5uZl9sb2dnZXJzKSkKIAkJcmV0dXJuOwogCW11dGV4X2xv
Y2soJm5mX2xvZ19tdXRleCk7Ci0JUkNVX0lOSVRfUE9JTlRFUihuZXQtPm5mLm5mX2xvZ2dlcnNb
cGZdLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5ldC0+bmYubmZfbG9nZ2Vyc1twZl0sIE5V
TEwpOwogCW11dGV4X3VubG9jaygmbmZfbG9nX211dGV4KTsKIH0KIEVYUE9SVF9TWU1CT0wobmZf
bG9nX3VuYmluZF9wZik7CmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX25hdF9hbWFuZGEu
YyBiL25ldC9uZXRmaWx0ZXIvbmZfbmF0X2FtYW5kYS5jCmluZGV4IGViNzcyMzguLmQ1YWM1YjIg
MTAwNjQ0Ci0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfbmF0X2FtYW5kYS5jCisrKyBiL25ldC9uZXRm
aWx0ZXIvbmZfbmF0X2FtYW5kYS5jCkBAIC03NSwxNCArNzUsMTQgQEAgc3RhdGljIHVuc2lnbmVk
IGludCBoZWxwKHN0cnVjdCBza19idWZmICpza2IsCiAKIHN0YXRpYyB2b2lkIF9fZXhpdCBuZl9u
YXRfYW1hbmRhX2Zpbmkodm9pZCkKIHsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5mX25hdF9hbWFuZGFf
aG9vaywgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihuZl9uYXRfYW1hbmRhX2hvb2ssIE5VTEwp
OwogCXN5bmNocm9uaXplX3JjdSgpOwogfQogCiBzdGF0aWMgaW50IF9faW5pdCBuZl9uYXRfYW1h
bmRhX2luaXQodm9pZCkKIHsKIAlCVUdfT04obmZfbmF0X2FtYW5kYV9ob29rICE9IE5VTEwpOwot
CVJDVV9JTklUX1BPSU5URVIobmZfbmF0X2FtYW5kYV9ob29rLCBoZWxwKTsKKwlyY3VfaW5pdF9w
b2ludGVyKG5mX25hdF9hbWFuZGFfaG9vaywgaGVscCk7CiAJcmV0dXJuIDA7CiB9CiAKZGlmZiAt
LWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZfbmF0X2NvcmUuYyBiL25ldC9uZXRmaWx0ZXIvbmZfbmF0
X2NvcmUuYwppbmRleCA1MmNhOTUyLi4xMjE5YjVlIDEwMDY0NAotLS0gYS9uZXQvbmV0ZmlsdGVy
L25mX25hdF9jb3JlLmMKKysrIGIvbmV0L25ldGZpbHRlci9uZl9uYXRfY29yZS5jCkBAIC01NjIs
NyArNTYyLDcgQEAgaW50IG5mX25hdF9sNHByb3RvX3JlZ2lzdGVyKHU4IGwzcHJvdG8sIGNvbnN0
IHN0cnVjdCBuZl9uYXRfbDRwcm90byAqbDRwcm90bykKIAkJfQogCiAJCWZvciAoaSA9IDA7IGkg
PCBJUFBST1RPX01BWDsgaSsrKQotCQkJUkNVX0lOSVRfUE9JTlRFUihsNHByb3Rvc1tpXSwgJm5m
X25hdF9sNHByb3RvX3Vua25vd24pOworCQkJcmN1X2luaXRfcG9pbnRlcihsNHByb3Rvc1tpXSwg
Jm5mX25hdF9sNHByb3RvX3Vua25vd24pOwogCiAJCS8qIEJlZm9yZSBtYWtpbmcgcHJvdG9fYXJy
YXkgdmlzaWJsZSB0byBsb2NrbGVzcyByZWFkZXJzLAogCQkgKiB3ZSBtdXN0IG1ha2Ugc3VyZSBp
dHMgY29udGVudCBpcyBjb21taXR0ZWQgdG8gbWVtb3J5LgpAQCAtNTc5LDcgKzU3OSw3IEBAIGlu
dCBuZl9uYXRfbDRwcm90b19yZWdpc3Rlcih1OCBsM3Byb3RvLCBjb25zdCBzdHJ1Y3QgbmZfbmF0
X2w0cHJvdG8gKmw0cHJvdG8pCiAJCXJldCA9IC1FQlVTWTsKIAkJZ290byBvdXQ7CiAJfQotCVJD
VV9JTklUX1BPSU5URVIobmZfbmF0X2w0cHJvdG9zW2wzcHJvdG9dW2w0cHJvdG8tPmw0cHJvdG9d
LCBsNHByb3RvKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5mX25hdF9sNHByb3Rvc1tsM3Byb3RvXVts
NHByb3RvLT5sNHByb3RvXSwgbDRwcm90byk7CiAgb3V0OgogCW11dGV4X3VubG9jaygmbmZfbmF0
X3Byb3RvX211dGV4KTsKIAlyZXR1cm4gcmV0OwpAQCAtNTkwLDcgKzU5MCw3IEBAIEVYUE9SVF9T
WU1CT0xfR1BMKG5mX25hdF9sNHByb3RvX3JlZ2lzdGVyKTsKIHZvaWQgbmZfbmF0X2w0cHJvdG9f
dW5yZWdpc3Rlcih1OCBsM3Byb3RvLCBjb25zdCBzdHJ1Y3QgbmZfbmF0X2w0cHJvdG8gKmw0cHJv
dG8pCiB7CiAJbXV0ZXhfbG9jaygmbmZfbmF0X3Byb3RvX211dGV4KTsKLQlSQ1VfSU5JVF9QT0lO
VEVSKG5mX25hdF9sNHByb3Rvc1tsM3Byb3RvXVtsNHByb3RvLT5sNHByb3RvXSwKKwlyY3VfaW5p
dF9wb2ludGVyKG5mX25hdF9sNHByb3Rvc1tsM3Byb3RvXVtsNHByb3RvLT5sNHByb3RvXSwKIAkJ
CSAmbmZfbmF0X2w0cHJvdG9fdW5rbm93bik7CiAJbXV0ZXhfdW5sb2NrKCZuZl9uYXRfcHJvdG9f
bXV0ZXgpOwogCXN5bmNocm9uaXplX3JjdSgpOwpAQCAtNjA4LDEzICs2MDgsMTMgQEAgaW50IG5m
X25hdF9sM3Byb3RvX3JlZ2lzdGVyKGNvbnN0IHN0cnVjdCBuZl9uYXRfbDNwcm90byAqbDNwcm90
bykKIAkJcmV0dXJuIGVycjsKIAogCW11dGV4X2xvY2soJm5mX25hdF9wcm90b19tdXRleCk7Ci0J
UkNVX0lOSVRfUE9JTlRFUihuZl9uYXRfbDRwcm90b3NbbDNwcm90by0+bDNwcm90b11bSVBQUk9U
T19UQ1BdLAorCXJjdV9pbml0X3BvaW50ZXIobmZfbmF0X2w0cHJvdG9zW2wzcHJvdG8tPmwzcHJv
dG9dW0lQUFJPVE9fVENQXSwKIAkJCSAmbmZfbmF0X2w0cHJvdG9fdGNwKTsKLQlSQ1VfSU5JVF9Q
T0lOVEVSKG5mX25hdF9sNHByb3Rvc1tsM3Byb3RvLT5sM3Byb3RvXVtJUFBST1RPX1VEUF0sCisJ
cmN1X2luaXRfcG9pbnRlcihuZl9uYXRfbDRwcm90b3NbbDNwcm90by0+bDNwcm90b11bSVBQUk9U
T19VRFBdLAogCQkJICZuZl9uYXRfbDRwcm90b191ZHApOwogCW11dGV4X3VubG9jaygmbmZfbmF0
X3Byb3RvX211dGV4KTsKIAotCVJDVV9JTklUX1BPSU5URVIobmZfbmF0X2wzcHJvdG9zW2wzcHJv
dG8tPmwzcHJvdG9dLCBsM3Byb3RvKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5mX25hdF9sM3Byb3Rv
c1tsM3Byb3RvLT5sM3Byb3RvXSwgbDNwcm90byk7CiAJcmV0dXJuIDA7CiB9CiBFWFBPUlRfU1lN
Qk9MX0dQTChuZl9uYXRfbDNwcm90b19yZWdpc3Rlcik7CkBAIC02MjIsNyArNjIyLDcgQEAgRVhQ
T1JUX1NZTUJPTF9HUEwobmZfbmF0X2wzcHJvdG9fcmVnaXN0ZXIpOwogdm9pZCBuZl9uYXRfbDNw
cm90b191bnJlZ2lzdGVyKGNvbnN0IHN0cnVjdCBuZl9uYXRfbDNwcm90byAqbDNwcm90bykKIHsK
IAltdXRleF9sb2NrKCZuZl9uYXRfcHJvdG9fbXV0ZXgpOwotCVJDVV9JTklUX1BPSU5URVIobmZf
bmF0X2wzcHJvdG9zW2wzcHJvdG8tPmwzcHJvdG9dLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVy
KG5mX25hdF9sM3Byb3Rvc1tsM3Byb3RvLT5sM3Byb3RvXSwgTlVMTCk7CiAJbXV0ZXhfdW5sb2Nr
KCZuZl9uYXRfcHJvdG9fbXV0ZXgpOwogCXN5bmNocm9uaXplX3JjdSgpOwogCkBAIC04MjIsMTEg
KzgyMiwxMSBAQCBzdGF0aWMgaW50IF9faW5pdCBuZl9uYXRfaW5pdCh2b2lkKQogCW5mX2N0X3Vu
dHJhY2tlZF9zdGF0dXNfb3IoSVBTX05BVF9ET05FX01BU0spOwogCiAJQlVHX09OKG5mbmV0bGlu
a19wYXJzZV9uYXRfc2V0dXBfaG9vayAhPSBOVUxMKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5mbmV0
bGlua19wYXJzZV9uYXRfc2V0dXBfaG9vaywKKwlyY3VfaW5pdF9wb2ludGVyKG5mbmV0bGlua19w
YXJzZV9uYXRfc2V0dXBfaG9vaywKIAkJCSAgIG5mbmV0bGlua19wYXJzZV9uYXRfc2V0dXApOwog
I2lmZGVmIENPTkZJR19YRlJNCiAJQlVHX09OKG5mX25hdF9kZWNvZGVfc2Vzc2lvbl9ob29rICE9
IE5VTEwpOwotCVJDVV9JTklUX1BPSU5URVIobmZfbmF0X2RlY29kZV9zZXNzaW9uX2hvb2ssIF9f
bmZfbmF0X2RlY29kZV9zZXNzaW9uKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5mX25hdF9kZWNvZGVf
c2Vzc2lvbl9ob29rLCBfX25mX25hdF9kZWNvZGVfc2Vzc2lvbik7CiAjZW5kaWYKIAlyZXR1cm4g
MDsKIApAQCAtODQyLDkgKzg0Miw5IEBAIHN0YXRpYyB2b2lkIF9fZXhpdCBuZl9uYXRfY2xlYW51
cCh2b2lkKQogCXVucmVnaXN0ZXJfcGVybmV0X3N1YnN5cygmbmZfbmF0X25ldF9vcHMpOwogCW5m
X2N0X2V4dGVuZF91bnJlZ2lzdGVyKCZuYXRfZXh0ZW5kKTsKIAluZl9jdF9oZWxwZXJfZXhwZWN0
Zm5fdW5yZWdpc3RlcigmZm9sbG93X21hc3Rlcl9uYXQpOwotCVJDVV9JTklUX1BPSU5URVIobmZu
ZXRsaW5rX3BhcnNlX25hdF9zZXR1cF9ob29rLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5m
bmV0bGlua19wYXJzZV9uYXRfc2V0dXBfaG9vaywgTlVMTCk7CiAjaWZkZWYgQ09ORklHX1hGUk0K
LQlSQ1VfSU5JVF9QT0lOVEVSKG5mX25hdF9kZWNvZGVfc2Vzc2lvbl9ob29rLCBOVUxMKTsKKwly
Y3VfaW5pdF9wb2ludGVyKG5mX25hdF9kZWNvZGVfc2Vzc2lvbl9ob29rLCBOVUxMKTsKICNlbmRp
ZgogCWZvciAoaSA9IDA7IGkgPCBORlBST1RPX05VTVBST1RPOyBpKyspCiAJCWtmcmVlKG5mX25h
dF9sNHByb3Rvc1tpXSk7CmRpZmYgLS1naXQgYS9uZXQvbmV0ZmlsdGVyL25mX25hdF9mdHAuYyBi
L25ldC9uZXRmaWx0ZXIvbmZfbmF0X2Z0cC5jCmluZGV4IGU4NGE1NzguLmFhZWY2YzYgMTAwNjQ0
Ci0tLSBhL25ldC9uZXRmaWx0ZXIvbmZfbmF0X2Z0cC5jCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZf
bmF0X2Z0cC5jCkBAIC0xMjIsMTQgKzEyMiwxNCBAQCBvdXQ6CiAKIHN0YXRpYyB2b2lkIF9fZXhp
dCBuZl9uYXRfZnRwX2Zpbmkodm9pZCkKIHsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5mX25hdF9mdHBf
aG9vaywgTlVMTCk7CisJcmN1X2luaXRfcG9pbnRlcihuZl9uYXRfZnRwX2hvb2ssIE5VTEwpOwog
CXN5bmNocm9uaXplX3JjdSgpOwogfQogCiBzdGF0aWMgaW50IF9faW5pdCBuZl9uYXRfZnRwX2lu
aXQodm9pZCkKIHsKIAlCVUdfT04obmZfbmF0X2Z0cF9ob29rICE9IE5VTEwpOwotCVJDVV9JTklU
X1BPSU5URVIobmZfbmF0X2Z0cF9ob29rLCBuZl9uYXRfZnRwKTsKKwlyY3VfaW5pdF9wb2ludGVy
KG5mX25hdF9mdHBfaG9vaywgbmZfbmF0X2Z0cCk7CiAJcmV0dXJuIDA7CiB9CiAKZGlmZiAtLWdp
dCBhL25ldC9uZXRmaWx0ZXIvbmZfbmF0X2lyYy5jIGIvbmV0L25ldGZpbHRlci9uZl9uYXRfaXJj
LmMKaW5kZXggMWZiMjI1OC4uNWJmNDk3ZCAxMDA2NDQKLS0tIGEvbmV0L25ldGZpbHRlci9uZl9u
YXRfaXJjLmMKKysrIGIvbmV0L25ldGZpbHRlci9uZl9uYXRfaXJjLmMKQEAgLTk1LDE0ICs5NSwx
NCBAQCBzdGF0aWMgdW5zaWduZWQgaW50IGhlbHAoc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAogc3Rh
dGljIHZvaWQgX19leGl0IG5mX25hdF9pcmNfZmluaSh2b2lkKQogewotCVJDVV9JTklUX1BPSU5U
RVIobmZfbmF0X2lyY19ob29rLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5mX25hdF9pcmNf
aG9vaywgTlVMTCk7CiAJc3luY2hyb25pemVfcmN1KCk7CiB9CiAKIHN0YXRpYyBpbnQgX19pbml0
IG5mX25hdF9pcmNfaW5pdCh2b2lkKQogewogCUJVR19PTihuZl9uYXRfaXJjX2hvb2sgIT0gTlVM
TCk7Ci0JUkNVX0lOSVRfUE9JTlRFUihuZl9uYXRfaXJjX2hvb2ssIGhlbHApOworCXJjdV9pbml0
X3BvaW50ZXIobmZfbmF0X2lyY19ob29rLCBoZWxwKTsKIAlyZXR1cm4gMDsKIH0KIApkaWZmIC0t
Z2l0IGEvbmV0L25ldGZpbHRlci9uZl9uYXRfc2lwLmMgYi9uZXQvbmV0ZmlsdGVyL25mX25hdF9z
aXAuYwppbmRleCBiNGQ2OTFkLi5hMmEwYTM5IDEwMDY0NAotLS0gYS9uZXQvbmV0ZmlsdGVyL25m
X25hdF9zaXAuYworKysgYi9uZXQvbmV0ZmlsdGVyL25mX25hdF9zaXAuYwpAQCAtNjI1LDcgKzYy
NSw3IEBAIHN0YXRpYyBzdHJ1Y3QgbmZfY3RfaGVscGVyX2V4cGVjdGZuIHNpcF9uYXQgPSB7CiAK
IHN0YXRpYyB2b2lkIF9fZXhpdCBuZl9uYXRfc2lwX2Zpbmkodm9pZCkKIHsKLQlSQ1VfSU5JVF9Q
T0lOVEVSKG5mX25hdF9zaXBfaG9va3MsIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIobmZfbmF0
X3NpcF9ob29rcywgTlVMTCk7CiAKIAluZl9jdF9oZWxwZXJfZXhwZWN0Zm5fdW5yZWdpc3Rlcigm
c2lwX25hdCk7CiAJc3luY2hyb25pemVfcmN1KCk7CkBAIC02NDQsNyArNjQ0LDcgQEAgc3RhdGlj
IGNvbnN0IHN0cnVjdCBuZl9uYXRfc2lwX2hvb2tzIHNpcF9ob29rcyA9IHsKIHN0YXRpYyBpbnQg
X19pbml0IG5mX25hdF9zaXBfaW5pdCh2b2lkKQogewogCUJVR19PTihuZl9uYXRfc2lwX2hvb2tz
ICE9IE5VTEwpOwotCVJDVV9JTklUX1BPSU5URVIobmZfbmF0X3NpcF9ob29rcywgJnNpcF9ob29r
cyk7CisJcmN1X2luaXRfcG9pbnRlcihuZl9uYXRfc2lwX2hvb2tzLCAmc2lwX2hvb2tzKTsKIAlu
Zl9jdF9oZWxwZXJfZXhwZWN0Zm5fcmVnaXN0ZXIoJnNpcF9uYXQpOwogCXJldHVybiAwOwogfQpk
aWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9uZl9uYXRfdGZ0cC5jIGIvbmV0L25ldGZpbHRlci9u
Zl9uYXRfdGZ0cC5jCmluZGV4IDdmNjdlMWQuLmY4MjhlZjAgMTAwNjQ0Ci0tLSBhL25ldC9uZXRm
aWx0ZXIvbmZfbmF0X3RmdHAuYworKysgYi9uZXQvbmV0ZmlsdGVyL25mX25hdF90ZnRwLmMKQEAg
LTM3LDE0ICszNywxNCBAQCBzdGF0aWMgdW5zaWduZWQgaW50IGhlbHAoc3RydWN0IHNrX2J1ZmYg
KnNrYiwKIAogc3RhdGljIHZvaWQgX19leGl0IG5mX25hdF90ZnRwX2Zpbmkodm9pZCkKIHsKLQlS
Q1VfSU5JVF9QT0lOVEVSKG5mX25hdF90ZnRwX2hvb2ssIE5VTEwpOworCXJjdV9pbml0X3BvaW50
ZXIobmZfbmF0X3RmdHBfaG9vaywgTlVMTCk7CiAJc3luY2hyb25pemVfcmN1KCk7CiB9CiAKIHN0
YXRpYyBpbnQgX19pbml0IG5mX25hdF90ZnRwX2luaXQodm9pZCkKIHsKIAlCVUdfT04obmZfbmF0
X3RmdHBfaG9vayAhPSBOVUxMKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5mX25hdF90ZnRwX2hvb2ss
IGhlbHApOworCXJjdV9pbml0X3BvaW50ZXIobmZfbmF0X3RmdHBfaG9vaywgaGVscCk7CiAJcmV0
dXJuIDA7CiB9CiAKZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIvbmZfcXVldWUuYyBiL25ldC9u
ZXRmaWx0ZXIvbmZfcXVldWUuYwppbmRleCA1ZDI0YjFmLi45M2ZlODAyIDEwMDY0NAotLS0gYS9u
ZXQvbmV0ZmlsdGVyL25mX3F1ZXVlLmMKKysrIGIvbmV0L25ldGZpbHRlci9uZl9xdWV1ZS5jCkBA
IC00MCw3ICs0MCw3IEBAIEVYUE9SVF9TWU1CT0wobmZfcmVnaXN0ZXJfcXVldWVfaGFuZGxlcik7
CiAvKiBUaGUgY2FsbGVyIG11c3QgZmx1c2ggdGhlaXIgcXVldWUgYmVmb3JlIHRoaXMgKi8KIHZv
aWQgbmZfdW5yZWdpc3Rlcl9xdWV1ZV9oYW5kbGVyKHZvaWQpCiB7Ci0JUkNVX0lOSVRfUE9JTlRF
UihxdWV1ZV9oYW5kbGVyLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKHF1ZXVlX2hhbmRsZXIs
IE5VTEwpOwogCXN5bmNocm9uaXplX3JjdSgpOwogfQogRVhQT1JUX1NZTUJPTChuZl91bnJlZ2lz
dGVyX3F1ZXVlX2hhbmRsZXIpOwpkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9uZm5ldGxpbmsu
YyBiL25ldC9uZXRmaWx0ZXIvbmZuZXRsaW5rLmMKaW5kZXggZTgxMzhkYS4uNjQ3N2EwMiAxMDA2
NDQKLS0tIGEvbmV0L25ldGZpbHRlci9uZm5ldGxpbmsuYworKysgYi9uZXQvbmV0ZmlsdGVyL25m
bmV0bGluay5jCkBAIC00NDAsNyArNDQwLDcgQEAgc3RhdGljIHZvaWQgX19uZXRfZXhpdCBuZm5l
dGxpbmtfbmV0X2V4aXRfYmF0Y2goc3RydWN0IGxpc3RfaGVhZCAqbmV0X2V4aXRfbGlzdCkKIAlz
dHJ1Y3QgbmV0ICpuZXQ7CiAKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KG5ldCwgbmV0X2V4aXRfbGlz
dCwgZXhpdF9saXN0KQotCQlSQ1VfSU5JVF9QT0lOVEVSKG5ldC0+bmZubCwgTlVMTCk7CisJCXJj
dV9pbml0X3BvaW50ZXIobmV0LT5uZm5sLCBOVUxMKTsKIAlzeW5jaHJvbml6ZV9uZXQoKTsKIAls
aXN0X2Zvcl9lYWNoX2VudHJ5KG5ldCwgbmV0X2V4aXRfbGlzdCwgZXhpdF9saXN0KQogCQluZXRs
aW5rX2tlcm5lbF9yZWxlYXNlKG5ldC0+bmZubF9zdGFzaCk7CmRpZmYgLS1naXQgYS9uZXQvbmV0
ZmlsdGVyL25mbmV0bGlua19jdHRpbWVvdXQuYyBiL25ldC9uZXRmaWx0ZXIvbmZuZXRsaW5rX2N0
dGltZW91dC5jCmluZGV4IDQ3NmFjY2QuLjgzNjgzNmMgMTAwNjQ0Ci0tLSBhL25ldC9uZXRmaWx0
ZXIvbmZuZXRsaW5rX2N0dGltZW91dC5jCisrKyBiL25ldC9uZXRmaWx0ZXIvbmZuZXRsaW5rX2N0
dGltZW91dC5jCkBAIC01NTEsOCArNTUxLDggQEAgc3RhdGljIGludCBfX2luaXQgY3R0aW1lb3V0
X2luaXQodm9pZCkKIAkJZ290byBlcnJfb3V0OwogCX0KICNpZmRlZiBDT05GSUdfTkZfQ09OTlRS
QUNLX1RJTUVPVVQKLQlSQ1VfSU5JVF9QT0lOVEVSKG5mX2N0X3RpbWVvdXRfZmluZF9nZXRfaG9v
aywgY3RubF90aW1lb3V0X2ZpbmRfZ2V0KTsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5mX2N0X3RpbWVv
dXRfcHV0X2hvb2ssIGN0bmxfdGltZW91dF9wdXQpOworCXJjdV9pbml0X3BvaW50ZXIobmZfY3Rf
dGltZW91dF9maW5kX2dldF9ob29rLCBjdG5sX3RpbWVvdXRfZmluZF9nZXQpOworCXJjdV9pbml0
X3BvaW50ZXIobmZfY3RfdGltZW91dF9wdXRfaG9vaywgY3RubF90aW1lb3V0X3B1dCk7CiAjZW5k
aWYgLyogQ09ORklHX05GX0NPTk5UUkFDS19USU1FT1VUICovCiAJcmV0dXJuIDA7CiAKQEAgLTU3
Niw4ICs1NzYsOCBAQCBzdGF0aWMgdm9pZCBfX2V4aXQgY3R0aW1lb3V0X2V4aXQodm9pZCkKIAkJ
a2ZyZWVfcmN1KGN1ciwgcmN1X2hlYWQpOwogCX0KICNpZmRlZiBDT05GSUdfTkZfQ09OTlRSQUNL
X1RJTUVPVVQKLQlSQ1VfSU5JVF9QT0lOVEVSKG5mX2N0X3RpbWVvdXRfZmluZF9nZXRfaG9vaywg
TlVMTCk7Ci0JUkNVX0lOSVRfUE9JTlRFUihuZl9jdF90aW1lb3V0X3B1dF9ob29rLCBOVUxMKTsK
KwlyY3VfaW5pdF9wb2ludGVyKG5mX2N0X3RpbWVvdXRfZmluZF9nZXRfaG9vaywgTlVMTCk7CisJ
cmN1X2luaXRfcG9pbnRlcihuZl9jdF90aW1lb3V0X3B1dF9ob29rLCBOVUxMKTsKICNlbmRpZiAv
KiBDT05GSUdfTkZfQ09OTlRSQUNLX1RJTUVPVVQgKi8KIH0KIApkaWZmIC0tZ2l0IGEvbmV0L25l
dGZpbHRlci9uZnRfaGFzaC5jIGIvbmV0L25ldGZpbHRlci9uZnRfaGFzaC5jCmluZGV4IDNiMWFk
ODcuLjUzOTM4NWIgMTAwNjQ0Ci0tLSBhL25ldC9uZXRmaWx0ZXIvbmZ0X2hhc2guYworKysgYi9u
ZXQvbmV0ZmlsdGVyL25mdF9oYXNoLmMKQEAgLTExOSw3ICsxMTksNyBAQCBzdGF0aWMgdm9pZCBu
ZnRfaGFzaF9jaGFpbl91bnppcChjb25zdCBzdHJ1Y3QgbmZ0X3NldCAqc2V0LAogCX0KIAogCS8q
IFVubGluayBmaXJzdCBjaGFpbiBmcm9tIHRoZSBvbGQgdGFibGUgKi8KLQlSQ1VfSU5JVF9QT0lO
VEVSKHRibC0+YnVja2V0c1tuXSwgbGFzdC0+bmV4dCk7CisJcmN1X2luaXRfcG9pbnRlcih0Ymwt
PmJ1Y2tldHNbbl0sIGxhc3QtPm5leHQpOwogCiAJLyogSWYgZW5kIG9mIGNoYWluIHJlYWNoZWQs
IGRvbmUgKi8KIAlpZiAoaGUgPT0gTlVMTCkKQEAgLTEzNSw3ICsxMzUsNyBAQCBzdGF0aWMgdm9p
ZCBuZnRfaGFzaF9jaGFpbl91bnppcChjb25zdCBzdHJ1Y3QgbmZ0X3NldCAqc2V0LAogCX0KIAog
CS8qIExpbmsgdGhlIHR3byBjaGFpbnMgKi8KLQlSQ1VfSU5JVF9QT0lOVEVSKGxhc3QtPm5leHQs
IG5leHQpOworCXJjdV9pbml0X3BvaW50ZXIobGFzdC0+bmV4dCwgbmV4dCk7CiB9CiAKIHN0YXRp
YyBpbnQgbmZ0X2hhc2hfdGJsX2V4cGFuZChjb25zdCBzdHJ1Y3QgbmZ0X3NldCAqc2V0LCBzdHJ1
Y3QgbmZ0X2hhc2ggKnByaXYpCkBAIC0xNTcsNyArMTU3LDcgQEAgc3RhdGljIGludCBuZnRfaGFz
aF90YmxfZXhwYW5kKGNvbnN0IHN0cnVjdCBuZnRfc2V0ICpzZXQsIHN0cnVjdCBuZnRfaGFzaCAq
cHJpdikKIAkJbmZ0X2hhc2hfZm9yX2VhY2hfZW50cnkoaGUsIHRibC0+YnVja2V0c1toXSkgewog
CQkJaWYgKG5mdF9oYXNoX2RhdGEoJmhlLT5rZXksIG50YmwtPnNpemUsIHNldC0+a2xlbikgIT0g
aSkKIAkJCQljb250aW51ZTsKLQkJCVJDVV9JTklUX1BPSU5URVIobnRibC0+YnVja2V0c1tpXSwg
aGUpOworCQkJcmN1X2luaXRfcG9pbnRlcihudGJsLT5idWNrZXRzW2ldLCBoZSk7CiAJCQlicmVh
azsKIAkJfQogCX0KQEAgLTE5OSw3ICsxOTksNyBAQCBzdGF0aWMgaW50IG5mdF9oYXNoX3RibF9z
aHJpbmsoY29uc3Qgc3RydWN0IG5mdF9zZXQgKnNldCwgc3RydWN0IG5mdF9oYXNoICpwcml2KQog
CQlmb3IgKHBwcmV2ID0gJm50YmwtPmJ1Y2tldHNbaV07ICpwcHJldiAhPSBOVUxMOwogCQkgICAg
IHBwcmV2ID0gJm5mdF9kZXJlZmVyZW5jZSgqcHByZXYpLT5uZXh0KQogCQkJOwotCQlSQ1VfSU5J
VF9QT0lOVEVSKCpwcHJldiwgdGJsLT5idWNrZXRzW2kgKyBudGJsLT5zaXplXSk7CisJCXJjdV9p
bml0X3BvaW50ZXIoKnBwcmV2LCB0YmwtPmJ1Y2tldHNbaSArIG50YmwtPnNpemVdKTsKIAl9CiAJ
bnRibC0+ZWxlbWVudHMgPSB0YmwtPmVsZW1lbnRzOwogCkBAIC0yMzUsNyArMjM1LDcgQEAgc3Rh
dGljIGludCBuZnRfaGFzaF9pbnNlcnQoY29uc3Qgc3RydWN0IG5mdF9zZXQgKnNldCwKIAkJbmZ0
X2RhdGFfY29weShoZS0+ZGF0YSwgJmVsZW0tPmRhdGEpOwogCiAJaCA9IG5mdF9oYXNoX2RhdGEo
JmhlLT5rZXksIHRibC0+c2l6ZSwgc2V0LT5rbGVuKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKGhlLT5u
ZXh0LCB0YmwtPmJ1Y2tldHNbaF0pOworCXJjdV9pbml0X3BvaW50ZXIoaGUtPm5leHQsIHRibC0+
YnVja2V0c1toXSk7CiAJcmN1X2Fzc2lnbl9wb2ludGVyKHRibC0+YnVja2V0c1toXSwgaGUpOwog
CXRibC0+ZWxlbWVudHMrKzsKIApAQCAtMjY1LDcgKzI2NSw3IEBAIHN0YXRpYyB2b2lkIG5mdF9o
YXNoX3JlbW92ZShjb25zdCBzdHJ1Y3QgbmZ0X3NldCAqc2V0LAogCXBwcmV2ID0gZWxlbS0+Y29v
a2llOwogCWhlID0gbmZ0X2RlcmVmZXJlbmNlKCgqcHByZXYpKTsKIAotCVJDVV9JTklUX1BPSU5U
RVIoKnBwcmV2LCBoZS0+bmV4dCk7CisJcmN1X2luaXRfcG9pbnRlcigqcHByZXYsIGhlLT5uZXh0
KTsKIAlzeW5jaHJvbml6ZV9yY3UoKTsKIAlrZnJlZShoZSk7CiAJdGJsLT5lbGVtZW50cy0tOwpA
QCAtMzQ4LDcgKzM0OCw3IEBAIHN0YXRpYyBpbnQgbmZ0X2hhc2hfaW5pdChjb25zdCBzdHJ1Y3Qg
bmZ0X3NldCAqc2V0LAogCXRibCA9IG5mdF9oYXNoX3RibF9hbGxvYyhORlRfSEFTSF9NSU5fU0la
RSk7CiAJaWYgKHRibCA9PSBOVUxMKQogCQlyZXR1cm4gLUVOT01FTTsKLQlSQ1VfSU5JVF9QT0lO
VEVSKHByaXYtPnRibCwgdGJsKTsKKwlyY3VfaW5pdF9wb2ludGVyKHByaXYtPnRibCwgdGJsKTsK
IAlyZXR1cm4gMDsKIH0KIApkaWZmIC0tZ2l0IGEvbmV0L25ldGxhYmVsL25ldGxhYmVsX2RvbWFp
bmhhc2guYyBiL25ldC9uZXRsYWJlbC9uZXRsYWJlbF9kb21haW5oYXNoLmMKaW5kZXggZjBjYjky
Zi4uOTc2MzJhZiAxMDA2NDQKLS0tIGEvbmV0L25ldGxhYmVsL25ldGxhYmVsX2RvbWFpbmhhc2gu
YworKysgYi9uZXQvbmV0bGFiZWwvbmV0bGFiZWxfZG9tYWluaGFzaC5jCkBAIC01MTYsNyArNTE2
LDcgQEAgaW50IG5ldGxibF9kb21oc2hfcmVtb3ZlX2VudHJ5KHN0cnVjdCBuZXRsYmxfZG9tX21h
cCAqZW50cnksCiAJCWlmIChlbnRyeSAhPSByY3VfZGVyZWZlcmVuY2UobmV0bGJsX2RvbWhzaF9k
ZWYpKQogCQkJbGlzdF9kZWxfcmN1KCZlbnRyeS0+bGlzdCk7CiAJCWVsc2UKLQkJCVJDVV9JTklU
X1BPSU5URVIobmV0bGJsX2RvbWhzaF9kZWYsIE5VTEwpOworCQkJcmN1X2luaXRfcG9pbnRlcihu
ZXRsYmxfZG9taHNoX2RlZiwgTlVMTCk7CiAJfSBlbHNlCiAJCXJldF92YWwgPSAtRU5PRU5UOwog
CXNwaW5fdW5sb2NrKCZuZXRsYmxfZG9taHNoX2xvY2spOwpkaWZmIC0tZ2l0IGEvbmV0L25ldGxh
YmVsL25ldGxhYmVsX3VubGFiZWxlZC5jIGIvbmV0L25ldGxhYmVsL25ldGxhYmVsX3VubGFiZWxl
ZC5jCmluZGV4IDc4YTYzYzEuLmI3ZWJkZWUgMTAwNjQ0Ci0tLSBhL25ldC9uZXRsYWJlbC9uZXRs
YWJlbF91bmxhYmVsZWQuYworKysgYi9uZXQvbmV0bGFiZWwvbmV0bGFiZWxfdW5sYWJlbGVkLmMK
QEAgLTYyMCw3ICs2MjAsNyBAQCBzdGF0aWMgdm9pZCBuZXRsYmxfdW5saHNoX2NvbmRyZW1vdmVf
aWZhY2Uoc3RydWN0IG5ldGxibF91bmxoc2hfaWZhY2UgKmlmYWNlKQogCWlmIChpZmFjZS0+aWZp
bmRleCA+IDApCiAJCWxpc3RfZGVsX3JjdSgmaWZhY2UtPmxpc3QpOwogCWVsc2UKLQkJUkNVX0lO
SVRfUE9JTlRFUihuZXRsYmxfdW5saHNoX2RlZiwgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIo
bmV0bGJsX3VubGhzaF9kZWYsIE5VTEwpOwogCXNwaW5fdW5sb2NrKCZuZXRsYmxfdW5saHNoX2xv
Y2spOwogCiAJY2FsbF9yY3UoJmlmYWNlLT5yY3UsIG5ldGxibF91bmxoc2hfZnJlZV9pZmFjZSk7
CmRpZmYgLS1naXQgYS9uZXQvbmV0bGluay9hZl9uZXRsaW5rLmMgYi9uZXQvbmV0bGluay9hZl9u
ZXRsaW5rLmMKaW5kZXggODk0Y2RhMC4uOTNmMGJkNiAxMDA2NDQKLS0tIGEvbmV0L25ldGxpbmsv
YWZfbmV0bGluay5jCisrKyBiL25ldC9uZXRsaW5rL2FmX25ldGxpbmsuYwpAQCAtMTI5Nyw3ICsx
Mjk3LDcgQEAgc3RhdGljIGludCBuZXRsaW5rX3JlbGVhc2Uoc3RydWN0IHNvY2tldCAqc29jaykK
IAkJCXN0cnVjdCBsaXN0ZW5lcnMgKm9sZDsKIAogCQkJb2xkID0gbmxfZGVyZWZfcHJvdGVjdGVk
KG5sX3RhYmxlW3NrLT5za19wcm90b2NvbF0ubGlzdGVuZXJzKTsKLQkJCVJDVV9JTklUX1BPSU5U
RVIobmxfdGFibGVbc2stPnNrX3Byb3RvY29sXS5saXN0ZW5lcnMsIE5VTEwpOworCQkJcmN1X2lu
aXRfcG9pbnRlcihubF90YWJsZVtzay0+c2tfcHJvdG9jb2xdLmxpc3RlbmVycywgTlVMTCk7CiAJ
CQlrZnJlZV9yY3Uob2xkLCByY3UpOwogCQkJbmxfdGFibGVbc2stPnNrX3Byb3RvY29sXS5tb2R1
bGUgPSBOVUxMOwogCQkJbmxfdGFibGVbc2stPnNrX3Byb3RvY29sXS5iaW5kID0gTlVMTDsKZGlm
ZiAtLWdpdCBhL25ldC9wYWNrZXQvYWZfcGFja2V0LmMgYi9uZXQvcGFja2V0L2FmX3BhY2tldC5j
CmluZGV4IGI4NWM2N2MuLjQ3NDBkYzYgMTAwNjQ0Ci0tLSBhL25ldC9wYWNrZXQvYWZfcGFja2V0
LmMKKysrIGIvbmV0L3BhY2tldC9hZl9wYWNrZXQuYwpAQCAtMzAxLDcgKzMwMSw3IEBAIHN0YXRp
YyB2b2lkIHBhY2tldF9jYWNoZWRfZGV2X2Fzc2lnbihzdHJ1Y3QgcGFja2V0X3NvY2sgKnBvLAog
CiBzdGF0aWMgdm9pZCBwYWNrZXRfY2FjaGVkX2Rldl9yZXNldChzdHJ1Y3QgcGFja2V0X3NvY2sg
KnBvKQogewotCVJDVV9JTklUX1BPSU5URVIocG8tPmNhY2hlZF9kZXYsIE5VTEwpOworCXJjdV9p
bml0X3BvaW50ZXIocG8tPmNhY2hlZF9kZXYsIE5VTEwpOwogfQogCiBzdGF0aWMgYm9vbCBwYWNr
ZXRfdXNlX2RpcmVjdF94bWl0KGNvbnN0IHN0cnVjdCBwYWNrZXRfc29jayAqcG8pCmRpZmYgLS1n
aXQgYS9uZXQvcGhvbmV0L2FmX3Bob25ldC5jIGIvbmV0L3Bob25ldC9hZl9waG9uZXQuYwppbmRl
eCA1YTk0MGRiLi42OTRkNWQ4IDEwMDY0NAotLS0gYS9uZXQvcGhvbmV0L2FmX3Bob25ldC5jCisr
KyBiL25ldC9waG9uZXQvYWZfcGhvbmV0LmMKQEAgLTQ5MSw3ICs0OTEsNyBAQCB2b2lkIHBob25l
dF9wcm90b191bnJlZ2lzdGVyKHVuc2lnbmVkIGludCBwcm90b2NvbCwgc3RydWN0IHBob25ldF9w
cm90b2NvbCAqcHApCiB7CiAJbXV0ZXhfbG9jaygmcHJvdG9fdGFiX2xvY2spOwogCUJVR19PTihw
cm90b190YWJbcHJvdG9jb2xdICE9IHBwKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKHByb3RvX3RhYltw
cm90b2NvbF0sIE5VTEwpOworCXJjdV9pbml0X3BvaW50ZXIocHJvdG9fdGFiW3Byb3RvY29sXSwg
TlVMTCk7CiAJbXV0ZXhfdW5sb2NrKCZwcm90b190YWJfbG9jayk7CiAJc3luY2hyb25pemVfcmN1
KCk7CiAJcHJvdG9fdW5yZWdpc3RlcihwcC0+cHJvdCk7CmRpZmYgLS1naXQgYS9uZXQvcGhvbmV0
L3BuX2Rldi5jIGIvbmV0L3Bob25ldC9wbl9kZXYuYwppbmRleCA1NmE2MTQ2Li4wN2Q1NjE5IDEw
MDY0NAotLS0gYS9uZXQvcGhvbmV0L3BuX2Rldi5jCisrKyBiL25ldC9waG9uZXQvcG5fZGV2LmMK
QEAgLTI3Niw3ICsyNzYsNyBAQCBzdGF0aWMgdm9pZCBwaG9uZXRfcm91dGVfYXV0b2RlbChzdHJ1
Y3QgbmV0X2RldmljZSAqZGV2KQogCW11dGV4X2xvY2soJnBubi0+cm91dGVzLmxvY2spOwogCWZv
ciAoaSA9IDA7IGkgPCA2NDsgaSsrKQogCQlpZiAoZGV2ID09IHBubi0+cm91dGVzLnRhYmxlW2ld
KSB7Ci0JCQlSQ1VfSU5JVF9QT0lOVEVSKHBubi0+cm91dGVzLnRhYmxlW2ldLCBOVUxMKTsKKwkJ
CXJjdV9pbml0X3BvaW50ZXIocG5uLT5yb3V0ZXMudGFibGVbaV0sIE5VTEwpOwogCQkJc2V0X2Jp
dChpLCBkZWxldGVkKTsKIAkJfQogCW11dGV4X3VubG9jaygmcG5uLT5yb3V0ZXMubG9jayk7CkBA
IC0zODksNyArMzg5LDcgQEAgaW50IHBob25ldF9yb3V0ZV9kZWwoc3RydWN0IG5ldF9kZXZpY2Ug
KmRldiwgdTggZGFkZHIpCiAJZGFkZHIgPSBkYWRkciA+PiAyOwogCW11dGV4X2xvY2soJnJvdXRl
cy0+bG9jayk7CiAJaWYgKGRldiA9PSByb3V0ZXMtPnRhYmxlW2RhZGRyXSkKLQkJUkNVX0lOSVRf
UE9JTlRFUihyb3V0ZXMtPnRhYmxlW2RhZGRyXSwgTlVMTCk7CisJCXJjdV9pbml0X3BvaW50ZXIo
cm91dGVzLT50YWJsZVtkYWRkcl0sIE5VTEwpOwogCWVsc2UKIAkJZGV2ID0gTlVMTDsKIAltdXRl
eF91bmxvY2soJnJvdXRlcy0+bG9jayk7CmRpZmYgLS1naXQgYS9uZXQvcGhvbmV0L3NvY2tldC5j
IGIvbmV0L3Bob25ldC9zb2NrZXQuYwppbmRleCAwMDgyMTRhLi4yNGUwZGIyIDEwMDY0NAotLS0g
YS9uZXQvcGhvbmV0L3NvY2tldC5jCisrKyBiL25ldC9waG9uZXQvc29ja2V0LmMKQEAgLTY5Myw3
ICs2OTMsNyBAQCBpbnQgcG5fc29ja191bmJpbmRfcmVzKHN0cnVjdCBzb2NrICpzaywgdTggcmVz
KQogCiAJbXV0ZXhfbG9jaygmcmVzb3VyY2VfbXV0ZXgpOwogCWlmIChwbnJlcy5za1tyZXNdID09
IHNrKSB7Ci0JCVJDVV9JTklUX1BPSU5URVIocG5yZXMuc2tbcmVzXSwgTlVMTCk7CisJCXJjdV9p
bml0X3BvaW50ZXIocG5yZXMuc2tbcmVzXSwgTlVMTCk7CiAJCXJldCA9IDA7CiAJfQogCW11dGV4
X3VubG9jaygmcmVzb3VyY2VfbXV0ZXgpOwpAQCAtNzEyLDcgKzcxMiw3IEBAIHZvaWQgcG5fc29j
a191bmJpbmRfYWxsX3JlcyhzdHJ1Y3Qgc29jayAqc2spCiAJbXV0ZXhfbG9jaygmcmVzb3VyY2Vf
bXV0ZXgpOwogCWZvciAocmVzID0gMDsgcmVzIDwgMjU2OyByZXMrKykgewogCQlpZiAocG5yZXMu
c2tbcmVzXSA9PSBzaykgewotCQkJUkNVX0lOSVRfUE9JTlRFUihwbnJlcy5za1tyZXNdLCBOVUxM
KTsKKwkJCXJjdV9pbml0X3BvaW50ZXIocG5yZXMuc2tbcmVzXSwgTlVMTCk7CiAJCQltYXRjaCsr
OwogCQl9CiAJfQpkaWZmIC0tZ2l0IGEvbmV0L3NvY2tldC5jIGIvbmV0L3NvY2tldC5jCmluZGV4
IGFiZjU2YjIuLjkzNTAzOTUgMTAwNjQ0Ci0tLSBhL25ldC9zb2NrZXQuYworKysgYi9uZXQvc29j
a2V0LmMKQEAgLTI2MCw3ICsyNjAsNyBAQCBzdGF0aWMgc3RydWN0IGlub2RlICpzb2NrX2FsbG9j
X2lub2RlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCiAJfQogCWluaXRfd2FpdHF1ZXVlX2hlYWQo
JndxLT53YWl0KTsKIAl3cS0+ZmFzeW5jX2xpc3QgPSBOVUxMOwotCVJDVV9JTklUX1BPSU5URVIo
ZWktPnNvY2tldC53cSwgd3EpOworCXJjdV9pbml0X3BvaW50ZXIoZWktPnNvY2tldC53cSwgd3Ep
OwogCiAJZWktPnNvY2tldC5zdGF0ZSA9IFNTX1VOQ09OTkVDVEVEOwogCWVpLT5zb2NrZXQuZmxh
Z3MgPSAwOwpAQCAtMjYzOCw3ICsyNjM4LDcgQEAgdm9pZCBzb2NrX3VucmVnaXN0ZXIoaW50IGZh
bWlseSkKIAlCVUdfT04oZmFtaWx5IDwgMCB8fCBmYW1pbHkgPj0gTlBST1RPKTsKIAogCXNwaW5f
bG9jaygmbmV0X2ZhbWlseV9sb2NrKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5ldF9mYW1pbGllc1tm
YW1pbHldLCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKG5ldF9mYW1pbGllc1tmYW1pbHldLCBO
VUxMKTsKIAlzcGluX3VubG9jaygmbmV0X2ZhbWlseV9sb2NrKTsKIAogCXN5bmNocm9uaXplX3Jj
dSgpOwpkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy9hdXRoX2dzcy9hdXRoX2dzcy5jIGIvbmV0L3N1
bnJwYy9hdXRoX2dzcy9hdXRoX2dzcy5jCmluZGV4IDM2ZTQzMWUuLjE4MTBjNTQgMTAwNjQ0Ci0t
LSBhL25ldC9zdW5ycGMvYXV0aF9nc3MvYXV0aF9nc3MuYworKysgYi9uZXQvc3VucnBjL2F1dGhf
Z3NzL2F1dGhfZ3NzLmMKQEAgLTEyNjIsNyArMTI2Miw3IEBAIGdzc19kZXN0cm95X251bGxjcmVk
KHN0cnVjdCBycGNfY3JlZCAqY3JlZCkKIAlzdHJ1Y3QgZ3NzX2F1dGggKmdzc19hdXRoID0gY29u
dGFpbmVyX29mKGNyZWQtPmNyX2F1dGgsIHN0cnVjdCBnc3NfYXV0aCwgcnBjX2F1dGgpOwogCXN0
cnVjdCBnc3NfY2xfY3R4ICpjdHggPSBnc3NfY3JlZC0+Z2NfY3R4OwogCi0JUkNVX0lOSVRfUE9J
TlRFUihnc3NfY3JlZC0+Z2NfY3R4LCBOVUxMKTsKKwlyY3VfaW5pdF9wb2ludGVyKGdzc19jcmVk
LT5nY19jdHgsIE5VTEwpOwogCWNhbGxfcmN1KCZjcmVkLT5jcl9yY3UsIGdzc19mcmVlX2NyZWRf
Y2FsbGJhY2spOwogCWlmIChjdHgpCiAJCWdzc19wdXRfY3R4KGN0eCk7CmRpZmYgLS1naXQgYS9u
ZXQvdGlwYy9iZWFyZXIuYyBiL25ldC90aXBjL2JlYXJlci5jCmluZGV4IDNmZWY3ZWIuLjNhNTZj
ZDYgMTAwNjQ0Ci0tLSBhL25ldC90aXBjL2JlYXJlci5jCisrKyBiL25ldC90aXBjL2JlYXJlci5j
CkBAIC00NjQsNyArNDY0LDcgQEAgaW50IHRpcGNfZW5hYmxlX2wyX21lZGlhKHN0cnVjdCB0aXBj
X2JlYXJlciAqYikKIHZvaWQgdGlwY19kaXNhYmxlX2wyX21lZGlhKHN0cnVjdCB0aXBjX2JlYXJl
ciAqYikKIHsKIAlzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0gKHN0cnVjdCBuZXRfZGV2aWNlICop
Yi0+bWVkaWFfcHRyOwotCVJDVV9JTklUX1BPSU5URVIoZGV2LT50aXBjX3B0ciwgTlVMTCk7CisJ
cmN1X2luaXRfcG9pbnRlcihkZXYtPnRpcGNfcHRyLCBOVUxMKTsKIAlkZXZfcHV0KGRldik7CiB9
CiAKZGlmZiAtLWdpdCBhL25ldC91bml4L2FmX3VuaXguYyBiL25ldC91bml4L2FmX3VuaXguYwpp
bmRleCBiYjdlOGJhLi5hZTg1NWI5IDEwMDY0NAotLS0gYS9uZXQvdW5peC9hZl91bml4LmMKKysr
IGIvbmV0L3VuaXgvYWZfdW5peC5jCkBAIC0xMTg3LDcgKzExODcsNyBAQCByZXN0YXJ0OgogCW5l
d3NrLT5za190eXBlCQk9IHNrLT5za190eXBlOwogCWluaXRfcGVlcmNyZWQobmV3c2spOwogCW5l
d3UgPSB1bml4X3NrKG5ld3NrKTsKLQlSQ1VfSU5JVF9QT0lOVEVSKG5ld3NrLT5za193cSwgJm5l
d3UtPnBlZXJfd3EpOworCXJjdV9pbml0X3BvaW50ZXIobmV3c2stPnNrX3dxLCAmbmV3dS0+cGVl
cl93cSk7CiAJb3RoZXJ1ID0gdW5peF9zayhvdGhlcik7CiAKIAkvKiBjb3B5IGFkZHJlc3MgaW5m
b3JtYXRpb24gZnJvbSBsaXN0ZW5pbmcgdG8gbmV3IHNvY2sqLwpkaWZmIC0tZ2l0IGEvbmV0L3hm
cm0veGZybV9pbnB1dC5jIGIvbmV0L3hmcm0veGZybV9pbnB1dC5jCmluZGV4IDg1ZDFkNDcuLmRl
Yjc3NmQgMTAwNjQ0Ci0tLSBhL25ldC94ZnJtL3hmcm1faW5wdXQuYworKysgYi9uZXQveGZybS94
ZnJtX2lucHV0LmMKQEAgLTUwLDcgKzUwLDcgQEAgaW50IHhmcm1faW5wdXRfdW5yZWdpc3Rlcl9h
ZmluZm8oc3RydWN0IHhmcm1faW5wdXRfYWZpbmZvICphZmluZm8pCiAJCWlmICh1bmxpa2VseSh4
ZnJtX2lucHV0X2FmaW5mb1thZmluZm8tPmZhbWlseV0gIT0gYWZpbmZvKSkKIAkJCWVyciA9IC1F
SU5WQUw7CiAJCWVsc2UKLQkJCVJDVV9JTklUX1BPSU5URVIoeGZybV9pbnB1dF9hZmluZm9bYWZp
bmZvLT5mYW1pbHldLCBOVUxMKTsKKwkJCXJjdV9pbml0X3BvaW50ZXIoeGZybV9pbnB1dF9hZmlu
Zm9bYWZpbmZvLT5mYW1pbHldLCBOVUxMKTsKIAl9CiAJc3Bpbl91bmxvY2tfYmgoJnhmcm1faW5w
dXRfYWZpbmZvX2xvY2spOwogCXN5bmNocm9uaXplX3JjdSgpOwpkaWZmIC0tZ2l0IGEvbmV0L3hm
cm0veGZybV9wb2xpY3kuYyBiL25ldC94ZnJtL3hmcm1fcG9saWN5LmMKaW5kZXggYzA4ZmJkMS4u
MzI2ZDZlZCAxMDA2NDQKLS0tIGEvbmV0L3hmcm0veGZybV9wb2xpY3kuYworKysgYi9uZXQveGZy
bS94ZnJtX3BvbGljeS5jCkBAIC0yNzI5LDcgKzI3MjksNyBAQCBpbnQgeGZybV9wb2xpY3lfdW5y
ZWdpc3Rlcl9hZmluZm8oc3RydWN0IHhmcm1fcG9saWN5X2FmaW5mbyAqYWZpbmZvKQogCQlpZiAo
dW5saWtlbHkoeGZybV9wb2xpY3lfYWZpbmZvW2FmaW5mby0+ZmFtaWx5XSAhPSBhZmluZm8pKQog
CQkJZXJyID0gLUVJTlZBTDsKIAkJZWxzZQotCQkJUkNVX0lOSVRfUE9JTlRFUih4ZnJtX3BvbGlj
eV9hZmluZm9bYWZpbmZvLT5mYW1pbHldLAorCQkJcmN1X2luaXRfcG9pbnRlcih4ZnJtX3BvbGlj
eV9hZmluZm9bYWZpbmZvLT5mYW1pbHldLAogCQkJCQkgTlVMTCk7CiAJfQogCXNwaW5fdW5sb2Nr
KCZ4ZnJtX3BvbGljeV9hZmluZm9fbG9jayk7CmRpZmYgLS1naXQgYS9uZXQveGZybS94ZnJtX3N0
YXRlLmMgYi9uZXQveGZybS94ZnJtX3N0YXRlLmMKaW5kZXggOGU5Yzc4MS4uY2Y3ZTg5YyAxMDA2
NDQKLS0tIGEvbmV0L3hmcm0veGZybV9zdGF0ZS5jCisrKyBiL25ldC94ZnJtL3hmcm1fc3RhdGUu
YwpAQCAtMTk0Miw3ICsxOTQyLDcgQEAgaW50IHhmcm1fc3RhdGVfdW5yZWdpc3Rlcl9hZmluZm8o
c3RydWN0IHhmcm1fc3RhdGVfYWZpbmZvICphZmluZm8pCiAJCWlmICh1bmxpa2VseSh4ZnJtX3N0
YXRlX2FmaW5mb1thZmluZm8tPmZhbWlseV0gIT0gYWZpbmZvKSkKIAkJCWVyciA9IC1FSU5WQUw7
CiAJCWVsc2UKLQkJCVJDVV9JTklUX1BPSU5URVIoeGZybV9zdGF0ZV9hZmluZm9bYWZpbmZvLT5m
YW1pbHldLCBOVUxMKTsKKwkJCXJjdV9pbml0X3BvaW50ZXIoeGZybV9zdGF0ZV9hZmluZm9bYWZp
bmZvLT5mYW1pbHldLCBOVUxMKTsKIAl9CiAJc3Bpbl91bmxvY2tfYmgoJnhmcm1fc3RhdGVfYWZp
bmZvX2xvY2spOwogCXN5bmNocm9uaXplX3JjdSgpOwpkaWZmIC0tZ2l0IGEvbmV0L3hmcm0veGZy
bV91c2VyLmMgYi9uZXQveGZybS94ZnJtX3VzZXIuYwppbmRleCA4ZjEzMWMxLi5jZGYyYTY2IDEw
MDY0NAotLS0gYS9uZXQveGZybS94ZnJtX3VzZXIuYworKysgYi9uZXQveGZybS94ZnJtX3VzZXIu
YwpAQCAtMzA0MCw3ICszMDQwLDcgQEAgc3RhdGljIHZvaWQgX19uZXRfZXhpdCB4ZnJtX3VzZXJf
bmV0X2V4aXQoc3RydWN0IGxpc3RfaGVhZCAqbmV0X2V4aXRfbGlzdCkKIHsKIAlzdHJ1Y3QgbmV0
ICpuZXQ7CiAJbGlzdF9mb3JfZWFjaF9lbnRyeShuZXQsIG5ldF9leGl0X2xpc3QsIGV4aXRfbGlz
dCkKLQkJUkNVX0lOSVRfUE9JTlRFUihuZXQtPnhmcm0ubmxzaywgTlVMTCk7CisJCXJjdV9pbml0
X3BvaW50ZXIobmV0LT54ZnJtLm5sc2ssIE5VTEwpOwogCXN5bmNocm9uaXplX25ldCgpOwogCWxp
c3RfZm9yX2VhY2hfZW50cnkobmV0LCBuZXRfZXhpdF9saXN0LCBleGl0X2xpc3QpCiAJCW5ldGxp
bmtfa2VybmVsX3JlbGVhc2UobmV0LT54ZnJtLm5sc2tfc3Rhc2gpOwotLSAKMS43LjkuNQoK
--001a11394fb4c48fca04f826e3de--
