Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbaD2PTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:19:17 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39114 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaD2PTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:19:11 -0400
Date: Tue, 29 Apr 2014 08:19:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Romanov Arya <romanov.arya@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] rename RCU_INIT_POINTER to rcu_init_pointer
Message-ID: <20140429151906.GD8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJKcOGcayerOcAZ9vtvW3GaysKjL=owzZJjkJYU7pH4hwRJgZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJKcOGcayerOcAZ9vtvW3GaysKjL=owzZJjkJYU7pH4hwRJgZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042915-3532-0000-0000-000001632DB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 12:30:20AM -0400, Romanov Arya wrote:
> Recently RCU_INIT_POINTER is suggested to be used instead of
> rcu_assign_pointer for NULL values.
> I do not see any reason why this is in all CAPS unlike for other
> cases. Rename so that it is consistent with other RCU_* macros.
> 
> Please also find the patch attached in case of mail client errors.
> Please discard patch if you think this huge change is unnecessary.

Actually, we do have several other all-caps macros in RCU.  Although
you certainly did some work converting this, I must say "no" to it.
Quite a bit of churn for equivocal benefit.

For future changes of this sort, I suggest using Coccinelle, which
can make it quite a bit easier.  When you do use Coccinelle, it is
good to say so in the commit log.

							Thanx, Paul

> Thanks!
> 
> Signed-off-by: Romanov Arya <romanov.arya@gmail.com>
> ---
>  arch/powerpc/platforms/cell/spu_syscalls.c         |    2 +-
>  drivers/crypto/nx/nx-842.c                         |    4 +-
>  drivers/infiniband/hw/qib/qib_qp.c                 |    2 +-
>  drivers/infiniband/hw/qib/qib_verbs.c              |   10 ++--
>  drivers/ipack/carriers/tpci200.c                   |    2 +-
>  drivers/md/dm.c                                    |    2 +-
>  drivers/net/bonding/bond_main.c                    |    2 +-
>  drivers/net/bonding/bond_options.c                 |    2 +-
>  drivers/net/ethernet/broadcom/bnx2.c               |    2 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    2 +-
>  drivers/net/ethernet/broadcom/cnic.c               |    6 +--
>  drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |    4 +-
>  drivers/net/macvtap.c                              |   10 ++--
>  drivers/net/ppp/pptp.c                             |    2 +-
>  drivers/net/team/team_mode_activebackup.c          |    2 +-
>  drivers/net/team/team_mode_loadbalance.c           |    2 +-
>  drivers/net/tun.c                                  |    8 ++--
>  drivers/net/veth.c                                 |    4 +-
>  drivers/net/wireless/ath/carl9170/main.c           |   12 ++---
>  drivers/net/wireless/iwlwifi/mvm/fw.c              |    4 +-
>  drivers/vhost/vhost.c                              |    4 +-
>  fs/eventpoll.c                                     |    4 +-
>  fs/proc/inode.c                                    |    2 +-
>  include/linux/rcupdate.h                           |   20 ++++----
>  kernel/audit.c                                     |    2 +-
>  kernel/cgroup.c                                    |   14 +++---
>  kernel/trace/trace_events_filter.c                 |    4 +-
>  kernel/trace/trace_events_trigger.c                |    2 +-
>  kernel/workqueue.c                                 |    2 +-
>  lib/idr.c                                          |    6 +--
>  net/802/garp.c                                     |    4 +-
>  net/802/mrp.c                                      |    4 +-
>  net/802/stp.c                                      |    4 +-
>  net/8021q/vlan_core.c                              |    2 +-
>  net/bridge/br_vlan.c                               |    8 ++--
>  net/bridge/netfilter/ebtable_broute.c              |    4 +-
>  net/caif/cfmuxl.c                                  |    4 +-
>  net/can/af_can.c                                   |    4 +-
>  net/core/dev.c                                     |   14 +++---
>  net/core/fib_rules.c                               |    4 +-
>  net/core/filter.c                                  |    2 +-
>  net/core/neighbour.c                               |    2 +-
>  net/core/net-sysfs.c                               |    4 +-
>  net/core/netpoll.c                                 |    2 +-
>  net/core/netprio_cgroup.c                          |    2 +-
>  net/core/sock.c                                    |    4 +-
>  net/core/sysctl_net_core.c                         |    2 +-
>  net/decnet/dn_dev.c                                |    2 +-
>  net/decnet/dn_route.c                              |    2 +-
>  net/ipv4/devinet.c                                 |    4 +-
>  net/ipv4/fib_semantics.c                           |    2 +-
>  net/ipv4/fib_trie.c                                |    2 +-
>  net/ipv4/igmp.c                                    |    4 +-
>  net/ipv4/inetpeer.c                                |   50 ++++++++++----------
>  net/ipv4/ipmr.c                                    |    2 +-
>  net/ipv4/netfilter/nf_nat_h323.c                   |   36 +++++++-------
>  net/ipv4/netfilter/nf_nat_pptp.c                   |   16 +++----
>  net/ipv4/netfilter/nf_nat_snmp_basic.c             |    4 +-
>  net/ipv4/route.c                                   |    4 +-
>  net/ipv6/addrconf.c                                |    2 +-
>  net/ipv6/ip6_tunnel.c                              |    2 +-
>  net/ipv6/ip6_vti.c                                 |    2 +-
>  net/ipv6/netfilter.c                               |    4 +-
>  net/ipv6/raw.c                                     |    2 +-
>  net/ipv6/sit.c                                     |    2 +-
>  net/mac80211/agg-rx.c                              |    2 +-
>  net/mac80211/cfg.c                                 |    8 ++--
>  net/mac80211/ibss.c                                |    4 +-
>  net/mac80211/mesh.c                                |    2 +-
>  net/mac80211/mesh_pathtbl.c                        |    4 +-
>  net/mac80211/sta_info.c                            |    2 +-
>  net/netfilter/core.c                               |    4 +-
>  net/netfilter/ipvs/ip_vs_ctl.c                     |    4 +-
>  net/netfilter/ipvs/ip_vs_dh.c                      |    6 +--
>  net/netfilter/ipvs/ip_vs_sh.c                      |    6 +--
>  net/netfilter/nf_conntrack_core.c                  |    8 ++--
>  net/netfilter/nf_conntrack_ecache.c                |    4 +-
>  net/netfilter/nf_conntrack_extend.c                |    2 +-
>  net/netfilter/nf_conntrack_helper.c                |    6 +--
>  net/netfilter/nf_conntrack_netlink.c               |    8 ++--
>  net/netfilter/nf_conntrack_proto.c                 |    2 +-
>  net/netfilter/nf_log.c                             |    4 +-
>  net/netfilter/nf_nat_amanda.c                      |    4 +-
>  net/netfilter/nf_nat_core.c                        |   22 ++++-----
>  net/netfilter/nf_nat_ftp.c                         |    4 +-
>  net/netfilter/nf_nat_irc.c                         |    4 +-
>  net/netfilter/nf_nat_sip.c                         |    4 +-
>  net/netfilter/nf_nat_tftp.c                        |    4 +-
>  net/netfilter/nf_queue.c                           |    2 +-
>  net/netfilter/nfnetlink.c                          |    2 +-
>  net/netfilter/nfnetlink_cttimeout.c                |    8 ++--
>  net/netfilter/nft_hash.c                           |   14 +++---
>  net/netlabel/netlabel_domainhash.c                 |    2 +-
>  net/netlabel/netlabel_unlabeled.c                  |    2 +-
>  net/netlink/af_netlink.c                           |    2 +-
>  net/packet/af_packet.c                             |    2 +-
>  net/phonet/af_phonet.c                             |    2 +-
>  net/phonet/pn_dev.c                                |    4 +-
>  net/phonet/socket.c                                |    4 +-
>  net/socket.c                                       |    4 +-
>  net/sunrpc/auth_gss/auth_gss.c                     |    2 +-
>  net/tipc/bearer.c                                  |    2 +-
>  net/unix/af_unix.c                                 |    2 +-
>  net/xfrm/xfrm_input.c                              |    2 +-
>  net/xfrm/xfrm_policy.c                             |    2 +-
>  net/xfrm/xfrm_state.c                              |    2 +-
>  net/xfrm/xfrm_user.c                               |    2 +-
>  107 files changed, 268 insertions(+), 268 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c
> b/arch/powerpc/platforms/cell/spu_syscalls.c
> index 38e0a1a..2feef7c 100644
> --- a/arch/powerpc/platforms/cell/spu_syscalls.c
> +++ b/arch/powerpc/platforms/cell/spu_syscalls.c
> @@ -170,7 +170,7 @@ EXPORT_SYMBOL_GPL(register_spu_syscalls);
>  void unregister_spu_syscalls(struct spufs_calls *calls)
>  {
>      BUG_ON(spufs_calls->owner != calls->owner);
> -    RCU_INIT_POINTER(spufs_calls, NULL);
> +    rcu_init_pointer(spufs_calls, NULL);
>      synchronize_rcu();
>  }
>  EXPORT_SYMBOL_GPL(unregister_spu_syscalls);
> diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
> index 1e5481d..e72d3d7 100644
> --- a/drivers/crypto/nx/nx-842.c
> +++ b/drivers/crypto/nx/nx-842.c
> @@ -1262,14 +1262,14 @@ static int __init nx842_init(void)
>      struct nx842_devdata *new_devdata;
>      pr_info("Registering IBM Power 842 compression driver\n");
> 
> -    RCU_INIT_POINTER(devdata, NULL);
> +    rcu_init_pointer(devdata, NULL);
>      new_devdata = kzalloc(sizeof(*new_devdata), GFP_KERNEL);
>      if (!new_devdata) {
>          pr_err("Could not allocate memory for device data\n");
>          return -ENOMEM;
>      }
>      new_devdata->status = UNAVAILABLE;
> -    RCU_INIT_POINTER(devdata, new_devdata);
> +    rcu_init_pointer(devdata, new_devdata);
> 
>      return vio_register_driver(&nx842_driver);
>  }
> diff --git a/drivers/infiniband/hw/qib/qib_qp.c
> b/drivers/infiniband/hw/qib/qib_qp.c
> index 0cad0c4..e967aa5 100644
> --- a/drivers/infiniband/hw/qib/qib_qp.c
> +++ b/drivers/infiniband/hw/qib/qib_qp.c
> @@ -1041,7 +1041,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
>              ret = ERR_PTR(-ENOMEM);
>              goto bail_swq;
>          }
> -        RCU_INIT_POINTER(qp->next, NULL);
> +        rcu_init_pointer(qp->next, NULL);
>          qp->s_hdr = kzalloc(sizeof(*qp->s_hdr), GFP_KERNEL);
>          if (!qp->s_hdr) {
>              ret = ERR_PTR(-ENOMEM);
> diff --git a/drivers/infiniband/hw/qib/qib_verbs.c
> b/drivers/infiniband/hw/qib/qib_verbs.c
> index 9bcfbd8..8ed08aa9 100644
> --- a/drivers/infiniband/hw/qib/qib_verbs.c
> +++ b/drivers/infiniband/hw/qib/qib_verbs.c
> @@ -2035,8 +2035,8 @@ static void init_ibport(struct qib_pportdata *ppd)
>      ibp->z_excessive_buffer_overrun_errors =
>          cntrs.excessive_buffer_overrun_errors;
>      ibp->z_vl15_dropped = cntrs.vl15_dropped;
> -    RCU_INIT_POINTER(ibp->qp0, NULL);
> -    RCU_INIT_POINTER(ibp->qp1, NULL);
> +    rcu_init_pointer(ibp->qp0, NULL);
> +    rcu_init_pointer(ibp->qp1, NULL);
>  }
> 
>  /**
> @@ -2061,7 +2061,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
>          goto err_qpt;
>      }
>      for (i = 0; i < dev->qp_table_size; i++)
> -        RCU_INIT_POINTER(dev->qp_table[i], NULL);
> +        rcu_init_pointer(dev->qp_table[i], NULL);
> 
>      for (i = 0; i < dd->num_pports; i++)
>          init_ibport(ppd + i);
> @@ -2094,9 +2094,9 @@ int qib_register_ib_device(struct qib_devdata *dd)
>          ret = -ENOMEM;
>          goto err_lk;
>      }
> -    RCU_INIT_POINTER(dev->dma_mr, NULL);
> +    rcu_init_pointer(dev->dma_mr, NULL);
>      for (i = 0; i < dev->lk_table.max; i++)
> -        RCU_INIT_POINTER(dev->lk_table.table[i], NULL);
> +        rcu_init_pointer(dev->lk_table.table[i], NULL);
>      INIT_LIST_HEAD(&dev->pending_mmaps);
>      spin_lock_init(&dev->pending_lock);
>      dev->mmap_offset = PAGE_SIZE;
> diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
> index c276fde..86ae582 100644
> --- a/drivers/ipack/carriers/tpci200.c
> +++ b/drivers/ipack/carriers/tpci200.c
> @@ -187,7 +187,7 @@ static int tpci200_free_irq(struct ipack_device *dev)
>      tpci200_disable_irq(tpci200, dev->slot);
>      slot_irq = tpci200->slots[dev->slot].irq;
>      /* uninstall handler */
> -    RCU_INIT_POINTER(tpci200->slots[dev->slot].irq, NULL);
> +    rcu_init_pointer(tpci200->slots[dev->slot].irq, NULL);
>      synchronize_rcu();
>      kfree(slot_irq);
>      mutex_unlock(&tpci200->mutex);
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 455e649..19e6e9a 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2168,7 +2168,7 @@ static struct dm_table *__unbind(struct mapped_device *md)
>          return NULL;
> 
>      dm_table_event_callback(map, NULL, NULL);
> -    RCU_INIT_POINTER(md->map, NULL);
> +    rcu_init_pointer(md->map, NULL);
>      dm_sync_table(md);
> 
>      return map;
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 69aff72..d75c7ef 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1704,7 +1704,7 @@ static int __bond_release_one(struct net_device *bond_dev,
>      }
> 
>      if (all) {
> -        RCU_INIT_POINTER(bond->curr_active_slave, NULL);
> +        rcu_init_pointer(bond->curr_active_slave, NULL);
>      } else if (oldcurrent == slave) {
>          /*
>           * Note that we hold RTNL over this sequence, so there
> diff --git a/drivers/net/bonding/bond_options.c
> b/drivers/net/bonding/bond_options.c
> index 724e30f..069c7c3 100644
> --- a/drivers/net/bonding/bond_options.c
> +++ b/drivers/net/bonding/bond_options.c
> @@ -712,7 +712,7 @@ static int bond_option_active_slave_set(struct
> bonding *bond,
>      /* check to see if we are clearing active */
>      if (!slave_dev) {
>          pr_info("%s: Clearing current active slave\n", bond->dev->name);
> -        RCU_INIT_POINTER(bond->curr_active_slave, NULL);
> +        rcu_init_pointer(bond->curr_active_slave, NULL);
>          bond_select_active_slave(bond);
>      } else {
>          struct slave *old_active = bond->curr_active_slave;
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c
> b/drivers/net/ethernet/broadcom/bnx2.c
> index 0ab8370..7facbc4 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -409,7 +409,7 @@ static int bnx2_unregister_cnic(struct net_device *dev)
>      mutex_lock(&bp->cnic_lock);
>      cp->drv_state = 0;
>      bnapi->cnic_present = 0;
> -    RCU_INIT_POINTER(bp->cnic_ops, NULL);
> +    rcu_init_pointer(bp->cnic_ops, NULL);
>      mutex_unlock(&bp->cnic_lock);
>      synchronize_rcu();
>      return 0;
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index a78edac..83a228e 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -14048,7 +14048,7 @@ static int bnx2x_unregister_cnic(struct net_device *dev)
> 
>      mutex_lock(&bp->cnic_mutex);
>      cp->drv_state = 0;
> -    RCU_INIT_POINTER(bp->cnic_ops, NULL);
> +    rcu_init_pointer(bp->cnic_ops, NULL);
>      mutex_unlock(&bp->cnic_mutex);
>      synchronize_rcu();
>      bp->cnic_enabled = false;
> diff --git a/drivers/net/ethernet/broadcom/cnic.c
> b/drivers/net/ethernet/broadcom/cnic.c
> index 09f3fef..42d5ff3a 100644
> --- a/drivers/net/ethernet/broadcom/cnic.c
> +++ b/drivers/net/ethernet/broadcom/cnic.c
> @@ -534,7 +534,7 @@ int cnic_unregister_driver(int ulp_type)
>      }
>      read_unlock(&cnic_dev_lock);
> 
> -    RCU_INIT_POINTER(cnic_ulp_tbl[ulp_type], NULL);
> +    rcu_init_pointer(cnic_ulp_tbl[ulp_type], NULL);
> 
>      mutex_unlock(&cnic_lock);
>      synchronize_rcu();
> @@ -610,7 +610,7 @@ static int cnic_unregister_device(struct cnic_dev
> *dev, int ulp_type)
>      }
>      mutex_lock(&cnic_lock);
>      if (rcu_dereference(cp->ulp_ops[ulp_type])) {
> -        RCU_INIT_POINTER(cp->ulp_ops[ulp_type], NULL);
> +        rcu_init_pointer(cp->ulp_ops[ulp_type], NULL);
>          cnic_put(dev);
>      } else {
>          pr_err("%s: device not registered to this ulp type %d\n",
> @@ -5414,7 +5414,7 @@ static void cnic_stop_hw(struct cnic_dev *dev)
>          cp->stop_cm(dev);
>          cp->ethdev->drv_state &= ~CNIC_DRV_STATE_HANDLES_IRQ;
>          clear_bit(CNIC_F_CNIC_UP, &dev->flags);
> -        RCU_INIT_POINTER(cp->ulp_ops[CNIC_ULP_L4], NULL);
> +        rcu_init_pointer(cp->ulp_ops[CNIC_ULP_L4], NULL);
>          synchronize_rcu();
>          cnic_cm_shutdown(dev);
>          cp->stop_hw(dev);
> diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
> b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
> index c0a9dd5..466f3b2 100644
> --- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
> +++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
> @@ -1280,7 +1280,7 @@ int cxgb3_offload_activate(struct adapter *adapter)
>      INIT_LIST_HEAD(&t->list_node);
>      t->dev = dev;
> 
> -    RCU_INIT_POINTER(dev->l2opt, l2td);
> +    rcu_init_pointer(dev->l2opt, l2td);
>      T3C_DATA(dev) = t;
>      dev->recv = process_rx;
>      dev->neigh_update = t3_l2t_update;
> @@ -1324,7 +1324,7 @@ void cxgb3_offload_deactivate(struct adapter *adapter)
>      rcu_read_lock();
>      d = L2DATA(tdev);
>      rcu_read_unlock();
> -    RCU_INIT_POINTER(tdev->l2opt, NULL);
> +    rcu_init_pointer(tdev->l2opt, NULL);
>      call_rcu(&d->rcu_head, clean_l2_data);
>      if (t->nofail_skb)
>          kfree_skb(t->nofail_skb);
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index ff111a8..c343c1d 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -159,7 +159,7 @@ static int macvtap_disable_queue(struct macvtap_queue *q)
>          nq->queue_index = index;
> 
>          rcu_assign_pointer(vlan->taps[index], nq);
> -        RCU_INIT_POINTER(vlan->taps[vlan->numvtaps - 1], NULL);
> +        rcu_init_pointer(vlan->taps[vlan->numvtaps - 1], NULL);
>          q->enabled = false;
> 
>          vlan->numvtaps--;
> @@ -188,7 +188,7 @@ static void macvtap_put_queue(struct macvtap_queue *q)
>              BUG_ON(macvtap_disable_queue(q));
> 
>          vlan->numqueues--;
> -        RCU_INIT_POINTER(q->vlan, NULL);
> +        rcu_init_pointer(q->vlan, NULL);
>          sock_put(&q->sk);
>          list_del_init(&q->next);
>      }
> @@ -259,13 +259,13 @@ static void macvtap_del_queues(struct net_device *dev)
>      list_for_each_entry_safe(q, tmp, &vlan->queue_list, next) {
>          list_del_init(&q->next);
>          qlist[j++] = q;
> -        RCU_INIT_POINTER(q->vlan, NULL);
> +        rcu_init_pointer(q->vlan, NULL);
>          if (q->enabled)
>              vlan->numvtaps--;
>          vlan->numqueues--;
>      }
>      for (i = 0; i < vlan->numvtaps; i++)
> -        RCU_INIT_POINTER(vlan->taps[i], NULL);
> +        rcu_init_pointer(vlan->taps[i], NULL);
>      BUG_ON(vlan->numvtaps);
>      BUG_ON(vlan->numqueues);
>      /* guarantee that any future macvtap_set_queue will fail */
> @@ -459,7 +459,7 @@ static int macvtap_open(struct inode *inode,
> struct file *file)
>      if (!q)
>          goto out;
> 
> -    RCU_INIT_POINTER(q->sock.wq, &q->wq);
> +    rcu_init_pointer(q->sock.wq, &q->wq);
>      init_waitqueue_head(&q->wq.wait);
>      q->sock.type = SOCK_RAW;
>      q->sock.state = SS_CONNECTED;
> diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
> index 0180531..b7c2acb 100644
> --- a/drivers/net/ppp/pptp.c
> +++ b/drivers/net/ppp/pptp.c
> @@ -162,7 +162,7 @@ static void del_chan(struct pppox_sock *sock)
>  {
>      spin_lock(&chan_lock);
>      clear_bit(sock->proto.pptp.src_addr.call_id, callid_bitmap);
> -    RCU_INIT_POINTER(callid_sock[sock->proto.pptp.src_addr.call_id], NULL);
> +    rcu_init_pointer(callid_sock[sock->proto.pptp.src_addr.call_id], NULL);
>      spin_unlock(&chan_lock);
>      synchronize_rcu();
>  }
> diff --git a/drivers/net/team/team_mode_activebackup.c
> b/drivers/net/team/team_mode_activebackup.c
> index 40fd338..91b3066 100644
> --- a/drivers/net/team/team_mode_activebackup.c
> +++ b/drivers/net/team/team_mode_activebackup.c
> @@ -56,7 +56,7 @@ drop:
>  static void ab_port_leave(struct team *team, struct team_port *port)
>  {
>      if (ab_priv(team)->active_port == port) {
> -        RCU_INIT_POINTER(ab_priv(team)->active_port, NULL);
> +        rcu_init_pointer(ab_priv(team)->active_port, NULL);
>          team_option_inst_set_change(ab_priv(team)->ap_opt_inst_info);
>      }
>  }
> diff --git a/drivers/net/team/team_mode_loadbalance.c
> b/drivers/net/team/team_mode_loadbalance.c
> index dbde341..deef2c9 100644
> --- a/drivers/net/team/team_mode_loadbalance.c
> +++ b/drivers/net/team/team_mode_loadbalance.c
> @@ -97,7 +97,7 @@ static void
> lb_tx_hash_to_port_mapping_null_port(struct team *team,
> 
>          pm = &lb_priv->ex->tx_hash_to_port_mapping[i];
>          if (rcu_access_pointer(pm->port) == port) {
> -            RCU_INIT_POINTER(pm->port, NULL);
> +            rcu_init_pointer(pm->port, NULL);
>              team_option_inst_set_change(pm->opt_inst_info);
>              changed = true;
>          }
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index ee328ba..ab06040 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -452,7 +452,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
> 
>          --tun->numqueues;
>          if (clean) {
> -            RCU_INIT_POINTER(tfile->tun, NULL);
> +            rcu_init_pointer(tfile->tun, NULL);
>              sock_put(&tfile->sk);
>          } else
>              tun_disable_queue(tun, tfile);
> @@ -499,12 +499,12 @@ static void tun_detach_all(struct net_device *dev)
>          tfile = rtnl_dereference(tun->tfiles[i]);
>          BUG_ON(!tfile);
>          wake_up_all(&tfile->wq.wait);
> -        RCU_INIT_POINTER(tfile->tun, NULL);
> +        rcu_init_pointer(tfile->tun, NULL);
>          --tun->numqueues;
>      }
>      list_for_each_entry(tfile, &tun->disabled, next) {
>          wake_up_all(&tfile->wq.wait);
> -        RCU_INIT_POINTER(tfile->tun, NULL);
> +        rcu_init_pointer(tfile->tun, NULL);
>      }
>      BUG_ON(tun->numqueues != 0);
> 
> @@ -2194,7 +2194,7 @@ static int tun_chr_open(struct inode *inode,
> struct file * file)
>                          &tun_proto);
>      if (!tfile)
>          return -ENOMEM;
> -    RCU_INIT_POINTER(tfile->tun, NULL);
> +    rcu_init_pointer(tfile->tun, NULL);
>      tfile->net = get_net(current->nsproxy->net_ns);
>      tfile->flags = 0;
>      tfile->ifindex = 0;
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index b4a10bc..b8c026f 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -432,12 +432,12 @@ static void veth_dellink(struct net_device *dev,
> struct list_head *head)
>       * before a rcu_synchronize() point. The devices are guaranteed
>       * not being freed before one RCU grace period.
>       */
> -    RCU_INIT_POINTER(priv->peer, NULL);
> +    rcu_init_pointer(priv->peer, NULL);
>      unregister_netdevice_queue(dev, head);
> 
>      if (peer) {
>          priv = netdev_priv(peer);
> -        RCU_INIT_POINTER(priv->peer, NULL);
> +        rcu_init_pointer(priv->peer, NULL);
>          unregister_netdevice_queue(peer, head);
>      }
>  }
> diff --git a/drivers/net/wireless/ath/carl9170/main.c
> b/drivers/net/wireless/ath/carl9170/main.c
> index 4c8cdb0..9ba9885 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -450,7 +450,7 @@ static void carl9170_op_stop(struct ieee80211_hw *hw)
> 
>      mutex_lock(&ar->mutex);
>      if (IS_ACCEPTING_CMD(ar)) {
> -        RCU_INIT_POINTER(ar->beacon_iter, NULL);
> +        rcu_init_pointer(ar->beacon_iter, NULL);
> 
>          carl9170_led_set_state(ar, 0);
> 
> @@ -747,7 +747,7 @@ unlock:
>          vif_priv->active = false;
>          bitmap_release_region(&ar->vif_bitmap, vif_id, 0);
>          ar->vifs--;
> -        RCU_INIT_POINTER(ar->vif_priv[vif_id].vif, NULL);
> +        rcu_init_pointer(ar->vif_priv[vif_id].vif, NULL);
>          list_del_rcu(&vif_priv->list);
>          mutex_unlock(&ar->mutex);
>          synchronize_rcu();
> @@ -785,7 +785,7 @@ static void carl9170_op_remove_interface(struct
> ieee80211_hw *hw,
>      WARN_ON(vif_priv->enable_beacon);
>      vif_priv->enable_beacon = false;
>      list_del_rcu(&vif_priv->list);
> -    RCU_INIT_POINTER(ar->vif_priv[id].vif, NULL);
> +    rcu_init_pointer(ar->vif_priv[id].vif, NULL);
> 
>      if (vif == main_vif) {
>          rcu_read_unlock();
> @@ -1333,7 +1333,7 @@ static int carl9170_op_sta_add(struct ieee80211_hw *hw,
>          }
> 
>          for (i = 0; i < ARRAY_SIZE(sta_info->agg); i++)
> -            RCU_INIT_POINTER(sta_info->agg[i], NULL);
> +            rcu_init_pointer(sta_info->agg[i], NULL);
> 
>          sta_info->ampdu_max_len = 1 << (3 + sta->ht_cap.ampdu_factor);
>          sta_info->ht_sta = true;
> @@ -1360,7 +1360,7 @@ static int carl9170_op_sta_remove(struct ieee80211_hw *hw,
>              struct carl9170_sta_tid *tid_info;
> 
>              tid_info = rcu_dereference(sta_info->agg[i]);
> -            RCU_INIT_POINTER(sta_info->agg[i], NULL);
> +            rcu_init_pointer(sta_info->agg[i], NULL);
> 
>              if (!tid_info)
>                  continue;
> @@ -1477,7 +1477,7 @@ static int carl9170_op_ampdu_action(struct
> ieee80211_hw *hw,
>              spin_unlock_bh(&ar->tx_ampdu_list_lock);
>          }
> 
> -        RCU_INIT_POINTER(sta_info->agg[tid], NULL);
> +        rcu_init_pointer(sta_info->agg[tid], NULL);
>          rcu_read_unlock();
> 
>          ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
> diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c
> b/drivers/net/wireless/iwlwifi/mvm/fw.c
> index 7ce2006..751abf0 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/fw.c
> +++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
> @@ -443,7 +443,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
> 
>      /* init the fw <-> mac80211 STA mapping */
>      for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
> -        RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
> +        rcu_init_pointer(mvm->fw_id_to_mac_id[i], NULL);
> 
>      /* Add auxiliary station for scanning */
>      ret = iwl_mvm_add_aux_sta(mvm);
> @@ -520,7 +520,7 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm)
> 
>      /* init the fw <-> mac80211 STA mapping */
>      for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
> -        RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
> +        rcu_init_pointer(mvm->fw_id_to_mac_id[i], NULL);
> 
>      /* Add auxiliary station for scanning */
>      ret = iwl_mvm_add_aux_sta(mvm);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 78987e4..92d3fbc 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -419,7 +419,7 @@ void vhost_dev_reset_owner(struct vhost_dev *dev,
> struct vhost_memory *memory)
> 
>      /* Restore memory to default empty mapping. */
>      memory->nregions = 0;
> -    RCU_INIT_POINTER(dev->memory, memory);
> +    rcu_init_pointer(dev->memory, memory);
>  }
>  EXPORT_SYMBOL_GPL(vhost_dev_reset_owner);
> 
> @@ -465,7 +465,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev, bool locked)
>      kfree(rcu_dereference_protected(dev->memory,
>                      locked ==
>                          lockdep_is_held(&dev->mutex)));
> -    RCU_INIT_POINTER(dev->memory, NULL);
> +    rcu_init_pointer(dev->memory, NULL);
>      WARN_ON(!list_empty(&dev->work_list));
>      if (dev->worker) {
>          kthread_stop(dev->worker);
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index af90312..bc52fb8 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1250,7 +1250,7 @@ static noinline void
> ep_destroy_wakeup_source(struct epitem *epi)
>  {
>      struct wakeup_source *ws = ep_wakeup_source(epi);
> 
> -    RCU_INIT_POINTER(epi->ws, NULL);
> +    rcu_init_pointer(epi->ws, NULL);
> 
>      /*
>       * wait for ep_pm_stay_awake_rcu to finish, synchronize_rcu is
> @@ -1293,7 +1293,7 @@ static int ep_insert(struct eventpoll *ep,
> struct epoll_event *event,
>          if (error)
>              goto error_create_wakeup_source;
>      } else {
> -        RCU_INIT_POINTER(epi->ws, NULL);
> +        rcu_init_pointer(epi->ws, NULL);
>      }
> 
>      /* Initialize the poll table using the queue callback */
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 0adbc02..a8734e0 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -47,7 +47,7 @@ static void proc_evict_inode(struct inode *inode)
>          pde_put(de);
>      head = PROC_I(inode)->sysctl;
>      if (head) {
> -        RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
> +        rcu_init_pointer(PROC_I(inode)->sysctl, NULL);
>          sysctl_head_put(head);
>      }
>      /* Release any associated namespace */
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 00a7fd6..d384392 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -566,13 +566,13 @@ static inline void rcu_preempt_sleep_check(void)
>   * assignment.  More importantly, this call documents which pointers
>   * will be dereferenced by RCU read-side code.
>   *
> - * In some special cases, you may use RCU_INIT_POINTER() instead
> - * of rcu_assign_pointer().  RCU_INIT_POINTER() is a bit faster due
> + * In some special cases, you may use rcu_init_pointer() instead
> + * of rcu_assign_pointer().  rcu_init_pointer() is a bit faster due
>   * to the fact that it does not constrain either the CPU or the compiler.
> - * That said, using RCU_INIT_POINTER() when you should have used
> + * That said, using rcu_init_pointer() when you should have used
>   * rcu_assign_pointer() is a very bad thing that results in
>   * impossible-to-diagnose memory corruption.  So please be careful.
> - * See the RCU_INIT_POINTER() comment header for details.
> + * See the rcu_init_pointer() comment header for details.
>   *
>   * Note that rcu_assign_pointer() evaluates each of its arguments only
>   * once, appearances notwithstanding.  One of the "extra" evaluations
> @@ -919,13 +919,13 @@ static inline notrace void
> rcu_read_unlock_sched_notrace(void)
>  }
> 
>  /**
> - * RCU_INIT_POINTER() - initialize an RCU protected pointer
> + * rcu_init_pointer() - initialize an RCU protected pointer
>   *
>   * Initialize an RCU-protected pointer in special cases where readers
>   * do not need ordering constraints on the CPU or the compiler.  These
>   * special cases are:
>   *
> - * 1.    This use of RCU_INIT_POINTER() is NULLing out the pointer -or-
> + * 1.    This use of rcu_init_pointer() is NULLing out the pointer -or-
>   * 2.    The caller has taken whatever steps are required to prevent
>   *    RCU readers from concurrently accessing this pointer -or-
>   * 3.    The referenced data structure has already been exposed to
> @@ -937,20 +937,20 @@ static inline notrace void
> rcu_read_unlock_sched_notrace(void)
>   *        example, the changes were to statistical counters or to
>   *        other state where exact synchronization is not required.)
>   *
> - * Failure to follow these rules governing use of RCU_INIT_POINTER() will
> + * Failure to follow these rules governing use of rcu_init_pointer() will
>   * result in impossible-to-diagnose memory corruption.  As in the structures
>   * will look OK in crash dumps, but any concurrent RCU readers might
>   * see pre-initialized values of the referenced data structure.  So
> - * please be very careful how you use RCU_INIT_POINTER()!!!
> + * please be very careful how you use rcu_init_pointer()!!!
>   *
>   * If you are creating an RCU-protected linked structure that is accessed
>   * by a single external-to-structure RCU-protected pointer, then you may
> - * use RCU_INIT_POINTER() to initialize the internal RCU-protected
> + * use rcu_init_pointer() to initialize the internal RCU-protected
>   * pointers, but you must use rcu_assign_pointer() to initialize the
>   * external-to-structure pointer -after- you have completely initialized
>   * the reader-accessible portions of the linked structure.
>   */
> -#define RCU_INIT_POINTER(p, v) \
> +#define rcu_init_pointer(p, v) \
>      do { \
>          p = RCU_INITIALIZER(v); \
>      } while (0)
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7c28936..f5bf565 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1102,7 +1102,7 @@ static void __net_exit audit_net_exit(struct net *net)
>          audit_sock = NULL;
>      }
> 
> -    RCU_INIT_POINTER(aunet->nlsk, NULL);
> +    rcu_init_pointer(aunet->nlsk, NULL);
>      synchronize_net();
>      netlink_kernel_release(sock);
>  }
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 9fcdaa7..252320b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1045,7 +1045,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
> 
>          WARN_ON(!css || cgroup_css(&dst_root->cgrp, ss));
> 
> -        RCU_INIT_POINTER(src_root->cgrp.subsys[ssid], NULL);
> +        rcu_init_pointer(src_root->cgrp.subsys[ssid], NULL);
>          rcu_assign_pointer(dst_root->cgrp.subsys[ssid], css);
>          ss->root = dst_root;
>          css->cgroup = &dst_root->cgrp;
> @@ -3567,7 +3567,7 @@ static void css_release(struct percpu_ref *ref)
>      struct cgroup_subsys_state *css =
>          container_of(ref, struct cgroup_subsys_state, refcnt);
> 
> -    RCU_INIT_POINTER(css->cgroup->subsys[css->ss->id], NULL);
> +    rcu_init_pointer(css->cgroup->subsys[css->ss->id], NULL);
>      call_rcu(&css->rcu_head, css_free_rcu_fn);
>  }
> 
> @@ -3621,7 +3621,7 @@ static void offline_css(struct cgroup_subsys_state *css)
> 
>      css->flags &= ~CSS_ONLINE;
>      css->cgroup->nr_css--;
> -    RCU_INIT_POINTER(css->cgroup->subsys[ss->id], css);
> +    rcu_init_pointer(css->cgroup->subsys[ss->id], css);
>  }
> 
>  /**
> @@ -4044,7 +4044,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>       * after all files under it have been removed.
>       */
>      kernfs_remove(cgrp->kn);    /* @cgrp has an extra ref on its kn */
> -    RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
> +    rcu_init_pointer(*(void __rcu __force **)&cgrp->kn->priv, NULL);
> 
>      mutex_lock(&cgroup_mutex);
> 
> @@ -4169,7 +4169,7 @@ int __init cgroup_init_early(void)
>      int i;
> 
>      init_cgroup_root(&cgrp_dfl_root, &opts);
> -    RCU_INIT_POINTER(init_task.cgroups, &init_css_set);
> +    rcu_init_pointer(init_task.cgroups, &init_css_set);
> 
>      for_each_subsys(ss, i) {
>          WARN(!ss->css_alloc || !ss->css_free || ss->name || ss->id,
> @@ -4377,7 +4377,7 @@ static const struct file_operations
> proc_cgroupstats_operations = {
>   */
>  void cgroup_fork(struct task_struct *child)
>  {
> -    RCU_INIT_POINTER(child->cgroups, &init_css_set);
> +    rcu_init_pointer(child->cgroups, &init_css_set);
>      INIT_LIST_HEAD(&child->cg_list);
>  }
> 
> @@ -4481,7 +4481,7 @@ void cgroup_exit(struct task_struct *tsk)
> 
>      /* Reassign the task to the init_css_set. */
>      cset = task_css_set(tsk);
> -    RCU_INIT_POINTER(tsk->cgroups, &init_css_set);
> +    rcu_init_pointer(tsk->cgroups, &init_css_set);
> 
>      if (need_forkexit_callback) {
>          /* see cgroup_post_fork() for details */
> diff --git a/kernel/trace/trace_events_filter.c
> b/kernel/trace/trace_events_filter.c
> index 8a86319..93b0d89 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -1708,9 +1708,9 @@ static inline void event_clear_filter(struct
> ftrace_event_file *file)
>      struct ftrace_event_call *call = file->event_call;
> 
>      if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> -        RCU_INIT_POINTER(call->filter, NULL);
> +        rcu_init_pointer(call->filter, NULL);
>      else
> -        RCU_INIT_POINTER(file->filter, NULL);
> +        rcu_init_pointer(file->filter, NULL);
>  }
> 
>  static inline void
> diff --git a/kernel/trace/trace_events_trigger.c
> b/kernel/trace/trace_events_trigger.c
> index 925f537..07dc2eb 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -1212,7 +1212,7 @@ event_enable_trigger_func(struct event_command *cmd_ops,
>      trigger_data->ops = trigger_ops;
>      trigger_data->cmd_ops = cmd_ops;
>      INIT_LIST_HEAD(&trigger_data->list);
> -    RCU_INIT_POINTER(trigger_data->filter, NULL);
> +    rcu_init_pointer(trigger_data->filter, NULL);
> 
>      enable_data->enable = enable;
>      enable_data->file = event_enable_file;
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 0ee63af..3c897f5 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4343,7 +4343,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
>           */
>          for_each_node(node) {
>              pwq = rcu_access_pointer(wq->numa_pwq_tbl[node]);
> -            RCU_INIT_POINTER(wq->numa_pwq_tbl[node], NULL);
> +            rcu_init_pointer(wq->numa_pwq_tbl[node], NULL);
>              put_pwq_unlocked(pwq);
>          }
> 
> diff --git a/lib/idr.c b/lib/idr.c
> index 2642fa8..b885650 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -152,7 +152,7 @@ static void idr_layer_rcu_free(struct rcu_head *head)
>  static inline void free_layer(struct idr *idr, struct idr_layer *p)
>  {
>      if (idr->hint && idr->hint == p)
> -        RCU_INIT_POINTER(idr->hint, NULL);
> +        rcu_init_pointer(idr->hint, NULL);
>      call_rcu(&p->rcu_head, idr_layer_rcu_free);
>  }
> 
> @@ -533,7 +533,7 @@ static void sub_remove(struct idr *idp, int shift, int id)
>      n = id & IDR_MASK;
>      if (likely(p != NULL && test_bit(n, p->bitmap))) {
>          __clear_bit(n, p->bitmap);
> -        RCU_INIT_POINTER(p->ary[n], NULL);
> +        rcu_init_pointer(p->ary[n], NULL);
>          to_free = NULL;
>          while(*paa && ! --((**paa)->count)){
>              if (to_free)
> @@ -602,7 +602,7 @@ static void __idr_remove_all(struct idr *idp)
> 
>      n = idp->layers * IDR_BITS;
>      p = idp->top;
> -    RCU_INIT_POINTER(idp->top, NULL);
> +    rcu_init_pointer(idp->top, NULL);
>      max = idr_max(idp->layers);
> 
>      id = 0;
> diff --git a/net/802/garp.c b/net/802/garp.c
> index b38ee6d..4bc98ac 100644
> --- a/net/802/garp.c
> +++ b/net/802/garp.c
> @@ -552,7 +552,7 @@ static void garp_release_port(struct net_device *dev)
>          if (rtnl_dereference(port->applicants[i]))
>              return;
>      }
> -    RCU_INIT_POINTER(dev->garp_port, NULL);
> +    rcu_init_pointer(dev->garp_port, NULL);
>      kfree_rcu(port, rcu);
>  }
> 
> @@ -604,7 +604,7 @@ void garp_uninit_applicant(struct net_device *dev,
> struct garp_application *appl
> 
>      ASSERT_RTNL();
> 
> -    RCU_INIT_POINTER(port->applicants[appl->type], NULL);
> +    rcu_init_pointer(port->applicants[appl->type], NULL);
> 
>      /* Delete timer and generate a final TRANSMIT_PDU event to flush out
>       * all pending messages before the applicant is gone. */
> diff --git a/net/802/mrp.c b/net/802/mrp.c
> index 72db278..e57b50e 100644
> --- a/net/802/mrp.c
> +++ b/net/802/mrp.c
> @@ -834,7 +834,7 @@ static void mrp_release_port(struct net_device *dev)
>          if (rtnl_dereference(port->applicants[i]))
>              return;
>      }
> -    RCU_INIT_POINTER(dev->mrp_port, NULL);
> +    rcu_init_pointer(dev->mrp_port, NULL);
>      kfree_rcu(port, rcu);
>  }
> 
> @@ -890,7 +890,7 @@ void mrp_uninit_applicant(struct net_device *dev,
> struct mrp_application *appl)
> 
>      ASSERT_RTNL();
> 
> -    RCU_INIT_POINTER(port->applicants[appl->type], NULL);
> +    rcu_init_pointer(port->applicants[appl->type], NULL);
> 
>      /* Delete timer and generate a final TX event to flush out
>       * all pending messages before the applicant is gone.
> diff --git a/net/802/stp.c b/net/802/stp.c
> index 2c40ba0..75c1a32 100644
> --- a/net/802/stp.c
> +++ b/net/802/stp.c
> @@ -89,9 +89,9 @@ void stp_proto_unregister(const struct stp_proto *proto)
>  {
>      mutex_lock(&stp_proto_mutex);
>      if (is_zero_ether_addr(proto->group_address))
> -        RCU_INIT_POINTER(stp_proto, NULL);
> +        rcu_init_pointer(stp_proto, NULL);
>      else
> -        RCU_INIT_POINTER(garp_protos[proto->group_address[5] -
> +        rcu_init_pointer(garp_protos[proto->group_address[5] -
>                             GARP_ADDR_MIN], NULL);
>      synchronize_rcu();
> 
> diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
> index 3c32bd2..252d777 100644
> --- a/net/8021q/vlan_core.c
> +++ b/net/8021q/vlan_core.c
> @@ -343,7 +343,7 @@ void vlan_vid_del(struct net_device *dev, __be16
> proto, u16 vid)
>      if (vid_info->refcount == 0) {
>          __vlan_vid_del(vlan_info, vid_info);
>          if (vlan_info->nr_vids == 0) {
> -            RCU_INIT_POINTER(dev->vlan_info, NULL);
> +            rcu_init_pointer(dev->vlan_info, NULL);
>              call_rcu(&vlan_info->rcu, vlan_info_rcu_free);
>          }
>      }
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 4a37161..99ffd42 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -99,9 +99,9 @@ static int __vlan_del(struct net_port_vlans *v, u16 vid)
>      v->num_vlans--;
>      if (bitmap_empty(v->vlan_bitmap, VLAN_N_VID)) {
>          if (v->port_idx)
> -            RCU_INIT_POINTER(v->parent.port->vlan_info, NULL);
> +            rcu_init_pointer(v->parent.port->vlan_info, NULL);
>          else
> -            RCU_INIT_POINTER(v->parent.br->vlan_info, NULL);
> +            rcu_init_pointer(v->parent.br->vlan_info, NULL);
>          kfree_rcu(v, rcu);
>      }
>      return 0;
> @@ -113,9 +113,9 @@ static void __vlan_flush(struct net_port_vlans *v)
>      v->pvid = 0;
>      bitmap_zero(v->vlan_bitmap, VLAN_N_VID);
>      if (v->port_idx)
> -        RCU_INIT_POINTER(v->parent.port->vlan_info, NULL);
> +        rcu_init_pointer(v->parent.port->vlan_info, NULL);
>      else
> -        RCU_INIT_POINTER(v->parent.br->vlan_info, NULL);
> +        rcu_init_pointer(v->parent.br->vlan_info, NULL);
>      kfree_rcu(v, rcu);
>  }
> 
> diff --git a/net/bridge/netfilter/ebtable_broute.c
> b/net/bridge/netfilter/ebtable_broute.c
> index d2cdf5d..13445ac 100644
> --- a/net/bridge/netfilter/ebtable_broute.c
> +++ b/net/bridge/netfilter/ebtable_broute.c
> @@ -83,14 +83,14 @@ static int __init ebtable_broute_init(void)
>      if (ret < 0)
>          return ret;
>      /* see br_input.c */
> -    RCU_INIT_POINTER(br_should_route_hook,
> +    rcu_init_pointer(br_should_route_hook,
>                 (br_should_route_hook_t *)ebt_broute);
>      return 0;
>  }
> 
>  static void __exit ebtable_broute_fini(void)
>  {
> -    RCU_INIT_POINTER(br_should_route_hook, NULL);
> +    rcu_init_pointer(br_should_route_hook, NULL);
>      synchronize_net();
>      unregister_pernet_subsys(&broute_net_ops);
>  }
> diff --git a/net/caif/cfmuxl.c b/net/caif/cfmuxl.c
> index 8c5d638..15d5d6d 100644
> --- a/net/caif/cfmuxl.c
> +++ b/net/caif/cfmuxl.c
> @@ -108,7 +108,7 @@ struct cflayer *cfmuxl_remove_dnlayer(struct
> cflayer *layr, u8 phyid)
>      int idx = phyid % DN_CACHE_SIZE;
> 
>      spin_lock_bh(&muxl->transmit_lock);
> -    RCU_INIT_POINTER(muxl->dn_cache[idx], NULL);
> +    rcu_init_pointer(muxl->dn_cache[idx], NULL);
>      dn = get_from_id(&muxl->frml_list, phyid);
>      if (dn == NULL)
>          goto out;
> @@ -164,7 +164,7 @@ struct cflayer *cfmuxl_remove_uplayer(struct
> cflayer *layr, u8 id)
>      if (up == NULL)
>          goto out;
> 
> -    RCU_INIT_POINTER(muxl->up_cache[idx], NULL);
> +    rcu_init_pointer(muxl->up_cache[idx], NULL);
>      list_del_rcu(&up->node);
>  out:
>      spin_unlock_bh(&muxl->receive_lock);
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index a27f8aa..8df0f52 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -761,7 +761,7 @@ int can_proto_register(const struct can_proto *cp)
>          pr_err("can: protocol %d already registered\n", proto);
>          err = -EBUSY;
>      } else
> -        RCU_INIT_POINTER(proto_tab[proto], cp);
> +        rcu_init_pointer(proto_tab[proto], cp);
> 
>      mutex_unlock(&proto_tab_lock);
> 
> @@ -782,7 +782,7 @@ void can_proto_unregister(const struct can_proto *cp)
> 
>      mutex_lock(&proto_tab_lock);
>      BUG_ON(proto_tab[proto] != cp);
> -    RCU_INIT_POINTER(proto_tab[proto], NULL);
> +    rcu_init_pointer(proto_tab[proto], NULL);
>      mutex_unlock(&proto_tab_lock);
> 
>      synchronize_rcu();
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d2c8a06..a0a93bd 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1836,7 +1836,7 @@ static struct xps_map *remove_xps_queue(struct
> xps_dev_maps *dev_maps,
>              if (map->len > 1) {
>                  map->queues[pos] = map->queues[--map->len];
>              } else {
> -                RCU_INIT_POINTER(dev_maps->cpu_map[cpu], NULL);
> +                rcu_init_pointer(dev_maps->cpu_map[cpu], NULL);
>                  kfree_rcu(map, rcu);
>                  map = NULL;
>              }
> @@ -1869,7 +1869,7 @@ static void netif_reset_xps_queues_gt(struct
> net_device *dev, u16 index)
>      }
> 
>      if (!active) {
> -        RCU_INIT_POINTER(dev->xps_maps, NULL);
> +        rcu_init_pointer(dev->xps_maps, NULL);
>          kfree_rcu(dev_maps, rcu);
>      }
> 
> @@ -1948,7 +1948,7 @@ int netif_set_xps_queue(struct net_device *dev,
> const struct cpumask *mask,
>          if (!map)
>              goto error;
> 
> -        RCU_INIT_POINTER(new_dev_maps->cpu_map[cpu], map);
> +        rcu_init_pointer(new_dev_maps->cpu_map[cpu], map);
>      }
> 
>      if (!new_dev_maps)
> @@ -1974,7 +1974,7 @@ int netif_set_xps_queue(struct net_device *dev,
> const struct cpumask *mask,
>          } else if (dev_maps) {
>              /* fill in the new device map from the old device map */
>              map = xmap_dereference(dev_maps->cpu_map[cpu]);
> -            RCU_INIT_POINTER(new_dev_maps->cpu_map[cpu], map);
> +            rcu_init_pointer(new_dev_maps->cpu_map[cpu], map);
>          }
> 
>      }
> @@ -2016,7 +2016,7 @@ out_no_new_maps:
> 
>      /* free map if not active */
>      if (!active) {
> -        RCU_INIT_POINTER(dev->xps_maps, NULL);
> +        rcu_init_pointer(dev->xps_maps, NULL);
>          kfree_rcu(dev_maps, rcu);
>      }
> 
> @@ -3476,13 +3476,13 @@ void netdev_rx_handler_unregister(struct
> net_device *dev)
>  {
> 
>      ASSERT_RTNL();
> -    RCU_INIT_POINTER(dev->rx_handler, NULL);
> +    rcu_init_pointer(dev->rx_handler, NULL);
>      /* a reader seeing a non NULL rx_handler in a rcu_read_lock()
>       * section has a guarantee to see a non NULL rx_handler_data
>       * as well.
>       */
>      synchronize_net();
> -    RCU_INIT_POINTER(dev->rx_handler_data, NULL);
> +    rcu_init_pointer(dev->rx_handler_data, NULL);
>  }
>  EXPORT_SYMBOL_GPL(netdev_rx_handler_unregister);
> 
> diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
> index 185c341..e11fc01 100644
> --- a/net/core/fib_rules.c
> +++ b/net/core/fib_rules.c
> @@ -368,7 +368,7 @@ static int fib_nl_newrule(struct sk_buff *skb,
> struct nlmsghdr* nlh)
> 
>          list_for_each_entry(r, &ops->rules_list, list) {
>              if (r->pref == rule->target) {
> -                RCU_INIT_POINTER(rule->ctarget, r);
> +                rcu_init_pointer(rule->ctarget, r);
>                  break;
>              }
>          }
> @@ -509,7 +509,7 @@ static int fib_nl_delrule(struct sk_buff *skb,
> struct nlmsghdr* nlh)
>          if (ops->nr_goto_rules > 0) {
>              list_for_each_entry(tmp, &ops->rules_list, list) {
>                  if (rtnl_dereference(tmp->ctarget) == rule) {
> -                    RCU_INIT_POINTER(tmp->ctarget, NULL);
> +                    rcu_init_pointer(tmp->ctarget, NULL);
>                      ops->unresolved_rules++;
>                  }
>              }
> diff --git a/net/core/filter.c b/net/core/filter.c
> index cd58614..cb9125d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -1697,7 +1697,7 @@ int sk_detach_filter(struct sock *sk)
>      filter = rcu_dereference_protected(sk->sk_filter,
>                         sock_owned_by_user(sk));
>      if (filter) {
> -        RCU_INIT_POINTER(sk->sk_filter, NULL);
> +        rcu_init_pointer(sk->sk_filter, NULL);
>          sk_filter_uncharge(sk, filter);
>          ret = 0;
>      }
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 8f8a96e..73d7640 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1550,7 +1550,7 @@ static void neigh_table_init_no_netlink(struct
> neigh_table *tbl)
>          panic("cannot create neighbour proc dir entry");
>  #endif
> 
> -    RCU_INIT_POINTER(tbl->nht, neigh_hash_alloc(3));
> +    rcu_init_pointer(tbl->nht, neigh_hash_alloc(3));
> 
>      phsize = (PNEIGH_HASHMASK + 1) * sizeof(struct pneigh_entry *);
>      tbl->phash_buckets = kzalloc(phsize, GFP_KERNEL);
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 1cac29e..cbbf952 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -742,13 +742,13 @@ static void rx_queue_release(struct kobject *kobj)
> 
>      map = rcu_dereference_protected(queue->rps_map, 1);
>      if (map) {
> -        RCU_INIT_POINTER(queue->rps_map, NULL);
> +        rcu_init_pointer(queue->rps_map, NULL);
>          kfree_rcu(map, rcu);
>      }
> 
>      flow_table = rcu_dereference_protected(queue->rps_flow_table, 1);
>      if (flow_table) {
> -        RCU_INIT_POINTER(queue->rps_flow_table, NULL);
> +        rcu_init_pointer(queue->rps_flow_table, NULL);
>          call_rcu(&flow_table->rcu, rps_dev_flow_table_release);
>      }
>  #endif
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index e33937f..496ba90 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -820,7 +820,7 @@ void __netpoll_cleanup(struct netpoll *np)
>          if (ops->ndo_netpoll_cleanup)
>              ops->ndo_netpoll_cleanup(np->dev);
> 
> -        RCU_INIT_POINTER(np->dev->npinfo, NULL);
> +        rcu_init_pointer(np->dev->npinfo, NULL);
>          call_rcu_bh(&npinfo->rcu, rcu_cleanup_netpoll_info);
>      }
>  }
> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
> index 3825f66..15c63ac 100644
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -266,7 +266,7 @@ static int netprio_device_event(struct
> notifier_block *unused,
>      switch (event) {
>      case NETDEV_UNREGISTER:
>          old = rtnl_dereference(dev->priomap);
> -        RCU_INIT_POINTER(dev->priomap, NULL);
> +        rcu_init_pointer(dev->priomap, NULL);
>          if (old)
>              kfree_rcu(old, rcu);
>          break;
> diff --git a/net/core/sock.c b/net/core/sock.c
> index b4fff00..ea565ba 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -481,7 +481,7 @@ struct dst_entry *__sk_dst_check(struct sock *sk,
> u32 cookie)
> 
>      if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
>          sk_tx_queue_clear(sk);
> -        RCU_INIT_POINTER(sk->sk_dst_cache, NULL);
> +        rcu_init_pointer(sk->sk_dst_cache, NULL);
>          dst_release(dst);
>          return NULL;
>      }
> @@ -1365,7 +1365,7 @@ static void __sk_free(struct sock *sk)
>                         atomic_read(&sk->sk_wmem_alloc) == 0);
>      if (filter) {
>          sk_filter_uncharge(sk, filter);
> -        RCU_INIT_POINTER(sk->sk_filter, NULL);
> +        rcu_init_pointer(sk->sk_filter, NULL);
>      }
> 
>      sock_disable_timestamp(sk, SK_FLAGS_TIMESTAMP);
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index cf9cd13..f3016f9 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -118,7 +118,7 @@ static int flow_limit_cpu_sysctl(struct ctl_table
> *table, int write,
>              cur = rcu_dereference_protected(sd->flow_limit,
>                       lockdep_is_held(&flow_limit_update_mutex));
>              if (cur && !cpumask_test_cpu(i, mask)) {
> -                RCU_INIT_POINTER(sd->flow_limit, NULL);
> +                rcu_init_pointer(sd->flow_limit, NULL);
>                  synchronize_rcu();
>                  kfree(cur);
>              } else if (!cur && cpumask_test_cpu(i, mask)) {
> diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
> index a603823..1680884 100644
> --- a/net/decnet/dn_dev.c
> +++ b/net/decnet/dn_dev.c
> @@ -1100,7 +1100,7 @@ static struct dn_dev *dn_dev_create(struct
> net_device *dev, int *err)
> 
>      dn_db->neigh_parms = neigh_parms_alloc(dev, &dn_neigh_table);
>      if (!dn_db->neigh_parms) {
> -        RCU_INIT_POINTER(dev->dn_ptr, NULL);
> +        rcu_init_pointer(dev->dn_ptr, NULL);
>          kfree(dn_db);
>          return NULL;
>      }
> diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
> index daccc4a..42d4bf0 100644
> --- a/net/decnet/dn_route.c
> +++ b/net/decnet/dn_route.c
> @@ -380,7 +380,7 @@ static void dn_run_flush(unsigned long dummy)
> 
>          for(; rt; rt = next) {
>              next = rcu_dereference_raw(rt->dst.dn_next);
> -            RCU_INIT_POINTER(rt->dst.dn_next, NULL);
> +            rcu_init_pointer(rt->dst.dn_next, NULL);
>              dst_free((struct dst_entry *)rt);
>          }
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index bdbf68b..5e2891c 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -294,7 +294,7 @@ static void inetdev_destroy(struct in_device *in_dev)
>          inet_free_ifa(ifa);
>      }
> 
> -    RCU_INIT_POINTER(dev->ip_ptr, NULL);
> +    rcu_init_pointer(dev->ip_ptr, NULL);
> 
>      devinet_sysctl_unregister(in_dev);
>      neigh_parms_release(&arp_tbl, in_dev->arp_parms);
> @@ -1367,7 +1367,7 @@ static int inetdev_event(struct notifier_block
> *this, unsigned long event,
>      switch (event) {
>      case NETDEV_REGISTER:
>          pr_debug("%s: bug\n", __func__);
> -        RCU_INIT_POINTER(dev->ip_ptr, NULL);
> +        rcu_init_pointer(dev->ip_ptr, NULL);
>          break;
>      case NETDEV_UP:
>          if (!inetdev_valid_mtu(dev->mtu))
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 8a043f0..aadbeda 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -147,7 +147,7 @@ static void rt_fibinfo_free(struct rtable __rcu **rtp)
>      if (!rt)
>          return;
> 
> -    /* Not even needed : RCU_INIT_POINTER(*rtp, NULL);
> +    /* Not even needed : rcu_init_pointer(*rtp, NULL);
>       * because we waited an RCU grace period before calling
>       * free_fib_info_rcu()
>       */
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 5afeb5a..b632346 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -1602,7 +1602,7 @@ static void trie_leaf_remove(struct trie *t,
> struct leaf *l)
>          put_child(tp, cindex, NULL);
>          trie_rebalance(t, tp);
>      } else
> -        RCU_INIT_POINTER(t->trie, NULL);
> +        rcu_init_pointer(t->trie, NULL);
> 
>      free_leaf(l);
>  }
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 97e4d16..54122f1 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -1276,7 +1276,7 @@ static void ip_mc_hash_add(struct in_device *in_dev,
>      for_each_pmc_rtnl(in_dev, im) {
>          hash = ip_mc_hash(im);
>          im->next_hash = mc_hash[hash];
> -        RCU_INIT_POINTER(mc_hash[hash], im);
> +        rcu_init_pointer(mc_hash[hash], im);
>      }
> 
>      rcu_assign_pointer(in_dev->mc_hash, mc_hash);
> @@ -1928,7 +1928,7 @@ static int ip_mc_leave_src(struct sock *sk,
> struct ip_mc_socklist *iml,
>      }
>      err = ip_mc_del_src(in_dev, &iml->multi.imr_multiaddr.s_addr,
>              iml->sfmode, psf->sl_count, psf->sl_addr, 0);
> -    RCU_INIT_POINTER(iml->sflist, NULL);
> +    rcu_init_pointer(iml->sflist, NULL);
>      /* decrease mem now to avoid the memleak warning */
>      atomic_sub(IP_SFLSIZE(psf->sl_max), &sk->sk_omem_alloc);
>      kfree_rcu(psf, rcu);
> diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
> index 48f4244..3983400 100644
> --- a/net/ipv4/inetpeer.c
> +++ b/net/ipv4/inetpeer.c
> @@ -309,26 +309,26 @@ static void peer_avl_rebalance(struct inet_peer
> __rcu **stack[],
>              lr = rcu_deref_locked(l->avl_right, base);
>              lrh = node_height(lr);
>              if (lrh <= node_height(ll)) {    /* ll: RH+1 */
> -                RCU_INIT_POINTER(node->avl_left, lr);    /* lr: RH or RH+1 */
> -                RCU_INIT_POINTER(node->avl_right, r);    /* r: RH */
> +                rcu_init_pointer(node->avl_left, lr);    /* lr: RH or RH+1 */
> +                rcu_init_pointer(node->avl_right, r);    /* r: RH */
>                  node->avl_height = lrh + 1; /* RH+1 or RH+2 */
> -                RCU_INIT_POINTER(l->avl_left, ll);       /* ll: RH+1 */
> -                RCU_INIT_POINTER(l->avl_right, node);    /* node:
> RH+1 or RH+2 */
> +                rcu_init_pointer(l->avl_left, ll);       /* ll: RH+1 */
> +                rcu_init_pointer(l->avl_right, node);    /* node:
> RH+1 or RH+2 */
>                  l->avl_height = node->avl_height + 1;
> -                RCU_INIT_POINTER(*nodep, l);
> +                rcu_init_pointer(*nodep, l);
>              } else { /* ll: RH, lr: RH+1 */
>                  lrl = rcu_deref_locked(lr->avl_left, base);/* lrl: RH
> or RH-1 */
>                  lrr = rcu_deref_locked(lr->avl_right, base);/* lrr:
> RH or RH-1 */
> -                RCU_INIT_POINTER(node->avl_left, lrr);    /* lrr: RH or RH-1 */
> -                RCU_INIT_POINTER(node->avl_right, r);    /* r: RH */
> +                rcu_init_pointer(node->avl_left, lrr);    /* lrr: RH or RH-1 */
> +                rcu_init_pointer(node->avl_right, r);    /* r: RH */
>                  node->avl_height = rh + 1; /* node: RH+1 */
> -                RCU_INIT_POINTER(l->avl_left, ll);    /* ll: RH */
> -                RCU_INIT_POINTER(l->avl_right, lrl);    /* lrl: RH or RH-1 */
> +                rcu_init_pointer(l->avl_left, ll);    /* ll: RH */
> +                rcu_init_pointer(l->avl_right, lrl);    /* lrl: RH or RH-1 */
>                  l->avl_height = rh + 1;    /* l: RH+1 */
> -                RCU_INIT_POINTER(lr->avl_left, l);    /* l: RH+1 */
> -                RCU_INIT_POINTER(lr->avl_right, node);    /* node: RH+1 */
> +                rcu_init_pointer(lr->avl_left, l);    /* l: RH+1 */
> +                rcu_init_pointer(lr->avl_right, node);    /* node: RH+1 */
>                  lr->avl_height = rh + 2;
> -                RCU_INIT_POINTER(*nodep, lr);
> +                rcu_init_pointer(*nodep, lr);
>              }
>          } else if (rh > lh + 1) { /* r: LH+2 */
>              struct inet_peer *rr, *rl, *rlr, *rll;
> @@ -337,26 +337,26 @@ static void peer_avl_rebalance(struct inet_peer
> __rcu **stack[],
>              rl = rcu_deref_locked(r->avl_left, base);
>              rlh = node_height(rl);
>              if (rlh <= node_height(rr)) {    /* rr: LH+1 */
> -                RCU_INIT_POINTER(node->avl_right, rl);    /* rl: LH or LH+1 */
> -                RCU_INIT_POINTER(node->avl_left, l);    /* l: LH */
> +                rcu_init_pointer(node->avl_right, rl);    /* rl: LH or LH+1 */
> +                rcu_init_pointer(node->avl_left, l);    /* l: LH */
>                  node->avl_height = rlh + 1; /* LH+1 or LH+2 */
> -                RCU_INIT_POINTER(r->avl_right, rr);    /* rr: LH+1 */
> -                RCU_INIT_POINTER(r->avl_left, node);    /* node: LH+1
> or LH+2 */
> +                rcu_init_pointer(r->avl_right, rr);    /* rr: LH+1 */
> +                rcu_init_pointer(r->avl_left, node);    /* node: LH+1
> or LH+2 */
>                  r->avl_height = node->avl_height + 1;
> -                RCU_INIT_POINTER(*nodep, r);
> +                rcu_init_pointer(*nodep, r);
>              } else { /* rr: RH, rl: RH+1 */
>                  rlr = rcu_deref_locked(rl->avl_right, base);/* rlr:
> LH or LH-1 */
>                  rll = rcu_deref_locked(rl->avl_left, base);/* rll: LH
> or LH-1 */
> -                RCU_INIT_POINTER(node->avl_right, rll);    /* rll: LH
> or LH-1 */
> -                RCU_INIT_POINTER(node->avl_left, l);    /* l: LH */
> +                rcu_init_pointer(node->avl_right, rll);    /* rll: LH
> or LH-1 */
> +                rcu_init_pointer(node->avl_left, l);    /* l: LH */
>                  node->avl_height = lh + 1; /* node: LH+1 */
> -                RCU_INIT_POINTER(r->avl_right, rr);    /* rr: LH */
> -                RCU_INIT_POINTER(r->avl_left, rlr);    /* rlr: LH or LH-1 */
> +                rcu_init_pointer(r->avl_right, rr);    /* rr: LH */
> +                rcu_init_pointer(r->avl_left, rlr);    /* rlr: LH or LH-1 */
>                  r->avl_height = lh + 1;    /* r: LH+1 */
> -                RCU_INIT_POINTER(rl->avl_right, r);    /* r: LH+1 */
> -                RCU_INIT_POINTER(rl->avl_left, node);    /* node: LH+1 */
> +                rcu_init_pointer(rl->avl_right, r);    /* r: LH+1 */
> +                rcu_init_pointer(rl->avl_left, node);    /* node: LH+1 */
>                  rl->avl_height = lh + 2;
> -                RCU_INIT_POINTER(*nodep, rl);
> +                rcu_init_pointer(*nodep, rl);
>              }
>          } else {
>              node->avl_height = (lh > rh ? lh : rh) + 1;
> @@ -400,7 +400,7 @@ static void unlink_from_pool(struct inet_peer *p,
> struct inet_peer_base *base,
>          /* t is removed, t->daddr > x->daddr for any
>           * x in p->avl_left subtree.
>           * Put t in the old place of p. */
> -        RCU_INIT_POINTER(*delp[0], t);
> +        rcu_init_pointer(*delp[0], t);
>          t->avl_left = p->avl_left;
>          t->avl_right = p->avl_right;
>          t->avl_height = p->avl_height;
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index d84dc8d..19700ee 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -1253,7 +1253,7 @@ static void mrtsock_destruct(struct sock *sk)
>              inet_netconf_notify_devconf(net, NETCONFA_MC_FORWARDING,
>                              NETCONFA_IFINDEX_ALL,
>                              net->ipv4.devconf_all);
> -            RCU_INIT_POINTER(mrt->mroute_sk, NULL);
> +            rcu_init_pointer(mrt->mroute_sk, NULL);
>              mroute_clean_tables(mrt);
>          }
>      }
> diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
> index 574f7eb..c927fb1 100644
> --- a/net/ipv4/netfilter/nf_nat_h323.c
> +++ b/net/ipv4/netfilter/nf_nat_h323.c
> @@ -590,15 +590,15 @@ static int __init init(void)
>      BUG_ON(nat_callforwarding_hook != NULL);
>      BUG_ON(nat_q931_hook != NULL);
> 
> -    RCU_INIT_POINTER(set_h245_addr_hook, set_h245_addr);
> -    RCU_INIT_POINTER(set_h225_addr_hook, set_h225_addr);
> -    RCU_INIT_POINTER(set_sig_addr_hook, set_sig_addr);
> -    RCU_INIT_POINTER(set_ras_addr_hook, set_ras_addr);
> -    RCU_INIT_POINTER(nat_rtp_rtcp_hook, nat_rtp_rtcp);
> -    RCU_INIT_POINTER(nat_t120_hook, nat_t120);
> -    RCU_INIT_POINTER(nat_h245_hook, nat_h245);
> -    RCU_INIT_POINTER(nat_callforwarding_hook, nat_callforwarding);
> -    RCU_INIT_POINTER(nat_q931_hook, nat_q931);
> +    rcu_init_pointer(set_h245_addr_hook, set_h245_addr);
> +    rcu_init_pointer(set_h225_addr_hook, set_h225_addr);
> +    rcu_init_pointer(set_sig_addr_hook, set_sig_addr);
> +    rcu_init_pointer(set_ras_addr_hook, set_ras_addr);
> +    rcu_init_pointer(nat_rtp_rtcp_hook, nat_rtp_rtcp);
> +    rcu_init_pointer(nat_t120_hook, nat_t120);
> +    rcu_init_pointer(nat_h245_hook, nat_h245);
> +    rcu_init_pointer(nat_callforwarding_hook, nat_callforwarding);
> +    rcu_init_pointer(nat_q931_hook, nat_q931);
>      nf_ct_helper_expectfn_register(&q931_nat);
>      nf_ct_helper_expectfn_register(&callforwarding_nat);
>      return 0;
> @@ -607,15 +607,15 @@ static int __init init(void)
>  /****************************************************************************/
>  static void __exit fini(void)
>  {
> -    RCU_INIT_POINTER(set_h245_addr_hook, NULL);
> -    RCU_INIT_POINTER(set_h225_addr_hook, NULL);
> -    RCU_INIT_POINTER(set_sig_addr_hook, NULL);
> -    RCU_INIT_POINTER(set_ras_addr_hook, NULL);
> -    RCU_INIT_POINTER(nat_rtp_rtcp_hook, NULL);
> -    RCU_INIT_POINTER(nat_t120_hook, NULL);
> -    RCU_INIT_POINTER(nat_h245_hook, NULL);
> -    RCU_INIT_POINTER(nat_callforwarding_hook, NULL);
> -    RCU_INIT_POINTER(nat_q931_hook, NULL);
> +    rcu_init_pointer(set_h245_addr_hook, NULL);
> +    rcu_init_pointer(set_h225_addr_hook, NULL);
> +    rcu_init_pointer(set_sig_addr_hook, NULL);
> +    rcu_init_pointer(set_ras_addr_hook, NULL);
> +    rcu_init_pointer(nat_rtp_rtcp_hook, NULL);
> +    rcu_init_pointer(nat_t120_hook, NULL);
> +    rcu_init_pointer(nat_h245_hook, NULL);
> +    rcu_init_pointer(nat_callforwarding_hook, NULL);
> +    rcu_init_pointer(nat_q931_hook, NULL);
>      nf_ct_helper_expectfn_unregister(&q931_nat);
>      nf_ct_helper_expectfn_unregister(&callforwarding_nat);
>      synchronize_rcu();
> diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
> index 657d230..63b58b2 100644
> --- a/net/ipv4/netfilter/nf_nat_pptp.c
> +++ b/net/ipv4/netfilter/nf_nat_pptp.c
> @@ -285,25 +285,25 @@ static int __init nf_nat_helper_pptp_init(void)
>      nf_nat_need_gre();
> 
>      BUG_ON(nf_nat_pptp_hook_outbound != NULL);
> -    RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
> +    rcu_init_pointer(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
> 
>      BUG_ON(nf_nat_pptp_hook_inbound != NULL);
> -    RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
> +    rcu_init_pointer(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
> 
>      BUG_ON(nf_nat_pptp_hook_exp_gre != NULL);
> -    RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
> +    rcu_init_pointer(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
> 
>      BUG_ON(nf_nat_pptp_hook_expectfn != NULL);
> -    RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
> +    rcu_init_pointer(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
>      return 0;
>  }
> 
>  static void __exit nf_nat_helper_pptp_fini(void)
>  {
> -    RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, NULL);
> -    RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, NULL);
> -    RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, NULL);
> -    RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, NULL);
> +    rcu_init_pointer(nf_nat_pptp_hook_expectfn, NULL);
> +    rcu_init_pointer(nf_nat_pptp_hook_exp_gre, NULL);
> +    rcu_init_pointer(nf_nat_pptp_hook_inbound, NULL);
> +    rcu_init_pointer(nf_nat_pptp_hook_outbound, NULL);
>      synchronize_rcu();
>  }
> 
> diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c
> b/net/ipv4/netfilter/nf_nat_snmp_basic.c
> index 7c67667..9b786d1 100644
> --- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
> +++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
> @@ -1291,7 +1291,7 @@ static int __init nf_nat_snmp_basic_init(void)
>      int ret = 0;
> 
>      BUG_ON(nf_nat_snmp_hook != NULL);
> -    RCU_INIT_POINTER(nf_nat_snmp_hook, help);
> +    rcu_init_pointer(nf_nat_snmp_hook, help);
> 
>      ret = nf_conntrack_helper_register(&snmp_trap_helper);
>      if (ret < 0) {
> @@ -1303,7 +1303,7 @@ static int __init nf_nat_snmp_basic_init(void)
> 
>  static void __exit nf_nat_snmp_basic_fini(void)
>  {
> -    RCU_INIT_POINTER(nf_nat_snmp_hook, NULL);
> +    rcu_init_pointer(nf_nat_snmp_hook, NULL);
>      nf_conntrack_helper_unregister(&snmp_trap_helper);
>  }
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index db1e0da..186ff04 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -563,12 +563,12 @@ static void fnhe_flush_routes(struct
> fib_nh_exception *fnhe)
> 
>      rt = rcu_dereference(fnhe->fnhe_rth_input);
>      if (rt) {
> -        RCU_INIT_POINTER(fnhe->fnhe_rth_input, NULL);
> +        rcu_init_pointer(fnhe->fnhe_rth_input, NULL);
>          rt_free(rt);
>      }
>      rt = rcu_dereference(fnhe->fnhe_rth_output);
>      if (rt) {
> -        RCU_INIT_POINTER(fnhe->fnhe_rth_output, NULL);
> +        rcu_init_pointer(fnhe->fnhe_rth_output, NULL);
>          rt_free(rt);
>      }
>  }
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 6c7fa08..563a9e4 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -3017,7 +3017,7 @@ static int addrconf_ifdown(struct net_device
> *dev, int how)
>          idev->dead = 1;
> 
>          /* protected by rtnl_lock */
> -        RCU_INIT_POINTER(dev->ip6_ptr, NULL);
> +        rcu_init_pointer(dev->ip6_ptr, NULL);
> 
>          /* Step 1.5: remove snmp6 entry */
>          snmp6_unregister_dev(idev);
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index b05b609..652e28a 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -386,7 +386,7 @@ ip6_tnl_dev_uninit(struct net_device *dev)
>      struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
> 
>      if (dev == ip6n->fb_tnl_dev)
> -        RCU_INIT_POINTER(ip6n->tnls_wc[0], NULL);
> +        rcu_init_pointer(ip6n->tnls_wc[0], NULL);
>      else
>          ip6_tnl_unlink(ip6n, t);
>      ip6_tnl_dst_reset(t);
> diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
> index b7c0f82..bff37b3 100644
> --- a/net/ipv6/ip6_vti.c
> +++ b/net/ipv6/ip6_vti.c
> @@ -275,7 +275,7 @@ static void vti6_dev_uninit(struct net_device *dev)
>      struct vti6_net *ip6n = net_generic(net, vti6_net_id);
> 
>      if (dev == ip6n->fb_tnl_dev)
> -        RCU_INIT_POINTER(ip6n->tnls_wc[0], NULL);
> +        rcu_init_pointer(ip6n->tnls_wc[0], NULL);
>      else
>          vti6_tnl_unlink(ip6n, t);
>      dev_put(dev);
> diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
> index 95f3f1d..88d73a1 100644
> --- a/net/ipv6/netfilter.c
> +++ b/net/ipv6/netfilter.c
> @@ -203,7 +203,7 @@ static const struct nf_afinfo nf_ip6_afinfo = {
> 
>  int __init ipv6_netfilter_init(void)
>  {
> -    RCU_INIT_POINTER(nf_ipv6_ops, &ipv6ops);
> +    rcu_init_pointer(nf_ipv6_ops, &ipv6ops);
>      return nf_register_afinfo(&nf_ip6_afinfo);
>  }
> 
> @@ -212,6 +212,6 @@ int __init ipv6_netfilter_init(void)
>   */
>  void ipv6_netfilter_fini(void)
>  {
> -    RCU_INIT_POINTER(nf_ipv6_ops, NULL);
> +    rcu_init_pointer(nf_ipv6_ops, NULL);
>      nf_unregister_afinfo(&nf_ip6_afinfo);
>  }
> diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
> index 1f29996..594ac2f 100644
> --- a/net/ipv6/raw.c
> +++ b/net/ipv6/raw.c
> @@ -140,7 +140,7 @@ EXPORT_SYMBOL(rawv6_mh_filter_register);
> 
>  int rawv6_mh_filter_unregister(mh_filter_t filter)
>  {
> -    RCU_INIT_POINTER(mh_filter, NULL);
> +    rcu_init_pointer(mh_filter, NULL);
>      synchronize_rcu();
>      return 0;
>  }
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index e5a453c..bbde433 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -470,7 +470,7 @@ static void ipip6_tunnel_uninit(struct net_device *dev)
>      struct sit_net *sitn = net_generic(tunnel->net, sit_net_id);
> 
>      if (dev == sitn->fb_tunnel_dev) {
> -        RCU_INIT_POINTER(sitn->tunnels_wc[0], NULL);
> +        rcu_init_pointer(sitn->tunnels_wc[0], NULL);
>      } else {
>          ipip6_tunnel_unlink(sitn, tunnel);
>          ipip6_tunnel_del_prl(tunnel, NULL);
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index 31bf258..22d4d35 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -72,7 +72,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info
> *sta, u16 tid,
>      if (!tid_rx)
>          return;
> 
> -    RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
> +    rcu_init_pointer(sta->ampdu_mlme.tid_rx[tid], NULL);
> 
>      ht_dbg(sta->sdata,
>             "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index aaa59d7..3839764 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -64,7 +64,7 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
> 
>      if (type == NL80211_IFTYPE_AP_VLAN &&
>          params && params->use_4addr == 0)
> -        RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
> +        rcu_init_pointer(sdata->u.vlan.sta, NULL);
>      else if (type == NL80211_IFTYPE_STATION &&
>           params && params->use_4addr >= 0)
>          sdata->u.mgd.use_4addr = params->use_4addr;
> @@ -1033,7 +1033,7 @@ static int ieee80211_start_ap(struct wiphy
> *wiphy, struct net_device *dev,
> 
>          if (old)
>              kfree_rcu(old, rcu_head);
> -        RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
> +        rcu_init_pointer(sdata->u.ap.beacon, NULL);
>          ieee80211_vif_release_channel(sdata);
>          return err;
>      }
> @@ -1102,8 +1102,8 @@ static int ieee80211_stop_ap(struct wiphy
> *wiphy, struct net_device *dev)
>      netif_carrier_off(dev);
> 
>      /* remove beacon and probe response */
> -    RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
> -    RCU_INIT_POINTER(sdata->u.ap.probe_resp, NULL);
> +    rcu_init_pointer(sdata->u.ap.beacon, NULL);
> +    rcu_init_pointer(sdata->u.ap.probe_resp, NULL);
>      kfree_rcu(old_beacon, rcu_head);
>      if (old_probe_resp)
>          kfree_rcu(old_probe_resp, rcu_head);
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 06d2878..bd477c2 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -365,7 +365,7 @@ static void __ieee80211_sta_join_ibss(struct
> ieee80211_sub_if_data *sdata,
>          sdata->vif.bss_conf.ibss_creator = false;
>          sdata->vif.bss_conf.enable_beacon = false;
>          sdata->vif.bss_conf.ssid_len = 0;
> -        RCU_INIT_POINTER(ifibss->presp, NULL);
> +        rcu_init_pointer(ifibss->presp, NULL);
>          kfree_rcu(presp, rcu_head);
>          mutex_lock(&local->mtx);
>          ieee80211_vif_release_channel(sdata);
> @@ -735,7 +735,7 @@ static void ieee80211_ibss_disconnect(struct
> ieee80211_sub_if_data *sdata)
>      /* remove beacon */
>      presp = rcu_dereference_protected(ifibss->presp,
>                        lockdep_is_held(&sdata->wdev.mtx));
> -    RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
> +    rcu_init_pointer(sdata->u.ibss.presp, NULL);
>      if (presp)
>          kfree_rcu(presp, rcu_head);
> 
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index f70e9cd..9271537 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -1341,7 +1341,7 @@ void ieee80211_mesh_init_sdata(struct
> ieee80211_sub_if_data *sdata)
>      skb_queue_head_init(&ifmsh->ps.bc_buf);
>      spin_lock_init(&ifmsh->mesh_preq_queue_lock);
>      spin_lock_init(&ifmsh->sync_offset_lock);
> -    RCU_INIT_POINTER(ifmsh->beacon, NULL);
> +    rcu_init_pointer(ifmsh->beacon, NULL);
> 
>      sdata->vif.bss_conf.bssid = zero_addr;
>  }
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 7d050ed..5db5430 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -1068,8 +1068,8 @@ int mesh_pathtbl_init(void)
>      INIT_HLIST_HEAD(tbl_mpp->known_gates);
> 
>      /* Need no locking since this is during init */
> -    RCU_INIT_POINTER(mesh_paths, tbl_path);
> -    RCU_INIT_POINTER(mpp_paths, tbl_mpp);
> +    rcu_init_pointer(mesh_paths, tbl_path);
> +    rcu_init_pointer(mpp_paths, tbl_mpp);
> 
>      return 0;
> 
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 137a192..0d2c0bf 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -860,7 +860,7 @@ static int __must_check
> __sta_info_destroy_part1(struct sta_info *sta)
> 
>      if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
>          rcu_access_pointer(sdata->u.vlan.sta) == sta)
> -        RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
> +        rcu_init_pointer(sdata->u.vlan.sta, NULL);
> 
>      return 0;
>  }
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 1fbab0c..5f88a73 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -40,7 +40,7 @@ int nf_register_afinfo(const struct nf_afinfo *afinfo)
>      err = mutex_lock_interruptible(&afinfo_mutex);
>      if (err < 0)
>          return err;
> -    RCU_INIT_POINTER(nf_afinfo[afinfo->family], afinfo);
> +    rcu_init_pointer(nf_afinfo[afinfo->family], afinfo);
>      mutex_unlock(&afinfo_mutex);
>      return 0;
>  }
> @@ -49,7 +49,7 @@ EXPORT_SYMBOL_GPL(nf_register_afinfo);
>  void nf_unregister_afinfo(const struct nf_afinfo *afinfo)
>  {
>      mutex_lock(&afinfo_mutex);
> -    RCU_INIT_POINTER(nf_afinfo[afinfo->family], NULL);
> +    rcu_init_pointer(nf_afinfo[afinfo->family], NULL);
>      mutex_unlock(&afinfo_mutex);
>      synchronize_rcu();
>  }
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index c42e83d..e8b609d 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -641,7 +641,7 @@ static void __ip_vs_dst_cache_reset(struct ip_vs_dest *dest)
> 
>      old = rcu_dereference_protected(dest->dest_dst, 1);
>      if (old) {
> -        RCU_INIT_POINTER(dest->dest_dst, NULL);
> +        rcu_init_pointer(dest->dest_dst, NULL);
>          call_rcu(&old->rcu_head, ip_vs_dest_dst_rcu_free);
>      }
>  }
> @@ -1221,7 +1221,7 @@ ip_vs_add_service(struct net *net, struct
> ip_vs_service_user_kern *u,
>      sched = NULL;
> 
>      /* Bind the ct retriever */
> -    RCU_INIT_POINTER(svc->pe, pe);
> +    rcu_init_pointer(svc->pe, pe);
>      pe = NULL;
> 
>      /* Update the virtual service counters */
> diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
> index c3b8454..6cd09c1 100644
> --- a/net/netfilter/ipvs/ip_vs_dh.c
> +++ b/net/netfilter/ipvs/ip_vs_dh.c
> @@ -115,14 +115,14 @@ ip_vs_dh_reassign(struct ip_vs_dh_state *s,
> struct ip_vs_service *svc)
>          if (dest)
>              ip_vs_dest_put(dest);
>          if (empty)
> -            RCU_INIT_POINTER(b->dest, NULL);
> +            rcu_init_pointer(b->dest, NULL);
>          else {
>              if (p == &svc->destinations)
>                  p = p->next;
> 
>              dest = list_entry(p, struct ip_vs_dest, n_list);
>              ip_vs_dest_hold(dest);
> -            RCU_INIT_POINTER(b->dest, dest);
> +            rcu_init_pointer(b->dest, dest);
> 
>              p = p->next;
>          }
> @@ -146,7 +146,7 @@ static void ip_vs_dh_flush(struct ip_vs_dh_state *s)
>          dest = rcu_dereference_protected(b->dest, 1);
>          if (dest) {
>              ip_vs_dest_put(dest);
> -            RCU_INIT_POINTER(b->dest, NULL);
> +            rcu_init_pointer(b->dest, NULL);
>          }
>          b++;
>      }
> diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
> index cc65b2f..6a3e885 100644
> --- a/net/netfilter/ipvs/ip_vs_sh.c
> +++ b/net/netfilter/ipvs/ip_vs_sh.c
> @@ -182,14 +182,14 @@ ip_vs_sh_reassign(struct ip_vs_sh_state *s,
> struct ip_vs_service *svc)
>          if (dest)
>              ip_vs_dest_put(dest);
>          if (empty)
> -            RCU_INIT_POINTER(b->dest, NULL);
> +            rcu_init_pointer(b->dest, NULL);
>          else {
>              if (p == &svc->destinations)
>                  p = p->next;
> 
>              dest = list_entry(p, struct ip_vs_dest, n_list);
>              ip_vs_dest_hold(dest);
> -            RCU_INIT_POINTER(b->dest, dest);
> +            rcu_init_pointer(b->dest, dest);
> 
>              IP_VS_DBG_BUF(6, "assigned i: %d dest: %s weight: %d\n",
>                        i, IP_VS_DBG_ADDR(svc->af, &dest->addr),
> @@ -222,7 +222,7 @@ static void ip_vs_sh_flush(struct ip_vs_sh_state *s)
>          dest = rcu_dereference_protected(b->dest, 1);
>          if (dest) {
>              ip_vs_dest_put(dest);
> -            RCU_INIT_POINTER(b->dest, NULL);
> +            rcu_init_pointer(b->dest, NULL);
>          }
>          b++;
>      }
> diff --git a/net/netfilter/nf_conntrack_core.c
> b/net/netfilter/nf_conntrack_core.c
> index 75421f2..57e1308 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1498,12 +1498,12 @@ static int untrack_refs(void)
> 
>  void nf_conntrack_cleanup_start(void)
>  {
> -    RCU_INIT_POINTER(ip_ct_attach, NULL);
> +    rcu_init_pointer(ip_ct_attach, NULL);
>  }
> 
>  void nf_conntrack_cleanup_end(void)
>  {
> -    RCU_INIT_POINTER(nf_ct_destroy, NULL);
> +    rcu_init_pointer(nf_ct_destroy, NULL);
>      while (untrack_refs() > 0)
>          schedule();
> 
> @@ -1778,8 +1778,8 @@ err_expect:
>  void nf_conntrack_init_end(void)
>  {
>      /* For use by REJECT target */
> -    RCU_INIT_POINTER(ip_ct_attach, nf_conntrack_attach);
> -    RCU_INIT_POINTER(nf_ct_destroy, destroy_conntrack);
> +    rcu_init_pointer(ip_ct_attach, nf_conntrack_attach);
> +    rcu_init_pointer(nf_ct_destroy, destroy_conntrack);
>  }
> 
>  /*
> diff --git a/net/netfilter/nf_conntrack_ecache.c
> b/net/netfilter/nf_conntrack_ecache.c
> index 1df1761..30ba3b0 100644
> --- a/net/netfilter/nf_conntrack_ecache.c
> +++ b/net/netfilter/nf_conntrack_ecache.c
> @@ -114,7 +114,7 @@ void nf_conntrack_unregister_notifier(struct net *net,
>      notify = rcu_dereference_protected(net->ct.nf_conntrack_event_cb,
>                         lockdep_is_held(&nf_ct_ecache_mutex));
>      BUG_ON(notify != new);
> -    RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, NULL);
> +    rcu_init_pointer(net->ct.nf_conntrack_event_cb, NULL);
>      mutex_unlock(&nf_ct_ecache_mutex);
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
> @@ -150,7 +150,7 @@ void nf_ct_expect_unregister_notifier(struct net *net,
>      notify = rcu_dereference_protected(net->ct.nf_expect_event_cb,
>                         lockdep_is_held(&nf_ct_ecache_mutex));
>      BUG_ON(notify != new);
> -    RCU_INIT_POINTER(net->ct.nf_expect_event_cb, NULL);
> +    rcu_init_pointer(net->ct.nf_expect_event_cb, NULL);
>      mutex_unlock(&nf_ct_ecache_mutex);
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
> diff --git a/net/netfilter/nf_conntrack_extend.c
> b/net/netfilter/nf_conntrack_extend.c
> index 1a95459..bbbea59b 100644
> --- a/net/netfilter/nf_conntrack_extend.c
> +++ b/net/netfilter/nf_conntrack_extend.c
> @@ -183,7 +183,7 @@ EXPORT_SYMBOL_GPL(nf_ct_extend_register);
>  void nf_ct_extend_unregister(struct nf_ct_ext_type *type)
>  {
>      mutex_lock(&nf_ct_ext_type_mutex);
> -    RCU_INIT_POINTER(nf_ct_ext_types[type->id], NULL);
> +    rcu_init_pointer(nf_ct_ext_types[type->id], NULL);
>      update_alloc_size(type);
>      mutex_unlock(&nf_ct_ext_type_mutex);
>      rcu_barrier(); /* Wait for completion of call_rcu()'s */
> diff --git a/net/netfilter/nf_conntrack_helper.c
> b/net/netfilter/nf_conntrack_helper.c
> index 5b3eae7..a4dce7f 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -222,7 +222,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct,
> struct nf_conn *tmpl,
> 
>      if (helper == NULL) {
>          if (help)
> -            RCU_INIT_POINTER(help->helper, NULL);
> +            rcu_init_pointer(help->helper, NULL);
>          goto out;
>      }
> 
> @@ -239,7 +239,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct,
> struct nf_conn *tmpl,
>          struct nf_conntrack_helper *tmp = rcu_dereference(help->helper);
> 
>          if (tmp && tmp->help != helper->help) {
> -            RCU_INIT_POINTER(help->helper, NULL);
> +            rcu_init_pointer(help->helper, NULL);
>              goto out;
>          }
>      }
> @@ -259,7 +259,7 @@ static inline int unhelp(struct nf_conntrack_tuple_hash *i,
> 
>      if (help && rcu_dereference_raw(help->helper) == me) {
>          nf_conntrack_event(IPCT_HELPER, ct);
> -        RCU_INIT_POINTER(help->helper, NULL);
> +        rcu_init_pointer(help->helper, NULL);
>      }
>      return 0;
>  }
> diff --git a/net/netfilter/nf_conntrack_netlink.c
> b/net/netfilter/nf_conntrack_netlink.c
> index ccc46fa..f147656 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1372,7 +1372,7 @@ ctnetlink_change_helper(struct nf_conn *ct,
> const struct nlattr * const cda[])
>          if (help && help->helper) {
>              /* we had a helper before ... */
>              nf_ct_remove_expectations(ct);
> -            RCU_INIT_POINTER(help->helper, NULL);
> +            rcu_init_pointer(help->helper, NULL);
>          }
> 
>          return 0;
> @@ -1666,7 +1666,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
>                  helper->from_nlattr(helpinfo, ct);
> 
>              /* not in hash table yet so not strictly necessary */
> -            RCU_INIT_POINTER(help->helper, helper);
> +            rcu_init_pointer(help->helper, helper);
>          }
>      } else {
>          /* try an implicit helper assignation */
> @@ -3213,7 +3213,7 @@ static int __init ctnetlink_init(void)
>      }
>  #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
>      /* setup interaction between nf_queue and nf_conntrack_netlink. */
> -    RCU_INIT_POINTER(nfq_ct_hook, &ctnetlink_nfqueue_hook);
> +    rcu_init_pointer(nfq_ct_hook, &ctnetlink_nfqueue_hook);
>  #endif
>      return 0;
> 
> @@ -3233,7 +3233,7 @@ static void __exit ctnetlink_exit(void)
>      nfnetlink_subsys_unregister(&ctnl_exp_subsys);
>      nfnetlink_subsys_unregister(&ctnl_subsys);
>  #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
> -    RCU_INIT_POINTER(nfq_ct_hook, NULL);
> +    rcu_init_pointer(nfq_ct_hook, NULL);
>  #endif
>  }
> 
> diff --git a/net/netfilter/nf_conntrack_proto.c
> b/net/netfilter/nf_conntrack_proto.c
> index b65d586..2dc7f72 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -384,7 +384,7 @@ int nf_ct_l4proto_register(struct
> nf_conntrack_l4proto *l4proto)
>          }
> 
>          for (i = 0; i < MAX_NF_CT_PROTO; i++)
> -            RCU_INIT_POINTER(proto_array[i], &nf_conntrack_l4proto_generic);
> +            rcu_init_pointer(proto_array[i], &nf_conntrack_l4proto_generic);
> 
>          /* Before making proto_array visible to lockless readers,
>           * we must make sure its content is committed to memory.
> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
> index 85296d4..a9580ec 100644
> --- a/net/netfilter/nf_log.c
> +++ b/net/netfilter/nf_log.c
> @@ -58,7 +58,7 @@ void nf_log_unset(struct net *net, const struct
> nf_logger *logger)
>          log = rcu_dereference_protected(net->nf.nf_loggers[i],
>                  lockdep_is_held(&nf_log_mutex));
>          if (log == logger)
> -            RCU_INIT_POINTER(net->nf.nf_loggers[i], NULL);
> +            rcu_init_pointer(net->nf.nf_loggers[i], NULL);
>      }
>      mutex_unlock(&nf_log_mutex);
>      synchronize_rcu();
> @@ -124,7 +124,7 @@ void nf_log_unbind_pf(struct net *net, u_int8_t pf)
>      if (pf >= ARRAY_SIZE(net->nf.nf_loggers))
>          return;
>      mutex_lock(&nf_log_mutex);
> -    RCU_INIT_POINTER(net->nf.nf_loggers[pf], NULL);
> +    rcu_init_pointer(net->nf.nf_loggers[pf], NULL);
>      mutex_unlock(&nf_log_mutex);
>  }
>  EXPORT_SYMBOL(nf_log_unbind_pf);
> diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
> index eb77238..d5ac5b2 100644
> --- a/net/netfilter/nf_nat_amanda.c
> +++ b/net/netfilter/nf_nat_amanda.c
> @@ -75,14 +75,14 @@ static unsigned int help(struct sk_buff *skb,
> 
>  static void __exit nf_nat_amanda_fini(void)
>  {
> -    RCU_INIT_POINTER(nf_nat_amanda_hook, NULL);
> +    rcu_init_pointer(nf_nat_amanda_hook, NULL);
>      synchronize_rcu();
>  }
> 
>  static int __init nf_nat_amanda_init(void)
>  {
>      BUG_ON(nf_nat_amanda_hook != NULL);
> -    RCU_INIT_POINTER(nf_nat_amanda_hook, help);
> +    rcu_init_pointer(nf_nat_amanda_hook, help);
>      return 0;
>  }
> 
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 52ca952..1219b5e 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -562,7 +562,7 @@ int nf_nat_l4proto_register(u8 l3proto, const
> struct nf_nat_l4proto *l4proto)
>          }
> 
>          for (i = 0; i < IPPROTO_MAX; i++)
> -            RCU_INIT_POINTER(l4protos[i], &nf_nat_l4proto_unknown);
> +            rcu_init_pointer(l4protos[i], &nf_nat_l4proto_unknown);
> 
>          /* Before making proto_array visible to lockless readers,
>           * we must make sure its content is committed to memory.
> @@ -579,7 +579,7 @@ int nf_nat_l4proto_register(u8 l3proto, const
> struct nf_nat_l4proto *l4proto)
>          ret = -EBUSY;
>          goto out;
>      }
> -    RCU_INIT_POINTER(nf_nat_l4protos[l3proto][l4proto->l4proto], l4proto);
> +    rcu_init_pointer(nf_nat_l4protos[l3proto][l4proto->l4proto], l4proto);
>   out:
>      mutex_unlock(&nf_nat_proto_mutex);
>      return ret;
> @@ -590,7 +590,7 @@ EXPORT_SYMBOL_GPL(nf_nat_l4proto_register);
>  void nf_nat_l4proto_unregister(u8 l3proto, const struct
> nf_nat_l4proto *l4proto)
>  {
>      mutex_lock(&nf_nat_proto_mutex);
> -    RCU_INIT_POINTER(nf_nat_l4protos[l3proto][l4proto->l4proto],
> +    rcu_init_pointer(nf_nat_l4protos[l3proto][l4proto->l4proto],
>               &nf_nat_l4proto_unknown);
>      mutex_unlock(&nf_nat_proto_mutex);
>      synchronize_rcu();
> @@ -608,13 +608,13 @@ int nf_nat_l3proto_register(const struct
> nf_nat_l3proto *l3proto)
>          return err;
> 
>      mutex_lock(&nf_nat_proto_mutex);
> -    RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_TCP],
> +    rcu_init_pointer(nf_nat_l4protos[l3proto->l3proto][IPPROTO_TCP],
>               &nf_nat_l4proto_tcp);
> -    RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_UDP],
> +    rcu_init_pointer(nf_nat_l4protos[l3proto->l3proto][IPPROTO_UDP],
>               &nf_nat_l4proto_udp);
>      mutex_unlock(&nf_nat_proto_mutex);
> 
> -    RCU_INIT_POINTER(nf_nat_l3protos[l3proto->l3proto], l3proto);
> +    rcu_init_pointer(nf_nat_l3protos[l3proto->l3proto], l3proto);
>      return 0;
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_l3proto_register);
> @@ -622,7 +622,7 @@ EXPORT_SYMBOL_GPL(nf_nat_l3proto_register);
>  void nf_nat_l3proto_unregister(const struct nf_nat_l3proto *l3proto)
>  {
>      mutex_lock(&nf_nat_proto_mutex);
> -    RCU_INIT_POINTER(nf_nat_l3protos[l3proto->l3proto], NULL);
> +    rcu_init_pointer(nf_nat_l3protos[l3proto->l3proto], NULL);
>      mutex_unlock(&nf_nat_proto_mutex);
>      synchronize_rcu();
> 
> @@ -822,11 +822,11 @@ static int __init nf_nat_init(void)
>      nf_ct_untracked_status_or(IPS_NAT_DONE_MASK);
> 
>      BUG_ON(nfnetlink_parse_nat_setup_hook != NULL);
> -    RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook,
> +    rcu_init_pointer(nfnetlink_parse_nat_setup_hook,
>                 nfnetlink_parse_nat_setup);
>  #ifdef CONFIG_XFRM
>      BUG_ON(nf_nat_decode_session_hook != NULL);
> -    RCU_INIT_POINTER(nf_nat_decode_session_hook, __nf_nat_decode_session);
> +    rcu_init_pointer(nf_nat_decode_session_hook, __nf_nat_decode_session);
>  #endif
>      return 0;
> 
> @@ -842,9 +842,9 @@ static void __exit nf_nat_cleanup(void)
>      unregister_pernet_subsys(&nf_nat_net_ops);
>      nf_ct_extend_unregister(&nat_extend);
>      nf_ct_helper_expectfn_unregister(&follow_master_nat);
> -    RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook, NULL);
> +    rcu_init_pointer(nfnetlink_parse_nat_setup_hook, NULL);
>  #ifdef CONFIG_XFRM
> -    RCU_INIT_POINTER(nf_nat_decode_session_hook, NULL);
> +    rcu_init_pointer(nf_nat_decode_session_hook, NULL);
>  #endif
>      for (i = 0; i < NFPROTO_NUMPROTO; i++)
>          kfree(nf_nat_l4protos[i]);
> diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
> index e84a578..aaef6c6 100644
> --- a/net/netfilter/nf_nat_ftp.c
> +++ b/net/netfilter/nf_nat_ftp.c
> @@ -122,14 +122,14 @@ out:
> 
>  static void __exit nf_nat_ftp_fini(void)
>  {
> -    RCU_INIT_POINTER(nf_nat_ftp_hook, NULL);
> +    rcu_init_pointer(nf_nat_ftp_hook, NULL);
>      synchronize_rcu();
>  }
> 
>  static int __init nf_nat_ftp_init(void)
>  {
>      BUG_ON(nf_nat_ftp_hook != NULL);
> -    RCU_INIT_POINTER(nf_nat_ftp_hook, nf_nat_ftp);
> +    rcu_init_pointer(nf_nat_ftp_hook, nf_nat_ftp);
>      return 0;
>  }
> 
> diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
> index 1fb2258..5bf497d 100644
> --- a/net/netfilter/nf_nat_irc.c
> +++ b/net/netfilter/nf_nat_irc.c
> @@ -95,14 +95,14 @@ static unsigned int help(struct sk_buff *skb,
> 
>  static void __exit nf_nat_irc_fini(void)
>  {
> -    RCU_INIT_POINTER(nf_nat_irc_hook, NULL);
> +    rcu_init_pointer(nf_nat_irc_hook, NULL);
>      synchronize_rcu();
>  }
> 
>  static int __init nf_nat_irc_init(void)
>  {
>      BUG_ON(nf_nat_irc_hook != NULL);
> -    RCU_INIT_POINTER(nf_nat_irc_hook, help);
> +    rcu_init_pointer(nf_nat_irc_hook, help);
>      return 0;
>  }
> 
> diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
> index b4d691d..a2a0a39 100644
> --- a/net/netfilter/nf_nat_sip.c
> +++ b/net/netfilter/nf_nat_sip.c
> @@ -625,7 +625,7 @@ static struct nf_ct_helper_expectfn sip_nat = {
> 
>  static void __exit nf_nat_sip_fini(void)
>  {
> -    RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
> +    rcu_init_pointer(nf_nat_sip_hooks, NULL);
> 
>      nf_ct_helper_expectfn_unregister(&sip_nat);
>      synchronize_rcu();
> @@ -644,7 +644,7 @@ static const struct nf_nat_sip_hooks sip_hooks = {
>  static int __init nf_nat_sip_init(void)
>  {
>      BUG_ON(nf_nat_sip_hooks != NULL);
> -    RCU_INIT_POINTER(nf_nat_sip_hooks, &sip_hooks);
> +    rcu_init_pointer(nf_nat_sip_hooks, &sip_hooks);
>      nf_ct_helper_expectfn_register(&sip_nat);
>      return 0;
>  }
> diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
> index 7f67e1d..f828ef0 100644
> --- a/net/netfilter/nf_nat_tftp.c
> +++ b/net/netfilter/nf_nat_tftp.c
> @@ -37,14 +37,14 @@ static unsigned int help(struct sk_buff *skb,
> 
>  static void __exit nf_nat_tftp_fini(void)
>  {
> -    RCU_INIT_POINTER(nf_nat_tftp_hook, NULL);
> +    rcu_init_pointer(nf_nat_tftp_hook, NULL);
>      synchronize_rcu();
>  }
> 
>  static int __init nf_nat_tftp_init(void)
>  {
>      BUG_ON(nf_nat_tftp_hook != NULL);
> -    RCU_INIT_POINTER(nf_nat_tftp_hook, help);
> +    rcu_init_pointer(nf_nat_tftp_hook, help);
>      return 0;
>  }
> 
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 5d24b1f..93fe802 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -40,7 +40,7 @@ EXPORT_SYMBOL(nf_register_queue_handler);
>  /* The caller must flush their queue before this */
>  void nf_unregister_queue_handler(void)
>  {
> -    RCU_INIT_POINTER(queue_handler, NULL);
> +    rcu_init_pointer(queue_handler, NULL);
>      synchronize_rcu();
>  }
>  EXPORT_SYMBOL(nf_unregister_queue_handler);
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index e8138da..6477a02 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -440,7 +440,7 @@ static void __net_exit
> nfnetlink_net_exit_batch(struct list_head *net_exit_list)
>      struct net *net;
> 
>      list_for_each_entry(net, net_exit_list, exit_list)
> -        RCU_INIT_POINTER(net->nfnl, NULL);
> +        rcu_init_pointer(net->nfnl, NULL);
>      synchronize_net();
>      list_for_each_entry(net, net_exit_list, exit_list)
>          netlink_kernel_release(net->nfnl_stash);
> diff --git a/net/netfilter/nfnetlink_cttimeout.c
> b/net/netfilter/nfnetlink_cttimeout.c
> index 476accd..836836c 100644
> --- a/net/netfilter/nfnetlink_cttimeout.c
> +++ b/net/netfilter/nfnetlink_cttimeout.c
> @@ -551,8 +551,8 @@ static int __init cttimeout_init(void)
>          goto err_out;
>      }
>  #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
> -    RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, ctnl_timeout_find_get);
> -    RCU_INIT_POINTER(nf_ct_timeout_put_hook, ctnl_timeout_put);
> +    rcu_init_pointer(nf_ct_timeout_find_get_hook, ctnl_timeout_find_get);
> +    rcu_init_pointer(nf_ct_timeout_put_hook, ctnl_timeout_put);
>  #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
>      return 0;
> 
> @@ -576,8 +576,8 @@ static void __exit cttimeout_exit(void)
>          kfree_rcu(cur, rcu_head);
>      }
>  #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
> -    RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, NULL);
> -    RCU_INIT_POINTER(nf_ct_timeout_put_hook, NULL);
> +    rcu_init_pointer(nf_ct_timeout_find_get_hook, NULL);
> +    rcu_init_pointer(nf_ct_timeout_put_hook, NULL);
>  #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
>  }
> 
> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> index 3b1ad87..539385b 100644
> --- a/net/netfilter/nft_hash.c
> +++ b/net/netfilter/nft_hash.c
> @@ -119,7 +119,7 @@ static void nft_hash_chain_unzip(const struct nft_set *set,
>      }
> 
>      /* Unlink first chain from the old table */
> -    RCU_INIT_POINTER(tbl->buckets[n], last->next);
> +    rcu_init_pointer(tbl->buckets[n], last->next);
> 
>      /* If end of chain reached, done */
>      if (he == NULL)
> @@ -135,7 +135,7 @@ static void nft_hash_chain_unzip(const struct nft_set *set,
>      }
> 
>      /* Link the two chains */
> -    RCU_INIT_POINTER(last->next, next);
> +    rcu_init_pointer(last->next, next);
>  }
> 
>  static int nft_hash_tbl_expand(const struct nft_set *set, struct
> nft_hash *priv)
> @@ -157,7 +157,7 @@ static int nft_hash_tbl_expand(const struct
> nft_set *set, struct nft_hash *priv)
>          nft_hash_for_each_entry(he, tbl->buckets[h]) {
>              if (nft_hash_data(&he->key, ntbl->size, set->klen) != i)
>                  continue;
> -            RCU_INIT_POINTER(ntbl->buckets[i], he);
> +            rcu_init_pointer(ntbl->buckets[i], he);
>              break;
>          }
>      }
> @@ -199,7 +199,7 @@ static int nft_hash_tbl_shrink(const struct
> nft_set *set, struct nft_hash *priv)
>          for (pprev = &ntbl->buckets[i]; *pprev != NULL;
>               pprev = &nft_dereference(*pprev)->next)
>              ;
> -        RCU_INIT_POINTER(*pprev, tbl->buckets[i + ntbl->size]);
> +        rcu_init_pointer(*pprev, tbl->buckets[i + ntbl->size]);
>      }
>      ntbl->elements = tbl->elements;
> 
> @@ -235,7 +235,7 @@ static int nft_hash_insert(const struct nft_set *set,
>          nft_data_copy(he->data, &elem->data);
> 
>      h = nft_hash_data(&he->key, tbl->size, set->klen);
> -    RCU_INIT_POINTER(he->next, tbl->buckets[h]);
> +    rcu_init_pointer(he->next, tbl->buckets[h]);
>      rcu_assign_pointer(tbl->buckets[h], he);
>      tbl->elements++;
> 
> @@ -265,7 +265,7 @@ static void nft_hash_remove(const struct nft_set *set,
>      pprev = elem->cookie;
>      he = nft_dereference((*pprev));
> 
> -    RCU_INIT_POINTER(*pprev, he->next);
> +    rcu_init_pointer(*pprev, he->next);
>      synchronize_rcu();
>      kfree(he);
>      tbl->elements--;
> @@ -348,7 +348,7 @@ static int nft_hash_init(const struct nft_set *set,
>      tbl = nft_hash_tbl_alloc(NFT_HASH_MIN_SIZE);
>      if (tbl == NULL)
>          return -ENOMEM;
> -    RCU_INIT_POINTER(priv->tbl, tbl);
> +    rcu_init_pointer(priv->tbl, tbl);
>      return 0;
>  }
> 
> diff --git a/net/netlabel/netlabel_domainhash.c
> b/net/netlabel/netlabel_domainhash.c
> index f0cb92f..97632af 100644
> --- a/net/netlabel/netlabel_domainhash.c
> +++ b/net/netlabel/netlabel_domainhash.c
> @@ -516,7 +516,7 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
>          if (entry != rcu_dereference(netlbl_domhsh_def))
>              list_del_rcu(&entry->list);
>          else
> -            RCU_INIT_POINTER(netlbl_domhsh_def, NULL);
> +            rcu_init_pointer(netlbl_domhsh_def, NULL);
>      } else
>          ret_val = -ENOENT;
>      spin_unlock(&netlbl_domhsh_lock);
> diff --git a/net/netlabel/netlabel_unlabeled.c
> b/net/netlabel/netlabel_unlabeled.c
> index 78a63c1..b7ebdee 100644
> --- a/net/netlabel/netlabel_unlabeled.c
> +++ b/net/netlabel/netlabel_unlabeled.c
> @@ -620,7 +620,7 @@ static void netlbl_unlhsh_condremove_iface(struct
> netlbl_unlhsh_iface *iface)
>      if (iface->ifindex > 0)
>          list_del_rcu(&iface->list);
>      else
> -        RCU_INIT_POINTER(netlbl_unlhsh_def, NULL);
> +        rcu_init_pointer(netlbl_unlhsh_def, NULL);
>      spin_unlock(&netlbl_unlhsh_lock);
> 
>      call_rcu(&iface->rcu, netlbl_unlhsh_free_iface);
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 894cda0..93f0bd6 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1297,7 +1297,7 @@ static int netlink_release(struct socket *sock)
>              struct listeners *old;
> 
>              old = nl_deref_protected(nl_table[sk->sk_protocol].listeners);
> -            RCU_INIT_POINTER(nl_table[sk->sk_protocol].listeners, NULL);
> +            rcu_init_pointer(nl_table[sk->sk_protocol].listeners, NULL);
>              kfree_rcu(old, rcu);
>              nl_table[sk->sk_protocol].module = NULL;
>              nl_table[sk->sk_protocol].bind = NULL;
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index b85c67c..4740dc6 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -301,7 +301,7 @@ static void packet_cached_dev_assign(struct packet_sock *po,
> 
>  static void packet_cached_dev_reset(struct packet_sock *po)
>  {
> -    RCU_INIT_POINTER(po->cached_dev, NULL);
> +    rcu_init_pointer(po->cached_dev, NULL);
>  }
> 
>  static bool packet_use_direct_xmit(const struct packet_sock *po)
> diff --git a/net/phonet/af_phonet.c b/net/phonet/af_phonet.c
> index 5a940db..694d5d8 100644
> --- a/net/phonet/af_phonet.c
> +++ b/net/phonet/af_phonet.c
> @@ -491,7 +491,7 @@ void phonet_proto_unregister(unsigned int
> protocol, struct phonet_protocol *pp)
>  {
>      mutex_lock(&proto_tab_lock);
>      BUG_ON(proto_tab[protocol] != pp);
> -    RCU_INIT_POINTER(proto_tab[protocol], NULL);
> +    rcu_init_pointer(proto_tab[protocol], NULL);
>      mutex_unlock(&proto_tab_lock);
>      synchronize_rcu();
>      proto_unregister(pp->prot);
> diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
> index 56a6146..07d5619 100644
> --- a/net/phonet/pn_dev.c
> +++ b/net/phonet/pn_dev.c
> @@ -276,7 +276,7 @@ static void phonet_route_autodel(struct net_device *dev)
>      mutex_lock(&pnn->routes.lock);
>      for (i = 0; i < 64; i++)
>          if (dev == pnn->routes.table[i]) {
> -            RCU_INIT_POINTER(pnn->routes.table[i], NULL);
> +            rcu_init_pointer(pnn->routes.table[i], NULL);
>              set_bit(i, deleted);
>          }
>      mutex_unlock(&pnn->routes.lock);
> @@ -389,7 +389,7 @@ int phonet_route_del(struct net_device *dev, u8 daddr)
>      daddr = daddr >> 2;
>      mutex_lock(&routes->lock);
>      if (dev == routes->table[daddr])
> -        RCU_INIT_POINTER(routes->table[daddr], NULL);
> +        rcu_init_pointer(routes->table[daddr], NULL);
>      else
>          dev = NULL;
>      mutex_unlock(&routes->lock);
> diff --git a/net/phonet/socket.c b/net/phonet/socket.c
> index 008214a..24e0db2 100644
> --- a/net/phonet/socket.c
> +++ b/net/phonet/socket.c
> @@ -693,7 +693,7 @@ int pn_sock_unbind_res(struct sock *sk, u8 res)
> 
>      mutex_lock(&resource_mutex);
>      if (pnres.sk[res] == sk) {
> -        RCU_INIT_POINTER(pnres.sk[res], NULL);
> +        rcu_init_pointer(pnres.sk[res], NULL);
>          ret = 0;
>      }
>      mutex_unlock(&resource_mutex);
> @@ -712,7 +712,7 @@ void pn_sock_unbind_all_res(struct sock *sk)
>      mutex_lock(&resource_mutex);
>      for (res = 0; res < 256; res++) {
>          if (pnres.sk[res] == sk) {
> -            RCU_INIT_POINTER(pnres.sk[res], NULL);
> +            rcu_init_pointer(pnres.sk[res], NULL);
>              match++;
>          }
>      }
> diff --git a/net/socket.c b/net/socket.c
> index abf56b2..9350395 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -260,7 +260,7 @@ static struct inode *sock_alloc_inode(struct
> super_block *sb)
>      }
>      init_waitqueue_head(&wq->wait);
>      wq->fasync_list = NULL;
> -    RCU_INIT_POINTER(ei->socket.wq, wq);
> +    rcu_init_pointer(ei->socket.wq, wq);
> 
>      ei->socket.state = SS_UNCONNECTED;
>      ei->socket.flags = 0;
> @@ -2638,7 +2638,7 @@ void sock_unregister(int family)
>      BUG_ON(family < 0 || family >= NPROTO);
> 
>      spin_lock(&net_family_lock);
> -    RCU_INIT_POINTER(net_families[family], NULL);
> +    rcu_init_pointer(net_families[family], NULL);
>      spin_unlock(&net_family_lock);
> 
>      synchronize_rcu();
> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> index 36e431e..1810c54 100644
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -1262,7 +1262,7 @@ gss_destroy_nullcred(struct rpc_cred *cred)
>      struct gss_auth *gss_auth = container_of(cred->cr_auth, struct
> gss_auth, rpc_auth);
>      struct gss_cl_ctx *ctx = gss_cred->gc_ctx;
> 
> -    RCU_INIT_POINTER(gss_cred->gc_ctx, NULL);
> +    rcu_init_pointer(gss_cred->gc_ctx, NULL);
>      call_rcu(&cred->cr_rcu, gss_free_cred_callback);
>      if (ctx)
>          gss_put_ctx(ctx);
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index 3fef7eb..3a56cd6 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -464,7 +464,7 @@ int tipc_enable_l2_media(struct tipc_bearer *b)
>  void tipc_disable_l2_media(struct tipc_bearer *b)
>  {
>      struct net_device *dev = (struct net_device *)b->media_ptr;
> -    RCU_INIT_POINTER(dev->tipc_ptr, NULL);
> +    rcu_init_pointer(dev->tipc_ptr, NULL);
>      dev_put(dev);
>  }
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index bb7e8ba..ae855b9 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1187,7 +1187,7 @@ restart:
>      newsk->sk_type        = sk->sk_type;
>      init_peercred(newsk);
>      newu = unix_sk(newsk);
> -    RCU_INIT_POINTER(newsk->sk_wq, &newu->peer_wq);
> +    rcu_init_pointer(newsk->sk_wq, &newu->peer_wq);
>      otheru = unix_sk(other);
> 
>      /* copy address information from listening to new sock*/
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index 85d1d47..deb776d 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -50,7 +50,7 @@ int xfrm_input_unregister_afinfo(struct
> xfrm_input_afinfo *afinfo)
>          if (unlikely(xfrm_input_afinfo[afinfo->family] != afinfo))
>              err = -EINVAL;
>          else
> -            RCU_INIT_POINTER(xfrm_input_afinfo[afinfo->family], NULL);
> +            rcu_init_pointer(xfrm_input_afinfo[afinfo->family], NULL);
>      }
>      spin_unlock_bh(&xfrm_input_afinfo_lock);
>      synchronize_rcu();
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index c08fbd1..326d6ed 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -2729,7 +2729,7 @@ int xfrm_policy_unregister_afinfo(struct
> xfrm_policy_afinfo *afinfo)
>          if (unlikely(xfrm_policy_afinfo[afinfo->family] != afinfo))
>              err = -EINVAL;
>          else
> -            RCU_INIT_POINTER(xfrm_policy_afinfo[afinfo->family],
> +            rcu_init_pointer(xfrm_policy_afinfo[afinfo->family],
>                       NULL);
>      }
>      spin_unlock(&xfrm_policy_afinfo_lock);
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index 8e9c781..cf7e89c 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -1942,7 +1942,7 @@ int xfrm_state_unregister_afinfo(struct
> xfrm_state_afinfo *afinfo)
>          if (unlikely(xfrm_state_afinfo[afinfo->family] != afinfo))
>              err = -EINVAL;
>          else
> -            RCU_INIT_POINTER(xfrm_state_afinfo[afinfo->family], NULL);
> +            rcu_init_pointer(xfrm_state_afinfo[afinfo->family], NULL);
>      }
>      spin_unlock_bh(&xfrm_state_afinfo_lock);
>      synchronize_rcu();
> diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> index 8f131c1..cdf2a66 100644
> --- a/net/xfrm/xfrm_user.c
> +++ b/net/xfrm/xfrm_user.c
> @@ -3040,7 +3040,7 @@ static void __net_exit xfrm_user_net_exit(struct
> list_head *net_exit_list)
>  {
>      struct net *net;
>      list_for_each_entry(net, net_exit_list, exit_list)
> -        RCU_INIT_POINTER(net->xfrm.nlsk, NULL);
> +        rcu_init_pointer(net->xfrm.nlsk, NULL);
>      synchronize_net();
>      list_for_each_entry(net, net_exit_list, exit_list)
>          netlink_kernel_release(net->xfrm.nlsk_stash);
> -- 
> 1.7.9.5

> Signed-off-by: Romanov Arya <romanov.arya@gmail.com>
> ---
>  arch/powerpc/platforms/cell/spu_syscalls.c         |    2 +-
>  drivers/crypto/nx/nx-842.c                         |    4 +-
>  drivers/infiniband/hw/qib/qib_qp.c                 |    2 +-
>  drivers/infiniband/hw/qib/qib_verbs.c              |   10 ++--
>  drivers/ipack/carriers/tpci200.c                   |    2 +-
>  drivers/md/dm.c                                    |    2 +-
>  drivers/net/bonding/bond_main.c                    |    2 +-
>  drivers/net/bonding/bond_options.c                 |    2 +-
>  drivers/net/ethernet/broadcom/bnx2.c               |    2 +-
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    2 +-
>  drivers/net/ethernet/broadcom/cnic.c               |    6 +--
>  drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |    4 +-
>  drivers/net/macvtap.c                              |   10 ++--
>  drivers/net/ppp/pptp.c                             |    2 +-
>  drivers/net/team/team_mode_activebackup.c          |    2 +-
>  drivers/net/team/team_mode_loadbalance.c           |    2 +-
>  drivers/net/tun.c                                  |    8 ++--
>  drivers/net/veth.c                                 |    4 +-
>  drivers/net/wireless/ath/carl9170/main.c           |   12 ++---
>  drivers/net/wireless/iwlwifi/mvm/fw.c              |    4 +-
>  drivers/vhost/vhost.c                              |    4 +-
>  fs/eventpoll.c                                     |    4 +-
>  fs/proc/inode.c                                    |    2 +-
>  include/linux/rcupdate.h                           |   20 ++++----
>  kernel/audit.c                                     |    2 +-
>  kernel/cgroup.c                                    |   14 +++---
>  kernel/trace/trace_events_filter.c                 |    4 +-
>  kernel/trace/trace_events_trigger.c                |    2 +-
>  kernel/workqueue.c                                 |    2 +-
>  lib/idr.c                                          |    6 +--
>  net/802/garp.c                                     |    4 +-
>  net/802/mrp.c                                      |    4 +-
>  net/802/stp.c                                      |    4 +-
>  net/8021q/vlan_core.c                              |    2 +-
>  net/bridge/br_vlan.c                               |    8 ++--
>  net/bridge/netfilter/ebtable_broute.c              |    4 +-
>  net/caif/cfmuxl.c                                  |    4 +-
>  net/can/af_can.c                                   |    4 +-
>  net/core/dev.c                                     |   14 +++---
>  net/core/fib_rules.c                               |    4 +-
>  net/core/filter.c                                  |    2 +-
>  net/core/neighbour.c                               |    2 +-
>  net/core/net-sysfs.c                               |    4 +-
>  net/core/netpoll.c                                 |    2 +-
>  net/core/netprio_cgroup.c                          |    2 +-
>  net/core/sock.c                                    |    4 +-
>  net/core/sysctl_net_core.c                         |    2 +-
>  net/decnet/dn_dev.c                                |    2 +-
>  net/decnet/dn_route.c                              |    2 +-
>  net/ipv4/devinet.c                                 |    4 +-
>  net/ipv4/fib_semantics.c                           |    2 +-
>  net/ipv4/fib_trie.c                                |    2 +-
>  net/ipv4/igmp.c                                    |    4 +-
>  net/ipv4/inetpeer.c                                |   50 ++++++++++----------
>  net/ipv4/ipmr.c                                    |    2 +-
>  net/ipv4/netfilter/nf_nat_h323.c                   |   36 +++++++-------
>  net/ipv4/netfilter/nf_nat_pptp.c                   |   16 +++----
>  net/ipv4/netfilter/nf_nat_snmp_basic.c             |    4 +-
>  net/ipv4/route.c                                   |    4 +-
>  net/ipv6/addrconf.c                                |    2 +-
>  net/ipv6/ip6_tunnel.c                              |    2 +-
>  net/ipv6/ip6_vti.c                                 |    2 +-
>  net/ipv6/netfilter.c                               |    4 +-
>  net/ipv6/raw.c                                     |    2 +-
>  net/ipv6/sit.c                                     |    2 +-
>  net/mac80211/agg-rx.c                              |    2 +-
>  net/mac80211/cfg.c                                 |    8 ++--
>  net/mac80211/ibss.c                                |    4 +-
>  net/mac80211/mesh.c                                |    2 +-
>  net/mac80211/mesh_pathtbl.c                        |    4 +-
>  net/mac80211/sta_info.c                            |    2 +-
>  net/netfilter/core.c                               |    4 +-
>  net/netfilter/ipvs/ip_vs_ctl.c                     |    4 +-
>  net/netfilter/ipvs/ip_vs_dh.c                      |    6 +--
>  net/netfilter/ipvs/ip_vs_sh.c                      |    6 +--
>  net/netfilter/nf_conntrack_core.c                  |    8 ++--
>  net/netfilter/nf_conntrack_ecache.c                |    4 +-
>  net/netfilter/nf_conntrack_extend.c                |    2 +-
>  net/netfilter/nf_conntrack_helper.c                |    6 +--
>  net/netfilter/nf_conntrack_netlink.c               |    8 ++--
>  net/netfilter/nf_conntrack_proto.c                 |    2 +-
>  net/netfilter/nf_log.c                             |    4 +-
>  net/netfilter/nf_nat_amanda.c                      |    4 +-
>  net/netfilter/nf_nat_core.c                        |   22 ++++-----
>  net/netfilter/nf_nat_ftp.c                         |    4 +-
>  net/netfilter/nf_nat_irc.c                         |    4 +-
>  net/netfilter/nf_nat_sip.c                         |    4 +-
>  net/netfilter/nf_nat_tftp.c                        |    4 +-
>  net/netfilter/nf_queue.c                           |    2 +-
>  net/netfilter/nfnetlink.c                          |    2 +-
>  net/netfilter/nfnetlink_cttimeout.c                |    8 ++--
>  net/netfilter/nft_hash.c                           |   14 +++---
>  net/netlabel/netlabel_domainhash.c                 |    2 +-
>  net/netlabel/netlabel_unlabeled.c                  |    2 +-
>  net/netlink/af_netlink.c                           |    2 +-
>  net/packet/af_packet.c                             |    2 +-
>  net/phonet/af_phonet.c                             |    2 +-
>  net/phonet/pn_dev.c                                |    4 +-
>  net/phonet/socket.c                                |    4 +-
>  net/socket.c                                       |    4 +-
>  net/sunrpc/auth_gss/auth_gss.c                     |    2 +-
>  net/tipc/bearer.c                                  |    2 +-
>  net/unix/af_unix.c                                 |    2 +-
>  net/xfrm/xfrm_input.c                              |    2 +-
>  net/xfrm/xfrm_policy.c                             |    2 +-
>  net/xfrm/xfrm_state.c                              |    2 +-
>  net/xfrm/xfrm_user.c                               |    2 +-
>  107 files changed, 268 insertions(+), 268 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/cell/spu_syscalls.c b/arch/powerpc/platforms/cell/spu_syscalls.c
> index 38e0a1a..2feef7c 100644
> --- a/arch/powerpc/platforms/cell/spu_syscalls.c
> +++ b/arch/powerpc/platforms/cell/spu_syscalls.c
> @@ -170,7 +170,7 @@ EXPORT_SYMBOL_GPL(register_spu_syscalls);
>  void unregister_spu_syscalls(struct spufs_calls *calls)
>  {
>  	BUG_ON(spufs_calls->owner != calls->owner);
> -	RCU_INIT_POINTER(spufs_calls, NULL);
> +	rcu_init_pointer(spufs_calls, NULL);
>  	synchronize_rcu();
>  }
>  EXPORT_SYMBOL_GPL(unregister_spu_syscalls);
> diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
> index 1e5481d..e72d3d7 100644
> --- a/drivers/crypto/nx/nx-842.c
> +++ b/drivers/crypto/nx/nx-842.c
> @@ -1262,14 +1262,14 @@ static int __init nx842_init(void)
>  	struct nx842_devdata *new_devdata;
>  	pr_info("Registering IBM Power 842 compression driver\n");
>  
> -	RCU_INIT_POINTER(devdata, NULL);
> +	rcu_init_pointer(devdata, NULL);
>  	new_devdata = kzalloc(sizeof(*new_devdata), GFP_KERNEL);
>  	if (!new_devdata) {
>  		pr_err("Could not allocate memory for device data\n");
>  		return -ENOMEM;
>  	}
>  	new_devdata->status = UNAVAILABLE;
> -	RCU_INIT_POINTER(devdata, new_devdata);
> +	rcu_init_pointer(devdata, new_devdata);
>  
>  	return vio_register_driver(&nx842_driver);
>  }
> diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
> index 0cad0c4..e967aa5 100644
> --- a/drivers/infiniband/hw/qib/qib_qp.c
> +++ b/drivers/infiniband/hw/qib/qib_qp.c
> @@ -1041,7 +1041,7 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
>  			ret = ERR_PTR(-ENOMEM);
>  			goto bail_swq;
>  		}
> -		RCU_INIT_POINTER(qp->next, NULL);
> +		rcu_init_pointer(qp->next, NULL);
>  		qp->s_hdr = kzalloc(sizeof(*qp->s_hdr), GFP_KERNEL);
>  		if (!qp->s_hdr) {
>  			ret = ERR_PTR(-ENOMEM);
> diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
> index 9bcfbd8..8ed08aa9 100644
> --- a/drivers/infiniband/hw/qib/qib_verbs.c
> +++ b/drivers/infiniband/hw/qib/qib_verbs.c
> @@ -2035,8 +2035,8 @@ static void init_ibport(struct qib_pportdata *ppd)
>  	ibp->z_excessive_buffer_overrun_errors =
>  		cntrs.excessive_buffer_overrun_errors;
>  	ibp->z_vl15_dropped = cntrs.vl15_dropped;
> -	RCU_INIT_POINTER(ibp->qp0, NULL);
> -	RCU_INIT_POINTER(ibp->qp1, NULL);
> +	rcu_init_pointer(ibp->qp0, NULL);
> +	rcu_init_pointer(ibp->qp1, NULL);
>  }
>  
>  /**
> @@ -2061,7 +2061,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
>  		goto err_qpt;
>  	}
>  	for (i = 0; i < dev->qp_table_size; i++)
> -		RCU_INIT_POINTER(dev->qp_table[i], NULL);
> +		rcu_init_pointer(dev->qp_table[i], NULL);
>  
>  	for (i = 0; i < dd->num_pports; i++)
>  		init_ibport(ppd + i);
> @@ -2094,9 +2094,9 @@ int qib_register_ib_device(struct qib_devdata *dd)
>  		ret = -ENOMEM;
>  		goto err_lk;
>  	}
> -	RCU_INIT_POINTER(dev->dma_mr, NULL);
> +	rcu_init_pointer(dev->dma_mr, NULL);
>  	for (i = 0; i < dev->lk_table.max; i++)
> -		RCU_INIT_POINTER(dev->lk_table.table[i], NULL);
> +		rcu_init_pointer(dev->lk_table.table[i], NULL);
>  	INIT_LIST_HEAD(&dev->pending_mmaps);
>  	spin_lock_init(&dev->pending_lock);
>  	dev->mmap_offset = PAGE_SIZE;
> diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tpci200.c
> index c276fde..86ae582 100644
> --- a/drivers/ipack/carriers/tpci200.c
> +++ b/drivers/ipack/carriers/tpci200.c
> @@ -187,7 +187,7 @@ static int tpci200_free_irq(struct ipack_device *dev)
>  	tpci200_disable_irq(tpci200, dev->slot);
>  	slot_irq = tpci200->slots[dev->slot].irq;
>  	/* uninstall handler */
> -	RCU_INIT_POINTER(tpci200->slots[dev->slot].irq, NULL);
> +	rcu_init_pointer(tpci200->slots[dev->slot].irq, NULL);
>  	synchronize_rcu();
>  	kfree(slot_irq);
>  	mutex_unlock(&tpci200->mutex);
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 455e649..19e6e9a 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2168,7 +2168,7 @@ static struct dm_table *__unbind(struct mapped_device *md)
>  		return NULL;
>  
>  	dm_table_event_callback(map, NULL, NULL);
> -	RCU_INIT_POINTER(md->map, NULL);
> +	rcu_init_pointer(md->map, NULL);
>  	dm_sync_table(md);
>  
>  	return map;
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 69aff72..d75c7ef 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1704,7 +1704,7 @@ static int __bond_release_one(struct net_device *bond_dev,
>  	}
>  
>  	if (all) {
> -		RCU_INIT_POINTER(bond->curr_active_slave, NULL);
> +		rcu_init_pointer(bond->curr_active_slave, NULL);
>  	} else if (oldcurrent == slave) {
>  		/*
>  		 * Note that we hold RTNL over this sequence, so there
> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
> index 724e30f..069c7c3 100644
> --- a/drivers/net/bonding/bond_options.c
> +++ b/drivers/net/bonding/bond_options.c
> @@ -712,7 +712,7 @@ static int bond_option_active_slave_set(struct bonding *bond,
>  	/* check to see if we are clearing active */
>  	if (!slave_dev) {
>  		pr_info("%s: Clearing current active slave\n", bond->dev->name);
> -		RCU_INIT_POINTER(bond->curr_active_slave, NULL);
> +		rcu_init_pointer(bond->curr_active_slave, NULL);
>  		bond_select_active_slave(bond);
>  	} else {
>  		struct slave *old_active = bond->curr_active_slave;
> diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
> index 0ab8370..7facbc4 100644
> --- a/drivers/net/ethernet/broadcom/bnx2.c
> +++ b/drivers/net/ethernet/broadcom/bnx2.c
> @@ -409,7 +409,7 @@ static int bnx2_unregister_cnic(struct net_device *dev)
>  	mutex_lock(&bp->cnic_lock);
>  	cp->drv_state = 0;
>  	bnapi->cnic_present = 0;
> -	RCU_INIT_POINTER(bp->cnic_ops, NULL);
> +	rcu_init_pointer(bp->cnic_ops, NULL);
>  	mutex_unlock(&bp->cnic_lock);
>  	synchronize_rcu();
>  	return 0;
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index a78edac..83a228e 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -14048,7 +14048,7 @@ static int bnx2x_unregister_cnic(struct net_device *dev)
>  
>  	mutex_lock(&bp->cnic_mutex);
>  	cp->drv_state = 0;
> -	RCU_INIT_POINTER(bp->cnic_ops, NULL);
> +	rcu_init_pointer(bp->cnic_ops, NULL);
>  	mutex_unlock(&bp->cnic_mutex);
>  	synchronize_rcu();
>  	bp->cnic_enabled = false;
> diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
> index 09f3fef..42d5ff3a 100644
> --- a/drivers/net/ethernet/broadcom/cnic.c
> +++ b/drivers/net/ethernet/broadcom/cnic.c
> @@ -534,7 +534,7 @@ int cnic_unregister_driver(int ulp_type)
>  	}
>  	read_unlock(&cnic_dev_lock);
>  
> -	RCU_INIT_POINTER(cnic_ulp_tbl[ulp_type], NULL);
> +	rcu_init_pointer(cnic_ulp_tbl[ulp_type], NULL);
>  
>  	mutex_unlock(&cnic_lock);
>  	synchronize_rcu();
> @@ -610,7 +610,7 @@ static int cnic_unregister_device(struct cnic_dev *dev, int ulp_type)
>  	}
>  	mutex_lock(&cnic_lock);
>  	if (rcu_dereference(cp->ulp_ops[ulp_type])) {
> -		RCU_INIT_POINTER(cp->ulp_ops[ulp_type], NULL);
> +		rcu_init_pointer(cp->ulp_ops[ulp_type], NULL);
>  		cnic_put(dev);
>  	} else {
>  		pr_err("%s: device not registered to this ulp type %d\n",
> @@ -5414,7 +5414,7 @@ static void cnic_stop_hw(struct cnic_dev *dev)
>  		cp->stop_cm(dev);
>  		cp->ethdev->drv_state &= ~CNIC_DRV_STATE_HANDLES_IRQ;
>  		clear_bit(CNIC_F_CNIC_UP, &dev->flags);
> -		RCU_INIT_POINTER(cp->ulp_ops[CNIC_ULP_L4], NULL);
> +		rcu_init_pointer(cp->ulp_ops[CNIC_ULP_L4], NULL);
>  		synchronize_rcu();
>  		cnic_cm_shutdown(dev);
>  		cp->stop_hw(dev);
> diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
> index c0a9dd5..466f3b2 100644
> --- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
> +++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c
> @@ -1280,7 +1280,7 @@ int cxgb3_offload_activate(struct adapter *adapter)
>  	INIT_LIST_HEAD(&t->list_node);
>  	t->dev = dev;
>  
> -	RCU_INIT_POINTER(dev->l2opt, l2td);
> +	rcu_init_pointer(dev->l2opt, l2td);
>  	T3C_DATA(dev) = t;
>  	dev->recv = process_rx;
>  	dev->neigh_update = t3_l2t_update;
> @@ -1324,7 +1324,7 @@ void cxgb3_offload_deactivate(struct adapter *adapter)
>  	rcu_read_lock();
>  	d = L2DATA(tdev);
>  	rcu_read_unlock();
> -	RCU_INIT_POINTER(tdev->l2opt, NULL);
> +	rcu_init_pointer(tdev->l2opt, NULL);
>  	call_rcu(&d->rcu_head, clean_l2_data);
>  	if (t->nofail_skb)
>  		kfree_skb(t->nofail_skb);
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index ff111a8..c343c1d 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -159,7 +159,7 @@ static int macvtap_disable_queue(struct macvtap_queue *q)
>  		nq->queue_index = index;
>  
>  		rcu_assign_pointer(vlan->taps[index], nq);
> -		RCU_INIT_POINTER(vlan->taps[vlan->numvtaps - 1], NULL);
> +		rcu_init_pointer(vlan->taps[vlan->numvtaps - 1], NULL);
>  		q->enabled = false;
>  
>  		vlan->numvtaps--;
> @@ -188,7 +188,7 @@ static void macvtap_put_queue(struct macvtap_queue *q)
>  			BUG_ON(macvtap_disable_queue(q));
>  
>  		vlan->numqueues--;
> -		RCU_INIT_POINTER(q->vlan, NULL);
> +		rcu_init_pointer(q->vlan, NULL);
>  		sock_put(&q->sk);
>  		list_del_init(&q->next);
>  	}
> @@ -259,13 +259,13 @@ static void macvtap_del_queues(struct net_device *dev)
>  	list_for_each_entry_safe(q, tmp, &vlan->queue_list, next) {
>  		list_del_init(&q->next);
>  		qlist[j++] = q;
> -		RCU_INIT_POINTER(q->vlan, NULL);
> +		rcu_init_pointer(q->vlan, NULL);
>  		if (q->enabled)
>  			vlan->numvtaps--;
>  		vlan->numqueues--;
>  	}
>  	for (i = 0; i < vlan->numvtaps; i++)
> -		RCU_INIT_POINTER(vlan->taps[i], NULL);
> +		rcu_init_pointer(vlan->taps[i], NULL);
>  	BUG_ON(vlan->numvtaps);
>  	BUG_ON(vlan->numqueues);
>  	/* guarantee that any future macvtap_set_queue will fail */
> @@ -459,7 +459,7 @@ static int macvtap_open(struct inode *inode, struct file *file)
>  	if (!q)
>  		goto out;
>  
> -	RCU_INIT_POINTER(q->sock.wq, &q->wq);
> +	rcu_init_pointer(q->sock.wq, &q->wq);
>  	init_waitqueue_head(&q->wq.wait);
>  	q->sock.type = SOCK_RAW;
>  	q->sock.state = SS_CONNECTED;
> diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
> index 0180531..b7c2acb 100644
> --- a/drivers/net/ppp/pptp.c
> +++ b/drivers/net/ppp/pptp.c
> @@ -162,7 +162,7 @@ static void del_chan(struct pppox_sock *sock)
>  {
>  	spin_lock(&chan_lock);
>  	clear_bit(sock->proto.pptp.src_addr.call_id, callid_bitmap);
> -	RCU_INIT_POINTER(callid_sock[sock->proto.pptp.src_addr.call_id], NULL);
> +	rcu_init_pointer(callid_sock[sock->proto.pptp.src_addr.call_id], NULL);
>  	spin_unlock(&chan_lock);
>  	synchronize_rcu();
>  }
> diff --git a/drivers/net/team/team_mode_activebackup.c b/drivers/net/team/team_mode_activebackup.c
> index 40fd338..91b3066 100644
> --- a/drivers/net/team/team_mode_activebackup.c
> +++ b/drivers/net/team/team_mode_activebackup.c
> @@ -56,7 +56,7 @@ drop:
>  static void ab_port_leave(struct team *team, struct team_port *port)
>  {
>  	if (ab_priv(team)->active_port == port) {
> -		RCU_INIT_POINTER(ab_priv(team)->active_port, NULL);
> +		rcu_init_pointer(ab_priv(team)->active_port, NULL);
>  		team_option_inst_set_change(ab_priv(team)->ap_opt_inst_info);
>  	}
>  }
> diff --git a/drivers/net/team/team_mode_loadbalance.c b/drivers/net/team/team_mode_loadbalance.c
> index dbde341..deef2c9 100644
> --- a/drivers/net/team/team_mode_loadbalance.c
> +++ b/drivers/net/team/team_mode_loadbalance.c
> @@ -97,7 +97,7 @@ static void lb_tx_hash_to_port_mapping_null_port(struct team *team,
>  
>  		pm = &lb_priv->ex->tx_hash_to_port_mapping[i];
>  		if (rcu_access_pointer(pm->port) == port) {
> -			RCU_INIT_POINTER(pm->port, NULL);
> +			rcu_init_pointer(pm->port, NULL);
>  			team_option_inst_set_change(pm->opt_inst_info);
>  			changed = true;
>  		}
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index ee328ba..ab06040 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -452,7 +452,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>  
>  		--tun->numqueues;
>  		if (clean) {
> -			RCU_INIT_POINTER(tfile->tun, NULL);
> +			rcu_init_pointer(tfile->tun, NULL);
>  			sock_put(&tfile->sk);
>  		} else
>  			tun_disable_queue(tun, tfile);
> @@ -499,12 +499,12 @@ static void tun_detach_all(struct net_device *dev)
>  		tfile = rtnl_dereference(tun->tfiles[i]);
>  		BUG_ON(!tfile);
>  		wake_up_all(&tfile->wq.wait);
> -		RCU_INIT_POINTER(tfile->tun, NULL);
> +		rcu_init_pointer(tfile->tun, NULL);
>  		--tun->numqueues;
>  	}
>  	list_for_each_entry(tfile, &tun->disabled, next) {
>  		wake_up_all(&tfile->wq.wait);
> -		RCU_INIT_POINTER(tfile->tun, NULL);
> +		rcu_init_pointer(tfile->tun, NULL);
>  	}
>  	BUG_ON(tun->numqueues != 0);
>  
> @@ -2194,7 +2194,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
>  					    &tun_proto);
>  	if (!tfile)
>  		return -ENOMEM;
> -	RCU_INIT_POINTER(tfile->tun, NULL);
> +	rcu_init_pointer(tfile->tun, NULL);
>  	tfile->net = get_net(current->nsproxy->net_ns);
>  	tfile->flags = 0;
>  	tfile->ifindex = 0;
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index b4a10bc..b8c026f 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -432,12 +432,12 @@ static void veth_dellink(struct net_device *dev, struct list_head *head)
>  	 * before a rcu_synchronize() point. The devices are guaranteed
>  	 * not being freed before one RCU grace period.
>  	 */
> -	RCU_INIT_POINTER(priv->peer, NULL);
> +	rcu_init_pointer(priv->peer, NULL);
>  	unregister_netdevice_queue(dev, head);
>  
>  	if (peer) {
>  		priv = netdev_priv(peer);
> -		RCU_INIT_POINTER(priv->peer, NULL);
> +		rcu_init_pointer(priv->peer, NULL);
>  		unregister_netdevice_queue(peer, head);
>  	}
>  }
> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> index 4c8cdb0..9ba9885 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -450,7 +450,7 @@ static void carl9170_op_stop(struct ieee80211_hw *hw)
>  
>  	mutex_lock(&ar->mutex);
>  	if (IS_ACCEPTING_CMD(ar)) {
> -		RCU_INIT_POINTER(ar->beacon_iter, NULL);
> +		rcu_init_pointer(ar->beacon_iter, NULL);
>  
>  		carl9170_led_set_state(ar, 0);
>  
> @@ -747,7 +747,7 @@ unlock:
>  		vif_priv->active = false;
>  		bitmap_release_region(&ar->vif_bitmap, vif_id, 0);
>  		ar->vifs--;
> -		RCU_INIT_POINTER(ar->vif_priv[vif_id].vif, NULL);
> +		rcu_init_pointer(ar->vif_priv[vif_id].vif, NULL);
>  		list_del_rcu(&vif_priv->list);
>  		mutex_unlock(&ar->mutex);
>  		synchronize_rcu();
> @@ -785,7 +785,7 @@ static void carl9170_op_remove_interface(struct ieee80211_hw *hw,
>  	WARN_ON(vif_priv->enable_beacon);
>  	vif_priv->enable_beacon = false;
>  	list_del_rcu(&vif_priv->list);
> -	RCU_INIT_POINTER(ar->vif_priv[id].vif, NULL);
> +	rcu_init_pointer(ar->vif_priv[id].vif, NULL);
>  
>  	if (vif == main_vif) {
>  		rcu_read_unlock();
> @@ -1333,7 +1333,7 @@ static int carl9170_op_sta_add(struct ieee80211_hw *hw,
>  		}
>  
>  		for (i = 0; i < ARRAY_SIZE(sta_info->agg); i++)
> -			RCU_INIT_POINTER(sta_info->agg[i], NULL);
> +			rcu_init_pointer(sta_info->agg[i], NULL);
>  
>  		sta_info->ampdu_max_len = 1 << (3 + sta->ht_cap.ampdu_factor);
>  		sta_info->ht_sta = true;
> @@ -1360,7 +1360,7 @@ static int carl9170_op_sta_remove(struct ieee80211_hw *hw,
>  			struct carl9170_sta_tid *tid_info;
>  
>  			tid_info = rcu_dereference(sta_info->agg[i]);
> -			RCU_INIT_POINTER(sta_info->agg[i], NULL);
> +			rcu_init_pointer(sta_info->agg[i], NULL);
>  
>  			if (!tid_info)
>  				continue;
> @@ -1477,7 +1477,7 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
>  			spin_unlock_bh(&ar->tx_ampdu_list_lock);
>  		}
>  
> -		RCU_INIT_POINTER(sta_info->agg[tid], NULL);
> +		rcu_init_pointer(sta_info->agg[tid], NULL);
>  		rcu_read_unlock();
>  
>  		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
> diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
> index 7ce2006..751abf0 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/fw.c
> +++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
> @@ -443,7 +443,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
>  
>  	/* init the fw <-> mac80211 STA mapping */
>  	for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
> -		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
> +		rcu_init_pointer(mvm->fw_id_to_mac_id[i], NULL);
>  
>  	/* Add auxiliary station for scanning */
>  	ret = iwl_mvm_add_aux_sta(mvm);
> @@ -520,7 +520,7 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm)
>  
>  	/* init the fw <-> mac80211 STA mapping */
>  	for (i = 0; i < IWL_MVM_STATION_COUNT; i++)
> -		RCU_INIT_POINTER(mvm->fw_id_to_mac_id[i], NULL);
> +		rcu_init_pointer(mvm->fw_id_to_mac_id[i], NULL);
>  
>  	/* Add auxiliary station for scanning */
>  	ret = iwl_mvm_add_aux_sta(mvm);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 78987e4..92d3fbc 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -419,7 +419,7 @@ void vhost_dev_reset_owner(struct vhost_dev *dev, struct vhost_memory *memory)
>  
>  	/* Restore memory to default empty mapping. */
>  	memory->nregions = 0;
> -	RCU_INIT_POINTER(dev->memory, memory);
> +	rcu_init_pointer(dev->memory, memory);
>  }
>  EXPORT_SYMBOL_GPL(vhost_dev_reset_owner);
>  
> @@ -465,7 +465,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev, bool locked)
>  	kfree(rcu_dereference_protected(dev->memory,
>  					locked ==
>  						lockdep_is_held(&dev->mutex)));
> -	RCU_INIT_POINTER(dev->memory, NULL);
> +	rcu_init_pointer(dev->memory, NULL);
>  	WARN_ON(!list_empty(&dev->work_list));
>  	if (dev->worker) {
>  		kthread_stop(dev->worker);
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index af90312..bc52fb8 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1250,7 +1250,7 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
>  {
>  	struct wakeup_source *ws = ep_wakeup_source(epi);
>  
> -	RCU_INIT_POINTER(epi->ws, NULL);
> +	rcu_init_pointer(epi->ws, NULL);
>  
>  	/*
>  	 * wait for ep_pm_stay_awake_rcu to finish, synchronize_rcu is
> @@ -1293,7 +1293,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
>  		if (error)
>  			goto error_create_wakeup_source;
>  	} else {
> -		RCU_INIT_POINTER(epi->ws, NULL);
> +		rcu_init_pointer(epi->ws, NULL);
>  	}
>  
>  	/* Initialize the poll table using the queue callback */
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 0adbc02..a8734e0 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -47,7 +47,7 @@ static void proc_evict_inode(struct inode *inode)
>  		pde_put(de);
>  	head = PROC_I(inode)->sysctl;
>  	if (head) {
> -		RCU_INIT_POINTER(PROC_I(inode)->sysctl, NULL);
> +		rcu_init_pointer(PROC_I(inode)->sysctl, NULL);
>  		sysctl_head_put(head);
>  	}
>  	/* Release any associated namespace */
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 00a7fd6..d384392 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -566,13 +566,13 @@ static inline void rcu_preempt_sleep_check(void)
>   * assignment.  More importantly, this call documents which pointers
>   * will be dereferenced by RCU read-side code.
>   *
> - * In some special cases, you may use RCU_INIT_POINTER() instead
> - * of rcu_assign_pointer().  RCU_INIT_POINTER() is a bit faster due
> + * In some special cases, you may use rcu_init_pointer() instead
> + * of rcu_assign_pointer().  rcu_init_pointer() is a bit faster due
>   * to the fact that it does not constrain either the CPU or the compiler.
> - * That said, using RCU_INIT_POINTER() when you should have used
> + * That said, using rcu_init_pointer() when you should have used
>   * rcu_assign_pointer() is a very bad thing that results in
>   * impossible-to-diagnose memory corruption.  So please be careful.
> - * See the RCU_INIT_POINTER() comment header for details.
> + * See the rcu_init_pointer() comment header for details.
>   *
>   * Note that rcu_assign_pointer() evaluates each of its arguments only
>   * once, appearances notwithstanding.  One of the "extra" evaluations
> @@ -919,13 +919,13 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>  }
>  
>  /**
> - * RCU_INIT_POINTER() - initialize an RCU protected pointer
> + * rcu_init_pointer() - initialize an RCU protected pointer
>   *
>   * Initialize an RCU-protected pointer in special cases where readers
>   * do not need ordering constraints on the CPU or the compiler.  These
>   * special cases are:
>   *
> - * 1.	This use of RCU_INIT_POINTER() is NULLing out the pointer -or-
> + * 1.	This use of rcu_init_pointer() is NULLing out the pointer -or-
>   * 2.	The caller has taken whatever steps are required to prevent
>   *	RCU readers from concurrently accessing this pointer -or-
>   * 3.	The referenced data structure has already been exposed to
> @@ -937,20 +937,20 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
>   *		example, the changes were to statistical counters or to
>   *		other state where exact synchronization is not required.)
>   *
> - * Failure to follow these rules governing use of RCU_INIT_POINTER() will
> + * Failure to follow these rules governing use of rcu_init_pointer() will
>   * result in impossible-to-diagnose memory corruption.  As in the structures
>   * will look OK in crash dumps, but any concurrent RCU readers might
>   * see pre-initialized values of the referenced data structure.  So
> - * please be very careful how you use RCU_INIT_POINTER()!!!
> + * please be very careful how you use rcu_init_pointer()!!!
>   *
>   * If you are creating an RCU-protected linked structure that is accessed
>   * by a single external-to-structure RCU-protected pointer, then you may
> - * use RCU_INIT_POINTER() to initialize the internal RCU-protected
> + * use rcu_init_pointer() to initialize the internal RCU-protected
>   * pointers, but you must use rcu_assign_pointer() to initialize the
>   * external-to-structure pointer -after- you have completely initialized
>   * the reader-accessible portions of the linked structure.
>   */
> -#define RCU_INIT_POINTER(p, v) \
> +#define rcu_init_pointer(p, v) \
>  	do { \
>  		p = RCU_INITIALIZER(v); \
>  	} while (0)
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7c28936..f5bf565 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1102,7 +1102,7 @@ static void __net_exit audit_net_exit(struct net *net)
>  		audit_sock = NULL;
>  	}
>  
> -	RCU_INIT_POINTER(aunet->nlsk, NULL);
> +	rcu_init_pointer(aunet->nlsk, NULL);
>  	synchronize_net();
>  	netlink_kernel_release(sock);
>  }
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 9fcdaa7..252320b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1045,7 +1045,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
>  
>  		WARN_ON(!css || cgroup_css(&dst_root->cgrp, ss));
>  
> -		RCU_INIT_POINTER(src_root->cgrp.subsys[ssid], NULL);
> +		rcu_init_pointer(src_root->cgrp.subsys[ssid], NULL);
>  		rcu_assign_pointer(dst_root->cgrp.subsys[ssid], css);
>  		ss->root = dst_root;
>  		css->cgroup = &dst_root->cgrp;
> @@ -3567,7 +3567,7 @@ static void css_release(struct percpu_ref *ref)
>  	struct cgroup_subsys_state *css =
>  		container_of(ref, struct cgroup_subsys_state, refcnt);
>  
> -	RCU_INIT_POINTER(css->cgroup->subsys[css->ss->id], NULL);
> +	rcu_init_pointer(css->cgroup->subsys[css->ss->id], NULL);
>  	call_rcu(&css->rcu_head, css_free_rcu_fn);
>  }
>  
> @@ -3621,7 +3621,7 @@ static void offline_css(struct cgroup_subsys_state *css)
>  
>  	css->flags &= ~CSS_ONLINE;
>  	css->cgroup->nr_css--;
> -	RCU_INIT_POINTER(css->cgroup->subsys[ss->id], css);
> +	rcu_init_pointer(css->cgroup->subsys[ss->id], css);
>  }
>  
>  /**
> @@ -4044,7 +4044,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>  	 * after all files under it have been removed.
>  	 */
>  	kernfs_remove(cgrp->kn);	/* @cgrp has an extra ref on its kn */
> -	RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
> +	rcu_init_pointer(*(void __rcu __force **)&cgrp->kn->priv, NULL);
>  
>  	mutex_lock(&cgroup_mutex);
>  
> @@ -4169,7 +4169,7 @@ int __init cgroup_init_early(void)
>  	int i;
>  
>  	init_cgroup_root(&cgrp_dfl_root, &opts);
> -	RCU_INIT_POINTER(init_task.cgroups, &init_css_set);
> +	rcu_init_pointer(init_task.cgroups, &init_css_set);
>  
>  	for_each_subsys(ss, i) {
>  		WARN(!ss->css_alloc || !ss->css_free || ss->name || ss->id,
> @@ -4377,7 +4377,7 @@ static const struct file_operations proc_cgroupstats_operations = {
>   */
>  void cgroup_fork(struct task_struct *child)
>  {
> -	RCU_INIT_POINTER(child->cgroups, &init_css_set);
> +	rcu_init_pointer(child->cgroups, &init_css_set);
>  	INIT_LIST_HEAD(&child->cg_list);
>  }
>  
> @@ -4481,7 +4481,7 @@ void cgroup_exit(struct task_struct *tsk)
>  
>  	/* Reassign the task to the init_css_set. */
>  	cset = task_css_set(tsk);
> -	RCU_INIT_POINTER(tsk->cgroups, &init_css_set);
> +	rcu_init_pointer(tsk->cgroups, &init_css_set);
>  
>  	if (need_forkexit_callback) {
>  		/* see cgroup_post_fork() for details */
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 8a86319..93b0d89 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -1708,9 +1708,9 @@ static inline void event_clear_filter(struct ftrace_event_file *file)
>  	struct ftrace_event_call *call = file->event_call;
>  
>  	if (call->flags & TRACE_EVENT_FL_USE_CALL_FILTER)
> -		RCU_INIT_POINTER(call->filter, NULL);
> +		rcu_init_pointer(call->filter, NULL);
>  	else
> -		RCU_INIT_POINTER(file->filter, NULL);
> +		rcu_init_pointer(file->filter, NULL);
>  }
>  
>  static inline void
> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
> index 925f537..07dc2eb 100644
> --- a/kernel/trace/trace_events_trigger.c
> +++ b/kernel/trace/trace_events_trigger.c
> @@ -1212,7 +1212,7 @@ event_enable_trigger_func(struct event_command *cmd_ops,
>  	trigger_data->ops = trigger_ops;
>  	trigger_data->cmd_ops = cmd_ops;
>  	INIT_LIST_HEAD(&trigger_data->list);
> -	RCU_INIT_POINTER(trigger_data->filter, NULL);
> +	rcu_init_pointer(trigger_data->filter, NULL);
>  
>  	enable_data->enable = enable;
>  	enable_data->file = event_enable_file;
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 0ee63af..3c897f5 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4343,7 +4343,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
>  		 */
>  		for_each_node(node) {
>  			pwq = rcu_access_pointer(wq->numa_pwq_tbl[node]);
> -			RCU_INIT_POINTER(wq->numa_pwq_tbl[node], NULL);
> +			rcu_init_pointer(wq->numa_pwq_tbl[node], NULL);
>  			put_pwq_unlocked(pwq);
>  		}
>  
> diff --git a/lib/idr.c b/lib/idr.c
> index 2642fa8..b885650 100644
> --- a/lib/idr.c
> +++ b/lib/idr.c
> @@ -152,7 +152,7 @@ static void idr_layer_rcu_free(struct rcu_head *head)
>  static inline void free_layer(struct idr *idr, struct idr_layer *p)
>  {
>  	if (idr->hint && idr->hint == p)
> -		RCU_INIT_POINTER(idr->hint, NULL);
> +		rcu_init_pointer(idr->hint, NULL);
>  	call_rcu(&p->rcu_head, idr_layer_rcu_free);
>  }
>  
> @@ -533,7 +533,7 @@ static void sub_remove(struct idr *idp, int shift, int id)
>  	n = id & IDR_MASK;
>  	if (likely(p != NULL && test_bit(n, p->bitmap))) {
>  		__clear_bit(n, p->bitmap);
> -		RCU_INIT_POINTER(p->ary[n], NULL);
> +		rcu_init_pointer(p->ary[n], NULL);
>  		to_free = NULL;
>  		while(*paa && ! --((**paa)->count)){
>  			if (to_free)
> @@ -602,7 +602,7 @@ static void __idr_remove_all(struct idr *idp)
>  
>  	n = idp->layers * IDR_BITS;
>  	p = idp->top;
> -	RCU_INIT_POINTER(idp->top, NULL);
> +	rcu_init_pointer(idp->top, NULL);
>  	max = idr_max(idp->layers);
>  
>  	id = 0;
> diff --git a/net/802/garp.c b/net/802/garp.c
> index b38ee6d..4bc98ac 100644
> --- a/net/802/garp.c
> +++ b/net/802/garp.c
> @@ -552,7 +552,7 @@ static void garp_release_port(struct net_device *dev)
>  		if (rtnl_dereference(port->applicants[i]))
>  			return;
>  	}
> -	RCU_INIT_POINTER(dev->garp_port, NULL);
> +	rcu_init_pointer(dev->garp_port, NULL);
>  	kfree_rcu(port, rcu);
>  }
>  
> @@ -604,7 +604,7 @@ void garp_uninit_applicant(struct net_device *dev, struct garp_application *appl
>  
>  	ASSERT_RTNL();
>  
> -	RCU_INIT_POINTER(port->applicants[appl->type], NULL);
> +	rcu_init_pointer(port->applicants[appl->type], NULL);
>  
>  	/* Delete timer and generate a final TRANSMIT_PDU event to flush out
>  	 * all pending messages before the applicant is gone. */
> diff --git a/net/802/mrp.c b/net/802/mrp.c
> index 72db278..e57b50e 100644
> --- a/net/802/mrp.c
> +++ b/net/802/mrp.c
> @@ -834,7 +834,7 @@ static void mrp_release_port(struct net_device *dev)
>  		if (rtnl_dereference(port->applicants[i]))
>  			return;
>  	}
> -	RCU_INIT_POINTER(dev->mrp_port, NULL);
> +	rcu_init_pointer(dev->mrp_port, NULL);
>  	kfree_rcu(port, rcu);
>  }
>  
> @@ -890,7 +890,7 @@ void mrp_uninit_applicant(struct net_device *dev, struct mrp_application *appl)
>  
>  	ASSERT_RTNL();
>  
> -	RCU_INIT_POINTER(port->applicants[appl->type], NULL);
> +	rcu_init_pointer(port->applicants[appl->type], NULL);
>  
>  	/* Delete timer and generate a final TX event to flush out
>  	 * all pending messages before the applicant is gone.
> diff --git a/net/802/stp.c b/net/802/stp.c
> index 2c40ba0..75c1a32 100644
> --- a/net/802/stp.c
> +++ b/net/802/stp.c
> @@ -89,9 +89,9 @@ void stp_proto_unregister(const struct stp_proto *proto)
>  {
>  	mutex_lock(&stp_proto_mutex);
>  	if (is_zero_ether_addr(proto->group_address))
> -		RCU_INIT_POINTER(stp_proto, NULL);
> +		rcu_init_pointer(stp_proto, NULL);
>  	else
> -		RCU_INIT_POINTER(garp_protos[proto->group_address[5] -
> +		rcu_init_pointer(garp_protos[proto->group_address[5] -
>  					       GARP_ADDR_MIN], NULL);
>  	synchronize_rcu();
>  
> diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
> index 3c32bd2..252d777 100644
> --- a/net/8021q/vlan_core.c
> +++ b/net/8021q/vlan_core.c
> @@ -343,7 +343,7 @@ void vlan_vid_del(struct net_device *dev, __be16 proto, u16 vid)
>  	if (vid_info->refcount == 0) {
>  		__vlan_vid_del(vlan_info, vid_info);
>  		if (vlan_info->nr_vids == 0) {
> -			RCU_INIT_POINTER(dev->vlan_info, NULL);
> +			rcu_init_pointer(dev->vlan_info, NULL);
>  			call_rcu(&vlan_info->rcu, vlan_info_rcu_free);
>  		}
>  	}
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 4a37161..99ffd42 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -99,9 +99,9 @@ static int __vlan_del(struct net_port_vlans *v, u16 vid)
>  	v->num_vlans--;
>  	if (bitmap_empty(v->vlan_bitmap, VLAN_N_VID)) {
>  		if (v->port_idx)
> -			RCU_INIT_POINTER(v->parent.port->vlan_info, NULL);
> +			rcu_init_pointer(v->parent.port->vlan_info, NULL);
>  		else
> -			RCU_INIT_POINTER(v->parent.br->vlan_info, NULL);
> +			rcu_init_pointer(v->parent.br->vlan_info, NULL);
>  		kfree_rcu(v, rcu);
>  	}
>  	return 0;
> @@ -113,9 +113,9 @@ static void __vlan_flush(struct net_port_vlans *v)
>  	v->pvid = 0;
>  	bitmap_zero(v->vlan_bitmap, VLAN_N_VID);
>  	if (v->port_idx)
> -		RCU_INIT_POINTER(v->parent.port->vlan_info, NULL);
> +		rcu_init_pointer(v->parent.port->vlan_info, NULL);
>  	else
> -		RCU_INIT_POINTER(v->parent.br->vlan_info, NULL);
> +		rcu_init_pointer(v->parent.br->vlan_info, NULL);
>  	kfree_rcu(v, rcu);
>  }
>  
> diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
> index d2cdf5d..13445ac 100644
> --- a/net/bridge/netfilter/ebtable_broute.c
> +++ b/net/bridge/netfilter/ebtable_broute.c
> @@ -83,14 +83,14 @@ static int __init ebtable_broute_init(void)
>  	if (ret < 0)
>  		return ret;
>  	/* see br_input.c */
> -	RCU_INIT_POINTER(br_should_route_hook,
> +	rcu_init_pointer(br_should_route_hook,
>  			   (br_should_route_hook_t *)ebt_broute);
>  	return 0;
>  }
>  
>  static void __exit ebtable_broute_fini(void)
>  {
> -	RCU_INIT_POINTER(br_should_route_hook, NULL);
> +	rcu_init_pointer(br_should_route_hook, NULL);
>  	synchronize_net();
>  	unregister_pernet_subsys(&broute_net_ops);
>  }
> diff --git a/net/caif/cfmuxl.c b/net/caif/cfmuxl.c
> index 8c5d638..15d5d6d 100644
> --- a/net/caif/cfmuxl.c
> +++ b/net/caif/cfmuxl.c
> @@ -108,7 +108,7 @@ struct cflayer *cfmuxl_remove_dnlayer(struct cflayer *layr, u8 phyid)
>  	int idx = phyid % DN_CACHE_SIZE;
>  
>  	spin_lock_bh(&muxl->transmit_lock);
> -	RCU_INIT_POINTER(muxl->dn_cache[idx], NULL);
> +	rcu_init_pointer(muxl->dn_cache[idx], NULL);
>  	dn = get_from_id(&muxl->frml_list, phyid);
>  	if (dn == NULL)
>  		goto out;
> @@ -164,7 +164,7 @@ struct cflayer *cfmuxl_remove_uplayer(struct cflayer *layr, u8 id)
>  	if (up == NULL)
>  		goto out;
>  
> -	RCU_INIT_POINTER(muxl->up_cache[idx], NULL);
> +	rcu_init_pointer(muxl->up_cache[idx], NULL);
>  	list_del_rcu(&up->node);
>  out:
>  	spin_unlock_bh(&muxl->receive_lock);
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index a27f8aa..8df0f52 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -761,7 +761,7 @@ int can_proto_register(const struct can_proto *cp)
>  		pr_err("can: protocol %d already registered\n", proto);
>  		err = -EBUSY;
>  	} else
> -		RCU_INIT_POINTER(proto_tab[proto], cp);
> +		rcu_init_pointer(proto_tab[proto], cp);
>  
>  	mutex_unlock(&proto_tab_lock);
>  
> @@ -782,7 +782,7 @@ void can_proto_unregister(const struct can_proto *cp)
>  
>  	mutex_lock(&proto_tab_lock);
>  	BUG_ON(proto_tab[proto] != cp);
> -	RCU_INIT_POINTER(proto_tab[proto], NULL);
> +	rcu_init_pointer(proto_tab[proto], NULL);
>  	mutex_unlock(&proto_tab_lock);
>  
>  	synchronize_rcu();
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d2c8a06..a0a93bd 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1836,7 +1836,7 @@ static struct xps_map *remove_xps_queue(struct xps_dev_maps *dev_maps,
>  			if (map->len > 1) {
>  				map->queues[pos] = map->queues[--map->len];
>  			} else {
> -				RCU_INIT_POINTER(dev_maps->cpu_map[cpu], NULL);
> +				rcu_init_pointer(dev_maps->cpu_map[cpu], NULL);
>  				kfree_rcu(map, rcu);
>  				map = NULL;
>  			}
> @@ -1869,7 +1869,7 @@ static void netif_reset_xps_queues_gt(struct net_device *dev, u16 index)
>  	}
>  
>  	if (!active) {
> -		RCU_INIT_POINTER(dev->xps_maps, NULL);
> +		rcu_init_pointer(dev->xps_maps, NULL);
>  		kfree_rcu(dev_maps, rcu);
>  	}
>  
> @@ -1948,7 +1948,7 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
>  		if (!map)
>  			goto error;
>  
> -		RCU_INIT_POINTER(new_dev_maps->cpu_map[cpu], map);
> +		rcu_init_pointer(new_dev_maps->cpu_map[cpu], map);
>  	}
>  
>  	if (!new_dev_maps)
> @@ -1974,7 +1974,7 @@ int netif_set_xps_queue(struct net_device *dev, const struct cpumask *mask,
>  		} else if (dev_maps) {
>  			/* fill in the new device map from the old device map */
>  			map = xmap_dereference(dev_maps->cpu_map[cpu]);
> -			RCU_INIT_POINTER(new_dev_maps->cpu_map[cpu], map);
> +			rcu_init_pointer(new_dev_maps->cpu_map[cpu], map);
>  		}
>  
>  	}
> @@ -2016,7 +2016,7 @@ out_no_new_maps:
>  
>  	/* free map if not active */
>  	if (!active) {
> -		RCU_INIT_POINTER(dev->xps_maps, NULL);
> +		rcu_init_pointer(dev->xps_maps, NULL);
>  		kfree_rcu(dev_maps, rcu);
>  	}
>  
> @@ -3476,13 +3476,13 @@ void netdev_rx_handler_unregister(struct net_device *dev)
>  {
>  
>  	ASSERT_RTNL();
> -	RCU_INIT_POINTER(dev->rx_handler, NULL);
> +	rcu_init_pointer(dev->rx_handler, NULL);
>  	/* a reader seeing a non NULL rx_handler in a rcu_read_lock()
>  	 * section has a guarantee to see a non NULL rx_handler_data
>  	 * as well.
>  	 */
>  	synchronize_net();
> -	RCU_INIT_POINTER(dev->rx_handler_data, NULL);
> +	rcu_init_pointer(dev->rx_handler_data, NULL);
>  }
>  EXPORT_SYMBOL_GPL(netdev_rx_handler_unregister);
>  
> diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
> index 185c341..e11fc01 100644
> --- a/net/core/fib_rules.c
> +++ b/net/core/fib_rules.c
> @@ -368,7 +368,7 @@ static int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr* nlh)
>  
>  		list_for_each_entry(r, &ops->rules_list, list) {
>  			if (r->pref == rule->target) {
> -				RCU_INIT_POINTER(rule->ctarget, r);
> +				rcu_init_pointer(rule->ctarget, r);
>  				break;
>  			}
>  		}
> @@ -509,7 +509,7 @@ static int fib_nl_delrule(struct sk_buff *skb, struct nlmsghdr* nlh)
>  		if (ops->nr_goto_rules > 0) {
>  			list_for_each_entry(tmp, &ops->rules_list, list) {
>  				if (rtnl_dereference(tmp->ctarget) == rule) {
> -					RCU_INIT_POINTER(tmp->ctarget, NULL);
> +					rcu_init_pointer(tmp->ctarget, NULL);
>  					ops->unresolved_rules++;
>  				}
>  			}
> diff --git a/net/core/filter.c b/net/core/filter.c
> index cd58614..cb9125d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -1697,7 +1697,7 @@ int sk_detach_filter(struct sock *sk)
>  	filter = rcu_dereference_protected(sk->sk_filter,
>  					   sock_owned_by_user(sk));
>  	if (filter) {
> -		RCU_INIT_POINTER(sk->sk_filter, NULL);
> +		rcu_init_pointer(sk->sk_filter, NULL);
>  		sk_filter_uncharge(sk, filter);
>  		ret = 0;
>  	}
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 8f8a96e..73d7640 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1550,7 +1550,7 @@ static void neigh_table_init_no_netlink(struct neigh_table *tbl)
>  		panic("cannot create neighbour proc dir entry");
>  #endif
>  
> -	RCU_INIT_POINTER(tbl->nht, neigh_hash_alloc(3));
> +	rcu_init_pointer(tbl->nht, neigh_hash_alloc(3));
>  
>  	phsize = (PNEIGH_HASHMASK + 1) * sizeof(struct pneigh_entry *);
>  	tbl->phash_buckets = kzalloc(phsize, GFP_KERNEL);
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 1cac29e..cbbf952 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -742,13 +742,13 @@ static void rx_queue_release(struct kobject *kobj)
>  
>  	map = rcu_dereference_protected(queue->rps_map, 1);
>  	if (map) {
> -		RCU_INIT_POINTER(queue->rps_map, NULL);
> +		rcu_init_pointer(queue->rps_map, NULL);
>  		kfree_rcu(map, rcu);
>  	}
>  
>  	flow_table = rcu_dereference_protected(queue->rps_flow_table, 1);
>  	if (flow_table) {
> -		RCU_INIT_POINTER(queue->rps_flow_table, NULL);
> +		rcu_init_pointer(queue->rps_flow_table, NULL);
>  		call_rcu(&flow_table->rcu, rps_dev_flow_table_release);
>  	}
>  #endif
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index e33937f..496ba90 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -820,7 +820,7 @@ void __netpoll_cleanup(struct netpoll *np)
>  		if (ops->ndo_netpoll_cleanup)
>  			ops->ndo_netpoll_cleanup(np->dev);
>  
> -		RCU_INIT_POINTER(np->dev->npinfo, NULL);
> +		rcu_init_pointer(np->dev->npinfo, NULL);
>  		call_rcu_bh(&npinfo->rcu, rcu_cleanup_netpoll_info);
>  	}
>  }
> diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
> index 3825f66..15c63ac 100644
> --- a/net/core/netprio_cgroup.c
> +++ b/net/core/netprio_cgroup.c
> @@ -266,7 +266,7 @@ static int netprio_device_event(struct notifier_block *unused,
>  	switch (event) {
>  	case NETDEV_UNREGISTER:
>  		old = rtnl_dereference(dev->priomap);
> -		RCU_INIT_POINTER(dev->priomap, NULL);
> +		rcu_init_pointer(dev->priomap, NULL);
>  		if (old)
>  			kfree_rcu(old, rcu);
>  		break;
> diff --git a/net/core/sock.c b/net/core/sock.c
> index b4fff00..ea565ba 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -481,7 +481,7 @@ struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie)
>  
>  	if (dst && dst->obsolete && dst->ops->check(dst, cookie) == NULL) {
>  		sk_tx_queue_clear(sk);
> -		RCU_INIT_POINTER(sk->sk_dst_cache, NULL);
> +		rcu_init_pointer(sk->sk_dst_cache, NULL);
>  		dst_release(dst);
>  		return NULL;
>  	}
> @@ -1365,7 +1365,7 @@ static void __sk_free(struct sock *sk)
>  				       atomic_read(&sk->sk_wmem_alloc) == 0);
>  	if (filter) {
>  		sk_filter_uncharge(sk, filter);
> -		RCU_INIT_POINTER(sk->sk_filter, NULL);
> +		rcu_init_pointer(sk->sk_filter, NULL);
>  	}
>  
>  	sock_disable_timestamp(sk, SK_FLAGS_TIMESTAMP);
> diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
> index cf9cd13..f3016f9 100644
> --- a/net/core/sysctl_net_core.c
> +++ b/net/core/sysctl_net_core.c
> @@ -118,7 +118,7 @@ static int flow_limit_cpu_sysctl(struct ctl_table *table, int write,
>  			cur = rcu_dereference_protected(sd->flow_limit,
>  				     lockdep_is_held(&flow_limit_update_mutex));
>  			if (cur && !cpumask_test_cpu(i, mask)) {
> -				RCU_INIT_POINTER(sd->flow_limit, NULL);
> +				rcu_init_pointer(sd->flow_limit, NULL);
>  				synchronize_rcu();
>  				kfree(cur);
>  			} else if (!cur && cpumask_test_cpu(i, mask)) {
> diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
> index a603823..1680884 100644
> --- a/net/decnet/dn_dev.c
> +++ b/net/decnet/dn_dev.c
> @@ -1100,7 +1100,7 @@ static struct dn_dev *dn_dev_create(struct net_device *dev, int *err)
>  
>  	dn_db->neigh_parms = neigh_parms_alloc(dev, &dn_neigh_table);
>  	if (!dn_db->neigh_parms) {
> -		RCU_INIT_POINTER(dev->dn_ptr, NULL);
> +		rcu_init_pointer(dev->dn_ptr, NULL);
>  		kfree(dn_db);
>  		return NULL;
>  	}
> diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
> index daccc4a..42d4bf0 100644
> --- a/net/decnet/dn_route.c
> +++ b/net/decnet/dn_route.c
> @@ -380,7 +380,7 @@ static void dn_run_flush(unsigned long dummy)
>  
>  		for(; rt; rt = next) {
>  			next = rcu_dereference_raw(rt->dst.dn_next);
> -			RCU_INIT_POINTER(rt->dst.dn_next, NULL);
> +			rcu_init_pointer(rt->dst.dn_next, NULL);
>  			dst_free((struct dst_entry *)rt);
>  		}
>  
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index bdbf68b..5e2891c 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -294,7 +294,7 @@ static void inetdev_destroy(struct in_device *in_dev)
>  		inet_free_ifa(ifa);
>  	}
>  
> -	RCU_INIT_POINTER(dev->ip_ptr, NULL);
> +	rcu_init_pointer(dev->ip_ptr, NULL);
>  
>  	devinet_sysctl_unregister(in_dev);
>  	neigh_parms_release(&arp_tbl, in_dev->arp_parms);
> @@ -1367,7 +1367,7 @@ static int inetdev_event(struct notifier_block *this, unsigned long event,
>  	switch (event) {
>  	case NETDEV_REGISTER:
>  		pr_debug("%s: bug\n", __func__);
> -		RCU_INIT_POINTER(dev->ip_ptr, NULL);
> +		rcu_init_pointer(dev->ip_ptr, NULL);
>  		break;
>  	case NETDEV_UP:
>  		if (!inetdev_valid_mtu(dev->mtu))
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 8a043f0..aadbeda 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -147,7 +147,7 @@ static void rt_fibinfo_free(struct rtable __rcu **rtp)
>  	if (!rt)
>  		return;
>  
> -	/* Not even needed : RCU_INIT_POINTER(*rtp, NULL);
> +	/* Not even needed : rcu_init_pointer(*rtp, NULL);
>  	 * because we waited an RCU grace period before calling
>  	 * free_fib_info_rcu()
>  	 */
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index 5afeb5a..b632346 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -1602,7 +1602,7 @@ static void trie_leaf_remove(struct trie *t, struct leaf *l)
>  		put_child(tp, cindex, NULL);
>  		trie_rebalance(t, tp);
>  	} else
> -		RCU_INIT_POINTER(t->trie, NULL);
> +		rcu_init_pointer(t->trie, NULL);
>  
>  	free_leaf(l);
>  }
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 97e4d16..54122f1 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -1276,7 +1276,7 @@ static void ip_mc_hash_add(struct in_device *in_dev,
>  	for_each_pmc_rtnl(in_dev, im) {
>  		hash = ip_mc_hash(im);
>  		im->next_hash = mc_hash[hash];
> -		RCU_INIT_POINTER(mc_hash[hash], im);
> +		rcu_init_pointer(mc_hash[hash], im);
>  	}
>  
>  	rcu_assign_pointer(in_dev->mc_hash, mc_hash);
> @@ -1928,7 +1928,7 @@ static int ip_mc_leave_src(struct sock *sk, struct ip_mc_socklist *iml,
>  	}
>  	err = ip_mc_del_src(in_dev, &iml->multi.imr_multiaddr.s_addr,
>  			iml->sfmode, psf->sl_count, psf->sl_addr, 0);
> -	RCU_INIT_POINTER(iml->sflist, NULL);
> +	rcu_init_pointer(iml->sflist, NULL);
>  	/* decrease mem now to avoid the memleak warning */
>  	atomic_sub(IP_SFLSIZE(psf->sl_max), &sk->sk_omem_alloc);
>  	kfree_rcu(psf, rcu);
> diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
> index 48f4244..3983400 100644
> --- a/net/ipv4/inetpeer.c
> +++ b/net/ipv4/inetpeer.c
> @@ -309,26 +309,26 @@ static void peer_avl_rebalance(struct inet_peer __rcu **stack[],
>  			lr = rcu_deref_locked(l->avl_right, base);
>  			lrh = node_height(lr);
>  			if (lrh <= node_height(ll)) {	/* ll: RH+1 */
> -				RCU_INIT_POINTER(node->avl_left, lr);	/* lr: RH or RH+1 */
> -				RCU_INIT_POINTER(node->avl_right, r);	/* r: RH */
> +				rcu_init_pointer(node->avl_left, lr);	/* lr: RH or RH+1 */
> +				rcu_init_pointer(node->avl_right, r);	/* r: RH */
>  				node->avl_height = lrh + 1; /* RH+1 or RH+2 */
> -				RCU_INIT_POINTER(l->avl_left, ll);       /* ll: RH+1 */
> -				RCU_INIT_POINTER(l->avl_right, node);	/* node: RH+1 or RH+2 */
> +				rcu_init_pointer(l->avl_left, ll);       /* ll: RH+1 */
> +				rcu_init_pointer(l->avl_right, node);	/* node: RH+1 or RH+2 */
>  				l->avl_height = node->avl_height + 1;
> -				RCU_INIT_POINTER(*nodep, l);
> +				rcu_init_pointer(*nodep, l);
>  			} else { /* ll: RH, lr: RH+1 */
>  				lrl = rcu_deref_locked(lr->avl_left, base);/* lrl: RH or RH-1 */
>  				lrr = rcu_deref_locked(lr->avl_right, base);/* lrr: RH or RH-1 */
> -				RCU_INIT_POINTER(node->avl_left, lrr);	/* lrr: RH or RH-1 */
> -				RCU_INIT_POINTER(node->avl_right, r);	/* r: RH */
> +				rcu_init_pointer(node->avl_left, lrr);	/* lrr: RH or RH-1 */
> +				rcu_init_pointer(node->avl_right, r);	/* r: RH */
>  				node->avl_height = rh + 1; /* node: RH+1 */
> -				RCU_INIT_POINTER(l->avl_left, ll);	/* ll: RH */
> -				RCU_INIT_POINTER(l->avl_right, lrl);	/* lrl: RH or RH-1 */
> +				rcu_init_pointer(l->avl_left, ll);	/* ll: RH */
> +				rcu_init_pointer(l->avl_right, lrl);	/* lrl: RH or RH-1 */
>  				l->avl_height = rh + 1;	/* l: RH+1 */
> -				RCU_INIT_POINTER(lr->avl_left, l);	/* l: RH+1 */
> -				RCU_INIT_POINTER(lr->avl_right, node);	/* node: RH+1 */
> +				rcu_init_pointer(lr->avl_left, l);	/* l: RH+1 */
> +				rcu_init_pointer(lr->avl_right, node);	/* node: RH+1 */
>  				lr->avl_height = rh + 2;
> -				RCU_INIT_POINTER(*nodep, lr);
> +				rcu_init_pointer(*nodep, lr);
>  			}
>  		} else if (rh > lh + 1) { /* r: LH+2 */
>  			struct inet_peer *rr, *rl, *rlr, *rll;
> @@ -337,26 +337,26 @@ static void peer_avl_rebalance(struct inet_peer __rcu **stack[],
>  			rl = rcu_deref_locked(r->avl_left, base);
>  			rlh = node_height(rl);
>  			if (rlh <= node_height(rr)) {	/* rr: LH+1 */
> -				RCU_INIT_POINTER(node->avl_right, rl);	/* rl: LH or LH+1 */
> -				RCU_INIT_POINTER(node->avl_left, l);	/* l: LH */
> +				rcu_init_pointer(node->avl_right, rl);	/* rl: LH or LH+1 */
> +				rcu_init_pointer(node->avl_left, l);	/* l: LH */
>  				node->avl_height = rlh + 1; /* LH+1 or LH+2 */
> -				RCU_INIT_POINTER(r->avl_right, rr);	/* rr: LH+1 */
> -				RCU_INIT_POINTER(r->avl_left, node);	/* node: LH+1 or LH+2 */
> +				rcu_init_pointer(r->avl_right, rr);	/* rr: LH+1 */
> +				rcu_init_pointer(r->avl_left, node);	/* node: LH+1 or LH+2 */
>  				r->avl_height = node->avl_height + 1;
> -				RCU_INIT_POINTER(*nodep, r);
> +				rcu_init_pointer(*nodep, r);
>  			} else { /* rr: RH, rl: RH+1 */
>  				rlr = rcu_deref_locked(rl->avl_right, base);/* rlr: LH or LH-1 */
>  				rll = rcu_deref_locked(rl->avl_left, base);/* rll: LH or LH-1 */
> -				RCU_INIT_POINTER(node->avl_right, rll);	/* rll: LH or LH-1 */
> -				RCU_INIT_POINTER(node->avl_left, l);	/* l: LH */
> +				rcu_init_pointer(node->avl_right, rll);	/* rll: LH or LH-1 */
> +				rcu_init_pointer(node->avl_left, l);	/* l: LH */
>  				node->avl_height = lh + 1; /* node: LH+1 */
> -				RCU_INIT_POINTER(r->avl_right, rr);	/* rr: LH */
> -				RCU_INIT_POINTER(r->avl_left, rlr);	/* rlr: LH or LH-1 */
> +				rcu_init_pointer(r->avl_right, rr);	/* rr: LH */
> +				rcu_init_pointer(r->avl_left, rlr);	/* rlr: LH or LH-1 */
>  				r->avl_height = lh + 1;	/* r: LH+1 */
> -				RCU_INIT_POINTER(rl->avl_right, r);	/* r: LH+1 */
> -				RCU_INIT_POINTER(rl->avl_left, node);	/* node: LH+1 */
> +				rcu_init_pointer(rl->avl_right, r);	/* r: LH+1 */
> +				rcu_init_pointer(rl->avl_left, node);	/* node: LH+1 */
>  				rl->avl_height = lh + 2;
> -				RCU_INIT_POINTER(*nodep, rl);
> +				rcu_init_pointer(*nodep, rl);
>  			}
>  		} else {
>  			node->avl_height = (lh > rh ? lh : rh) + 1;
> @@ -400,7 +400,7 @@ static void unlink_from_pool(struct inet_peer *p, struct inet_peer_base *base,
>  		/* t is removed, t->daddr > x->daddr for any
>  		 * x in p->avl_left subtree.
>  		 * Put t in the old place of p. */
> -		RCU_INIT_POINTER(*delp[0], t);
> +		rcu_init_pointer(*delp[0], t);
>  		t->avl_left = p->avl_left;
>  		t->avl_right = p->avl_right;
>  		t->avl_height = p->avl_height;
> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
> index d84dc8d..19700ee 100644
> --- a/net/ipv4/ipmr.c
> +++ b/net/ipv4/ipmr.c
> @@ -1253,7 +1253,7 @@ static void mrtsock_destruct(struct sock *sk)
>  			inet_netconf_notify_devconf(net, NETCONFA_MC_FORWARDING,
>  						    NETCONFA_IFINDEX_ALL,
>  						    net->ipv4.devconf_all);
> -			RCU_INIT_POINTER(mrt->mroute_sk, NULL);
> +			rcu_init_pointer(mrt->mroute_sk, NULL);
>  			mroute_clean_tables(mrt);
>  		}
>  	}
> diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
> index 574f7eb..c927fb1 100644
> --- a/net/ipv4/netfilter/nf_nat_h323.c
> +++ b/net/ipv4/netfilter/nf_nat_h323.c
> @@ -590,15 +590,15 @@ static int __init init(void)
>  	BUG_ON(nat_callforwarding_hook != NULL);
>  	BUG_ON(nat_q931_hook != NULL);
>  
> -	RCU_INIT_POINTER(set_h245_addr_hook, set_h245_addr);
> -	RCU_INIT_POINTER(set_h225_addr_hook, set_h225_addr);
> -	RCU_INIT_POINTER(set_sig_addr_hook, set_sig_addr);
> -	RCU_INIT_POINTER(set_ras_addr_hook, set_ras_addr);
> -	RCU_INIT_POINTER(nat_rtp_rtcp_hook, nat_rtp_rtcp);
> -	RCU_INIT_POINTER(nat_t120_hook, nat_t120);
> -	RCU_INIT_POINTER(nat_h245_hook, nat_h245);
> -	RCU_INIT_POINTER(nat_callforwarding_hook, nat_callforwarding);
> -	RCU_INIT_POINTER(nat_q931_hook, nat_q931);
> +	rcu_init_pointer(set_h245_addr_hook, set_h245_addr);
> +	rcu_init_pointer(set_h225_addr_hook, set_h225_addr);
> +	rcu_init_pointer(set_sig_addr_hook, set_sig_addr);
> +	rcu_init_pointer(set_ras_addr_hook, set_ras_addr);
> +	rcu_init_pointer(nat_rtp_rtcp_hook, nat_rtp_rtcp);
> +	rcu_init_pointer(nat_t120_hook, nat_t120);
> +	rcu_init_pointer(nat_h245_hook, nat_h245);
> +	rcu_init_pointer(nat_callforwarding_hook, nat_callforwarding);
> +	rcu_init_pointer(nat_q931_hook, nat_q931);
>  	nf_ct_helper_expectfn_register(&q931_nat);
>  	nf_ct_helper_expectfn_register(&callforwarding_nat);
>  	return 0;
> @@ -607,15 +607,15 @@ static int __init init(void)
>  /****************************************************************************/
>  static void __exit fini(void)
>  {
> -	RCU_INIT_POINTER(set_h245_addr_hook, NULL);
> -	RCU_INIT_POINTER(set_h225_addr_hook, NULL);
> -	RCU_INIT_POINTER(set_sig_addr_hook, NULL);
> -	RCU_INIT_POINTER(set_ras_addr_hook, NULL);
> -	RCU_INIT_POINTER(nat_rtp_rtcp_hook, NULL);
> -	RCU_INIT_POINTER(nat_t120_hook, NULL);
> -	RCU_INIT_POINTER(nat_h245_hook, NULL);
> -	RCU_INIT_POINTER(nat_callforwarding_hook, NULL);
> -	RCU_INIT_POINTER(nat_q931_hook, NULL);
> +	rcu_init_pointer(set_h245_addr_hook, NULL);
> +	rcu_init_pointer(set_h225_addr_hook, NULL);
> +	rcu_init_pointer(set_sig_addr_hook, NULL);
> +	rcu_init_pointer(set_ras_addr_hook, NULL);
> +	rcu_init_pointer(nat_rtp_rtcp_hook, NULL);
> +	rcu_init_pointer(nat_t120_hook, NULL);
> +	rcu_init_pointer(nat_h245_hook, NULL);
> +	rcu_init_pointer(nat_callforwarding_hook, NULL);
> +	rcu_init_pointer(nat_q931_hook, NULL);
>  	nf_ct_helper_expectfn_unregister(&q931_nat);
>  	nf_ct_helper_expectfn_unregister(&callforwarding_nat);
>  	synchronize_rcu();
> diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
> index 657d230..63b58b2 100644
> --- a/net/ipv4/netfilter/nf_nat_pptp.c
> +++ b/net/ipv4/netfilter/nf_nat_pptp.c
> @@ -285,25 +285,25 @@ static int __init nf_nat_helper_pptp_init(void)
>  	nf_nat_need_gre();
>  
>  	BUG_ON(nf_nat_pptp_hook_outbound != NULL);
> -	RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
> +	rcu_init_pointer(nf_nat_pptp_hook_outbound, pptp_outbound_pkt);
>  
>  	BUG_ON(nf_nat_pptp_hook_inbound != NULL);
> -	RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
> +	rcu_init_pointer(nf_nat_pptp_hook_inbound, pptp_inbound_pkt);
>  
>  	BUG_ON(nf_nat_pptp_hook_exp_gre != NULL);
> -	RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
> +	rcu_init_pointer(nf_nat_pptp_hook_exp_gre, pptp_exp_gre);
>  
>  	BUG_ON(nf_nat_pptp_hook_expectfn != NULL);
> -	RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
> +	rcu_init_pointer(nf_nat_pptp_hook_expectfn, pptp_nat_expected);
>  	return 0;
>  }
>  
>  static void __exit nf_nat_helper_pptp_fini(void)
>  {
> -	RCU_INIT_POINTER(nf_nat_pptp_hook_expectfn, NULL);
> -	RCU_INIT_POINTER(nf_nat_pptp_hook_exp_gre, NULL);
> -	RCU_INIT_POINTER(nf_nat_pptp_hook_inbound, NULL);
> -	RCU_INIT_POINTER(nf_nat_pptp_hook_outbound, NULL);
> +	rcu_init_pointer(nf_nat_pptp_hook_expectfn, NULL);
> +	rcu_init_pointer(nf_nat_pptp_hook_exp_gre, NULL);
> +	rcu_init_pointer(nf_nat_pptp_hook_inbound, NULL);
> +	rcu_init_pointer(nf_nat_pptp_hook_outbound, NULL);
>  	synchronize_rcu();
>  }
>  
> diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
> index 7c67667..9b786d1 100644
> --- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
> +++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
> @@ -1291,7 +1291,7 @@ static int __init nf_nat_snmp_basic_init(void)
>  	int ret = 0;
>  
>  	BUG_ON(nf_nat_snmp_hook != NULL);
> -	RCU_INIT_POINTER(nf_nat_snmp_hook, help);
> +	rcu_init_pointer(nf_nat_snmp_hook, help);
>  
>  	ret = nf_conntrack_helper_register(&snmp_trap_helper);
>  	if (ret < 0) {
> @@ -1303,7 +1303,7 @@ static int __init nf_nat_snmp_basic_init(void)
>  
>  static void __exit nf_nat_snmp_basic_fini(void)
>  {
> -	RCU_INIT_POINTER(nf_nat_snmp_hook, NULL);
> +	rcu_init_pointer(nf_nat_snmp_hook, NULL);
>  	nf_conntrack_helper_unregister(&snmp_trap_helper);
>  }
>  
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index db1e0da..186ff04 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -563,12 +563,12 @@ static void fnhe_flush_routes(struct fib_nh_exception *fnhe)
>  
>  	rt = rcu_dereference(fnhe->fnhe_rth_input);
>  	if (rt) {
> -		RCU_INIT_POINTER(fnhe->fnhe_rth_input, NULL);
> +		rcu_init_pointer(fnhe->fnhe_rth_input, NULL);
>  		rt_free(rt);
>  	}
>  	rt = rcu_dereference(fnhe->fnhe_rth_output);
>  	if (rt) {
> -		RCU_INIT_POINTER(fnhe->fnhe_rth_output, NULL);
> +		rcu_init_pointer(fnhe->fnhe_rth_output, NULL);
>  		rt_free(rt);
>  	}
>  }
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 6c7fa08..563a9e4 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -3017,7 +3017,7 @@ static int addrconf_ifdown(struct net_device *dev, int how)
>  		idev->dead = 1;
>  
>  		/* protected by rtnl_lock */
> -		RCU_INIT_POINTER(dev->ip6_ptr, NULL);
> +		rcu_init_pointer(dev->ip6_ptr, NULL);
>  
>  		/* Step 1.5: remove snmp6 entry */
>  		snmp6_unregister_dev(idev);
> diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> index b05b609..652e28a 100644
> --- a/net/ipv6/ip6_tunnel.c
> +++ b/net/ipv6/ip6_tunnel.c
> @@ -386,7 +386,7 @@ ip6_tnl_dev_uninit(struct net_device *dev)
>  	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
>  
>  	if (dev == ip6n->fb_tnl_dev)
> -		RCU_INIT_POINTER(ip6n->tnls_wc[0], NULL);
> +		rcu_init_pointer(ip6n->tnls_wc[0], NULL);
>  	else
>  		ip6_tnl_unlink(ip6n, t);
>  	ip6_tnl_dst_reset(t);
> diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
> index b7c0f82..bff37b3 100644
> --- a/net/ipv6/ip6_vti.c
> +++ b/net/ipv6/ip6_vti.c
> @@ -275,7 +275,7 @@ static void vti6_dev_uninit(struct net_device *dev)
>  	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
>  
>  	if (dev == ip6n->fb_tnl_dev)
> -		RCU_INIT_POINTER(ip6n->tnls_wc[0], NULL);
> +		rcu_init_pointer(ip6n->tnls_wc[0], NULL);
>  	else
>  		vti6_tnl_unlink(ip6n, t);
>  	dev_put(dev);
> diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
> index 95f3f1d..88d73a1 100644
> --- a/net/ipv6/netfilter.c
> +++ b/net/ipv6/netfilter.c
> @@ -203,7 +203,7 @@ static const struct nf_afinfo nf_ip6_afinfo = {
>  
>  int __init ipv6_netfilter_init(void)
>  {
> -	RCU_INIT_POINTER(nf_ipv6_ops, &ipv6ops);
> +	rcu_init_pointer(nf_ipv6_ops, &ipv6ops);
>  	return nf_register_afinfo(&nf_ip6_afinfo);
>  }
>  
> @@ -212,6 +212,6 @@ int __init ipv6_netfilter_init(void)
>   */
>  void ipv6_netfilter_fini(void)
>  {
> -	RCU_INIT_POINTER(nf_ipv6_ops, NULL);
> +	rcu_init_pointer(nf_ipv6_ops, NULL);
>  	nf_unregister_afinfo(&nf_ip6_afinfo);
>  }
> diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
> index 1f29996..594ac2f 100644
> --- a/net/ipv6/raw.c
> +++ b/net/ipv6/raw.c
> @@ -140,7 +140,7 @@ EXPORT_SYMBOL(rawv6_mh_filter_register);
>  
>  int rawv6_mh_filter_unregister(mh_filter_t filter)
>  {
> -	RCU_INIT_POINTER(mh_filter, NULL);
> +	rcu_init_pointer(mh_filter, NULL);
>  	synchronize_rcu();
>  	return 0;
>  }
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index e5a453c..bbde433 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -470,7 +470,7 @@ static void ipip6_tunnel_uninit(struct net_device *dev)
>  	struct sit_net *sitn = net_generic(tunnel->net, sit_net_id);
>  
>  	if (dev == sitn->fb_tunnel_dev) {
> -		RCU_INIT_POINTER(sitn->tunnels_wc[0], NULL);
> +		rcu_init_pointer(sitn->tunnels_wc[0], NULL);
>  	} else {
>  		ipip6_tunnel_unlink(sitn, tunnel);
>  		ipip6_tunnel_del_prl(tunnel, NULL);
> diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> index 31bf258..22d4d35 100644
> --- a/net/mac80211/agg-rx.c
> +++ b/net/mac80211/agg-rx.c
> @@ -72,7 +72,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
>  	if (!tid_rx)
>  		return;
>  
> -	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
> +	rcu_init_pointer(sta->ampdu_mlme.tid_rx[tid], NULL);
>  
>  	ht_dbg(sta->sdata,
>  	       "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index aaa59d7..3839764 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -64,7 +64,7 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
>  
>  	if (type == NL80211_IFTYPE_AP_VLAN &&
>  	    params && params->use_4addr == 0)
> -		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
> +		rcu_init_pointer(sdata->u.vlan.sta, NULL);
>  	else if (type == NL80211_IFTYPE_STATION &&
>  		 params && params->use_4addr >= 0)
>  		sdata->u.mgd.use_4addr = params->use_4addr;
> @@ -1033,7 +1033,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
>  
>  		if (old)
>  			kfree_rcu(old, rcu_head);
> -		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
> +		rcu_init_pointer(sdata->u.ap.beacon, NULL);
>  		ieee80211_vif_release_channel(sdata);
>  		return err;
>  	}
> @@ -1102,8 +1102,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
>  	netif_carrier_off(dev);
>  
>  	/* remove beacon and probe response */
> -	RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
> -	RCU_INIT_POINTER(sdata->u.ap.probe_resp, NULL);
> +	rcu_init_pointer(sdata->u.ap.beacon, NULL);
> +	rcu_init_pointer(sdata->u.ap.probe_resp, NULL);
>  	kfree_rcu(old_beacon, rcu_head);
>  	if (old_probe_resp)
>  		kfree_rcu(old_probe_resp, rcu_head);
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 06d2878..bd477c2 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -365,7 +365,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  		sdata->vif.bss_conf.ibss_creator = false;
>  		sdata->vif.bss_conf.enable_beacon = false;
>  		sdata->vif.bss_conf.ssid_len = 0;
> -		RCU_INIT_POINTER(ifibss->presp, NULL);
> +		rcu_init_pointer(ifibss->presp, NULL);
>  		kfree_rcu(presp, rcu_head);
>  		mutex_lock(&local->mtx);
>  		ieee80211_vif_release_channel(sdata);
> @@ -735,7 +735,7 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
>  	/* remove beacon */
>  	presp = rcu_dereference_protected(ifibss->presp,
>  					  lockdep_is_held(&sdata->wdev.mtx));
> -	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
> +	rcu_init_pointer(sdata->u.ibss.presp, NULL);
>  	if (presp)
>  		kfree_rcu(presp, rcu_head);
>  
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index f70e9cd..9271537 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -1341,7 +1341,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
>  	skb_queue_head_init(&ifmsh->ps.bc_buf);
>  	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
>  	spin_lock_init(&ifmsh->sync_offset_lock);
> -	RCU_INIT_POINTER(ifmsh->beacon, NULL);
> +	rcu_init_pointer(ifmsh->beacon, NULL);
>  
>  	sdata->vif.bss_conf.bssid = zero_addr;
>  }
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index 7d050ed..5db5430 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -1068,8 +1068,8 @@ int mesh_pathtbl_init(void)
>  	INIT_HLIST_HEAD(tbl_mpp->known_gates);
>  
>  	/* Need no locking since this is during init */
> -	RCU_INIT_POINTER(mesh_paths, tbl_path);
> -	RCU_INIT_POINTER(mpp_paths, tbl_mpp);
> +	rcu_init_pointer(mesh_paths, tbl_path);
> +	rcu_init_pointer(mpp_paths, tbl_mpp);
>  
>  	return 0;
>  
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 137a192..0d2c0bf 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -860,7 +860,7 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
>  
>  	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
>  	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
> -		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
> +		rcu_init_pointer(sdata->u.vlan.sta, NULL);
>  
>  	return 0;
>  }
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 1fbab0c..5f88a73 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -40,7 +40,7 @@ int nf_register_afinfo(const struct nf_afinfo *afinfo)
>  	err = mutex_lock_interruptible(&afinfo_mutex);
>  	if (err < 0)
>  		return err;
> -	RCU_INIT_POINTER(nf_afinfo[afinfo->family], afinfo);
> +	rcu_init_pointer(nf_afinfo[afinfo->family], afinfo);
>  	mutex_unlock(&afinfo_mutex);
>  	return 0;
>  }
> @@ -49,7 +49,7 @@ EXPORT_SYMBOL_GPL(nf_register_afinfo);
>  void nf_unregister_afinfo(const struct nf_afinfo *afinfo)
>  {
>  	mutex_lock(&afinfo_mutex);
> -	RCU_INIT_POINTER(nf_afinfo[afinfo->family], NULL);
> +	rcu_init_pointer(nf_afinfo[afinfo->family], NULL);
>  	mutex_unlock(&afinfo_mutex);
>  	synchronize_rcu();
>  }
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index c42e83d..e8b609d 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -641,7 +641,7 @@ static void __ip_vs_dst_cache_reset(struct ip_vs_dest *dest)
>  
>  	old = rcu_dereference_protected(dest->dest_dst, 1);
>  	if (old) {
> -		RCU_INIT_POINTER(dest->dest_dst, NULL);
> +		rcu_init_pointer(dest->dest_dst, NULL);
>  		call_rcu(&old->rcu_head, ip_vs_dest_dst_rcu_free);
>  	}
>  }
> @@ -1221,7 +1221,7 @@ ip_vs_add_service(struct net *net, struct ip_vs_service_user_kern *u,
>  	sched = NULL;
>  
>  	/* Bind the ct retriever */
> -	RCU_INIT_POINTER(svc->pe, pe);
> +	rcu_init_pointer(svc->pe, pe);
>  	pe = NULL;
>  
>  	/* Update the virtual service counters */
> diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
> index c3b8454..6cd09c1 100644
> --- a/net/netfilter/ipvs/ip_vs_dh.c
> +++ b/net/netfilter/ipvs/ip_vs_dh.c
> @@ -115,14 +115,14 @@ ip_vs_dh_reassign(struct ip_vs_dh_state *s, struct ip_vs_service *svc)
>  		if (dest)
>  			ip_vs_dest_put(dest);
>  		if (empty)
> -			RCU_INIT_POINTER(b->dest, NULL);
> +			rcu_init_pointer(b->dest, NULL);
>  		else {
>  			if (p == &svc->destinations)
>  				p = p->next;
>  
>  			dest = list_entry(p, struct ip_vs_dest, n_list);
>  			ip_vs_dest_hold(dest);
> -			RCU_INIT_POINTER(b->dest, dest);
> +			rcu_init_pointer(b->dest, dest);
>  
>  			p = p->next;
>  		}
> @@ -146,7 +146,7 @@ static void ip_vs_dh_flush(struct ip_vs_dh_state *s)
>  		dest = rcu_dereference_protected(b->dest, 1);
>  		if (dest) {
>  			ip_vs_dest_put(dest);
> -			RCU_INIT_POINTER(b->dest, NULL);
> +			rcu_init_pointer(b->dest, NULL);
>  		}
>  		b++;
>  	}
> diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
> index cc65b2f..6a3e885 100644
> --- a/net/netfilter/ipvs/ip_vs_sh.c
> +++ b/net/netfilter/ipvs/ip_vs_sh.c
> @@ -182,14 +182,14 @@ ip_vs_sh_reassign(struct ip_vs_sh_state *s, struct ip_vs_service *svc)
>  		if (dest)
>  			ip_vs_dest_put(dest);
>  		if (empty)
> -			RCU_INIT_POINTER(b->dest, NULL);
> +			rcu_init_pointer(b->dest, NULL);
>  		else {
>  			if (p == &svc->destinations)
>  				p = p->next;
>  
>  			dest = list_entry(p, struct ip_vs_dest, n_list);
>  			ip_vs_dest_hold(dest);
> -			RCU_INIT_POINTER(b->dest, dest);
> +			rcu_init_pointer(b->dest, dest);
>  
>  			IP_VS_DBG_BUF(6, "assigned i: %d dest: %s weight: %d\n",
>  				      i, IP_VS_DBG_ADDR(svc->af, &dest->addr),
> @@ -222,7 +222,7 @@ static void ip_vs_sh_flush(struct ip_vs_sh_state *s)
>  		dest = rcu_dereference_protected(b->dest, 1);
>  		if (dest) {
>  			ip_vs_dest_put(dest);
> -			RCU_INIT_POINTER(b->dest, NULL);
> +			rcu_init_pointer(b->dest, NULL);
>  		}
>  		b++;
>  	}
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 75421f2..57e1308 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1498,12 +1498,12 @@ static int untrack_refs(void)
>  
>  void nf_conntrack_cleanup_start(void)
>  {
> -	RCU_INIT_POINTER(ip_ct_attach, NULL);
> +	rcu_init_pointer(ip_ct_attach, NULL);
>  }
>  
>  void nf_conntrack_cleanup_end(void)
>  {
> -	RCU_INIT_POINTER(nf_ct_destroy, NULL);
> +	rcu_init_pointer(nf_ct_destroy, NULL);
>  	while (untrack_refs() > 0)
>  		schedule();
>  
> @@ -1778,8 +1778,8 @@ err_expect:
>  void nf_conntrack_init_end(void)
>  {
>  	/* For use by REJECT target */
> -	RCU_INIT_POINTER(ip_ct_attach, nf_conntrack_attach);
> -	RCU_INIT_POINTER(nf_ct_destroy, destroy_conntrack);
> +	rcu_init_pointer(ip_ct_attach, nf_conntrack_attach);
> +	rcu_init_pointer(nf_ct_destroy, destroy_conntrack);
>  }
>  
>  /*
> diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
> index 1df1761..30ba3b0 100644
> --- a/net/netfilter/nf_conntrack_ecache.c
> +++ b/net/netfilter/nf_conntrack_ecache.c
> @@ -114,7 +114,7 @@ void nf_conntrack_unregister_notifier(struct net *net,
>  	notify = rcu_dereference_protected(net->ct.nf_conntrack_event_cb,
>  					   lockdep_is_held(&nf_ct_ecache_mutex));
>  	BUG_ON(notify != new);
> -	RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, NULL);
> +	rcu_init_pointer(net->ct.nf_conntrack_event_cb, NULL);
>  	mutex_unlock(&nf_ct_ecache_mutex);
>  }
>  EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
> @@ -150,7 +150,7 @@ void nf_ct_expect_unregister_notifier(struct net *net,
>  	notify = rcu_dereference_protected(net->ct.nf_expect_event_cb,
>  					   lockdep_is_held(&nf_ct_ecache_mutex));
>  	BUG_ON(notify != new);
> -	RCU_INIT_POINTER(net->ct.nf_expect_event_cb, NULL);
> +	rcu_init_pointer(net->ct.nf_expect_event_cb, NULL);
>  	mutex_unlock(&nf_ct_ecache_mutex);
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
> diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
> index 1a95459..bbbea59b 100644
> --- a/net/netfilter/nf_conntrack_extend.c
> +++ b/net/netfilter/nf_conntrack_extend.c
> @@ -183,7 +183,7 @@ EXPORT_SYMBOL_GPL(nf_ct_extend_register);
>  void nf_ct_extend_unregister(struct nf_ct_ext_type *type)
>  {
>  	mutex_lock(&nf_ct_ext_type_mutex);
> -	RCU_INIT_POINTER(nf_ct_ext_types[type->id], NULL);
> +	rcu_init_pointer(nf_ct_ext_types[type->id], NULL);
>  	update_alloc_size(type);
>  	mutex_unlock(&nf_ct_ext_type_mutex);
>  	rcu_barrier(); /* Wait for completion of call_rcu()'s */
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 5b3eae7..a4dce7f 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -222,7 +222,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
>  
>  	if (helper == NULL) {
>  		if (help)
> -			RCU_INIT_POINTER(help->helper, NULL);
> +			rcu_init_pointer(help->helper, NULL);
>  		goto out;
>  	}
>  
> @@ -239,7 +239,7 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
>  		struct nf_conntrack_helper *tmp = rcu_dereference(help->helper);
>  
>  		if (tmp && tmp->help != helper->help) {
> -			RCU_INIT_POINTER(help->helper, NULL);
> +			rcu_init_pointer(help->helper, NULL);
>  			goto out;
>  		}
>  	}
> @@ -259,7 +259,7 @@ static inline int unhelp(struct nf_conntrack_tuple_hash *i,
>  
>  	if (help && rcu_dereference_raw(help->helper) == me) {
>  		nf_conntrack_event(IPCT_HELPER, ct);
> -		RCU_INIT_POINTER(help->helper, NULL);
> +		rcu_init_pointer(help->helper, NULL);
>  	}
>  	return 0;
>  }
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index ccc46fa..f147656 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1372,7 +1372,7 @@ ctnetlink_change_helper(struct nf_conn *ct, const struct nlattr * const cda[])
>  		if (help && help->helper) {
>  			/* we had a helper before ... */
>  			nf_ct_remove_expectations(ct);
> -			RCU_INIT_POINTER(help->helper, NULL);
> +			rcu_init_pointer(help->helper, NULL);
>  		}
>  
>  		return 0;
> @@ -1666,7 +1666,7 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
>  				helper->from_nlattr(helpinfo, ct);
>  
>  			/* not in hash table yet so not strictly necessary */
> -			RCU_INIT_POINTER(help->helper, helper);
> +			rcu_init_pointer(help->helper, helper);
>  		}
>  	} else {
>  		/* try an implicit helper assignation */
> @@ -3213,7 +3213,7 @@ static int __init ctnetlink_init(void)
>  	}
>  #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
>  	/* setup interaction between nf_queue and nf_conntrack_netlink. */
> -	RCU_INIT_POINTER(nfq_ct_hook, &ctnetlink_nfqueue_hook);
> +	rcu_init_pointer(nfq_ct_hook, &ctnetlink_nfqueue_hook);
>  #endif
>  	return 0;
>  
> @@ -3233,7 +3233,7 @@ static void __exit ctnetlink_exit(void)
>  	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
>  	nfnetlink_subsys_unregister(&ctnl_subsys);
>  #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
> -	RCU_INIT_POINTER(nfq_ct_hook, NULL);
> +	rcu_init_pointer(nfq_ct_hook, NULL);
>  #endif
>  }
>  
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index b65d586..2dc7f72 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -384,7 +384,7 @@ int nf_ct_l4proto_register(struct nf_conntrack_l4proto *l4proto)
>  		}
>  
>  		for (i = 0; i < MAX_NF_CT_PROTO; i++)
> -			RCU_INIT_POINTER(proto_array[i], &nf_conntrack_l4proto_generic);
> +			rcu_init_pointer(proto_array[i], &nf_conntrack_l4proto_generic);
>  
>  		/* Before making proto_array visible to lockless readers,
>  		 * we must make sure its content is committed to memory.
> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
> index 85296d4..a9580ec 100644
> --- a/net/netfilter/nf_log.c
> +++ b/net/netfilter/nf_log.c
> @@ -58,7 +58,7 @@ void nf_log_unset(struct net *net, const struct nf_logger *logger)
>  		log = rcu_dereference_protected(net->nf.nf_loggers[i],
>  				lockdep_is_held(&nf_log_mutex));
>  		if (log == logger)
> -			RCU_INIT_POINTER(net->nf.nf_loggers[i], NULL);
> +			rcu_init_pointer(net->nf.nf_loggers[i], NULL);
>  	}
>  	mutex_unlock(&nf_log_mutex);
>  	synchronize_rcu();
> @@ -124,7 +124,7 @@ void nf_log_unbind_pf(struct net *net, u_int8_t pf)
>  	if (pf >= ARRAY_SIZE(net->nf.nf_loggers))
>  		return;
>  	mutex_lock(&nf_log_mutex);
> -	RCU_INIT_POINTER(net->nf.nf_loggers[pf], NULL);
> +	rcu_init_pointer(net->nf.nf_loggers[pf], NULL);
>  	mutex_unlock(&nf_log_mutex);
>  }
>  EXPORT_SYMBOL(nf_log_unbind_pf);
> diff --git a/net/netfilter/nf_nat_amanda.c b/net/netfilter/nf_nat_amanda.c
> index eb77238..d5ac5b2 100644
> --- a/net/netfilter/nf_nat_amanda.c
> +++ b/net/netfilter/nf_nat_amanda.c
> @@ -75,14 +75,14 @@ static unsigned int help(struct sk_buff *skb,
>  
>  static void __exit nf_nat_amanda_fini(void)
>  {
> -	RCU_INIT_POINTER(nf_nat_amanda_hook, NULL);
> +	rcu_init_pointer(nf_nat_amanda_hook, NULL);
>  	synchronize_rcu();
>  }
>  
>  static int __init nf_nat_amanda_init(void)
>  {
>  	BUG_ON(nf_nat_amanda_hook != NULL);
> -	RCU_INIT_POINTER(nf_nat_amanda_hook, help);
> +	rcu_init_pointer(nf_nat_amanda_hook, help);
>  	return 0;
>  }
>  
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index 52ca952..1219b5e 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -562,7 +562,7 @@ int nf_nat_l4proto_register(u8 l3proto, const struct nf_nat_l4proto *l4proto)
>  		}
>  
>  		for (i = 0; i < IPPROTO_MAX; i++)
> -			RCU_INIT_POINTER(l4protos[i], &nf_nat_l4proto_unknown);
> +			rcu_init_pointer(l4protos[i], &nf_nat_l4proto_unknown);
>  
>  		/* Before making proto_array visible to lockless readers,
>  		 * we must make sure its content is committed to memory.
> @@ -579,7 +579,7 @@ int nf_nat_l4proto_register(u8 l3proto, const struct nf_nat_l4proto *l4proto)
>  		ret = -EBUSY;
>  		goto out;
>  	}
> -	RCU_INIT_POINTER(nf_nat_l4protos[l3proto][l4proto->l4proto], l4proto);
> +	rcu_init_pointer(nf_nat_l4protos[l3proto][l4proto->l4proto], l4proto);
>   out:
>  	mutex_unlock(&nf_nat_proto_mutex);
>  	return ret;
> @@ -590,7 +590,7 @@ EXPORT_SYMBOL_GPL(nf_nat_l4proto_register);
>  void nf_nat_l4proto_unregister(u8 l3proto, const struct nf_nat_l4proto *l4proto)
>  {
>  	mutex_lock(&nf_nat_proto_mutex);
> -	RCU_INIT_POINTER(nf_nat_l4protos[l3proto][l4proto->l4proto],
> +	rcu_init_pointer(nf_nat_l4protos[l3proto][l4proto->l4proto],
>  			 &nf_nat_l4proto_unknown);
>  	mutex_unlock(&nf_nat_proto_mutex);
>  	synchronize_rcu();
> @@ -608,13 +608,13 @@ int nf_nat_l3proto_register(const struct nf_nat_l3proto *l3proto)
>  		return err;
>  
>  	mutex_lock(&nf_nat_proto_mutex);
> -	RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_TCP],
> +	rcu_init_pointer(nf_nat_l4protos[l3proto->l3proto][IPPROTO_TCP],
>  			 &nf_nat_l4proto_tcp);
> -	RCU_INIT_POINTER(nf_nat_l4protos[l3proto->l3proto][IPPROTO_UDP],
> +	rcu_init_pointer(nf_nat_l4protos[l3proto->l3proto][IPPROTO_UDP],
>  			 &nf_nat_l4proto_udp);
>  	mutex_unlock(&nf_nat_proto_mutex);
>  
> -	RCU_INIT_POINTER(nf_nat_l3protos[l3proto->l3proto], l3proto);
> +	rcu_init_pointer(nf_nat_l3protos[l3proto->l3proto], l3proto);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(nf_nat_l3proto_register);
> @@ -622,7 +622,7 @@ EXPORT_SYMBOL_GPL(nf_nat_l3proto_register);
>  void nf_nat_l3proto_unregister(const struct nf_nat_l3proto *l3proto)
>  {
>  	mutex_lock(&nf_nat_proto_mutex);
> -	RCU_INIT_POINTER(nf_nat_l3protos[l3proto->l3proto], NULL);
> +	rcu_init_pointer(nf_nat_l3protos[l3proto->l3proto], NULL);
>  	mutex_unlock(&nf_nat_proto_mutex);
>  	synchronize_rcu();
>  
> @@ -822,11 +822,11 @@ static int __init nf_nat_init(void)
>  	nf_ct_untracked_status_or(IPS_NAT_DONE_MASK);
>  
>  	BUG_ON(nfnetlink_parse_nat_setup_hook != NULL);
> -	RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook,
> +	rcu_init_pointer(nfnetlink_parse_nat_setup_hook,
>  			   nfnetlink_parse_nat_setup);
>  #ifdef CONFIG_XFRM
>  	BUG_ON(nf_nat_decode_session_hook != NULL);
> -	RCU_INIT_POINTER(nf_nat_decode_session_hook, __nf_nat_decode_session);
> +	rcu_init_pointer(nf_nat_decode_session_hook, __nf_nat_decode_session);
>  #endif
>  	return 0;
>  
> @@ -842,9 +842,9 @@ static void __exit nf_nat_cleanup(void)
>  	unregister_pernet_subsys(&nf_nat_net_ops);
>  	nf_ct_extend_unregister(&nat_extend);
>  	nf_ct_helper_expectfn_unregister(&follow_master_nat);
> -	RCU_INIT_POINTER(nfnetlink_parse_nat_setup_hook, NULL);
> +	rcu_init_pointer(nfnetlink_parse_nat_setup_hook, NULL);
>  #ifdef CONFIG_XFRM
> -	RCU_INIT_POINTER(nf_nat_decode_session_hook, NULL);
> +	rcu_init_pointer(nf_nat_decode_session_hook, NULL);
>  #endif
>  	for (i = 0; i < NFPROTO_NUMPROTO; i++)
>  		kfree(nf_nat_l4protos[i]);
> diff --git a/net/netfilter/nf_nat_ftp.c b/net/netfilter/nf_nat_ftp.c
> index e84a578..aaef6c6 100644
> --- a/net/netfilter/nf_nat_ftp.c
> +++ b/net/netfilter/nf_nat_ftp.c
> @@ -122,14 +122,14 @@ out:
>  
>  static void __exit nf_nat_ftp_fini(void)
>  {
> -	RCU_INIT_POINTER(nf_nat_ftp_hook, NULL);
> +	rcu_init_pointer(nf_nat_ftp_hook, NULL);
>  	synchronize_rcu();
>  }
>  
>  static int __init nf_nat_ftp_init(void)
>  {
>  	BUG_ON(nf_nat_ftp_hook != NULL);
> -	RCU_INIT_POINTER(nf_nat_ftp_hook, nf_nat_ftp);
> +	rcu_init_pointer(nf_nat_ftp_hook, nf_nat_ftp);
>  	return 0;
>  }
>  
> diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
> index 1fb2258..5bf497d 100644
> --- a/net/netfilter/nf_nat_irc.c
> +++ b/net/netfilter/nf_nat_irc.c
> @@ -95,14 +95,14 @@ static unsigned int help(struct sk_buff *skb,
>  
>  static void __exit nf_nat_irc_fini(void)
>  {
> -	RCU_INIT_POINTER(nf_nat_irc_hook, NULL);
> +	rcu_init_pointer(nf_nat_irc_hook, NULL);
>  	synchronize_rcu();
>  }
>  
>  static int __init nf_nat_irc_init(void)
>  {
>  	BUG_ON(nf_nat_irc_hook != NULL);
> -	RCU_INIT_POINTER(nf_nat_irc_hook, help);
> +	rcu_init_pointer(nf_nat_irc_hook, help);
>  	return 0;
>  }
>  
> diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
> index b4d691d..a2a0a39 100644
> --- a/net/netfilter/nf_nat_sip.c
> +++ b/net/netfilter/nf_nat_sip.c
> @@ -625,7 +625,7 @@ static struct nf_ct_helper_expectfn sip_nat = {
>  
>  static void __exit nf_nat_sip_fini(void)
>  {
> -	RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
> +	rcu_init_pointer(nf_nat_sip_hooks, NULL);
>  
>  	nf_ct_helper_expectfn_unregister(&sip_nat);
>  	synchronize_rcu();
> @@ -644,7 +644,7 @@ static const struct nf_nat_sip_hooks sip_hooks = {
>  static int __init nf_nat_sip_init(void)
>  {
>  	BUG_ON(nf_nat_sip_hooks != NULL);
> -	RCU_INIT_POINTER(nf_nat_sip_hooks, &sip_hooks);
> +	rcu_init_pointer(nf_nat_sip_hooks, &sip_hooks);
>  	nf_ct_helper_expectfn_register(&sip_nat);
>  	return 0;
>  }
> diff --git a/net/netfilter/nf_nat_tftp.c b/net/netfilter/nf_nat_tftp.c
> index 7f67e1d..f828ef0 100644
> --- a/net/netfilter/nf_nat_tftp.c
> +++ b/net/netfilter/nf_nat_tftp.c
> @@ -37,14 +37,14 @@ static unsigned int help(struct sk_buff *skb,
>  
>  static void __exit nf_nat_tftp_fini(void)
>  {
> -	RCU_INIT_POINTER(nf_nat_tftp_hook, NULL);
> +	rcu_init_pointer(nf_nat_tftp_hook, NULL);
>  	synchronize_rcu();
>  }
>  
>  static int __init nf_nat_tftp_init(void)
>  {
>  	BUG_ON(nf_nat_tftp_hook != NULL);
> -	RCU_INIT_POINTER(nf_nat_tftp_hook, help);
> +	rcu_init_pointer(nf_nat_tftp_hook, help);
>  	return 0;
>  }
>  
> diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> index 5d24b1f..93fe802 100644
> --- a/net/netfilter/nf_queue.c
> +++ b/net/netfilter/nf_queue.c
> @@ -40,7 +40,7 @@ EXPORT_SYMBOL(nf_register_queue_handler);
>  /* The caller must flush their queue before this */
>  void nf_unregister_queue_handler(void)
>  {
> -	RCU_INIT_POINTER(queue_handler, NULL);
> +	rcu_init_pointer(queue_handler, NULL);
>  	synchronize_rcu();
>  }
>  EXPORT_SYMBOL(nf_unregister_queue_handler);
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index e8138da..6477a02 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -440,7 +440,7 @@ static void __net_exit nfnetlink_net_exit_batch(struct list_head *net_exit_list)
>  	struct net *net;
>  
>  	list_for_each_entry(net, net_exit_list, exit_list)
> -		RCU_INIT_POINTER(net->nfnl, NULL);
> +		rcu_init_pointer(net->nfnl, NULL);
>  	synchronize_net();
>  	list_for_each_entry(net, net_exit_list, exit_list)
>  		netlink_kernel_release(net->nfnl_stash);
> diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
> index 476accd..836836c 100644
> --- a/net/netfilter/nfnetlink_cttimeout.c
> +++ b/net/netfilter/nfnetlink_cttimeout.c
> @@ -551,8 +551,8 @@ static int __init cttimeout_init(void)
>  		goto err_out;
>  	}
>  #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
> -	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, ctnl_timeout_find_get);
> -	RCU_INIT_POINTER(nf_ct_timeout_put_hook, ctnl_timeout_put);
> +	rcu_init_pointer(nf_ct_timeout_find_get_hook, ctnl_timeout_find_get);
> +	rcu_init_pointer(nf_ct_timeout_put_hook, ctnl_timeout_put);
>  #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
>  	return 0;
>  
> @@ -576,8 +576,8 @@ static void __exit cttimeout_exit(void)
>  		kfree_rcu(cur, rcu_head);
>  	}
>  #ifdef CONFIG_NF_CONNTRACK_TIMEOUT
> -	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, NULL);
> -	RCU_INIT_POINTER(nf_ct_timeout_put_hook, NULL);
> +	rcu_init_pointer(nf_ct_timeout_find_get_hook, NULL);
> +	rcu_init_pointer(nf_ct_timeout_put_hook, NULL);
>  #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
>  }
>  
> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> index 3b1ad87..539385b 100644
> --- a/net/netfilter/nft_hash.c
> +++ b/net/netfilter/nft_hash.c
> @@ -119,7 +119,7 @@ static void nft_hash_chain_unzip(const struct nft_set *set,
>  	}
>  
>  	/* Unlink first chain from the old table */
> -	RCU_INIT_POINTER(tbl->buckets[n], last->next);
> +	rcu_init_pointer(tbl->buckets[n], last->next);
>  
>  	/* If end of chain reached, done */
>  	if (he == NULL)
> @@ -135,7 +135,7 @@ static void nft_hash_chain_unzip(const struct nft_set *set,
>  	}
>  
>  	/* Link the two chains */
> -	RCU_INIT_POINTER(last->next, next);
> +	rcu_init_pointer(last->next, next);
>  }
>  
>  static int nft_hash_tbl_expand(const struct nft_set *set, struct nft_hash *priv)
> @@ -157,7 +157,7 @@ static int nft_hash_tbl_expand(const struct nft_set *set, struct nft_hash *priv)
>  		nft_hash_for_each_entry(he, tbl->buckets[h]) {
>  			if (nft_hash_data(&he->key, ntbl->size, set->klen) != i)
>  				continue;
> -			RCU_INIT_POINTER(ntbl->buckets[i], he);
> +			rcu_init_pointer(ntbl->buckets[i], he);
>  			break;
>  		}
>  	}
> @@ -199,7 +199,7 @@ static int nft_hash_tbl_shrink(const struct nft_set *set, struct nft_hash *priv)
>  		for (pprev = &ntbl->buckets[i]; *pprev != NULL;
>  		     pprev = &nft_dereference(*pprev)->next)
>  			;
> -		RCU_INIT_POINTER(*pprev, tbl->buckets[i + ntbl->size]);
> +		rcu_init_pointer(*pprev, tbl->buckets[i + ntbl->size]);
>  	}
>  	ntbl->elements = tbl->elements;
>  
> @@ -235,7 +235,7 @@ static int nft_hash_insert(const struct nft_set *set,
>  		nft_data_copy(he->data, &elem->data);
>  
>  	h = nft_hash_data(&he->key, tbl->size, set->klen);
> -	RCU_INIT_POINTER(he->next, tbl->buckets[h]);
> +	rcu_init_pointer(he->next, tbl->buckets[h]);
>  	rcu_assign_pointer(tbl->buckets[h], he);
>  	tbl->elements++;
>  
> @@ -265,7 +265,7 @@ static void nft_hash_remove(const struct nft_set *set,
>  	pprev = elem->cookie;
>  	he = nft_dereference((*pprev));
>  
> -	RCU_INIT_POINTER(*pprev, he->next);
> +	rcu_init_pointer(*pprev, he->next);
>  	synchronize_rcu();
>  	kfree(he);
>  	tbl->elements--;
> @@ -348,7 +348,7 @@ static int nft_hash_init(const struct nft_set *set,
>  	tbl = nft_hash_tbl_alloc(NFT_HASH_MIN_SIZE);
>  	if (tbl == NULL)
>  		return -ENOMEM;
> -	RCU_INIT_POINTER(priv->tbl, tbl);
> +	rcu_init_pointer(priv->tbl, tbl);
>  	return 0;
>  }
>  
> diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
> index f0cb92f..97632af 100644
> --- a/net/netlabel/netlabel_domainhash.c
> +++ b/net/netlabel/netlabel_domainhash.c
> @@ -516,7 +516,7 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
>  		if (entry != rcu_dereference(netlbl_domhsh_def))
>  			list_del_rcu(&entry->list);
>  		else
> -			RCU_INIT_POINTER(netlbl_domhsh_def, NULL);
> +			rcu_init_pointer(netlbl_domhsh_def, NULL);
>  	} else
>  		ret_val = -ENOENT;
>  	spin_unlock(&netlbl_domhsh_lock);
> diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
> index 78a63c1..b7ebdee 100644
> --- a/net/netlabel/netlabel_unlabeled.c
> +++ b/net/netlabel/netlabel_unlabeled.c
> @@ -620,7 +620,7 @@ static void netlbl_unlhsh_condremove_iface(struct netlbl_unlhsh_iface *iface)
>  	if (iface->ifindex > 0)
>  		list_del_rcu(&iface->list);
>  	else
> -		RCU_INIT_POINTER(netlbl_unlhsh_def, NULL);
> +		rcu_init_pointer(netlbl_unlhsh_def, NULL);
>  	spin_unlock(&netlbl_unlhsh_lock);
>  
>  	call_rcu(&iface->rcu, netlbl_unlhsh_free_iface);
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 894cda0..93f0bd6 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1297,7 +1297,7 @@ static int netlink_release(struct socket *sock)
>  			struct listeners *old;
>  
>  			old = nl_deref_protected(nl_table[sk->sk_protocol].listeners);
> -			RCU_INIT_POINTER(nl_table[sk->sk_protocol].listeners, NULL);
> +			rcu_init_pointer(nl_table[sk->sk_protocol].listeners, NULL);
>  			kfree_rcu(old, rcu);
>  			nl_table[sk->sk_protocol].module = NULL;
>  			nl_table[sk->sk_protocol].bind = NULL;
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index b85c67c..4740dc6 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -301,7 +301,7 @@ static void packet_cached_dev_assign(struct packet_sock *po,
>  
>  static void packet_cached_dev_reset(struct packet_sock *po)
>  {
> -	RCU_INIT_POINTER(po->cached_dev, NULL);
> +	rcu_init_pointer(po->cached_dev, NULL);
>  }
>  
>  static bool packet_use_direct_xmit(const struct packet_sock *po)
> diff --git a/net/phonet/af_phonet.c b/net/phonet/af_phonet.c
> index 5a940db..694d5d8 100644
> --- a/net/phonet/af_phonet.c
> +++ b/net/phonet/af_phonet.c
> @@ -491,7 +491,7 @@ void phonet_proto_unregister(unsigned int protocol, struct phonet_protocol *pp)
>  {
>  	mutex_lock(&proto_tab_lock);
>  	BUG_ON(proto_tab[protocol] != pp);
> -	RCU_INIT_POINTER(proto_tab[protocol], NULL);
> +	rcu_init_pointer(proto_tab[protocol], NULL);
>  	mutex_unlock(&proto_tab_lock);
>  	synchronize_rcu();
>  	proto_unregister(pp->prot);
> diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
> index 56a6146..07d5619 100644
> --- a/net/phonet/pn_dev.c
> +++ b/net/phonet/pn_dev.c
> @@ -276,7 +276,7 @@ static void phonet_route_autodel(struct net_device *dev)
>  	mutex_lock(&pnn->routes.lock);
>  	for (i = 0; i < 64; i++)
>  		if (dev == pnn->routes.table[i]) {
> -			RCU_INIT_POINTER(pnn->routes.table[i], NULL);
> +			rcu_init_pointer(pnn->routes.table[i], NULL);
>  			set_bit(i, deleted);
>  		}
>  	mutex_unlock(&pnn->routes.lock);
> @@ -389,7 +389,7 @@ int phonet_route_del(struct net_device *dev, u8 daddr)
>  	daddr = daddr >> 2;
>  	mutex_lock(&routes->lock);
>  	if (dev == routes->table[daddr])
> -		RCU_INIT_POINTER(routes->table[daddr], NULL);
> +		rcu_init_pointer(routes->table[daddr], NULL);
>  	else
>  		dev = NULL;
>  	mutex_unlock(&routes->lock);
> diff --git a/net/phonet/socket.c b/net/phonet/socket.c
> index 008214a..24e0db2 100644
> --- a/net/phonet/socket.c
> +++ b/net/phonet/socket.c
> @@ -693,7 +693,7 @@ int pn_sock_unbind_res(struct sock *sk, u8 res)
>  
>  	mutex_lock(&resource_mutex);
>  	if (pnres.sk[res] == sk) {
> -		RCU_INIT_POINTER(pnres.sk[res], NULL);
> +		rcu_init_pointer(pnres.sk[res], NULL);
>  		ret = 0;
>  	}
>  	mutex_unlock(&resource_mutex);
> @@ -712,7 +712,7 @@ void pn_sock_unbind_all_res(struct sock *sk)
>  	mutex_lock(&resource_mutex);
>  	for (res = 0; res < 256; res++) {
>  		if (pnres.sk[res] == sk) {
> -			RCU_INIT_POINTER(pnres.sk[res], NULL);
> +			rcu_init_pointer(pnres.sk[res], NULL);
>  			match++;
>  		}
>  	}
> diff --git a/net/socket.c b/net/socket.c
> index abf56b2..9350395 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -260,7 +260,7 @@ static struct inode *sock_alloc_inode(struct super_block *sb)
>  	}
>  	init_waitqueue_head(&wq->wait);
>  	wq->fasync_list = NULL;
> -	RCU_INIT_POINTER(ei->socket.wq, wq);
> +	rcu_init_pointer(ei->socket.wq, wq);
>  
>  	ei->socket.state = SS_UNCONNECTED;
>  	ei->socket.flags = 0;
> @@ -2638,7 +2638,7 @@ void sock_unregister(int family)
>  	BUG_ON(family < 0 || family >= NPROTO);
>  
>  	spin_lock(&net_family_lock);
> -	RCU_INIT_POINTER(net_families[family], NULL);
> +	rcu_init_pointer(net_families[family], NULL);
>  	spin_unlock(&net_family_lock);
>  
>  	synchronize_rcu();
> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> index 36e431e..1810c54 100644
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -1262,7 +1262,7 @@ gss_destroy_nullcred(struct rpc_cred *cred)
>  	struct gss_auth *gss_auth = container_of(cred->cr_auth, struct gss_auth, rpc_auth);
>  	struct gss_cl_ctx *ctx = gss_cred->gc_ctx;
>  
> -	RCU_INIT_POINTER(gss_cred->gc_ctx, NULL);
> +	rcu_init_pointer(gss_cred->gc_ctx, NULL);
>  	call_rcu(&cred->cr_rcu, gss_free_cred_callback);
>  	if (ctx)
>  		gss_put_ctx(ctx);
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index 3fef7eb..3a56cd6 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -464,7 +464,7 @@ int tipc_enable_l2_media(struct tipc_bearer *b)
>  void tipc_disable_l2_media(struct tipc_bearer *b)
>  {
>  	struct net_device *dev = (struct net_device *)b->media_ptr;
> -	RCU_INIT_POINTER(dev->tipc_ptr, NULL);
> +	rcu_init_pointer(dev->tipc_ptr, NULL);
>  	dev_put(dev);
>  }
>  
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index bb7e8ba..ae855b9 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1187,7 +1187,7 @@ restart:
>  	newsk->sk_type		= sk->sk_type;
>  	init_peercred(newsk);
>  	newu = unix_sk(newsk);
> -	RCU_INIT_POINTER(newsk->sk_wq, &newu->peer_wq);
> +	rcu_init_pointer(newsk->sk_wq, &newu->peer_wq);
>  	otheru = unix_sk(other);
>  
>  	/* copy address information from listening to new sock*/
> diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
> index 85d1d47..deb776d 100644
> --- a/net/xfrm/xfrm_input.c
> +++ b/net/xfrm/xfrm_input.c
> @@ -50,7 +50,7 @@ int xfrm_input_unregister_afinfo(struct xfrm_input_afinfo *afinfo)
>  		if (unlikely(xfrm_input_afinfo[afinfo->family] != afinfo))
>  			err = -EINVAL;
>  		else
> -			RCU_INIT_POINTER(xfrm_input_afinfo[afinfo->family], NULL);
> +			rcu_init_pointer(xfrm_input_afinfo[afinfo->family], NULL);
>  	}
>  	spin_unlock_bh(&xfrm_input_afinfo_lock);
>  	synchronize_rcu();
> diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
> index c08fbd1..326d6ed 100644
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -2729,7 +2729,7 @@ int xfrm_policy_unregister_afinfo(struct xfrm_policy_afinfo *afinfo)
>  		if (unlikely(xfrm_policy_afinfo[afinfo->family] != afinfo))
>  			err = -EINVAL;
>  		else
> -			RCU_INIT_POINTER(xfrm_policy_afinfo[afinfo->family],
> +			rcu_init_pointer(xfrm_policy_afinfo[afinfo->family],
>  					 NULL);
>  	}
>  	spin_unlock(&xfrm_policy_afinfo_lock);
> diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
> index 8e9c781..cf7e89c 100644
> --- a/net/xfrm/xfrm_state.c
> +++ b/net/xfrm/xfrm_state.c
> @@ -1942,7 +1942,7 @@ int xfrm_state_unregister_afinfo(struct xfrm_state_afinfo *afinfo)
>  		if (unlikely(xfrm_state_afinfo[afinfo->family] != afinfo))
>  			err = -EINVAL;
>  		else
> -			RCU_INIT_POINTER(xfrm_state_afinfo[afinfo->family], NULL);
> +			rcu_init_pointer(xfrm_state_afinfo[afinfo->family], NULL);
>  	}
>  	spin_unlock_bh(&xfrm_state_afinfo_lock);
>  	synchronize_rcu();
> diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> index 8f131c1..cdf2a66 100644
> --- a/net/xfrm/xfrm_user.c
> +++ b/net/xfrm/xfrm_user.c
> @@ -3040,7 +3040,7 @@ static void __net_exit xfrm_user_net_exit(struct list_head *net_exit_list)
>  {
>  	struct net *net;
>  	list_for_each_entry(net, net_exit_list, exit_list)
> -		RCU_INIT_POINTER(net->xfrm.nlsk, NULL);
> +		rcu_init_pointer(net->xfrm.nlsk, NULL);
>  	synchronize_net();
>  	list_for_each_entry(net, net_exit_list, exit_list)
>  		netlink_kernel_release(net->xfrm.nlsk_stash);
> -- 
> 1.7.9.5
> 

