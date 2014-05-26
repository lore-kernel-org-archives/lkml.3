Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaEZSQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:16:16 -0400
Received: from s87.loopia.se ([194.9.95.110]:36038 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaEZSQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:16:15 -0400
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2014 14:16:14 EDT
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 1/1] Fix confusing uses of %d prefixed by 0x in format strings
Date: Mon, 26 May 2014 11:07:27 -0700
Message-Id: <1401127647-7913-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 arch/cris/arch-v32/drivers/cryptocop.c          | 2 +-
 drivers/atm/eni.c                               | 4 ++--
 drivers/block/DAC960.c                          | 4 ++--
 drivers/block/cciss.c                           | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 2 +-
 drivers/mfd/htc-i2cpld.c                        | 2 +-
 drivers/mfd/omap-usb-host.c                     | 2 +-
 drivers/misc/sgi-gru/grumain.c                  | 2 +-
 drivers/net/ethernet/smsc/smc911x.c             | 2 +-
 drivers/net/wireless/ath/ath6kl/init.c          | 2 +-
 drivers/net/wireless/ath/ath6kl/main.c          | 2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c        | 2 +-
 drivers/net/wireless/rtlwifi/pci.c              | 6 +++---
 drivers/parisc/dino.c                           | 2 +-
 drivers/scsi/hpsa.c                             | 2 +-
 drivers/staging/nokia_h4p/nokia_core.c          | 2 +-
 drivers/staging/rtl8821ae/pci.c                 | 6 +++---
 fs/cifs/cifs_debug.c                            | 2 +-
 fs/cifs/misc.c                                  | 4 ++--
 fs/cifs/smb2misc.c                              | 6 +++---
 sound/pci/riptide/riptide.c                     | 4 ++--
 21 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/cryptocop.c b/arch/cris/arch-v32/drivers/cryptocop.c
index 877da19..0ae4f65 100644
--- a/arch/cris/arch-v32/drivers/cryptocop.c
+++ b/arch/cris/arch-v32/drivers/cryptocop.c
@@ -3155,7 +3155,7 @@ static void print_dma_descriptors(struct cryptocop_int_operation *iop)
 	printk("print_dma_descriptors start\n");
 
 	printk("iop:\n");
-	printk("\tsid: 0x%lld\n", iop->sid);
+	printk("\tsid: 0x%llx\n", iop->sid);
 
 	printk("\tcdesc_out: 0x%p\n", iop->cdesc_out);
 	printk("\tcdesc_in: 0x%p\n", iop->cdesc_in);
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index b1955ba..d65975a 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -2155,7 +2155,7 @@ static int eni_proc_read(struct atm_dev *dev,loff_t *pos,char *page)
 
 		if (!tx->send) continue;
 		if (!--left) {
-			return sprintf(page,"tx[%d]:    0x%ld-0x%ld "
+			return sprintf(page, "tx[%d]:    0x%lx-0x%lx "
 			    "(%6ld bytes), rsv %d cps, shp %d cps%s\n",i,
 			    (unsigned long) (tx->send - eni_dev->ram),
 			    tx->send-eni_dev->ram+tx->words*4-1,tx->words*4,
@@ -2181,7 +2181,7 @@ static int eni_proc_read(struct atm_dev *dev,loff_t *pos,char *page)
 			if (--left) continue;
 			length = sprintf(page,"vcc %4d: ",vcc->vci);
 			if (eni_vcc->rx) {
-				length += sprintf(page+length,"0x%ld-0x%ld "
+				length += sprintf(page+length, "0x%lx-0x%lx "
 				    "(%6ld bytes)",
 				    (unsigned long) (eni_vcc->recv - eni_dev->ram),
 				    eni_vcc->recv-eni_dev->ram+eni_vcc->words*4-1,
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 125d845..3734545 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -2954,7 +2954,7 @@ DAC960_DetectController(struct pci_dev *PCI_Device,
 	case DAC960_PD_Controller:
 	  if (!request_region(Controller->IO_Address, 0x80,
 			      Controller->FullModelName)) {
-		DAC960_Error("IO port 0x%d busy for Controller at\n",
+		DAC960_Error("IO port 0x%x busy for Controller at\n",
 			     Controller, Controller->IO_Address);
 		goto Failure;
 	  }
@@ -2990,7 +2990,7 @@ DAC960_DetectController(struct pci_dev *PCI_Device,
 	case DAC960_P_Controller:
 	  if (!request_region(Controller->IO_Address, 0x80,
 			      Controller->FullModelName)){
-		DAC960_Error("IO port 0x%d busy for Controller at\n",
+		DAC960_Error("IO port 0x%x busy for Controller at\n",
 		   	     Controller, Controller->IO_Address);
 		goto Failure;
 	  }
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 4595c22..ca88ebe 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3841,7 +3841,7 @@ static void print_cfg_table(ctlr_info_t *h)
 	       readl(&(tb->HostWrite.CoalIntDelay)));
 	dev_dbg(&h->pdev->dev, "   Coalesce Interrupt Count = 0x%x\n",
 	       readl(&(tb->HostWrite.CoalIntCount)));
-	dev_dbg(&h->pdev->dev, "   Max outstanding commands = 0x%d\n",
+	dev_dbg(&h->pdev->dev, "   Max outstanding commands = 0x%x\n",
 	       readl(&(tb->CmdsOutMax)));
 	dev_dbg(&h->pdev->dev, "   Bus Types = 0x%x\n",
 		readl(&(tb->BusTypes)));
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 4f5e0ea..afef51c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -523,7 +523,7 @@ static int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 	WRITEL(addr, mfc_regs->e_stream_buffer_addr); /* 16B align */
 	WRITEL(size, mfc_regs->e_stream_buffer_size);
 
-	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d\n",
+	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%x\n",
 		  addr, size);
 
 	return 0;
diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index d7b2a75..e719b58 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -409,7 +409,7 @@ static int htcpld_register_chip_i2c(
 	}
 
 	i2c_set_clientdata(client, chip);
-	snprintf(client->name, I2C_NAME_SIZE, "Chip_0x%d", client->addr);
+	snprintf(client->name, I2C_NAME_SIZE, "Chip_0x%x", client->addr);
 	chip->client = client;
 
 	/* Reset the chip */
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index b48d80c..259aca8 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -647,7 +647,7 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		default:
 			omap->nports = OMAP3_HS_USB_PORTS;
 			dev_dbg(dev,
-			 "USB HOST Rev:0x%d not recognized, assuming %d ports\n",
+			 "USB HOST Rev:0x%x not recognized, assuming %d ports\n",
 			 omap->usbhs_rev, omap->nports);
 			break;
 		}
diff --git a/drivers/misc/sgi-gru/grumain.c b/drivers/misc/sgi-gru/grumain.c
index ae16c8c..a1ce324 100644
--- a/drivers/misc/sgi-gru/grumain.c
+++ b/drivers/misc/sgi-gru/grumain.c
@@ -283,7 +283,7 @@ static void gru_unload_mm_tracker(struct gru_state *gru,
 	spin_lock(&gru->gs_asid_lock);
 	BUG_ON((asids->mt_ctxbitmap & ctxbitmap) != ctxbitmap);
 	asids->mt_ctxbitmap ^= ctxbitmap;
-	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%d, asidmap 0x%lx\n",
+	gru_dbg(grudev, "gid %d, gts %p, gms %p, ctxnum 0x%x, asidmap 0x%lx\n",
 		gru->gs_gid, gts, gms, gts->ts_ctxnum, gms->ms_asidmap[0]);
 	spin_unlock(&gru->gs_asid_lock);
 	spin_unlock(&gms->ms_asid_lock);
diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 1c44e67..9778cba 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -730,7 +730,7 @@ static void smc911x_phy_detect(struct net_device *dev)
 			lp->phy_type = id1 << 16 | id2;
 	}
 
-	DBG(SMC_DEBUG_MISC, dev, "phy_id1=0x%x, phy_id2=0x%x phyaddr=0x%d\n",
+	DBG(SMC_DEBUG_MISC, dev, "phy_id1=0x%x, phy_id2=0x%x phyaddr=0x%x\n",
 	    id1, id2, lp->mii.phy_id);
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index d5ef211..d986333 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1024,7 +1024,7 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 			ar->hw.reserved_ram_size = le32_to_cpup(val);
 
 			ath6kl_dbg(ATH6KL_DBG_BOOT,
-				   "found reserved ram size ie 0x%d\n",
+				   "found reserved ram size ie 0x%x\n",
 				   ar->hw.reserved_ram_size);
 			break;
 		case ATH6KL_FW_IE_CAPABILITIES:
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d565546..4f12cf9 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -225,7 +225,7 @@ int ath6kl_diag_write32(struct ath6kl *ar, u32 address, __le32 value)
 	ret = ath6kl_hif_diag_write32(ar, address, value);
 
 	if (ret) {
-		ath6kl_err("failed to write 0x%x during diagnose window to 0x%d\n",
+		ath6kl_err("failed to write 0x%x during diagnose window to 0x%x\n",
 			   address, value);
 		return ret;
 	}
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index c159c05..7d6fd59 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4633,7 +4633,7 @@ il4965_store_tx_power(struct device *d, struct device_attribute *attr,
 	else {
 		ret = il_set_tx_power(il, val, false);
 		if (ret)
-			IL_ERR("failed setting tx power (0x%d).\n", ret);
+			IL_ERR("failed setting tx power (0x%x).\n", ret);
 		else
 			ret = count;
 	}
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index dae5525..06c6318 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -646,7 +646,7 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 				== 2) {
 
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
-				 "more desc left, wake skb_queue@%d, ring->idx = %d, skb_queue_len = 0x%d\n",
+				 "more desc left, wake skb_queue@%d, ring->idx = %d, skb_queue_len = 0x%x\n",
 				 prio, ring->idx,
 				 skb_queue_len(&ring->queue));
 
@@ -1476,7 +1476,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 
 		if ((own == 1) && (hw_queue != BEACON_QUEUE)) {
 			RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-				 "No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
+				 "No more TX desc@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%x\n",
 				 hw_queue, ring->idx, idx,
 				 skb_queue_len(&ring->queue));
 
@@ -1518,7 +1518,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 	if ((ring->entries - skb_queue_len(&ring->queue)) < 2 &&
 	    hw_queue != BEACON_QUEUE) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_LOUD,
-			 "less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%d\n",
+			 "less desc left, stop skb_queue@%d, ring->idx = %d, idx = %d, skb_queue_len = 0x%x\n",
 			 hw_queue, ring->idx, idx,
 			 skb_queue_len(&ring->queue));
 
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 9eae983..a0580af 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -913,7 +913,7 @@ static int __init dino_probe(struct parisc_device *dev)
 	printk("%s version %s found at 0x%lx\n", name, version, hpa);
 
 	if (!request_mem_region(hpa, PAGE_SIZE, name)) {
-		printk(KERN_ERR "DINO: Hey! Someone took my MMIO space (0x%ld)!\n",
+		printk(KERN_ERR "DINO: Hey! Someone took my MMIO space (0x%lx)!\n",
 			hpa);
 		return 1;
 	}
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 13d4cc5..6f9eecc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6097,7 +6097,7 @@ static void print_cfg_table(struct device *dev, struct CfgTable *tb)
 	       readl(&(tb->HostWrite.CoalIntDelay)));
 	dev_info(dev, "   Coalesce Interrupt Count = 0x%x\n",
 	       readl(&(tb->HostWrite.CoalIntCount)));
-	dev_info(dev, "   Max outstanding commands = 0x%d\n",
+	dev_info(dev, "   Max outstanding commands = 0x%x\n",
 	       readl(&(tb->CmdsOutMax)));
 	dev_info(dev, "   Bus Types = 0x%x\n", readl(&(tb->BusTypes)));
 	for (i = 0; i < 16; i++)
diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
index 5e19cd6..ef4fd37 100644
--- a/drivers/staging/nokia_h4p/nokia_core.c
+++ b/drivers/staging/nokia_h4p/nokia_core.c
@@ -1112,7 +1112,7 @@ static int hci_h4p_probe(struct platform_device *pdev)
 				    GPIOF_OUT_INIT_LOW, "bt_wakeup");
 
 	if (err < 0) {
-		dev_err(info->dev, "Cannot get GPIO line 0x%d",
+		dev_err(info->dev, "Cannot get GPIO line 0x%x",
 			info->bt_wakeup_gpio);
 		return err;
 	}
diff --git a/drivers/staging/rtl8821ae/pci.c b/drivers/staging/rtl8821ae/pci.c
index eef3ebc..926faba 100644
--- a/drivers/staging/rtl8821ae/pci.c
+++ b/drivers/staging/rtl8821ae/pci.c
@@ -712,7 +712,7 @@ static void _rtl_pci_tx_isr(struct ieee80211_hw *hw, int prio)
 			RT_TRACE(COMP_ERR, DBG_LOUD,
 					("more desc left, wake"
 					 "skb_queue@%d,ring->idx = %d,"
-					 "skb_queue_len = 0x%d\n",
+					 "skb_queue_len = 0x%x\n",
 					 prio, ring->idx,
 					 skb_queue_len(&ring->queue)));
 
@@ -1751,7 +1751,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 		if ((own == 1) && (hw_queue != BEACON_QUEUE)) {
 			RT_TRACE(COMP_ERR, DBG_WARNING,
 				 ("No more TX desc@%d, ring->idx = %d,"
-				  "idx = %d, skb_queue_len = 0x%d\n",
+				  "idx = %d, skb_queue_len = 0x%x\n",
 				  hw_queue, ring->idx, idx,
 				  skb_queue_len(&ring->queue)));
 
@@ -1806,7 +1806,7 @@ static int rtl_pci_tx(struct ieee80211_hw *hw,
 		RT_TRACE(COMP_ERR, DBG_LOUD,
 			 ("less desc left, stop skb_queue@%d, "
 			  "ring->idx = %d,"
-			  "idx = %d, skb_queue_len = 0x%d\n",
+			  "idx = %d, skb_queue_len = 0x%x\n",
 			  hw_queue, ring->idx, idx,
 			  skb_queue_len(&ring->queue)));
 
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index f3ac415..ff22eeb 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -213,7 +213,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 						   tcon->nativeFileSystem);
 				}
 				seq_printf(m, "DevInfo: 0x%x Attributes: 0x%x"
-					"\n\tPathComponentMax: %d Status: 0x%d",
+					"\n\tPathComponentMax: %d Status: 0x%x",
 					le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics),
 					le32_to_cpu(tcon->fsAttrInfo.Attributes),
 					le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 3b0c62e..757520d 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -414,7 +414,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 			return true;
 		}
 		if (pSMBr->hdr.Status.CifsError) {
-			cifs_dbg(FYI, "notify err 0x%d\n",
+			cifs_dbg(FYI, "notify err 0x%x\n",
 				 pSMBr->hdr.Status.CifsError);
 			return true;
 		}
@@ -441,7 +441,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 	if (pSMB->hdr.WordCount != 8)
 		return false;
 
-	cifs_dbg(FYI, "oplock type 0x%d level 0x%d\n",
+	cifs_dbg(FYI, "oplock type 0x%x level 0x%x\n",
 		 pSMB->LockType, pSMB->OplockLevel);
 	if (!(pSMB->LockType & LOCKING_ANDX_OPLOCK_RELEASE))
 		return false;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 36867bd..da0faf6 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -437,7 +437,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 			continue;
 
 		cifs_dbg(FYI, "found in the open list\n");
-		cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
+		cifs_dbg(FYI, "lease key match, lease break 0x%x\n",
 			 le32_to_cpu(rsp->NewLeaseState));
 
 		server->ops->set_oplock_level(cinode, lease_state, 0, NULL);
@@ -467,7 +467,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 		}
 
 		cifs_dbg(FYI, "found in the pending open list\n");
-		cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
+		cifs_dbg(FYI, "lease key match, lease break 0x%x\n",
 			 le32_to_cpu(rsp->NewLeaseState));
 
 		open->oplock = lease_state;
@@ -546,7 +546,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 			return false;
 	}
 
-	cifs_dbg(FYI, "oplock level 0x%d\n", rsp->OplockLevel);
+	cifs_dbg(FYI, "oplock level 0x%x\n", rsp->OplockLevel);
 
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index b4a8278..f0315c3 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -941,7 +941,7 @@ setmixer(struct cmdif *cif, short num, unsigned short rval, unsigned short lval)
 	union cmdret rptr = CMDRET_ZERO;
 	int i = 0;
 
-	snd_printdd("sent mixer %d: 0x%d 0x%d\n", num, rval, lval);
+	snd_printdd("sent mixer %d: 0x%x 0x%x\n", num, rval, lval);
 	do {
 		SEND_SDGV(cif, num, num, rval, lval);
 		SEND_RDGV(cif, num, num, &rptr);
@@ -1080,7 +1080,7 @@ getmixer(struct cmdif *cif, short num, unsigned short *rval,
 		return -EIO;
 	*rval = rptr.retwords[0];
 	*lval = rptr.retwords[1];
-	snd_printdd("got mixer %d: 0x%d 0x%d\n", num, *rval, *lval);
+	snd_printdd("got mixer %d: 0x%x 0x%x\n", num, *rval, *lval);
 	return 0;
 }
 
-- 
1.9.1.423.g4596e3a

