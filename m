Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3JGPs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:48:59 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:45357 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3JGPsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:48:54 -0400
Message-ID: <5252D7E4.2050509@lwfinger.net>
Date: Mon, 07 Oct 2013 10:48:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arend van Spriel <arend@broadcom.com>, Joe Perches <joe@perches.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the wireless-next tree
References: <1381159127-11067-1-git-send-email-treding@nvidia.com> <1381159127-11067-5-git-send-email-treding@nvidia.com>
In-Reply-To: <1381159127-11067-5-git-send-email-treding@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 10:18 AM, Thierry Reding wrote:
> Today's linux-next merge of the wireless-next tree got conflicts in:
>
> 	drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
> 	drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
> 	drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
> 	drivers/net/wireless/rtlwifi/rtl8192de/phy.h
> 	drivers/net/wireless/rtlwifi/rtl8723ae/phy.h
>
> caused by commits 05f3820 (brcmfmac: rework rx path bus interface) and
> 9bd91f3 (brcm80211: Remove extern from function prototypes) as well as
> commits d41200a (rtlwifi: rtl8188ee: Convert driver to use new
> rtl_phy_scan_operation_backup() routine), 3764eb7 (rtlwifi: rtl8192ce:
> Convert driver to use new rtl_phy_scan_operation_backup() routine),
> 6483033 (rtlwifi: rtl8192ce: Convert driver to use new
> rtl_phy_scan_operation_backup() routine), 3fc0165 (rtlwifi: rtl8723ae:
> Convert driver to use new rtl_phy_scan_operation_backup() routine) and
> a958df5 (rtlwifi: Remove extern from function prototypes).
>
> I fixed them up (see below). Please verify that the resolution looks
> correct.
>
> Thanks,
> Thierry
> ---
> diff --cc drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
> index 7f1340d,200ee9b..a6eb09e
> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
> @@@ -132,34 -132,34 +132,34 @@@ struct pktq *brcmf_bus_gettxq(struct br
>     * interface functions from common layer
>     */
>
>   -extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
>   -			 struct sk_buff *pkt, int prec);
>   +bool brcmf_c_prec_enq(struct device *dev, struct pktq *q, struct sk_buff *pkt,
>   +		      int prec);
>
>    /* Receive frame for delivery to OS.  Callee disposes of rxp. */
> - void brcmf_rx_frames(struct device *dev, struct sk_buff_head *rxlist);
>   -extern void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp);
> ++void brcmf_rx_frame(struct device *dev, struct sk_buff *rxp);
>
>    /* Indication from bus module regarding presence/insertion of dongle. */
>   -extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
>   +int brcmf_attach(uint bus_hdrlen, struct device *dev);
>    /* Indication from bus module regarding removal/absence of dongle */
>   -extern void brcmf_detach(struct device *dev);
>   +void brcmf_detach(struct device *dev);
>    /* Indication from bus module that dongle should be reset */
>   -extern void brcmf_dev_reset(struct device *dev);
>   +void brcmf_dev_reset(struct device *dev);
>    /* Indication from bus module to change flow-control state */
>   -extern void brcmf_txflowblock(struct device *dev, bool state);
>   +void brcmf_txflowblock(struct device *dev, bool state);
>
>    /* Notify the bus has transferred the tx packet to firmware */
>   -extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
>   -			     bool success);
>   +void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success);
>
>   -extern int brcmf_bus_start(struct device *dev);
>   +int brcmf_bus_start(struct device *dev);
>
>    #ifdef CONFIG_BRCMFMAC_SDIO
>   -extern void brcmf_sdio_exit(void);
>   -extern void brcmf_sdio_init(void);
>   +void brcmf_sdio_exit(void);
>   +void brcmf_sdio_init(void);
>   +void brcmf_sdio_register(void);
>    #endif
>    #ifdef CONFIG_BRCMFMAC_USB
>   -extern void brcmf_usb_exit(void);
>   -extern void brcmf_usb_init(void);
>   +void brcmf_usb_exit(void);
>   +void brcmf_usb_register(void);
>    #endif
>
>    #endif				/* _BRCMF_BUS_H_ */
> diff --cc drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
> index 71ddf4f,d4545f0..8e1f1be
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
> @@@ -200,26 -200,29 +200,25 @@@ enum _ANT_DIV_TYPE
>    	CGCS_RX_SW_ANTDIV		= 0x05,
>    };
>
>   -extern u32 rtl88e_phy_query_bb_reg(struct ieee80211_hw *hw,
>   -				   u32 regaddr, u32 bitmask);
>   -extern void rtl88e_phy_set_bb_reg(struct ieee80211_hw *hw,
>   -				  u32 regaddr, u32 bitmask, u32 data);
>   -extern u32 rtl88e_phy_query_rf_reg(struct ieee80211_hw *hw,
>   -				   enum radio_path rfpath, u32 regaddr,
>   -				   u32 bitmask);
>   -extern void rtl88e_phy_set_rf_reg(struct ieee80211_hw *hw,
>   -				  enum radio_path rfpath, u32 regaddr,
>   -				  u32 bitmask, u32 data);
>   -extern bool rtl88e_phy_mac_config(struct ieee80211_hw *hw);
>   -extern bool rtl88e_phy_bb_config(struct ieee80211_hw *hw);
>   -extern bool rtl88e_phy_rf_config(struct ieee80211_hw *hw);
>   -extern void rtl88e_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
>   -extern void rtl88e_phy_get_txpower_level(struct ieee80211_hw *hw,
>   -					 long *powerlevel);
>   -extern void rtl88e_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel);
>   -extern void rtl88e_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
>   -extern void rtl88e_phy_set_bw_mode(struct ieee80211_hw *hw,
>   -				   enum nl80211_channel_type ch_type);
>   -extern void rtl88e_phy_sw_chnl_callback(struct ieee80211_hw *hw);
>   -extern u8 rtl88e_phy_sw_chnl(struct ieee80211_hw *hw);
>   -extern void rtl88e_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery);
>   +u32 rtl88e_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask);
>   +void rtl88e_phy_set_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
>   +			   u32 data);
>   +u32 rtl88e_phy_query_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
>   +			    u32 regaddr, u32 bitmask);
>   +void rtl88e_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
>   +			   u32 regaddr, u32 bitmask, u32 data);
>   +bool rtl88e_phy_mac_config(struct ieee80211_hw *hw);
>   +bool rtl88e_phy_bb_config(struct ieee80211_hw *hw);
>   +bool rtl88e_phy_rf_config(struct ieee80211_hw *hw);
>   +void rtl88e_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
>   +void rtl88e_phy_get_txpower_level(struct ieee80211_hw *hw, long *powerlevel);
>   +void rtl88e_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel);
> - void rtl88e_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation);
>   +void rtl88e_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
>   +void rtl88e_phy_set_bw_mode(struct ieee80211_hw *hw,
>   +			    enum nl80211_channel_type ch_type);
>   +void rtl88e_phy_sw_chnl_callback(struct ieee80211_hw *hw);
>   +u8 rtl88e_phy_sw_chnl(struct ieee80211_hw *hw);
>   +void rtl88e_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery);
>    void rtl88e_phy_lc_calibrate(struct ieee80211_hw *hw);
>    void rtl88e_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain);
>    bool rtl88e_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
> diff --cc drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
> index f8973e5,aeb268b..ff32b5b
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
> @@@ -199,14 -200,15 +197,13 @@@ bool rtl92c_phy_mac_config(struct ieee8
>    bool rtl92ce_phy_bb_config(struct ieee80211_hw *hw);
>    bool rtl92c_phy_rf_config(struct ieee80211_hw *hw);
>    bool rtl92c_phy_config_rf_with_feaderfile(struct ieee80211_hw *hw,
>   -						 enum radio_path rfpath);
>   +					  enum radio_path rfpath);
>    void rtl92c_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
>   -void rtl92c_phy_get_txpower_level(struct ieee80211_hw *hw,
>   -					 long *powerlevel);
>   +void rtl92c_phy_get_txpower_level(struct ieee80211_hw *hw, long *powerlevel);
>    void rtl92c_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel);
>   -bool rtl92c_phy_update_txpower_dbm(struct ieee80211_hw *hw,
>   -					  long power_indbm);
>   +bool rtl92c_phy_update_txpower_dbm(struct ieee80211_hw *hw, long power_indbm);
> - void rtl92c_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation);
>    void rtl92c_phy_set_bw_mode(struct ieee80211_hw *hw,
>   -				   enum nl80211_channel_type ch_type);
>   +			    enum nl80211_channel_type ch_type);
>    void rtl92c_phy_sw_chnl_callback(struct ieee80211_hw *hw);
>    u8 rtl92c_phy_sw_chnl(struct ieee80211_hw *hw);
>    void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery);
> @@@ -217,10 -220,10 +214,9 @@@ void _rtl92ce_phy_lc_calibrate(struct i
>    void rtl92c_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain);
>    bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
>    					  enum radio_path rfpath);
>   -bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
>   -					      u32 rfpath);
>   +bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw, u32 rfpath);
> - bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
>    bool rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
>   -					  enum rf_pwrstate rfpwr_state);
>   +				    enum rf_pwrstate rfpwr_state);
>    void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
>    bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
>    void rtl92c_phy_set_io(struct ieee80211_hw *hw);
> diff --cc drivers/net/wireless/rtlwifi/rtl8192de/phy.h
> index 0f993f4,bef3040..33df0d1c
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.h
> @@@ -127,24 -125,26 +125,23 @@@ static inline void rtl92d_release_cckan
>    			*flag);
>    }
>
>   -extern u32 rtl92d_phy_query_bb_reg(struct ieee80211_hw *hw,
>   -				   u32 regaddr, u32 bitmask);
>   -extern void rtl92d_phy_set_bb_reg(struct ieee80211_hw *hw,
>   -				  u32 regaddr, u32 bitmask, u32 data);
>   -extern u32 rtl92d_phy_query_rf_reg(struct ieee80211_hw *hw,
>   -				   enum radio_path rfpath, u32 regaddr,
>   -				   u32 bitmask);
>   -extern void rtl92d_phy_set_rf_reg(struct ieee80211_hw *hw,
>   -				  enum radio_path rfpath, u32 regaddr,
>   -				  u32 bitmask, u32 data);
>   -extern bool rtl92d_phy_mac_config(struct ieee80211_hw *hw);
>   -extern bool rtl92d_phy_bb_config(struct ieee80211_hw *hw);
>   -extern bool rtl92d_phy_rf_config(struct ieee80211_hw *hw);
>   -extern bool rtl92c_phy_config_rf_with_feaderfile(struct ieee80211_hw *hw,
>   -						 enum radio_path rfpath);
>   -extern void rtl92d_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
>   -extern void rtl92d_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel);
>   -extern void rtl92d_phy_set_bw_mode(struct ieee80211_hw *hw,
>   -				   enum nl80211_channel_type ch_type);
>   -extern u8 rtl92d_phy_sw_chnl(struct ieee80211_hw *hw);
>   +u32 rtl92d_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask);
>   +void rtl92d_phy_set_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
>   +			   u32 data);
>   +u32 rtl92d_phy_query_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
>   +			    u32 regaddr, u32 bitmask);
>   +void rtl92d_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
>   +			   u32 regaddr, u32 bitmask, u32 data);
>   +bool rtl92d_phy_mac_config(struct ieee80211_hw *hw);
>   +bool rtl92d_phy_bb_config(struct ieee80211_hw *hw);
>   +bool rtl92d_phy_rf_config(struct ieee80211_hw *hw);
>   +bool rtl92c_phy_config_rf_with_feaderfile(struct ieee80211_hw *hw,
>   +					  enum radio_path rfpath);
>   +void rtl92d_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
>   +void rtl92d_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel);
> - void rtl92d_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation);
>   +void rtl92d_phy_set_bw_mode(struct ieee80211_hw *hw,
>   +			    enum nl80211_channel_type ch_type);
>   +u8 rtl92d_phy_sw_chnl(struct ieee80211_hw *hw);
>    bool rtl92d_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
>    					  enum rf_content content,
>    					  enum radio_path rfpath);
> diff --cc drivers/net/wireless/rtlwifi/rtl8723ae/phy.h
> index bbb950d,3d8f9e3..c3adc72
> --- a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8723ae/phy.h
> @@@ -183,33 -183,34 +183,32 @@@ struct tx_power_struct
>    	u32 mcs_original_offset[4][16];
>    };
>
>   -extern u32 rtl8723ae_phy_query_bb_reg(struct ieee80211_hw *hw,
>   -				      u32 regaddr, u32 bitmask);
>   -extern void rtl8723ae_phy_set_bb_reg(struct ieee80211_hw *hw,
>   -				     u32 regaddr, u32 bitmask, u32 data);
>   -extern u32 rtl8723ae_phy_query_rf_reg(struct ieee80211_hw *hw,
>   -				      enum radio_path rfpath, u32 regaddr,
>   -				      u32 bitmask);
>   -extern void rtl8723ae_phy_set_rf_reg(struct ieee80211_hw *hw,
>   -				     enum radio_path rfpath, u32 regaddr,
>   -				     u32 bitmask, u32 data);
>   -extern bool rtl8723ae_phy_mac_config(struct ieee80211_hw *hw);
>   -extern bool rtl8723ae_phy_bb_config(struct ieee80211_hw *hw);
>   -extern bool rtl8723ae_phy_rf_config(struct ieee80211_hw *hw);
>   -extern bool rtl92c_phy_config_rf_with_feaderfile(struct ieee80211_hw *hw,
>   -						 enum radio_path rfpath);
>   -extern void rtl8723ae_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
>   -extern void rtl8723ae_phy_get_txpower_level(struct ieee80211_hw *hw,
>   -					    long *powerlevel);
>   -extern void rtl8723ae_phy_set_txpower_level(struct ieee80211_hw *hw,
>   -					    u8 channel);
>   -extern bool rtl8723ae_phy_update_txpower_dbm(struct ieee80211_hw *hw,
>   -					     long power_indbm);
>   -extern void rtl8723ae_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
>   -extern void rtl8723ae_phy_set_bw_mode(struct ieee80211_hw *hw,
>   -				      enum nl80211_channel_type ch_type);
>   -extern void rtl8723ae_phy_sw_chnl_callback(struct ieee80211_hw *hw);
>   -extern u8 rtl8723ae_phy_sw_chnl(struct ieee80211_hw *hw);
>   -extern void rtl8723ae_phy_iq_calibrate(struct ieee80211_hw *hw, bool recovery);
>   +u32 rtl8723ae_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr,
>   +			       u32 bitmask);
>   +void rtl8723ae_phy_set_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
>   +			      u32 data);
>   +u32 rtl8723ae_phy_query_rf_reg(struct ieee80211_hw *hw,
>   +			       enum radio_path rfpath, u32 regaddr,
>   +			       u32 bitmask);
>   +void rtl8723ae_phy_set_rf_reg(struct ieee80211_hw *hw,
>   +			      enum radio_path rfpath, u32 regaddr, u32 bitmask,
>   +			      u32 data);
>   +bool rtl8723ae_phy_mac_config(struct ieee80211_hw *hw);
>   +bool rtl8723ae_phy_bb_config(struct ieee80211_hw *hw);
>   +bool rtl8723ae_phy_rf_config(struct ieee80211_hw *hw);
>   +bool rtl92c_phy_config_rf_with_feaderfile(struct ieee80211_hw *hw,
>   +					  enum radio_path rfpath);
>   +void rtl8723ae_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
>   +void rtl8723ae_phy_get_txpower_level(struct ieee80211_hw *hw, long *powerlevel);
>   +void rtl8723ae_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel);
>   +bool rtl8723ae_phy_update_txpower_dbm(struct ieee80211_hw *hw,
>   +				      long power_indbm);
> - void rtl8723ae_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation);
>   +void rtl8723ae_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
>   +void rtl8723ae_phy_set_bw_mode(struct ieee80211_hw *hw,
>   +			       enum nl80211_channel_type ch_type);
>   +void rtl8723ae_phy_sw_chnl_callback(struct ieee80211_hw *hw);
>   +u8 rtl8723ae_phy_sw_chnl(struct ieee80211_hw *hw);
>   +void rtl8723ae_phy_iq_calibrate(struct ieee80211_hw *hw, bool recovery);
>    void rtl8723ae_phy_lc_calibrate(struct ieee80211_hw *hw);
>    void rtl8723ae_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain);
>    bool rtl8723ae_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,

Yes, the patches for rtlwifi problems are correct. All of these problems would 
have been avoided if changes to wireless drivers were sent to the wireless tree 
rather than direct submission to net-next!!!!

Larry


