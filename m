Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaBNVtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:49:00 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56366 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaBNVs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:48:58 -0500
From: Peter Wu <lekensteyn@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming_Li <chaoming_li@realsil.com.cn>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/3] rtlwifi: remove unused allow_all_destaddr functions
Date: Fri, 14 Feb 2014 22:48:54 +0100
Message-ID: <5255317.CRdrWcWANY@al>
User-Agent: KMail/4.12.2 (Linux/3.13.2-custom; KDE/4.12.2; x86_64; ; )
In-Reply-To: <52FE8CD8.1050409@lwfinger.net>
References: <1392401026-18417-1-git-send-email-lekensteyn@gmail.com> <1392401026-18417-4-git-send-email-lekensteyn@gmail.com> <52FE8CD8.1050409@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 February 2014 15:38:32 Larry Finger wrote:
> On 02/14/2014 12:03 PM, Peter Wu wrote:
> > Unused as configure_filter takes care of setting/clearing RCR_AAP.
> > 
> > Signed-off-by: Peter Wu <lekensteyn@gmail.com>
> 
> NACK - at least for now. This patch has merge conflicts for the set of
> patches that add the rtl8723be driver, and would cause build errors if the
> merge were fixed. I will hang on to it and apply it later when the
> rtl8723be merge is done.

Fair enough, the next patch will strip even more then :-)

> @John Linville: You should apply #1 and 2 of this series, but skip this one.
> 
> Thanks,
> 
> Larry
> 
> PS: I just noticed the John Linville was not Cc'd on these patches. For
> wireless, such patches should be sent to him with a Cc to the wireless ML.

Ah, I will keep that in mind for future patches. The first reply is now
also sent with John in the recipients list.

Thanks,
Peter

> > ---
> > 
> >   drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 20 --------------------
> >   drivers/net/wireless/rtlwifi/rtl8188ee/hw.h |  2 --
> >   drivers/net/wireless/rtlwifi/rtl8188ee/sw.c |  1 -
> >   drivers/net/wireless/rtlwifi/rtl8192ce/hw.c | 21 ---------------------
> >   drivers/net/wireless/rtlwifi/rtl8192ce/hw.h |  2 --
> >   drivers/net/wireless/rtlwifi/rtl8192ce/sw.c |  1 -
> >   drivers/net/wireless/rtlwifi/rtl8192se/hw.c | 20 --------------------
> >   drivers/net/wireless/rtlwifi/rtl8192se/hw.h |  2 --
> >   drivers/net/wireless/rtlwifi/rtl8192se/sw.c |  1 -
> >   drivers/net/wireless/rtlwifi/rtl8723ae/hw.c | 21 ---------------------
> >   drivers/net/wireless/rtlwifi/rtl8723ae/hw.h |  2 --
> >   drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |  1 -
> >   drivers/net/wireless/rtlwifi/wifi.h         |  2 --
> >   13 files changed, 96 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> > b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c index ce2226c..c0e7f62
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> > @@ -2510,23 +2510,3 @@ void rtl88ee_suspend(struct ieee80211_hw *hw)
> > 
> >   void rtl88ee_resume(struct ieee80211_hw *hw)
> >   {
> >   }
> > 
> > -
> > -/* Turn on AAP (RCR:bit 0) for promicuous mode. */
> > -void rtl88ee_allow_all_destaddr(struct ieee80211_hw *hw,
> > -				bool allow_all_da, bool write_into_reg)
> > -{
> > -	struct rtl_priv *rtlpriv = rtl_priv(hw);
> > -	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
> > -
> > -	if (allow_all_da) /* Set BIT0 */
> > -		rtlpci->receive_config |= RCR_AAP;
> > -	 else /* Clear BIT0 */
> > -		rtlpci->receive_config &= ~RCR_AAP;
> > -
> > -	if (write_into_reg)
> > -		rtl_write_dword(rtlpriv, REG_RCR, rtlpci->receive_config);
> > -
> > -	RT_TRACE(rtlpriv, COMP_TURBO | COMP_INIT, DBG_LOUD,
> > -		 "receive_config = 0x%08X, write_into_reg =%d\n",
> > -		 rtlpci->receive_config, write_into_reg);
> > -}
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.h
> > b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.h index b4460a4..1850fde
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.h
> > +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.h
> > @@ -61,8 +61,6 @@ void rtl8188ee_bt_reg_init(struct ieee80211_hw *hw);
> > 
> >   void rtl8188ee_bt_hw_init(struct ieee80211_hw *hw);
> >   void rtl88ee_suspend(struct ieee80211_hw *hw);
> >   void rtl88ee_resume(struct ieee80211_hw *hw);
> > 
> > -void rtl88ee_allow_all_destaddr(struct ieee80211_hw *hw,
> > -				bool allow_all_da, bool write_into_reg);
> > 
> >   void rtl88ee_fw_clk_off_timer_callback(unsigned long data);
> >   
> >   #endif
> > 
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> > b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c index 347af1e..41de6f3
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> > @@ -254,7 +254,6 @@ static struct rtl_hal_ops rtl8188ee_hal_ops = {
> > 
> >   	.enable_hw_sec = rtl88ee_enable_hw_security_config,
> >   	.set_key = rtl88ee_set_key,
> >   	.init_sw_leds = rtl88ee_init_sw_leds,
> > 
> > -	.allow_all_destaddr = rtl88ee_allow_all_destaddr,
> > 
> >   	.get_bbreg = rtl88e_phy_query_bb_reg,
> >   	.set_bbreg = rtl88e_phy_set_bb_reg,
> >   	.get_rfreg = rtl88e_phy_query_rf_reg,
> > 
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> > b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c index 25e178c..8b3134a
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
> > @@ -2407,24 +2407,3 @@ void rtl92ce_suspend(struct ieee80211_hw *hw)
> > 
> >   void rtl92ce_resume(struct ieee80211_hw *hw)
> >   {
> >   }
> > 
> > -
> > -/* Turn on AAP (RCR:bit 0) for promicuous mode. */
> > -void rtl92ce_allow_all_destaddr(struct ieee80211_hw *hw,
> > -	bool allow_all_da, bool write_into_reg)
> > -{
> > -	struct rtl_priv *rtlpriv = rtl_priv(hw);
> > -	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
> > -
> > -	if (allow_all_da) {/* Set BIT0 */
> > -		rtlpci->receive_config |= RCR_AAP;
> > -	} else {/* Clear BIT0 */
> > -		rtlpci->receive_config &= ~RCR_AAP;
> > -	}
> > -
> > -	if (write_into_reg)
> > -		rtl_write_dword(rtlpriv, REG_RCR, rtlpci->receive_config);
> > -
> > -	RT_TRACE(rtlpriv, COMP_TURBO | COMP_INIT, DBG_LOUD,
> > -		 "receive_config=0x%08X, write_into_reg=%d\n",
> > -		 rtlpci->receive_config, write_into_reg);
> > -}
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
> > b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h index 2d063b0..5533070
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
> > +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
> > @@ -76,7 +76,5 @@ void rtl8192ce_bt_reg_init(struct ieee80211_hw *hw);
> > 
> >   void rtl8192ce_bt_hw_init(struct ieee80211_hw *hw);
> >   void rtl92ce_suspend(struct ieee80211_hw *hw);
> >   void rtl92ce_resume(struct ieee80211_hw *hw);
> > 
> > -void rtl92ce_allow_all_destaddr(struct ieee80211_hw *hw,
> > -				bool allow_all_da, bool write_into_reg);
> > 
> >   #endif
> > 
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
> > b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c index b790320..12f21f4
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
> > @@ -229,7 +229,6 @@ static struct rtl_hal_ops rtl8192ce_hal_ops = {
> > 
> >   	.enable_hw_sec = rtl92ce_enable_hw_security_config,
> >   	.set_key = rtl92ce_set_key,
> >   	.init_sw_leds = rtl92ce_init_sw_leds,
> > 
> > -	.allow_all_destaddr = rtl92ce_allow_all_destaddr,
> > 
> >   	.get_bbreg = rtl92c_phy_query_bb_reg,
> >   	.set_bbreg = rtl92c_phy_set_bb_reg,
> >   	.set_rfreg = rtl92ce_phy_set_rf_reg,
> > 
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
> > b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c index 5aa39ef..8c7aca4
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
> > @@ -2531,23 +2531,3 @@ void rtl92se_resume(struct ieee80211_hw *hw)
> > 
> >   		pci_write_config_dword(rtlpci->pdev, 0x40,
> >   		
> >   			val & 0xffff00ff);
> >   
> >   }
> > 
> > -
> > -/* Turn on AAP (RCR:bit 0) for promicuous mode. */
> > -void rtl92se_allow_all_destaddr(struct ieee80211_hw *hw,
> > -				bool allow_all_da, bool write_into_reg)
> > -{
> > -	struct rtl_priv *rtlpriv = rtl_priv(hw);
> > -	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
> > -
> > -	if (allow_all_da) /* Set BIT0 */
> > -		rtlpci->receive_config |= RCR_AAP;
> > -	else /* Clear BIT0 */
> > -		rtlpci->receive_config &= ~RCR_AAP;
> > -
> > -	if (write_into_reg)
> > -		rtl_write_dword(rtlpriv, RCR, rtlpci->receive_config);
> > -
> > -	RT_TRACE(rtlpriv, COMP_TURBO | COMP_INIT, DBG_LOUD,
> > -		 "receive_config=0x%08X, write_into_reg=%d\n",
> > -		 rtlpci->receive_config, write_into_reg);
> > -}
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
> > b/drivers/net/wireless/rtlwifi/rtl8192se/hw.h index da48aa8..4cacee1
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
> > +++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
> > @@ -74,7 +74,5 @@ void rtl92se_set_key(struct ieee80211_hw *hw,
> > 
> >   		     u8 enc_algo, bool is_wepkey, bool clear_all);
> >   
> >   void rtl92se_suspend(struct ieee80211_hw *hw);
> >   void rtl92se_resume(struct ieee80211_hw *hw);
> > 
> > -void rtl92se_allow_all_destaddr(struct ieee80211_hw *hw,
> > -				bool allow_all_da, bool write_into_reg);
> > 
> >   #endif
> > 
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> > b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c index 2e8e6f8..1bff2a0
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
> > @@ -290,7 +290,6 @@ static struct rtl_hal_ops rtl8192se_hal_ops = {
> > 
> >   	.enable_hw_sec = rtl92se_enable_hw_security_config,
> >   	.set_key = rtl92se_set_key,
> >   	.init_sw_leds = rtl92se_init_sw_leds,
> > 
> > -	.allow_all_destaddr = rtl92se_allow_all_destaddr,
> > 
> >   	.get_bbreg = rtl92s_phy_query_bb_reg,
> >   	.set_bbreg = rtl92s_phy_set_bb_reg,
> >   	.get_rfreg = rtl92s_phy_query_rf_reg,
> > 
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
> > b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c index 4680816..48e8b82
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
> > @@ -2377,24 +2377,3 @@ void rtl8723ae_suspend(struct ieee80211_hw *hw)
> > 
> >   void rtl8723ae_resume(struct ieee80211_hw *hw)
> >   {
> >   }
> > 
> > -
> > -/* Turn on AAP (RCR:bit 0) for promicuous mode. */
> > -void rtl8723ae_allow_all_destaddr(struct ieee80211_hw *hw,
> > -	bool allow_all_da, bool write_into_reg)
> > -{
> > -	struct rtl_priv *rtlpriv = rtl_priv(hw);
> > -	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
> > -
> > -	if (allow_all_da) /* Set BIT0 */
> > -		rtlpci->receive_config |= RCR_AAP;
> > -	else /* Clear BIT0 */
> > -		rtlpci->receive_config &= ~RCR_AAP;
> > -
> > -	if (write_into_reg)
> > -		rtl_write_dword(rtlpriv, REG_RCR, rtlpci->receive_config);
> > -
> > -
> > -	RT_TRACE(rtlpriv, COMP_TURBO | COMP_INIT, DBG_LOUD,
> > -		 "receive_config=0x%08X, write_into_reg=%d\n",
> > -		 rtlpci->receive_config, write_into_reg);
> > -}
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.h
> > b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.h index 6fa24f7..d3bc39f
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.h
> > +++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.h
> > @@ -67,7 +67,5 @@ void rtl8723ae_bt_reg_init(struct ieee80211_hw *hw);
> > 
> >   void rtl8723ae_bt_hw_init(struct ieee80211_hw *hw);
> >   void rtl8723ae_suspend(struct ieee80211_hw *hw);
> >   void rtl8723ae_resume(struct ieee80211_hw *hw);
> > 
> > -void rtl8723ae_allow_all_destaddr(struct ieee80211_hw *hw,
> > -				  bool allow_all_da, bool write_into_reg);
> > 
> >   #endif
> > 
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
> > b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c index 62b204f..a9cb110
> > 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
> > @@ -230,7 +230,6 @@ static struct rtl_hal_ops rtl8723ae_hal_ops = {
> > 
> >   	.enable_hw_sec = rtl8723ae_enable_hw_security_config,
> >   	.set_key = rtl8723ae_set_key,
> >   	.init_sw_leds = rtl8723ae_init_sw_leds,
> > 
> > -	.allow_all_destaddr = rtl8723ae_allow_all_destaddr,
> > 
> >   	.get_bbreg = rtl8723ae_phy_query_bb_reg,
> >   	.set_bbreg = rtl8723ae_phy_set_bb_reg,
> >   	.get_rfreg = rtl8723ae_phy_query_rf_reg,
> > 
> > diff --git a/drivers/net/wireless/rtlwifi/wifi.h
> > b/drivers/net/wireless/rtlwifi/wifi.h index 8c64739..08fd164 100644
> > --- a/drivers/net/wireless/rtlwifi/wifi.h
> > +++ b/drivers/net/wireless/rtlwifi/wifi.h
> > @@ -1714,8 +1714,6 @@ struct rtl_hal_ops {
> > 
> >   			  u32 regaddr, u32 bitmask);
> >   	
> >   	void (*set_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
> >   	
> >   			   u32 regaddr, u32 bitmask, u32 data);
> > 
> > -	void (*allow_all_destaddr)(struct ieee80211_hw *hw,
> > -		bool allow_all_da, bool write_into_reg);
> > 
> >   	void (*linked_set_reg) (struct ieee80211_hw *hw);
> >   	void (*chk_switch_dmdp) (struct ieee80211_hw *hw);
> >   	void (*dualmac_easy_concurrent) (struct ieee80211_hw *hw);

