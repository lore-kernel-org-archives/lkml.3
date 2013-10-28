Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab3J1Xj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 19:39:56 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:38777 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab3J1Xjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:39:54 -0400
Message-ID: <1383003587.3779.49.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH 03/16] wl1251: add sysfs interface for bluetooth
 coexistence mode configuration
From: Ben Hutchings <bhutchings@solarflare.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <freemangordon@abv.bg>,
        <aaro.koskinen@iki.fi>, <pavel@ucw.cz>, <sre@ring0.de>,
        <joni.lapilainen@gmail.com>, David Gnedt <david.gnedt@davizone.at>
Date: Mon, 28 Oct 2013 23:39:47 +0000
In-Reply-To: <1382819655-30430-4-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <1382819655-30430-4-git-send-email-pali.rohar@gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20252.005
X-TM-AS-Result: No--10.365500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-26 at 22:34 +0200, Pali Rohár wrote:
> From: David Gnedt <david.gnedt@davizone.at>
> 
> Port the bt_coex_mode sysfs interface from wl1251 driver version included
> in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
> This enables userspace applications to set one of the modes
> WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
> The default mode is WL1251_BT_COEX_OFF.
> It should be noted that this driver always enabled bt-coexistence before
> and enabled bt-coexistence directly affects the receiving performance,
> rendering it unusable in some low-signal situations. Especially monitor
> mode is affected very badly with bt-coexistence enabled.
[...]

This should be implemented consistently with other drivers:

drivers/net/wireless/ath/ath9k/htc_drv_init.c:module_param_named(btcoex_enable, ath9k_htc_btcoex_enable, int, 0444);
drivers/net/wireless/ath/ath9k/init.c:module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
drivers/net/wireless/b43/main.c:module_param_named(btcoex, modparam_btcoex, int, 0444);
drivers/net/wireless/ipw2x00/ipw2200.c:module_param(bt_coexist, int, 0444);
drivers/net/wireless/iwlegacy/common.c:module_param(bt_coex_active, bool, S_IRUGO);
drivers/net/wireless/iwlwifi/iwl-drv.c:module_param_named(bt_coex_active, iwlwifi_mod_params.bt_coex_active,
drivers/net/wireless/ti/wlcore/sysfs.c:static DEVICE_ATTR(bt_coex_state, S_IRUGO | S_IWUSR,

Oh, hmm, I see a problem here.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

