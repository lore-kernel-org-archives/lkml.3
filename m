Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbaCZDYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 23:24:19 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:43107 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbaCZDYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 23:24:17 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, arend@broadcom.com,
        rdunlap@infradead.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] [trivial]treewide: Fix typo in printk
Date: Wed, 26 Mar 2014 12:24:03 +0900
Message-Id: <1395804243-3199-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.1.315.g3f09db0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling typo in printk from various part of kernel source.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Arend van Spriel <arend@broadcom.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

---
 arch/powerpc/platforms/powernv/opal.c                 | 2 +-
 drivers/i2c/busses/i2c-s3c2410.c                      | 2 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c         | 8 ++++----
 drivers/misc/mei/hw-txe.c                             | 2 +-
 drivers/net/bonding/bond_sysfs_slave.c                | 2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c    | 2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c        | 2 +-
 drivers/net/ethernet/via/via-velocity.c               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 6 +++---
 drivers/scsi/qla2xxx/qla_nx2.c                        | 2 +-
 drivers/scsi/scsi_transport_fc.c                      | 2 +-
 sound/soc/davinci/davinci-mcasp.c                     | 2 +-
 12 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 2e269c2..7adcf62 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -275,7 +275,7 @@ static void opal_handle_message(void)
 
 	/* check for errors. */
 	if (ret) {
-		pr_warning("%s: Failed to retrive opal message, err=%lld\n",
+		pr_warning("%s: Failed to retrieve opal message, err=%lld\n",
 				__func__, ret);
 		return;
 	}
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index ae44910..4bef480 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -244,7 +244,7 @@ static bool is_ack(struct s3c24xx_i2c *i2c)
 		}
 		usleep_range(1000, 2000);
 	}
-	dev_err(i2c->dev, "ack was not recieved\n");
+	dev_err(i2c->dev, "ack was not received\n");
 	return false;
 }
 
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index f8dfd76..f92e083 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -49,7 +49,7 @@ const char *usnic_ib_qp_grp_state_to_string(enum ib_qp_state state)
 	case IB_QPS_ERR:
 		return "ERR";
 	default:
-		return "UNKOWN STATE";
+		return "UNKNOWN STATE";
 
 	}
 }
@@ -506,12 +506,12 @@ int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
 
 	if (!status) {
 		qp_grp->state = new_state;
-		usnic_info("Transistioned %u from %s to %s",
+		usnic_info("Transitioned %u from %s to %s",
 		qp_grp->grp_id,
 		usnic_ib_qp_grp_state_to_string(old_state),
 		usnic_ib_qp_grp_state_to_string(new_state));
 	} else {
-		usnic_err("Failed to transistion %u from %s to %s",
+		usnic_err("Failed to transition %u from %s to %s",
 		qp_grp->grp_id,
 		usnic_ib_qp_grp_state_to_string(old_state),
 		usnic_ib_qp_grp_state_to_string(new_state));
@@ -672,7 +672,7 @@ usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev, struct usnic_ib_vf *vf,
 	err = usnic_vnic_res_spec_satisfied(&min_transport_spec[transport],
 						res_spec);
 	if (err) {
-		usnic_err("Spec does not meet miniumum req for transport %d\n",
+		usnic_err("Spec does not meet minimum req for transport %d\n",
 				transport);
 		log_spec(res_spec);
 		return ERR_PTR(err);
diff --git a/drivers/misc/mei/hw-txe.c b/drivers/misc/mei/hw-txe.c
index f60182a..00d328d 100644
--- a/drivers/misc/mei/hw-txe.c
+++ b/drivers/misc/mei/hw-txe.c
@@ -781,7 +781,7 @@ static int mei_txe_hw_start(struct mei_device *dev)
 
 	ret = mei_txe_readiness_wait(dev);
 	if (ret < 0) {
-		dev_err(&dev->pdev->dev, "wating for readiness failed\n");
+		dev_err(&dev->pdev->dev, "waiting for readiness failed\n");
 		return ret;
 	}
 
diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index 2e4eec5..a4de46b 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -36,7 +36,7 @@ static ssize_t state_show(struct slave *slave, char *buf)
 	case BOND_STATE_BACKUP:
 		return sprintf(buf, "backup\n");
 	default:
-		return sprintf(buf, "UNKONWN\n");
+		return sprintf(buf, "UNKNOWN\n");
 	}
 }
 static SLAVE_ATTR_RO(state);
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
index db4280c..716fc37 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c
@@ -922,7 +922,7 @@ int netxen_config_ipaddr(struct netxen_adapter *adapter, __be32 ip, int cmd)
 
 	rv = netxen_send_cmd_descs(adapter, (struct cmd_desc_type0 *)&req, 1);
 	if (rv != 0) {
-		printk(KERN_ERR "%s: could not notify %s IP 0x%x reuqest\n",
+		printk(KERN_ERR "%s: could not notify %s IP 0x%x request\n",
 				adapter->netdev->name,
 				(cmd == NX_IP_UP) ? "Add" : "Remove", ip);
 	}
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 9f3adf4..a16d33f 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -951,7 +951,7 @@ void qlcnic_82xx_config_ipaddr(struct qlcnic_adapter *adapter,
 	rv = qlcnic_send_cmd_descs(adapter, (struct cmd_desc_type0 *)&req, 1);
 	if (rv != 0)
 		dev_err(&adapter->netdev->dev,
-				"could not notify %s IP 0x%x reuqest\n",
+				"could not notify %s IP 0x%x request\n",
 				(cmd == QLCNIC_IP_UP) ? "Add" : "Remove", ip);
 }
 
diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index ad61d26..a2dc486 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2056,7 +2056,7 @@ static int velocity_receive_frame(struct velocity_info *vptr, int idx)
 	struct sk_buff *skb;
 
 	if (rd->rdesc0.RSR & (RSR_STP | RSR_EDP)) {
-		VELOCITY_PRT(MSG_LEVEL_VERBOSE, KERN_ERR " %s : the received frame span multple RDs.\n", vptr->netdev->name);
+		VELOCITY_PRT(MSG_LEVEL_VERBOSE, KERN_ERR " %s : the received frame spans multiple RDs.\n", vptr->netdev->name);
 		stats->rx_length_errors++;
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 9f75afb..da46f1f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3303,7 +3303,7 @@ brcmf_configure_wpaie(struct net_device *ndev,
 
 	if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 		err = -EINVAL;
-		brcmf_err("ivalid OUI\n");
+		brcmf_err("invalid OUI\n");
 		goto exit;
 	}
 	offset += TLV_OUI_LEN;
@@ -3342,7 +3342,7 @@ brcmf_configure_wpaie(struct net_device *ndev,
 	for (i = 0; i < count; i++) {
 		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 			err = -EINVAL;
-			brcmf_err("ivalid OUI\n");
+			brcmf_err("invalid OUI\n");
 			goto exit;
 		}
 		offset += TLV_OUI_LEN;
@@ -3376,7 +3376,7 @@ brcmf_configure_wpaie(struct net_device *ndev,
 	for (i = 0; i < count; i++) {
 		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 			err = -EINVAL;
-			brcmf_err("ivalid OUI\n");
+			brcmf_err("invalid OUI\n");
 			goto exit;
 		}
 		offset += TLV_OUI_LEN;
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 86cf108..36fdd01 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -307,7 +307,7 @@ qla8044_idc_lock(struct qla_hw_data *ha)
 				 */
 				 ql_dbg(ql_dbg_p3p, vha, 0xb08a,
 				     "%s: IDC lock Recovery by %d "
-				     "failed, Retrying timout\n", __func__,
+				     "failed, Retrying timeout\n", __func__,
 				     ha->portnum);
 				 timeout = 0;
 			}
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index f80908f..d2adfb6 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3064,7 +3064,7 @@ fc_remote_port_rolechg(struct fc_rport  *rport, u32 roles)
 		ret = fc_tgt_it_nexus_create(shost, (unsigned long)rport,
 					     (char *)&rport->node_name);
 		if (ret)
-			printk(KERN_ERR "FC Remore Port tgt nexus failed %d\n",
+			printk(KERN_ERR "FC Remote Port tgt nexus failed %d\n",
 			       ret);
 	}
 
diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index a01ae97..790c145 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -620,7 +620,7 @@ static int davinci_mcasp_hw_params(struct snd_pcm_substream *substream,
 	if (mcasp->bclk_master) {
 		unsigned int bclk_freq = snd_soc_params_to_bclk(params);
 		if (mcasp->sysclk_freq % bclk_freq != 0) {
-			dev_err(mcasp->dev, "Can't produce requred BCLK\n");
+			dev_err(mcasp->dev, "Can't produce required BCLK\n");
 			return -EINVAL;
 		}
 		davinci_mcasp_set_clkdiv(
-- 
1.9.1.315.g3f09db0

