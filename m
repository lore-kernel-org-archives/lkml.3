Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbaGITiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:38:50 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:56172 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbaGITis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:38:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140706090111.GA16760@acer>
References: <20140706090111.GA16760@acer>
Date: Wed, 9 Jul 2014 15:38:48 -0400
Message-ID: <CAJUuVQ7ayT2k0J=HC77L+Eb83ftuLY_8G6-iRBPo6sytmd+zZA@mail.gmail.com>
Subject: Re: [PATCH next-20140704]: staging/rtl8821ae/base.c: sparse warning corrections
From: Andev <debiandev@gmail.com>
To: Sami Laine <laine.j.sami@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, gulsah.1004@gmail.com,
        Larry.Finger@lwfinger.net, John Linville <linville@tuxdriver.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2014 at 5:01 AM, Sami Laine <laine.j.sami@gmail.com> wrote:
> From: Sami Laine <laine.j.sami@gmail.com>
>
> Sparse warning corrections for:
>
> drivers/staging/rtl8821ae/base.c:1370:16: warning: symbol 'rtl_make_smps_action' was not declared. Should it be static?
> drivers/staging/rtl8821ae/base.c:1543:6: warning: symbol 'rtl_find_221_ie' was not declared. Should it be static?
> drivers/staging/rtl8821ae/base.c:1804:5: warning: symbol 'rtl_core_module_init' was not declared. Should it be static?
> drivers/staging/rtl8821ae/base.c:1820:6: warning: symbol 'rtl_core_module_exit' was not declared. Should it be static?
>
> Signed-off-by: Sami Laine <laine.j.sami@gmail.com>
> ---
> diff --git a/drivers/staging/rtl8821ae/base.c b/drivers/staging/rtl8821ae/base.c
> index 4a36da0..c2d0b18 100644
> --- a/drivers/staging/rtl8821ae/base.c
> +++ b/drivers/staging/rtl8821ae/base.c
> @@ -1367,7 +1367,7 @@ u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie)
>
>  /* when we use 2 rx ants we send IEEE80211_SMPS_OFF */
>  /* when we use 1 rx ant we send IEEE80211_SMPS_STATIC */
> -struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
> +static struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
>                                      enum ieee80211_smps_mode smps,
>                                      u8 *da, u8 *bssid)
>  {
> @@ -1540,7 +1540,7 @@ static bool rtl_chk_vendor_ouisub(struct ieee80211_hw *hw,
>         return matched;
>  }
>
> -bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
> +static bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
>                 unsigned int len)
>  {
>         struct ieee80211_mgmt *mgmt = (void *)data;
> @@ -1801,7 +1801,7 @@ MODULE_DESCRIPTION("Realtek 802.11n PCI wireless core");
>  #endif
>  struct rtl_global_var global_var = {};
>
> -int rtl_core_module_init(void)
> +static int rtl_core_module_init(void)
>  {
>         if (rtl_rate_control_register())
>                 printk(KERN_DEBUG "rtl: Unable to register rtl_rc, use default RC !!\n");
> @@ -1815,8 +1815,9 @@ int rtl_core_module_init(void)
>
>         return 0;
>  }
> +EXPORT_SYMBOL(rtl_core_module_init);

Why are you adding this? Just declaring it static should be enough if
you are not using this elsewhere.

>
> -void rtl_core_module_exit(void)
> +static void rtl_core_module_exit(void)
>  {
>         /*RC*/
>         rtl_rate_control_unregister();
> @@ -1824,6 +1825,7 @@ void rtl_core_module_exit(void)
>         /* add proc for debug */
>         rtl_proc_remove_topdir();
>  }
> +EXPORT_SYMBOL(rtl_core_module_exit);

same here.

>
>  #if 0
>  module_init(rtl_core_module_init);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Andev
