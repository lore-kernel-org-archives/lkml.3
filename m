Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3JVPNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:13:50 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:41662 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3JVPNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:13:20 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Joe Perches <joe@perches.com>, Arend van Spriel <arend@broadcom.com>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        Eran Harary <eran.harary@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the wireless-next tree
Date: Tue, 22 Oct 2013 17:10:46 +0200
Message-Id: <1382454649-16442-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382454649-16442-1-git-send-email-treding@nvidia.com>
References: <1382369814-7582-1-git-send-email-treding@nvidia.com>
 <1382454649-16442-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the wireless-next tree got conflicts in

	drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
	drivers/net/wireless/iwlwifi/pcie/drv.c

caused by commits 9bd91f3 (brcm80211: Remove extern from function prototypes)
and a413e39 (brcmfmac: fix brcmf_sdcard_recv_chain() for host without sg
support) as well as b499266 (iwlwifi: pcie: add new SKUs for 7000 & 3160 NIC
series) and c4aee08 (iwlwifi: Support 7265 devices).

I fixed them up (see below). Please verify that the resolution looks good.

Thanks,
Thierry
---
diff --cc drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index c9b06b4,1b034ea..bfadcb8
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@@ -206,17 -210,22 +210,18 @@@ int brcmf_sdio_regrw_helper(struct brcm
   * Returns 0 or error code.
   * NOTE: Async operation is not currently supported.
   */
 -extern int
 -brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 -		      uint flags, struct sk_buff_head *pktq);
 -extern int
 -brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 -		      uint flags, u8 *buf, uint nbytes);
 -
 -extern int
 -brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 -		      uint flags, struct sk_buff *pkt);
 -extern int
 -brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 -		      uint flags, u8 *buf, uint nbytes);
 -extern int
 -brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 -			uint flags, struct sk_buff_head *pktq, uint totlen);
 +int brcmf_sdcard_send_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 +			  uint flags, struct sk_buff_head *pktq);
 +int brcmf_sdcard_send_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 +			  uint flags, u8 *buf, uint nbytes);
 +
 +int brcmf_sdcard_recv_pkt(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 +			  uint flags, struct sk_buff *pkt);
 +int brcmf_sdcard_recv_buf(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
 +			  uint flags, u8 *buf, uint nbytes);
 +int brcmf_sdcard_recv_chain(struct brcmf_sdio_dev *sdiodev, u32 addr, uint fn,
- 			    uint flags, struct sk_buff_head *pktq);
++			    uint flags, struct sk_buff_head *pktq,
++			    uint totlen);
  
  /* Flags bits */
  
diff --cc drivers/net/wireless/iwlwifi/pcie/drv.c
index 26108a1,ddf15e1..941c0c8
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@@ -268,12 -258,10 +268,12 @@@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_c
  #endif /* CONFIG_IWLDVM */
  
  #if IS_ENABLED(CONFIG_IWLMVM)
- /* 7000 Series */
+ /* 7260 Series */
  	{IWL_PCI_DEVICE(0x08B1, 0x4070, iwl7260_2ac_cfg)},
 +	{IWL_PCI_DEVICE(0x08B1, 0x4072, iwl7260_2ac_cfg)},
  	{IWL_PCI_DEVICE(0x08B1, 0x4170, iwl7260_2ac_cfg)},
  	{IWL_PCI_DEVICE(0x08B1, 0x4060, iwl7260_2n_cfg)},
 +	{IWL_PCI_DEVICE(0x08B1, 0x406A, iwl7260_2n_cfg)},
  	{IWL_PCI_DEVICE(0x08B1, 0x4160, iwl7260_2n_cfg)},
  	{IWL_PCI_DEVICE(0x08B1, 0x4062, iwl7260_n_cfg)},
  	{IWL_PCI_DEVICE(0x08B1, 0x4162, iwl7260_n_cfg)},
@@@ -349,7 -308,9 +349,10 @@@
  	{IWL_PCI_DEVICE(0x08B3, 0x8062, iwl3160_n_cfg)},
  	{IWL_PCI_DEVICE(0x08B4, 0x8270, iwl3160_2ac_cfg)},
  	{IWL_PCI_DEVICE(0x08B3, 0x8470, iwl3160_2ac_cfg)},
 +	{IWL_PCI_DEVICE(0x08B3, 0x8570, iwl3160_2ac_cfg)},
+ 
+ /* 7265 Series */
+ 	{IWL_PCI_DEVICE(0x095A, 0x5010, iwl7265_2ac_cfg)},
  #endif /* CONFIG_IWLMVM */
  
  	{0}
