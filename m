Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3J2HKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:10:24 -0400
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:45943 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3J2HKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:10:22 -0400
Message-ID: <1383030565.21526.92.camel@porter.coelho.fi>
Subject: Re: [PATCH 03/16] wl1251: add sysfs interface for bluetooth
 coexistence mode configuration
From: Luca Coelho <luca@coelho.fi>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, David Gnedt <david.gnedt@davizone.at>
Date: Tue, 29 Oct 2013 09:09:25 +0200
In-Reply-To: <1383003587.3779.49.camel@bwh-desktop.uk.level5networks.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <1382819655-30430-4-git-send-email-pali.rohar@gmail.com>
	 <1383003587.3779.49.camel@bwh-desktop.uk.level5networks.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 23:39 +0000, Ben Hutchings wrote:
> On Sat, 2013-10-26 at 22:34 +0200, Pali Rohár wrote:
> > From: David Gnedt <david.gnedt@davizone.at>
> > 
> > Port the bt_coex_mode sysfs interface from wl1251 driver version included
> > in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
> > This enables userspace applications to set one of the modes
> > WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
> > The default mode is WL1251_BT_COEX_OFF.
> > It should be noted that this driver always enabled bt-coexistence before
> > and enabled bt-coexistence directly affects the receiving performance,
> > rendering it unusable in some low-signal situations. Especially monitor
> > mode is affected very badly with bt-coexistence enabled.
> [...]
> 
> This should be implemented consistently with other drivers:
> 
> drivers/net/wireless/ath/ath9k/htc_drv_init.c:module_param_named(btcoex_enable, ath9k_htc_btcoex_enable, int, 0444);
> drivers/net/wireless/ath/ath9k/init.c:module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
> drivers/net/wireless/b43/main.c:module_param_named(btcoex, modparam_btcoex, int, 0444);
> drivers/net/wireless/ipw2x00/ipw2200.c:module_param(bt_coexist, int, 0444);
> drivers/net/wireless/iwlegacy/common.c:module_param(bt_coex_active, bool, S_IRUGO);
> drivers/net/wireless/iwlwifi/iwl-drv.c:module_param_named(bt_coex_active, iwlwifi_mod_params.bt_coex_active,
> drivers/net/wireless/ti/wlcore/sysfs.c:static DEVICE_ATTR(bt_coex_state, S_IRUGO | S_IWUSR,
> 
> Oh, hmm, I see a problem here.

With so many drivers doing the same thing, isn't it about time to add
this to nl80211?

--
Luca.

